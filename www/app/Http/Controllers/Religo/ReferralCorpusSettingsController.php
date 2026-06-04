<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Requests\Religo\PatchReferralCorpusSettingsRequest;
use App\Models\User;
use App\Services\Religo\ReferralCorpusSettingsService;
use App\Services\Religo\ReligoActorContext;
use Illuminate\Http\JsonResponse;

/**
 * Phase 195: 横断コーパス共有設定 API。
 */
class ReferralCorpusSettingsController extends Controller
{
    public function __construct(
        private ReferralCorpusSettingsService $service,
    ) {}

    public function show(): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if (! $user instanceof User || $user->owner_member_id === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }

        $workspaceId = ReligoActorContext::resolveWorkspaceIdForUser($user);

        return response()->json($this->service->showForUser($user, $workspaceId));
    }

    public function update(PatchReferralCorpusSettingsRequest $request): JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if (! $user instanceof User || $user->owner_member_id === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }

        $workspaceId = ReligoActorContext::resolveWorkspaceIdForUser($user);

        return response()->json(
            $this->service->updateForUser($user, $workspaceId, $request->validated()),
        );
    }
}
