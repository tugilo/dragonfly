<?php

namespace App\Services\Zoom;

use App\Models\Member;
use App\Models\User;
use App\Models\ZoomAccount;
use App\Models\ZoomMeetingImport;
use App\Services\Religo\ReligoActorContext;
use Illuminate\Support\Carbon;

/**
 * Zoom から予定（scheduled）・実施済み（past）ミーティングを取得し、
 * 取り込みステージング（zoom_meeting_imports）へ upsert する（SPEC-012 Phase B / R1・R4・R5）。
 *
 * - 1to1 判定: ZoomOneToOneDetector
 * - 相手マッチ: 氏名・email から members を照合（人の確認前の自動候補）
 * - 既に one_to_ones に取り込み済みのものは status=imported のまま据え置く
 */
class ZoomMeetingSyncService
{
    private const MAX_PAST_DETAIL_CALLS = 80;

    public function __construct(
        private ZoomApiClient $client,
        private ZoomOneToOneDetector $detector,
    ) {}

    /**
     * @return array{scheduled: int, past: int, candidates: int}
     */
    public function sync(User $user, ZoomAccount $account, int $pastDays = 30, int $upcomingDays = 14): array
    {
        $ownerMemberId = $user->owner_member_id;
        $workspaceId = ReligoActorContext::resolveWorkspaceIdForUser($user);

        $now = Carbon::now();
        $pastFrom = $now->copy()->subDays(max(0, $pastDays));
        $upcomingTo = $now->copy()->addDays(max(0, $upcomingDays));

        $scheduledCount = $this->syncScheduled($user, $account, $ownerMemberId, $workspaceId, $now, $upcomingTo);
        $pastCount = $this->syncPast($user, $account, $ownerMemberId, $workspaceId, $pastFrom, $now);

        $candidates = ZoomMeetingImport::where('user_id', $user->id)
            ->where('is_one_to_one_candidate', true)
            ->count();

        return ['scheduled' => $scheduledCount, 'past' => $pastCount, 'candidates' => $candidates];
    }

    /**
     * Webhook（meeting.ended）から過去ミーティング 1 件をステージングへ取り込む（Phase D）。
     * 人の確認用の候補を生成する（one_to_ones への自動登録はしない）。
     *
     * @param  array<string, mixed>  $object
     */
    public function ingestEndedMeeting(User $user, array $object): void
    {
        $ownerMemberId = $user->owner_member_id;
        $workspaceId = ReligoActorContext::resolveWorkspaceIdForUser($user);

        $topic = $object['topic'] ?? null;
        $eval = $this->detector->evaluate($topic, null);

        $this->upsert($user, $ownerMemberId, $workspaceId, [
            'zoom_meeting_id' => (string) ($object['id'] ?? ''),
            'zoom_meeting_uuid' => isset($object['uuid']) ? (string) $object['uuid'] : null,
            'kind' => ZoomMeetingImport::KIND_PAST,
            'topic' => $topic,
            'start_time' => $this->parseDate($object['start_time'] ?? null),
            'end_time' => $this->parseDate($object['end_time'] ?? null),
            'duration_minutes' => isset($object['duration']) ? (int) $object['duration'] : null,
            'participants_count' => null,
            'eval' => $eval,
            'counterpart_name' => $this->detector->guessCounterpartName($topic),
            'counterpart_email' => null,
            'raw' => $object,
        ]);
    }

    private function syncScheduled(
        User $user,
        ZoomAccount $account,
        ?int $ownerMemberId,
        ?int $workspaceId,
        Carbon $from,
        Carbon $to
    ): int {
        $meetings = $this->client->listScheduledMeetings($account, 'me');
        $count = 0;

        foreach ($meetings as $m) {
            $start = $this->parseDate($m['start_time'] ?? null);
            if ($start !== null && ($start->lt($from) || $start->gt($to))) {
                continue;
            }
            $topic = $m['topic'] ?? null;
            $eval = $this->detector->evaluate($topic, null);

            $this->upsert($user, $ownerMemberId, $workspaceId, [
                'zoom_meeting_id' => (string) ($m['id'] ?? ''),
                'zoom_meeting_uuid' => null,
                'kind' => ZoomMeetingImport::KIND_SCHEDULED,
                'topic' => $topic,
                'start_time' => $start,
                'end_time' => null,
                'duration_minutes' => isset($m['duration']) ? (int) $m['duration'] : null,
                'participants_count' => null,
                'eval' => $eval,
                'counterpart_name' => $this->detector->guessCounterpartName($topic),
                'counterpart_email' => null,
                'raw' => $m,
            ]);
            $count++;
        }

        return $count;
    }

