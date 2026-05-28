<?php

namespace App\Services\Religo;

use App\Models\Member;
use App\Models\User;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

/**
 * members.email と一致するメンバー向けの初回アカウント作成（SPEC-010 §7.2 / §8）。
 */
class MemberAccountRegistrationService
{
    private function cacheKey(string $email): string
    {
        return 'religo:register:'.Str::lower(trim($email));
    }

    /**
     * @return array{message: string, debug_code?: string}
     */
    public function requestVerificationCode(string $email): array
    {
        $normalized = Str::lower(trim($email));
        $member = $this->resolveMemberForRegistration($normalized, leakExists: false);

        if ($member === null) {
            return [
                'message' => '登録されているメールアドレスの場合、確認コードを送信しました。',
            ];
        }

        if (User::query()->whereRaw('LOWER(email) = ?', [$normalized])->exists()) {
            throw ValidationException::withMessages([
                'email' => ['このメールアドレスは既に登録されています。ログインしてください。'],
            ]);
        }

        $code = str_pad((string) random_int(0, 999999), 6, '0', STR_PAD_LEFT);
        $ttlMinutes = max(1, (int) config('religo.registration_code_ttl_minutes', 30));

        Cache::put($this->cacheKey($normalized), [
            'code' => $code,
            'member_id' => $member->id,
            'workspace_id' => $member->workspace_id,
        ], now()->addMinutes($ttlMinutes));

        $payload = [
            'message' => '登録されているメールアドレスの場合、確認コードを送信しました。',
        ];

        if (config('religo.registration_expose_debug_code', false)) {
            $payload['debug_code'] = $code;
        }

        return $payload;
    }

    public function completeRegistration(string $email, string $code, string $password): User
    {
        $normalized = Str::lower(trim($email));
        $cached = Cache::get($this->cacheKey($normalized));

        if (! is_array($cached) || ! isset($cached['code'], $cached['member_id'])) {
            throw ValidationException::withMessages([
                'code' => ['確認コードが無効または期限切れです。もう一度お試しください。'],
            ]);
        }

        if (! hash_equals((string) $cached['code'], trim($code))) {
            throw ValidationException::withMessages([
                'code' => ['確認コードが正しくありません。'],
            ]);
        }

        if (User::query()->whereRaw('LOWER(email) = ?', [$normalized])->exists()) {
            Cache::forget($this->cacheKey($normalized));
            throw ValidationException::withMessages([
                'email' => ['このメールアドレスは既に登録されています。ログインしてください。'],
            ]);
        }

        /** @var Member|null $member */
        $member = Member::query()->find($cached['member_id']);
        if ($member === null || Str::lower((string) $member->email) !== $normalized) {
            Cache::forget($this->cacheKey($normalized));
            throw ValidationException::withMessages([
                'email' => ['メンバー情報を確認できませんでした。最初からやり直してください。'],
            ]);
        }

        $user = User::query()->create([
            'name' => $member->name,
            'email' => $member->email,
            'password' => Hash::make($password),
            'owner_member_id' => $member->id,
            'default_workspace_id' => $member->workspace_id,
            'religo_role' => User::RELIGO_ROLE_MEMBER,
        ]);

        Cache::forget($this->cacheKey($normalized));

        return $user;
    }

    private function resolveMemberForRegistration(string $normalizedEmail, bool $leakExists): ?Member
    {
        $members = Member::query()
            ->whereNotNull('email')
            ->where('email', '!=', '')
            ->whereRaw('LOWER(email) = ?', [$normalizedEmail])
            ->get();

        if ($members->isEmpty()) {
            return null;
        }

        if ($members->count() > 1) {
            throw ValidationException::withMessages([
                'email' => ['このメールアドレスは複数のチャプターに登録されています。管理者にお問い合わせください。'],
            ]);
        }

        return $members->first();
    }
}
