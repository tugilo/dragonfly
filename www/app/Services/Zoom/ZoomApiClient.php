<?php

namespace App\Services\Zoom;

use App\Models\ZoomAccount;
use Illuminate\Http\Client\Response;
use Illuminate\Support\Facades\Http;
use RuntimeException;

/**
 * Zoom REST API クライアント（SPEC-012）。
 *
 * - アクセストークンは ZoomTokenService 経由で常に有効化（期限切れ自動更新）
 * - next_page_token でのページネーション巡回
 * - 429（レート制限）時の Retry-After / 指数バックオフ
 *
 * 注意: ミーティング UUID に '/' や '+' が含まれる場合は二重 URL エンコードが必要（Zoom 仕様）。
 */
class ZoomApiClient
{
    private const MAX_RETRIES = 3;

    private const MAX_PAGES = 50;

    public function __construct(private ZoomTokenService $tokenService) {}

    /**
     * 今後の予定ミーティング一覧（type=scheduled）。全ページ巡回して meetings を返す。
     *
     * @return array<int, array<string, mixed>>
     */
    public function listScheduledMeetings(ZoomAccount $account, string $zoomUserId = 'me'): array
    {
        return $this->paginate($account, "/users/{$zoomUserId}/meetings", ['type' => 'scheduled', 'page_size' => 100], 'meetings');
    }

    /**
     * 過去のミーティング一覧（type=previous_meetings）。
     *
     * @return array<int, array<string, mixed>>
     */
    public function listPreviousMeetings(ZoomAccount $account, string $zoomUserId = 'me'): array
    {
        return $this->paginate($account, "/users/{$zoomUserId}/meetings", ['type' => 'previous_meetings', 'page_size' => 100], 'meetings');
    }

    /**
     * 繰り返しミーティングの過去インスタンス一覧（各 uuid）。
     *
     * @return array<int, array<string, mixed>>
     */
    public function listPastInstances(ZoomAccount $account, int|string $meetingId): array
    {
        $res = $this->request($account, 'get', "/past_meetings/{$meetingId}/instances");
        if ($res === null || ! $res->successful()) {
            return [];
        }

        return $res->json('meetings') ?? [];
    }

    /**
     * 過去ミーティングの詳細（実 start_time / end_time / duration / participants_count）。
     *
     * @return array<string, mixed>|null
     */
    public function getPastMeeting(ZoomAccount $account, string $meetingUuid): ?array
    {
        $res = $this->request($account, 'get', '/past_meetings/'.$this->encodeUuid($meetingUuid));
        if ($res === null || ! $res->successful()) {
            return null;
        }

        return $res->json();
    }

    /**
     * 過去ミーティングの参加者一覧（氏名・email。プラン/設定により email 空あり）。
     *
     * @return array<int, array<string, mixed>>
     */
    public function listPastParticipants(ZoomAccount $account, string $meetingUuid): array
    {
        return $this->paginate(
            $account,
            '/past_meetings/'.$this->encodeUuid($meetingUuid).'/participants',
            ['page_size' => 100],
            'participants'
        );
    }

    /**
     * ミーティング要約（AI Companion）。プラン依存。取得不可なら null。
     *
     * @return array<string, mixed>|null
     */
    public function getMeetingSummary(ZoomAccount $account, int|string $meetingId): ?array
    {
        $res = $this->request($account, 'get', "/meetings/{$meetingId}/meeting_summary");
        if ($res === null || ! $res->successful()) {
            return null;
        }

        return $res->json();
    }

    /**
     * クラウド録画一覧（文字起こしファイル TRANSCRIPT を含む）。プラン依存。
     *
     * @return array<string, mixed>|null
     */
    public function getMeetingRecordings(ZoomAccount $account, string $meetingUuid): ?array
    {
        $res = $this->request($account, 'get', '/meetings/'.$this->encodeUuid($meetingUuid).'/recordings');
        if ($res === null || ! $res->successful()) {
            return null;
        }

        return $res->json();
    }

    /**
     * 単純な GET（任意エンドポイント）。
     *
     * @param  array<string, mixed>  $query
     * @return array<string, mixed>|null
     */
    public function get(ZoomAccount $account, string $path, array $query = []): ?array
    {
        $res = $this->request($account, 'get', $path, $query);
        if ($res === null || ! $res->successful()) {
            return null;
        }

        return $res->json();
    }

    /**
     * next_page_token を辿って指定キーの配列を全件集約する。
     *
     * @param  array<string, mixed>  $query
     * @return array<int, array<string, mixed>>
     */
    private function paginate(ZoomAccount $account, string $path, array $query, string $itemsKey): array
    {
        $items = [];
        $pageToken = null;
        $pages = 0;

        do {
            $q = $query;
            if ($pageToken !== null && $pageToken !== '') {
                $q['next_page_token'] = $pageToken;
            }
            $res = $this->request($account, 'get', $path, $q);
            if ($res === null || ! $res->successful()) {
                break;
            }
            $body = $res->json();
            foreach (($body[$itemsKey] ?? []) as $item) {
                $items[] = $item;
            }
            $pageToken = $body['next_page_token'] ?? null;
            $pages++;
        } while ($pageToken !== null && $pageToken !== '' && $pages < self::MAX_PAGES);

        return $items;
    }

    /**
     * トークン付き HTTP リクエスト。429 はバックオフ再試行する。
     *
     * @param  array<string, mixed>  $query
     */
    private function request(ZoomAccount $account, string $method, string $path, array $query = []): ?Response
    {
        $url = $this->baseUrl().$path;

        for ($attempt = 0; $attempt <= self::MAX_RETRIES; $attempt++) {
            $token = $this->tokenService->ensureFreshAccessToken($account);
            $response = Http::withToken($token)->acceptJson()->{$method}($url, $query);

            if ($response->status() === 429) {
                $this->sleepForRateLimit($response, $attempt);

                continue;
            }

            // 401 はトークン更新で 1 度だけ救済を試みる。
            if ($response->status() === 401 && $attempt === 0) {
                $this->tokenService->refresh($account->refresh());

                continue;
            }

            return $response;
        }

        throw new RuntimeException("Zoom API rate limit exceeded after retries: {$path}");
    }

    private function sleepForRateLimit(Response $response, int $attempt): void
    {
        $retryAfter = $response->header('Retry-After');
        $seconds = is_numeric($retryAfter) ? (int) $retryAfter : (2 ** $attempt);
        $seconds = max(1, min($seconds, 30));
        if (! app()->runningUnitTests()) {
            sleep($seconds);
        }
    }

    private function baseUrl(): string
    {
        return rtrim((string) config('services.zoom.base_url'), '/');
    }

    /**
     * UUID をパスに入れるための二重エンコード（'/' or '+' を含む場合・Zoom 仕様）。
     */
    private function encodeUuid(string $uuid): string
    {
        if (str_contains($uuid, '/') || str_contains($uuid, '+')) {
            return rawurlencode(rawurlencode($uuid));
        }

        return rawurlencode($uuid);
    }
}
