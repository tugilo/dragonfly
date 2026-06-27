<?php

namespace Tests\Support;

use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\Sanctum;

/**
 * SPEC-020 Phase A: sanctum 必須 API の Feature test 用ヘルパ。
 */
trait ReligoSanctumTestHelpers
{
    protected function createReligoUser(
        ?int $ownerMemberId = null,
        string $email = 'religo-test@example.com',
        string $role = User::RELIGO_ROLE_MEMBER,
        ?int $defaultWorkspaceId = null,
    ): User {
        return User::create([
            'name' => 'Religo Test User',
            'email' => $email,
            'password' => Hash::make('password'),
            'owner_member_id' => $ownerMemberId,
            'default_workspace_id' => $defaultWorkspaceId,
            'religo_role' => $role,
        ]);
    }

    protected function actingAsReligoUser(
        ?int $ownerMemberId = null,
        string $email = 'religo-test@example.com',
        string $role = User::RELIGO_ROLE_MEMBER,
    ): User {
        $user = $this->createReligoUser($ownerMemberId, $email, $role);
        Sanctum::actingAs($user);

        return $user;
    }
}
