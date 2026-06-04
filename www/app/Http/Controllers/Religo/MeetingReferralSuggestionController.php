<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Requests\Religo\PatchReferralSuggestionRequest;
use App\Models\Meeting;
use App\Models\MeetingReferralSuggestion;
use App\Models\User;
use App\Models\UserAiCredential;
use App\Services\Religo\MeetingReferralSuggestionService;
use App\Services\Religo\ReligoActorContext;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use InvalidArgumentException;

/**
 * SPEC-016: 定例会リファーラル提案 API。
 */
class MeetingReferralSuggestionController extends Controller
{
    public function __construct(private MeetingReferralSuggestionService $service) {}

    public function generate(Meeting $meeting): JsonResponse
    {
        if ($resp = $this->guard()) {
            return $resp;
        }

        $user = ReligoActorContext::actingUser();
        $cred = UserAiCredential::where('user_id', $user->id)->first();
        if ($cred === null || ! $cred->hasUsableKey()) {
            return response()->json(['message' => 'AI が未設定です。設定画面で AI を有効化し API キーを登録してください。'], 422);
        }

        $meeting->loadMissing('meetingMinute');

        try {
            $payload = $this->service->generate($meeting, $user, $cred);
        } catch (InvalidArgumentException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        return response()->json($payload, 201);
    }

    public function index(Request $request, Meeting $meeting): JsonResponse
    {
        if ($resp = $this->guard()) {
            return $resp;
        }

        $user = ReligoActorContext::actingUser();
        $meeting->loadMissing('meetingMinute');
        $runId = $request->query('run_id');
        $runId = $runId !== null && $runId !== '' ? (int) $runId : null;

        return response()->json(
            $this->service->list($meeting, (int) $user->owner_member_id, $runId)
        );
    }

    public function update(PatchReferralSuggestionRequest $request, MeetingReferralSuggestion $meetingReferralSuggestion): JsonResponse
    {
        if ($resp = $this->guard()) {
            return $resp;
        }

        $user = ReligoActorContext::actingUser();

        try {
            $payload = $this->service->updateSuggestion(
                $meetingReferralSuggestion,
                (int) $user->owner_member_id,
                $request->validated(),
            );
        } catch (InvalidArgumentException $e) {
            return response()->json(['message' => $e->getMessage()], 403);
        }

        return response()->json($payload);
    }

    private function guard(): ?JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if (! $user instanceof User) {
            return response()->json(['message' => 'No acting user.'], 403);
        }
        if ($user->owner_member_id === null) {
            return response()->json(['message' => 'owner_member_id が未設定です。'], 403);
        }

        return null;
    }
}
