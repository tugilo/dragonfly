<?php

namespace Tests\Feature\Religo;

use App\Models\ContactMemo;
use App\Models\Meeting;
use App\Models\Member;
use App\Models\OneToOne;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

/**
 * GET /api/dashboard/stats, tasks, activity. Phase E-1, E-4. SSOT: DASHBOARD_REQUIREMENTS.md §5.
 */
class DashboardApiTest extends TestCase
{
    use RefreshDatabase;

    private int $ownerId;

    protected function setUp(): void
    {
        parent::setUp();
        $this->ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    private function createMeUser(?int $ownerMemberId): void
    {
        DB::table('users')->insert([
            'id' => 1,
            'name' => 'Me',
            'email' => 'me@example.com',
            'password' => Hash::make('password'),
            'remember_token' => null,
            'created_at' => now(),
            'updated_at' => now(),
            'owner_member_id' => $ownerMemberId,
        ]);
    }

    public function test_stats_returns_200_with_required_keys(): void
    {
        $res = $this->getJson('/api/dashboard/stats?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $data = $res->json();
        $this->assertIsArray($data);
        $this->assertArrayHasKey('stale_contacts_count', $data);
        $this->assertArrayHasKey('monthly_one_to_one_count', $data);
        $this->assertArrayHasKey('monthly_intro_memo_count', $data);
        $this->assertArrayHasKey('monthly_meeting_memo_count', $data);
        $this->assertArrayHasKey('subtexts', $data);
        $this->assertIsInt($data['stale_contacts_count']);
        $this->assertIsArray($data['subtexts']);
    }

    public function test_stats_returns_404_when_owner_not_found(): void
    {
        $res = $this->getJson('/api/dashboard/stats?owner_member_id=99999');
        $res->assertStatus(404);
        $data = $res->json();
        $this->assertArrayHasKey('message', $data);
    }

    /** E-4: user.owner_member_id が設定済みなら query なしで 200 */
    public function test_stats_returns_200_without_query_when_user_owner_set(): void
    {
        $this->createMeUser($this->ownerId);
        $res = $this->getJson('/api/dashboard/stats');
        $res->assertOk();
        $data = $res->json();
        $this->assertArrayHasKey('stale_contacts_count', $data);
    }

    /** E-4: user.owner_member_id が未設定なら 422 */
    public function test_stats_returns_422_when_owner_not_set(): void
    {
        $this->createMeUser(null);
        $res = $this->getJson('/api/dashboard/stats');
        $res->assertStatus(422);
        $data = $res->json();
        $this->assertArrayHasKey('message', $data);
    }

    public function test_tasks_returns_200_array(): void
    {
        $res = $this->getJson('/api/dashboard/tasks?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $data = $res->json();
        $this->assertIsArray($data);
        foreach ($data as $task) {
            $this->assertArrayHasKey('id', $task);
            $this->assertArrayHasKey('kind', $task);
            $this->assertArrayHasKey('title', $task);
            $this->assertArrayHasKey('action', $task);
        }
    }

    public function test_tasks_returns_404_when_owner_not_found(): void
    {
        $res = $this->getJson('/api/dashboard/tasks?owner_member_id=99999');
        $res->assertStatus(404);
    }

    public function test_activity_returns_200_array_with_required_keys(): void
    {
        $res = $this->getJson('/api/dashboard/activity?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $data = $res->json();
        $this->assertIsArray($data);
        foreach ($data as $item) {
            $this->assertArrayHasKey('id', $item);
            $this->assertArrayHasKey('occurred_at', $item);
            $this->assertArrayHasKey('kind', $item);
            $this->assertArrayHasKey('title', $item);
            $this->assertArrayHasKey('meta', $item);
        }
    }

    public function test_activity_respects_limit(): void
    {
        $targetId = (int) DB::table('members')->insertGetId([
            'name' => 'Target',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $workspaceId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'W',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        for ($i = 0; $i < 10; $i++) {
            ContactMemo::create([
                'owner_member_id' => $this->ownerId,
                'target_member_id' => $targetId,
                'memo_type' => 'other',
                'body' => "Memo {$i}",
            ]);
        }
        $res = $this->getJson('/api/dashboard/activity?owner_member_id=' . $this->ownerId . '&limit=3');
        $res->assertOk();
        $data = $res->json();
        $this->assertCount(3, $data);
    }

    public function test_activity_returns_404_when_owner_not_found(): void
    {
        $res = $this->getJson('/api/dashboard/activity?owner_member_id=99999');
        $res->assertStatus(404);
    }
}
