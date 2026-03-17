<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Requests\Religo\UpdateMeetingMemoRequest;
use App\Models\ContactMemo;
use App\Models\Meeting;
use App\Models\Member;
use Illuminate\Http\JsonResponse;

/**
 * GET /api/meeting-memos — 既存 route 用の最小実装. Phase M4.
 * GET /api/meetings/{meetingId}/memo — 例会メモ本文取得.
 * PUT /api/meetings/{meetingId}/memo — 例会メモ保存（1 meeting = 1 現在メモ、空文字で削除）.
 */
class MeetingMemoController extends Controller
{
    /**
     * GET /api/meeting-memos — 一覧. 既存 route を壊さないための最小実装.
     */
    public function index(): JsonResponse
    {
        return response()->json([]);
    }

    /**
     * GET /api/meetings/{meetingId}/memo — 例会メモ本文を返す.
     */
    public function show(int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $body = ContactMemo::query()
            ->where('meeting_id', $meeting->id)
            ->where('memo_type', 'meeting')
            ->orderByDesc('created_at')
            ->value('body');

        return response()->json(['body' => $body === null || $body === '' ? null : $body]);
    }

    /**
     * PUT /api/meetings/{meetingId}/memo — 例会メモを保存. 空文字ならメモなし扱い（削除）.
     */
    public function update(UpdateMeetingMemoRequest $request, int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $body = $request->input('body');
        $body = is_string($body) ? trim($body) : '';

        if ($body === '') {
            ContactMemo::query()
                ->where('meeting_id', $meeting->id)
                ->where('memo_type', 'meeting')
                ->delete();

            return response()->json(['body' => null, 'has_memo' => false]);
        }

        $defaultMemberId = Member::query()->orderBy('id')->value('id') ?? 1;

        $memo = ContactMemo::query()
            ->where('meeting_id', $meeting->id)
            ->where('memo_type', 'meeting')
            ->orderByDesc('created_at')
            ->first();

        if ($memo) {
            $memo->update(['body' => $body]);
        } else {
            ContactMemo::create([
                'owner_member_id' => $defaultMemberId,
                'target_member_id' => $defaultMemberId,
                'meeting_id' => $meeting->id,
                'memo_type' => 'meeting',
                'body' => $body,
            ]);
        }

        return response()->json(['body' => $body, 'has_memo' => true]);
    }
}
