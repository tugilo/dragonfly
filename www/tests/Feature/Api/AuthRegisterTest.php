<?php

namespace Tests\Feature\Api;

use App\Mail\ReligoRegistrationVerificationMail;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Tests\TestCase;

class AuthRegisterTest extends TestCase
{
    use RefreshDatabase;

    public function test_request_returns_debug_code_for_known_member_email_when_exposed(): void
    {
        Mail::fake();
        config(['religo.registration_expose_debug_code' => true]);

        $wsId = $this->createWorkspace();
        $this->createMember($wsId, 'taro@example.com', 'Taro');

        $res = $this->postJson('/api/auth/register/request', [
            'email' => 'taro@example.com',
        ]);

        $res->assertOk();
        $res->assertJsonStructure(['message', 'debug_code']);
        $this->assertMatchesRegularExpression('/^\d{6}$/', $res->json('debug_code'));
        Mail::assertSent(ReligoRegistrationVerificationMail::class, function (ReligoRegistrationVerificationMail $mail) use ($res) {
            return $mail->hasTo('taro@example.com')
                && $mail->code === $res->json('debug_code');
        });
    }

    public function test_request_sends_verification_mail_for_known_member(): void
    {
        Mail::fake();
        config(['religo.registration_expose_debug_code' => false]);

        $wsId = $this->createWorkspace();
        $this->createMember($wsId, 'taro@example.com', 'Taro Yamada');

        $res = $this->postJson('/api/auth/register/request', [
            'email' => 'taro@example.com',
        ]);

        $res->assertOk();
        $res->assertJsonMissing(['debug_code']);
        Mail::assertSent(ReligoRegistrationVerificationMail::class, function (ReligoRegistrationVerificationMail $mail) {
            return $mail->hasTo('taro@example.com')
                && $mail->memberName === 'Taro Yamada'
                && preg_match('/^\d{6}$/', $mail->code) === 1
                && $mail->ttlMinutes >= 1;
        });
    }

    public function test_request_returns_422_for_unknown_email(): void
    {
        Mail::fake();

        $res = $this->postJson('/api/auth/register/request', [
            'email' => 'unknown@example.com',
        ]);

        $res->assertStatus(422);
        $res->assertJsonValidationErrors(['email']);
        $res->assertJsonMissing(['debug_code']);
        Mail::assertNothingSent();
        $this->assertNull(Cache::get('religo:register:unknown@example.com'));
    }

    public function test_request_returns_503_and_clears_cache_when_mail_fails(): void
    {
        config(['religo.registration_expose_debug_code' => false]);
        $wsId = $this->createWorkspace();
        $this->createMember($wsId, 'taro@example.com', 'Taro');

        Mail::shouldReceive('to')->once()->andThrow(new \RuntimeException('SMTP error'));

        $res = $this->postJson('/api/auth/register/request', [
            'email' => 'taro@example.com',
        ]);

        $res->assertStatus(503);
        $res->assertJsonPath('message', '送信に失敗しました。しばらくしてから再度お試しください。');
        $this->assertNull(Cache::get('religo:register:taro@example.com'));
    }

    public function test_complete_creates_user_bound_to_member(): void
    {
        Mail::fake();
        config(['religo.registration_expose_debug_code' => true]);

        $wsId = $this->createWorkspace();
        $memberId = $this->createMember($wsId, 'taro@example.com', 'Taro');

        $request = $this->postJson('/api/auth/register/request', [
            'email' => 'taro@example.com',
        ]);
        $code = $request->json('debug_code');

        $res = $this->postJson('/api/auth/register/complete', [
            'email' => 'taro@example.com',
            'code' => $code,
            'password' => 'secret-pass',
            'password_confirmation' => 'secret-pass',
        ]);

        $res->assertCreated();
        $this->assertDatabaseHas('users', [
            'email' => 'taro@example.com',
            'owner_member_id' => $memberId,
            'default_workspace_id' => $wsId,
            'religo_role' => User::RELIGO_ROLE_MEMBER,
        ]);

        $login = $this->postJson('/api/auth/login', [
            'email' => 'taro@example.com',
            'password' => 'secret-pass',
        ]);
        $login->assertOk();
    }

    public function test_complete_rejects_wrong_code(): void
    {
        Mail::fake();
        config(['religo.registration_expose_debug_code' => true]);

        $wsId = $this->createWorkspace();
        $this->createMember($wsId, 'taro@example.com', 'Taro');

        $this->postJson('/api/auth/register/request', [
            'email' => 'taro@example.com',
        ]);

        $res = $this->postJson('/api/auth/register/complete', [
            'email' => 'taro@example.com',
            'code' => '000000',
            'password' => 'secret-pass',
            'password_confirmation' => 'secret-pass',
        ]);

        $res->assertStatus(422);
    }

    public function test_request_rejects_existing_user_email(): void
    {
        Mail::fake();

        $wsId = $this->createWorkspace();
        $this->createMember($wsId, 'taro@example.com', 'Taro');
        User::factory()->create(['email' => 'taro@example.com']);

        $res = $this->postJson('/api/auth/register/request', [
            'email' => 'taro@example.com',
        ]);

        $res->assertStatus(422);
        Mail::assertNothingSent();
    }

    private function createWorkspace(): int
    {
        return (int) DB::table('workspaces')->insertGetId([
            'name' => 'Test WS',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    private function createMember(int $wsId, string $email, string $name): int
    {
        return (int) DB::table('members')->insertGetId([
            'name' => $name,
            'name_kana' => 'テスト',
            'display_no' => '1',
            'type' => 'active',
            'workspace_id' => $wsId,
            'email' => $email,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    protected function tearDown(): void
    {
        Cache::flush();
        parent::tearDown();
    }
}
