<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Requests\Religo\GenerateReferralConnectCopyRequest;
use App\Http\Requests\Religo\PatchReferralSuggestionRequest;
use App\Http\Requests\Religo\RegisterReferralIntroductionRequest;
use App\Services\Religo\ReferralIntroductionRegistrationService;
use App\Models\OneToOne;
use App\Models\OneToOneReferralSuggestion;
use App\Models\User;
use App\Models\UserAiCredential;
use App\Services\Religo\OneToOneReferralSuggestionService;
use App\Services\Religo\ReferralConnectCopyService;
use App\Services\Religo\ReligoActorContext;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use InvalidArgumentException;

/**
 * SPEC-015: 121 リファーラル提案 API。
 */
class OneToOneReferralSuggestionController extends Controller
{
    public function __construct(
        private OneToOneReferralSuggestionService $service,
        private ReferralIntroductionRegistrationService $registrationService,
        private ReferralConnectCopyService $connectCopyService,
    ) {}

    public function generate(Request $request, OneToOne $oneToOne): JsonResponse
    {
        if ($resp = $this->guard($oneToOne)) {
            return $resp;
        }

        $user = ReligoActorContext::actingUser();
        $cred = UserAiCredential::where('user_id', $user->id)->first();
        if ($cred === null || ! $cred->hasUsableKey()) {
            return response()->json(['message' => 'AI が未設定です。設定画面で AI を有効化し API キーを登録してください。'], 422);
        }

        $contextMode = (string) $request->input('context_mode', 'document');
        if (! in_array($contextMode, ['relationship', 'document'], true)) {
            $contextMode = 'relationship';
        }

        try {
            $payload = $this->service->generate($oneToOne, $user, $cred, $contextMode);
        } catch (InvalidArgumentException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        return response()->json($payload, 201);
    }

    public function index(Request $request, OneToOne $oneToOne): JsonResponse
    {
        if ($resp = $this->guard($oneToOne)) {
            return $resp;
        }

        $user = ReligoActorContext::actingUser();
        $runId = $request->query('run_id');
        $runId = $runId !== null && $runId !== '' ? (int) $runId : null;

        return response()->json(
            $this->service->list($oneToOne, (int) $user->owner_member_id, $runId)
        );
    }

    public function update(PatchReferralSuggestionRequest $request, OneToOneReferralSuggestion $oneToOneReferralSuggestion): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null || $user->owner_member_id === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }

        try {
            $payload = $this->service->updateSuggestion(
                $oneToOneReferralSuggestion,
                (int) $user->owner_member_id,
                $request->validated(),
            );
        } catch (InvalidArgumentException $e) {
            return response()->json(['message' => $e->getMessage()], 403);
        }

        return response()->json($payload);
    }

    public function generateConnectCopy(
        GenerateReferralConnectCopyRequest $request,
        OneToOneReferralSuggestion $oneToOneReferralSuggestion,
    ): JsonResponse {
        $user = ReligoActorContext::actingUser();
        if ($user === null || $user->owner_member_id === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }

        $cred = UserAiCredential::where('user_id', $user->id)->first();
        if ($cred === null || ! $cred->hasUsableKey()) {
            return response()->json(['message' => 'AI が未設定です。設定画面で AI を有効化し API キーを登録してください。'], 422);
        }

        try {
            $payload = $this->connectCopyService->generateForOneToOne(
                $oneToOneReferralSuggestion,
                $user,
                $cred,
                $request->validated(),
            );
        } catch (InvalidArgumentException $e) {
            $code = str_contains($e->getMessage(), '権限') ? 403 : 422;

            return response()->json(['message' => $e->getMessage()], $code);
        }

        return response()->json($payload);
    }

    public function registerIntroduction(
        RegisterReferralIntroductionRequest $request,
        OneToOneReferralSuggestion $oneToOneReferralSuggestion,
    ): JsonResponse {
        $user = ReligoActorContext::actingUser();
        if ($user === null || $user->owner_member_id === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }

        try {
            $payload = $this->registrationService->registerFromOneToOne(
                $oneToOneReferralSuggestion,
                (int) $user->owner_member_id,
                $request->validated(),
                fn ($s) => $this->service->formatSuggestion($s),
            );
        } catch (InvalidArgumentException $e) {
            $code = str_contains($e->getMessage(), '権限') ? 403 : 422;

            return response()->json(['message' => $e->getMessage()], $code);
        }

        return response()->json($payload, 201);
    }

    private function guard(OneToOne $oneToOne): ?JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if (! $user instanceof User) {
            return response()->json(['message' => 'No acting user.'], 403);
        }
        if ($user->owner_member_id === null || (int) $user->owner_member_id !== (int) $oneToOne->owner_member_id) {
            return response()->json(['message' => 'この 1 to 1 を操作する権限がありません。'], 403);
        }

        return null;
    }
}
