<?php

namespace App\Services\Zoom;

use App\Models\ZoomAccount;
use App\Models\ZoomMeetingImport;
use Illuminate\Support\Facades\Http;

/**
 * Zoom 要約・文字起こしの取得（SPEC-012 Phase C / R2・Should）。
 *
 * 取得可否は Zoom プランに依存する:
 * - AI Companion ミーティングサマリー（/meetings/{id}/meeting_summary）
 * - クラウド録画の文字起こし（recording_files の TRANSCRIPT, .vtt）
 *
 * いずれも取得できない場合は null を返し、呼び出し側は「手動要約継続」にフォールバックする。
 */
class ZoomSummaryService
{
    public function __construct(
        private ZoomApiClient $client,
        private ZoomTokenService $tokenService,
    ) {}

    /**
     * 要約テキスト（下書き）を組み立てて返す。取得不可なら null。
     */
    public function fetchSummaryText(ZoomAccount $account, ZoomMeetingImport $import): ?string
    {
        $summary = $this->buildFromMeetingSummary($account, $import);
        if ($summary !== null) {
            return $summary;
        }

        return $this->buildFromTranscript($account, $import);
    }

    private function buildFromMeetingSummary(ZoomAccount $account, ZoomMeetingImport $import): ?string
    {
        if (empty($import->zoom_meeting_id)) {
            return null;
        }
        $data = $this->client->getMeetingSummary($account, $import->zoom_meeting_id);
        if ($data === null) {
            return null;
        }

        $lines = [];
        if (! empty($data['summary_overview'])) {
            $lines[] = '【要約】';
            $lines[] = (string) $data['summary_overview'];
        }
        foreach (($data['summary_details'] ?? []) as $detail) {
            $label = $detail['label'] ?? '';
            $summary = $detail['summary'] ?? '';
            if ($summary !== '') {
                $lines[] = '- '.($label !== '' ? $label.': ' : '').$summary;
            }
        }
        if (! empty($data['next_steps'])) {
            $lines[] = '【次のステップ】';
            foreach ((array) $data['next_steps'] as $step) {
                $lines[] = '- '.(is_string($step) ? $step : ($step['summary'] ?? ''));
            }
        }

        $text = trim(implode("\n", array_filter($lines)));

        return $text !== '' ? $text."\n\n(Zoom AI Companion 要約・下書き。校正してください)" : null;
    }

    private function buildFromTranscript(ZoomAccount $account, ZoomMeetingImport $import): ?string
    {
        if (empty($import->zoom_meeting_uuid)) {
            return null;
        }
        $recordings = $this->client->getMeetingRecordings($account, $import->zoom_meeting_uuid);
        if ($recordings === null) {
            return null;
        }

        $transcriptUrl = null;
        foreach (($recordings['recording_files'] ?? []) as $file) {
            $type = strtoupper((string) ($file['file_type'] ?? $file['recording_type'] ?? ''));
            if (str_contains($type, 'TRANSCRIPT') || $type === 'VTT') {
                $transcriptUrl = $file['download_url'] ?? null;
                break;
            }
        }
        if ($transcriptUrl === null) {
            return null;
        }

        $token = $this->tokenService->ensureFreshAccessToken($account);
        $response = Http::withToken($token)->get($transcriptUrl);
        if (! $response->successful()) {
            return null;
        }

        $text = $this->parseVtt($response->body());

        return $text !== '' ? $text."\n\n(Zoom 文字起こし・下書き。校正してください)" : null;
    }

    /**
     * WEBVTT を素のテキストへ整形する（タイムスタンプ・キュー番号・ヘッダーを除去）。
     */
    private function parseVtt(string $vtt): string
    {
        $lines = preg_split('/\r\n|\r|\n/', $vtt) ?: [];
        $out = [];
        foreach ($lines as $line) {
            $trimmed = trim($line);
            if ($trimmed === '' || $trimmed === 'WEBVTT') {
                continue;
            }
            if (preg_match('/-->/', $trimmed)) {
                continue; // タイムスタンプ行
            }
            if (ctype_digit($trimmed)) {
                continue; // キュー番号
            }
            $out[] = $trimmed;
        }

        return trim(implode("\n", $out));
    }
}
