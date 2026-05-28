<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Services\Religo\MemberAccountRegistrationService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class AuthRegisterController extends Controller
{
    public function __construct(
        private readonly MemberAccountRegistrationService $registration
    ) {}

    /**
     * POST /api/auth/register/request — members.email 一致時に確認コードを発行。
     */
    public function request(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'email' => ['required', 'email', 'max:255'],
        ]);

        $result = $this->registration->requestVerificationCode($validated['email']);

        return response()->json($result);
    }

    /**
     * POST /api/auth/register/complete — 確認コードとパスワードで users を作成。
     */
    public function complete(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'email' => ['required', 'email', 'max:255'],
            'code' => ['required', 'string', 'size:6'],
            'password' => ['required', 'string', 'min:8', 'confirmed'],
        ]);

        $user = $this->registration->completeRegistration(
            $validated['email'],
            $validated['code'],
            $validated['password']
        );

        return response()->json([
            'message' => 'アカウントを作成しました。ログインしてください。',
            'user' => [
                'id' => $user->id,
                'email' => $user->email,
                'owner_member_id' => $user->owner_member_id,
            ],
        ], 201);
    }
}
