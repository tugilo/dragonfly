<?php

namespace Tests\Feature\Religo;

use App\Models\ContactMemo;
use App\Models\DragonflyContactFlag;
use App\Models\Meeting;
use App\Models\OneToOne;
use Carbon\Carbon;
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

    public function test_stats_subtexts_include_month_over_month_for_one_to_one(): void
    {
        $this->travelTo(Carbon::parse('2026-03-15 12:00:00', config('app.timezone')));
        $targetId = (int) DB::table('members')->insertGetId([
            'name' => 'T',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        OneToOne::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $targetId,
            'status' => 'completed',
            'started_at' => '2026-02-10 10:00:00',
        ]);
        OneToOne::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $targetId,
            'status' => 'completed',
            'started_at' => '2026-03-10 11:00:00',
        ]);
        OneToOne::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $targetId,
            'status' => 'completed',
            'started_at' => '2026-03-12 11:00:00',
        ]);
        $res = $this->getJson('/api/dashboard/stats?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $this->assertStringContainsString('先月', $res->json('subtexts.one_to_one'));
    }

    public function test_tasks_second_stale_row_has_member_show_deep_link(): void
    {
        $lowId = (int) DB::table('members')->insertGetId([
            'name' => 'Stale A',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $highId = (int) DB::table('members')->insertGetId([
            'name' => 'Stale B',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->assertLessThan($highId, $lowId);
        $res = $this->getJson('/api/dashboard/tasks?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $staleTasks = array_values(array_filter($res->json(), fn ($t) => ($t['kind'] ?? '') === 'stale_follow'));
        $this->assertGreaterThanOrEqual(2, count($staleTasks));
        $second = $staleTasks[1];
        $this->assertSame('メモ追加', $second['action']['label']);
        $this->assertSame('/members/' . $highId . '/show', $second['action']['href']);
        $this->assertFalse($second['action']['disabled']);
    }

    /** P2: 開催済み例会が無い（未来のみ）→ meeting_follow_up は出さない */
    public function test_tasks_meeting_follow_up_absent_when_only_future_meetings(): void
    {
        $this->travelTo(Carbon::parse('2026-03-20 10:00:00', config('app.timezone')));
        Meeting::create([
            'number' => 900,
            'held_on' => '2026-03-23',
            'name' => 'Next',
        ]);
        $res = $this->getJson('/api/dashboard/tasks?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $meetingTask = collect($res->json())->firstWhere('kind', 'meeting_follow_up');
        $this->assertNull($meetingTask);
    }

    /** P2: 直近開催済みがあり例会メモ無し→ task 表示 */
    public function test_tasks_meeting_follow_up_when_last_held_has_no_meeting_memo(): void
    {
        $this->travelTo(Carbon::parse('2026-03-20 10:00:00', config('app.timezone')));
        $m = Meeting::create([
            'number' => 50,
            'held_on' => '2026-03-01',
            'name' => 'Past',
        ]);
        $res = $this->getJson('/api/dashboard/tasks?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $meetingTask = collect($res->json())->firstWhere('kind', 'meeting_follow_up');
        $this->assertNotNull($meetingTask);
        $this->assertSame((string) $m->number, $meetingTask['meeting_number']);
        $this->assertStringContainsString('未記録', $meetingTask['meta']);
        $this->assertStringContainsString('3/1', $meetingTask['meta']);
    }

    /** P2: 開催日が本日・メモ無し（held_on は travelTo 後の now() と同一暦日に揃える） */
    public function test_tasks_meeting_follow_up_meta_today_when_held_today_without_memo(): void
    {
        $this->travelTo(Carbon::parse('2026-03-20 10:00:00', config('app.timezone')));
        Meeting::create([
            'number' => 901,
            'held_on' => now()->toDateString(),
            'name' => 'This week',
        ]);
        $res = $this->getJson('/api/dashboard/tasks?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $meetingTask = collect($res->json())->firstWhere('kind', 'meeting_follow_up');
        $this->assertNotNull($meetingTask);
        $this->assertStringContainsString('本日', $meetingTask['meta']);
        $this->assertStringContainsString('未記録', $meetingTask['meta']);
    }

    /** P2: 例会メモあり→ task なし（owner 行は見ない・会議単位で Meeting 一覧 has_memo と整合） */
    public function test_tasks_meeting_follow_up_hidden_when_meeting_memo_exists(): void
    {
        $this->travelTo(Carbon::parse('2026-03-20 10:00:00', config('app.timezone')));
        $targetId = (int) DB::table('members')->insertGetId([
            'name' => 'MemoPeer',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $m = Meeting::create([
            'number' => 51,
            'held_on' => '2026-03-01',
            'name' => 'PastWithMemo',
        ]);
        ContactMemo::create([
            'owner_member_id' => $targetId,
            'target_member_id' => $this->ownerId,
            'meeting_id' => $m->id,
            'memo_type' => 'meeting',
            'body' => '例会の記録あり',
        ]);
        $res = $this->getJson('/api/dashboard/tasks?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $this->assertNull(collect($res->json())->firstWhere('kind', 'meeting_follow_up'));
    }

    /** P2: 紹介メモだけでは「記録済み」にしない */
    public function test_tasks_meeting_follow_up_still_shows_when_only_introduction_memo_on_meeting(): void
    {
        $this->travelTo(Carbon::parse('2026-03-20 10:00:00', config('app.timezone')));
        $targetId = (int) DB::table('members')->insertGetId([
            'name' => 'IntroPeer',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $m = Meeting::create([
            'number' => 52,
            'held_on' => '2026-03-02',
            'name' => 'PastIntroOnly',
        ]);
        ContactMemo::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $targetId,
            'meeting_id' => $m->id,
            'memo_type' => 'introduction',
            'body' => '紹介だけ',
        ]);
        $res = $this->getJson('/api/dashboard/tasks?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $meetingTask = collect($res->json())->firstWhere('kind', 'meeting_follow_up');
        $this->assertNotNull($meetingTask);
        $this->assertSame((string) $m->number, $meetingTask['meeting_number']);
    }

    /** P2: 別例会のメモは「直近」判定に影響しない（直近にメモが無ければ出す） */
    public function test_tasks_meeting_follow_up_uses_last_held_only_for_memo_check(): void
    {
        $this->travelTo(Carbon::parse('2026-03-20 10:00:00', config('app.timezone')));
        $older = Meeting::create([
            'number' => 60,
            'held_on' => '2026-02-01',
            'name' => 'Older',
        ]);
        $latest = Meeting::create([
            'number' => 61,
            'held_on' => '2026-03-10',
            'name' => 'Latest',
        ]);
        $targetId = (int) DB::table('members')->insertGetId([
            'name' => 'X',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        ContactMemo::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $targetId,
            'meeting_id' => $older->id,
            'memo_type' => 'meeting',
            'body' => '古い方だけ記録',
        ]);
        $res = $this->getJson('/api/dashboard/tasks?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $meetingTask = collect($res->json())->firstWhere('kind', 'meeting_follow_up');
        $this->assertNotNull($meetingTask);
        $this->assertSame((string) $latest->number, $meetingTask['meeting_number']);
    }

    public function test_activity_includes_bo_assigned_after_breakout_save(): void
    {
        $this->createMeUser($this->ownerId);
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 501,
            'held_on' => now()->toDateString(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $targetId = (int) DB::table('members')->insertGetId([
            'name' => 'BoMember',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $payload = [
            'rooms' => [
                ['room_label' => 'BO1', 'notes' => null, 'member_ids' => [$this->ownerId, $targetId]],
                ['room_label' => 'BO2', 'notes' => null, 'member_ids' => []],
            ],
        ];
        $this->putJson("/api/meetings/{$meetingId}/breakouts", $payload)->assertOk();
        $res = $this->getJson('/api/dashboard/activity?owner_member_id=' . $this->ownerId);
        $res->assertOk();
        $items = $res->json();
        $bo = collect($items)->firstWhere('kind', 'bo_assigned');
        $this->assertNotNull($bo);
        $this->assertStringContainsString('501', $bo['title']);
        $this->assertStringContainsString('BO1/BO2', $bo['meta'] ?? '');
    }

    public function test_activity_includes_flag_changed_and_intro_memo_kind(): void
    {
        $targetId = (int) DB::table('members')->insertGetId([
            'name' => 'FlagTarget',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $workspaceId = (int) DB::table('workspaces')->insertGetId([
            'name' => 'W',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DragonflyContactFlag::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $targetId,
            'interested' => true,
            'want_1on1' => false,
            'workspace_id' => $workspaceId,
        ]);
        ContactMemo::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $targetId,
            'memo_type' => 'introduction',
            'body' => '紹介メモ本文',
            'workspace_id' => $workspaceId,
        ]);
        $res = $this->getJson('/api/dashboard/activity?owner_member_id=' . $this->ownerId . '&limit=20');
        $res->assertOk();
        $kinds = array_column($res->json(), 'kind');
        $this->assertContains('flag_changed', $kinds);
        $this->assertContains('memo_introduction', $kinds);
    }
}
