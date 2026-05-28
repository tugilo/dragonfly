<?php

namespace App\Services\Religo;

use App\Mail\ReligoRegistrationVerificationMail;
use App\Models\Member;
use App\Models\User;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;
use Throwable;

/**
 * members.email と一致するメンバー向けの初回アカウント作成（SPEC-010 §7.2 / SPEC-011）。
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
        $member = $this->resolveMemberForRegistration($normalized);

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
        $cacheKey = $this->cacheKey($normalized);

        Cache::put($cacheKey, [
            'code' => $code,
            'member_id' => $member->id,
            'workspace_id' => $member->workspace_id,
        ], now()->addMinutes($ttlMinutes));

        try {
            Mail::to($member->email)->send(
                new ReligoRegistrationVerificationMail(
                    memberName: $member->name,
                    code: $code,
                    ttlMinutes: $ttlMinutes,
                )
            );
        } catch (Throwable $e) {
            Cache::forget($cacheKey);
            Log::error('Religo registration verification mail failed', [
                'email' => $normalized,
                'member_id' => $member->id,
                'error' => $e->getMessage(),
            ]);
            throw new HttpResponseException(response()->json([
                'message' => '送信に失敗しました。しばらくしてから再度お試しください。',
            ], 503));
        }

        Log::info('Religo registration verification mail sent', [
            'email' => $normalized,
            'member_id' => $member->id,
            'workspace_id' => $member->workspace_id,
        ]);

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

    private function resolveMemberForRegistration(string $normalizedEmail): ?Member
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