    private function syncPast(
        User $user,
        ZoomAccount $account,
        ?int $ownerMemberId,
        ?int $workspaceId,
        Carbon $from,
        Carbon $to
    ): int {
        $meetings = $this->client->listPreviousMeetings($account, 'me');
        $count = 0;
        $detailCalls = 0;

        foreach ($meetings as $m) {
            $start = $this->parseDate($m['start_time'] ?? null);
            if ($start !== null && ($start->lt($from) || $start->gt($to))) {
                continue;
            }
            $uuid = $m['uuid'] ?? null;
            $topic = $m['topic'] ?? null;
            $end = null;
            $participants = null;
            $counterpartName = $this->detector->guessCounterpartName($topic);
            $counterpartEmail = null;

            // 候補になり得るものだけ詳細・参加者を取得して API 消費を抑える。
            $preEval = $this->detector->evaluate($topic, null);
            if ($uuid !== null && ($preEval['is_candidate'] || $counterpartName !== null) && $detailCalls < self::MAX_PAST_DETAIL_CALLS) {
                $detail = $this->client->getPastMeeting($account, (string) $uuid);
                $detailCalls++;
                if ($detail !== null) {
                    $end = $this->parseDate($detail['end_time'] ?? null);
                    $participants = isset($detail['participants_count']) ? (int) $detail['participants_count'] : null;
                }
                [$counterpartName, $counterpartEmail] = $this->resolveCounterpartFromParticipants(
                    $account,
                    (string) $uuid,
                    $account->zoom_email,
                    $counterpartName
                );
                $detailCalls++;
            }

            $eval = $this->detector->evaluate($topic, $participants);

            $this->upsert($user, $ownerMemberId, $workspaceId, [
                'zoom_meeting_id' => (string) ($m['id'] ?? ''),
                'zoom_meeting_uuid' => $uuid !== null ? (string) $uuid : null,
                'kind' => ZoomMeetingImport::KIND_PAST,
                'topic' => $topic,
                'start_time' => $start,
                'end_time' => $end,
                'duration_minutes' => isset($m['duration']) ? (int) $m['duration'] : null,
                'participants_count' => $participants,
                'eval' => $eval,
                'counterpart_name' => $counterpartName,
                'counterpart_email' => $counterpartEmail,
                'raw' => $m,
            ]);
            $count++;
        }

        return $count;
    }

    /**
     * 過去ミーティング参加者から、ホスト（自分の email）以外の相手名・email を 1 名拾う。
     *
     * @return array{0: ?string, 1: ?string}
     */
    private function resolveCounterpartFromParticipants(
        ZoomAccount $account,
        string $uuid,
        ?string $ownerEmail,
        ?string $fallbackName
    ): array {
        $participants = $this->client->listPastParticipants($account, $uuid);
        foreach ($participants as $p) {
            $email = $p['user_email'] ?? null;
            $name = $p['name'] ?? null;
            if ($ownerEmail !== null && $email !== null && strcasecmp((string) $email, (string) $ownerEmail) === 0) {
                continue;
            }
            if ($name !== null && trim((string) $name) !== '') {
                return [trim((string) $name), $email !== '' ? $email : null];
            }
        }

        return [$fallbackName, null];
    }

    /**
     * ステージングへ 1 行 upsert する。既に imported のものは判定・相手のみ保持し status は変えない。
     *
     * @param  array<string, mixed>  $data
     */
    private function upsert(User $user, ?int $ownerMemberId, ?int $workspaceId, array $data): void
    {
        /** @var array{is_candidate: bool, confidence: string} $eval */
        $eval = $data['eval'];

        // 突合: past は uuid、scheduled は (user, meeting_id, kind)。
        $query = ZoomMeetingImport::where('user_id', $user->id);
        if ($data['zoom_meeting_uuid'] !== null) {
            $query->where('zoom_meeting_uuid', $data['zoom_meeting_uuid']);
        } else {
            $query->where('kind', $data['kind'])
                ->where('zoom_meeting_id', $data['zoom_meeting_id'])
                ->whereNull('zoom_meeting_uuid');
        }
        $existing = $query->first();

        [$matchedMemberId, $matchStatus] = $this->matchMember($data['counterpart_name'], $data['counterpart_email']);

        $attributes = [
            'user_id' => $user->id,
            'owner_member_id' => $ownerMemberId,
            'workspace_id' => $workspaceId,
            'zoom_meeting_id' => $data['zoom_meeting_id'],
            'zoom_meeting_uuid' => $data['zoom_meeting_uuid'],
            'kind' => $data['kind'],
            'topic' => $data['topic'],
            'start_time' => $data['start_time'],
            'end_time' => $data['end_time'],
            'duration_minutes' => $data['duration_minutes'],
            'participants_count' => $data['participants_count'],
            'is_one_to_one_candidate' => $eval['is_candidate'],
            'confidence' => $eval['confidence'],
            'counterpart_name' => $data['counterpart_name'],
            'counterpart_email' => $data['counterpart_email'],
            'raw' => $data['raw'],
        ];

        if ($existing === null) {
            $attributes['matched_member_id'] = $matchedMemberId;
            $attributes['match_status'] = $matchStatus;
            $attributes['selected'] = $eval['is_candidate'];
            $attributes['status'] = ZoomMeetingImport::STATUS_PENDING;
            ZoomMeetingImport::create($attributes);

            return;
        }

        // 既存: 取り込み済みなら status/selected/手動マッチを保持。
        if ($existing->status !== ZoomMeetingImport::STATUS_IMPORTED) {
            // 人が手動マッチした場合（match_status=matched かつ既に member 指定）は維持。
            if (! ($existing->match_status === 'matched' && $existing->matched_member_id !== null)) {
                $attributes['matched_member_id'] = $matchedMemberId;
                $attributes['match_status'] = $matchStatus;
            }
        }
        $existing->fill($attributes);
        $existing->save();
    }

    /**
     * @return array{0: ?int, 1: string} [matched_member_id, match_status]
     */
    private function matchMember(?string $name, ?string $email): array
    {
        if ($email !== null && $email !== '') {
            $byEmail = Member::query()->where('email', $email)->first();
            if ($byEmail !== null) {
                return [$byEmail->id, 'matched'];
            }
        }
        if ($name !== null && trim($name) !== '') {
            $byName = Member::query()->where('name', trim($name))->first();
            if ($byName !== null) {
                return [$byName->id, 'matched'];
            }

            return [null, 'new'];
        }

        return [null, 'unmatched'];
    }

    private function parseDate(?string $value): ?Carbon
    {
        if ($value === null || $value === '') {
            return null;
        }
        try {
            // Zoom は UTC（...Z）。アプリ TZ（JST）に変換して保存する。
            return Carbon::parse($value)->setTimezone(config('app.timezone'));
        } catch (\Throwable) {
            return null;
        }
    }
}
