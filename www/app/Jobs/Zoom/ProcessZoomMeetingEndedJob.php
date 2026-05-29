<?php

namespace App\Jobs\Zoom;

use App\Models\User;
use App\Models\ZoomAccount;
use App\Services\Zoom\ZoomMeetingSyncService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

/**
 * Zoom Webhook meeting.ended を処理し、ステージング候補を生成する（SPEC-012 Phase D）。
 * host_id から連携ユーザーを解決し、過去ミーティングとして取り込む。
 */
class ProcessZoomMeetingEndedJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * @param  array<string, mixed>  $object
     */
    public function __construct(private array $object) {}

    public function handle(ZoomMeetingSyncService $syncService): void
    {
        $hostId = $this->object['host_id'] ?? null;
        if ($hostId === null) {
            return;
        }
        $account = ZoomAccount::where('zoom_user_id', $hostId)->first();
        if ($account === null) {
            return;
        }
        $user = User::find($account->user_id);
        if ($user === null) {
            return;
        }

        $syncService->ingestEndedMeeting($user, $this->object);
    }
}
