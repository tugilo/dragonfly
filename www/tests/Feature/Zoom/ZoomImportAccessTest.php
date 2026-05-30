<?php

namespace Tests\Feature\Zoom;

use App\Models\User;
use App\Models\ZoomMeetingImport;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

/**
 * SPEC-012: Zoom 連携は「認証済みユーザー単位」。chapter_admin 限定ではない（各ユーザーが自分の Zoom を扱う）。
 */
class ZoomImportAccessTest extends TestCase
{
    use RefreshDatabase;

    private function makeUser(string $email, string $role = User::RELIGO_ROLE_MEMBER): User
    {
        return User::create([
            'name' => $email,
            'email' => $email,
            'password' => bcrypt('secret-password'),
            'religo_role' => $role,
        ]);
    }

    public function test_status_requires_authentication(): void
    {
        $this->getJson('/api/zoom/status')->assertStatus(401);
    }

    public function test_status_ok_for_any_authenticated_member(): void
    {
        $user = $this->makeUser('member@example.com', User::RELIGO_ROLE_MEMBER);
        Sanctum::actingAs($user);

        $res = $this->getJson('/api/zoom/status');
        $res->assertOk();
        $res->assertJsonStructure(['configured', 'connected']);
    }

    public function test_imports_index_scoped_to_acting_user(): void
    {
        $userA = $this->makeUser('a@example.com');
        $userB = $this->makeUser('b@example.com');
        $this->makeImport($userA);

        Sanctum::actingAs($userB);
        $res = $this->getJson('/api/zoom/imports');
        $res->assertOk();
        $res->assertJsonCount(0); // B は A の候補を見られない
    }

    public function test_user_cannot_update_other_users_import(): void
    {
        $userA = $this->makeUser('a2@example.com');
        $userB = $this->makeUser('b2@example.com');
        $import = $this->makeImport($userA);

        Sanctum::actingAs($userB);
        $this->putJson('/api/zoom/imports/'.$import->id, ['selected' => true])
            ->assertStatus(403);
    }

    private function makeImport(User $user): ZoomMeetingImport
    {
        $memberId = (int) DB::table('members')->insertGetId([
            'name' => 'X '.$user->id,
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        return ZoomMeetingImport::create([
            'user_id' => $user->id,
            'owner_member_id' => $memberId,
            'zoom_meeting_id' => '900'.$user->id,
            'zoom_meeting_uuid' => 'uuid-'.$user->id,
            'kind' => ZoomMeetingImport::KIND_PAST,
            'topic' => 'Test 1to1',
            'is_one_to_one_candidate' => true,
            'confidence' => 'high',
            'match_status' => 'unmatched',
            'selected' => false,
            'status' => ZoomMeetingImport::STATUS_PENDING,
        ]);
    }
}
