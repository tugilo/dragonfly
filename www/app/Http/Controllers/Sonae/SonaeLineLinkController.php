<?php

namespace App\Http\Controllers\Sonae;

use App\Http\Controllers\Controller;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeLineAccount;
use App\Models\Sonae\SonaeMember;
use App\Services\Sonae\SonaeLineLinkService;
use App\Services\Sonae\SonaeLinePushService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SonaeLineLinkController extends Controller
{
    public function issueInvite(
        SonaeChapter $chapter,
        SonaeMember $member,
        SonaeLineLinkService $linkService
    ): JsonResponse {
        $this->assertMemberBelongsToChapter($chapter, $member);

        $invite = $linkService->issueInviteToken($member);

        return response()->json([
            'data' => [
                'member_id' => $member->id,
                'token' => $invite['token'],
                'link_message' => $invite['message'],
            ],
        ]);
    }

    public function linkDirect(
        Request $request,
        SonaeChapter $chapter,
        SonaeMember $member,
        SonaeLineLinkService $linkService
    ): JsonResponse {
        $this->assertMemberBelongsToChapter($chapter, $member);

        $validated = $request->validate([
            'line_user_id' => ['required', 'string', 'max:64'],
        ]);

        $lineAccount = $chapter->lineAccount;
        if ($lineAccount === null) {
            return response()->json(['message' => 'LINE account not configured.'], 422);
        }

        $link = $linkService->linkMember(
            $chapter,
            $member,
            $lineAccount,
            $validated['line_user_id']
        );

        return response()->json([
            'data' => [
                'id' => $link->id,
                'member_id' => $link->member_id,
                'line_user_id' => $link->line_user_id,
                'status' => $link->status,
            ],
        ]);
    }

    public function pushTest(
        Request $request,
        SonaeChapter $chapter,
        SonaeMember $member,
        SonaeLinePushService $pushService
    ): JsonResponse {
        $this->assertMemberBelongsToChapter($chapter, $member);

        $validated = $request->validate([
            'message' => ['required', 'string', 'max:1000'],
        ]);

        $lineAccount = $chapter->lineAccount;
        if ($lineAccount === null) {
            return response()->json(['message' => 'LINE account not configured.'], 422);
        }

        $member->load('activeLineUserLink');
        $lineUserId = $member->activeLineUserLink?->line_user_id;
        if ($lineUserId === null) {
            return response()->json(['message' => 'Member is not linked to LINE.'], 422);
        }

        $ok = $pushService->pushText($lineAccount, $lineUserId, $validated['message']);

        return response()->json([
            'data' => ['sent' => $ok],
        ], $ok ? 200 : 502);
    }

    private function assertMemberBelongsToChapter(SonaeChapter $chapter, SonaeMember $member): void
    {
        if ($member->chapter_id !== $chapter->id) {
            abort(404);
        }
    }
}
