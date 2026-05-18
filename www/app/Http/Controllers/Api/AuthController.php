<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use Laravel\Sanctum\PersonalAccessToken;

class AuthController extends Controller
{
    /**
     * POST /api/auth/login — Sanctum 個人アクセストークンを発行（SPEC-010）。
     */
    public function login(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'email' => ['required', 'email'],
            'password' => ['required', 'string'],
            'device_name' => ['sometimes', 'string', 'max:255'],
        ]);

        /** @var User|null $user */
        $user = User::query()->where('email', $validated['email'])->first();
        if ($user === null || ! Hash::check($validated['password'], $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['認証に失敗しました。'],
            ]);
        }

        $deviceName = $validated['device_name'] ?? 'api';
        $token = $user->createToken($deviceName)->plainTextToken;

        return response()->json([
            'token' => $token,
            'token_type' => 'Bearer',
            'user' => [
                'id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
            ],
        ]);
    }

    /**
     * POST /api/auth/logout — 現在のトークンを破棄。
     */
    public function logout(Request $request): JsonResponse
    {
        $plain = $request->bearerToken();
        if ($plain !== null && $plain !== '') {
            $pat = PersonalAccessToken::findToken($plain);
            $pat?->delete();
        }

        return response()->json(['message' => 'Logged out.']);
    }
}
