<?php

namespace Tests\Feature\Religo;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\Support\ReligoSanctumTestHelpers;
use Tests\TestCase;

/**
 * SPEC-020 Phase A: owner スコープ系 API は未認証 401。
 */
class AuthBoundaryHardeningTest extends TestCase
{
    use RefreshDatabase;
    use ReligoSanctumTestHelpers;

    /**
     * @dataProvider protectedGetRoutesProvider
     */
    public function test_protected_get_routes_require_authentication(string $uri): void
    {
        $this->getJson($uri)->assertUnauthorized();
    }

    public static function protectedGetRoutesProvider(): array
    {
        return [
            'dashboard stats' => ['/api/dashboard/stats'],
            'users me' => ['/api/users/me'],
            'one-to-ones index' => ['/api/one-to-ones'],
            'contact memos' => ['/api/contact-memos'],
            'introductions' => ['/api/introductions'],
            'dragonfly flags' => ['/api/dragonfly/flags'],
            'dragonfly members' => ['/api/dragonfly/members'],
            'meetings index' => ['/api/meetings'],
            'categories index' => ['/api/categories'],
        ];
    }

    public function test_authenticated_user_can_access_dashboard_stats(): void
    {
        $ownerId = (int) \DB::table('members')->insertGetId([
            'name' => 'Owner',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->actingAsReligoUser($ownerId);

        $this->getJson('/api/dashboard/stats?owner_member_id='.$ownerId)
            ->assertOk();
    }

    public function test_acting_user_fallback_defaults_to_false(): void
    {
        $this->assertFalse(config('religo.acting_user_fallback'));
    }
}
