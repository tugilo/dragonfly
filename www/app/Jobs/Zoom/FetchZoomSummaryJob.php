<?php

namespace App\Jobs\Zoom;

use App\Models\ZoomAccount;
use App\Models\ZoomMeetingImport;
use App\Services\Zoom\ZoomSummaryService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

/**
 * Zoom Webhook recording.completed / meeting.summary_completed を処理し、
 * 取り込み済み 1to1 の notes に要約/文字起こし下書きを反映する（SPEC-012 Phase D / R2）。
 */
class FetchZoomSummaryJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function __construct(private ?string $meetingUuid, private ?string $hostId) {}

    public function handle(ZoomSummaryService $summaryService): void
    {
        if ($this->meetingUuid === null || $this->hostId === null) {
            return;
        }
        $account = ZoomAccount::where('zoom_user_id', $this->hostId)->first();
        if ($account === null) {
            return;
        }

        $import = ZoomMeetingImport::where('user_id', $account->user_id)
            ->where('zoom_meeting_uuid', $this->meetingUuid)
            ->first();
        if ($import === null || $import->one_to_one_id === null) {
            return; // 未取り込みのものは自動で本文反映しない。
        }

        $text = $summaryService->fetchSummaryText($account, $import);
        if ($text === null) {
            return;
        }

        $oneToOne = $import->oneToOne;
        if ($oneToOne !== null) {
            $existing = trim((string) $oneToOne->notes);
            $oneToOne->notes = $existing === '' ? $text : $existing."\n\n---\n".$text;
            $oneToOne->save();
        }
    }
}
