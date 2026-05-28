<?php

namespace App\Http\Controllers\Religo\Concerns;

use App\Models\Member;
use App\Services\Religo\ReligoActorContext;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

trait ResolvesReligoOwner
{
    private function resolveOwnerMemberId(Request $request): int|false
    {
        if ($request->filled('owner_member_id')) {
            return (int) $request->input('owner_member_id');
        }
        $user = ReligoActorContext::actingUser();
        if ($user && $user->owner_member_id !== null) {
            return (int) $user->owner_member_id;
        }

        return false;
    }

    private function ownerNotConfiguredResponse(): JsonResponse
    {
        return response()->json(['message' => 'オーナーが未設定です。ダッシュボード上でオーナーを選択してください。'], 422);
    }

    private function assertOwnerMemberExists(int $ownerMemberId): JsonResponse|null
    {
        if (! Member::where('id', $ownerMemberId)->exists()) {
            return response()->json(['message' => 'Owner member not found.'], 404);
        }

        return null;
    }
}
