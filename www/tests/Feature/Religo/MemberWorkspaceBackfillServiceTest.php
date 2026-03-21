<?php

namespace Tests\Feature\Religo;

use App\Models\Member;
use App\Models\User;
use App\Models\Workspace;
use App\Services\Religo\MemberWorkspaceBackfillService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

class MemberWorkspaceBackfillServiceTest extends TestCase
{
    use RefreshDatabase;

    public function test_backfill_sets_workspace_from_user_default_workspace(): void
    {
        $ws = Workspace::create(['name' => 'Chapter', 'slug' => 'ch']);
        $member = Member::create(['name' => 'Owner M', 'type' => 'active']);
        User::factory()->create([
            'owner_member_id' => $member->id,
            'default_workspace_id' => $ws->id,
        ]);
        DB::table('members')->where('id', $member->id)->update(['workspace_id' => null]);

        (new MemberWorkspaceBackfillService())->backfillFromUserDefaultWorkspace();

        $this->assertSame((int) $ws->id, (int) Member::find($member->id)->workspace_id);
    }

    public function test_backfill_from_owner_artifact_when_no_user_workspace(): void
    {
        $ws = Workspace::create(['name' => 'Chapter', 'slug' => 'ch2']);
        $owner = Member::create(['name' => 'O', 'type' => 'active']);
        $target = Member::create(['name' => 'T', 'type' => 'active']);
        DB::table('dragonfly_contact_flags')->insert([
            'owner_member_id' => $owner->id,
            'target_member_id' => $target->id,
            'interested' => false,
            'want_1on1' => false,
            'workspace_id' => $ws->id,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        (new MemberWorkspaceBackfillService())->backfillFromOwnerArtifacts();

        $this->assertSame((int) $ws->id, (int) Member::find($owner->id)->workspace_id);
        $this->assertNull(Member::find($target->id)->workspace_id);
    }

    public function test_single_workspace_fills_remaining_members(): void
    {
        Workspace::create(['name' => 'Only', 'slug' => 'only']);
        $m1 = Member::create(['name' => 'A', 'type' => 'active']);
        $m2 = Member::create(['name' => 'B', 'type' => 'active']);
        $onlyId = (int) Workspace::query()->orderBy('id')->value('id');

        (new MemberWorkspaceBackfillService())->backfillWhenSingleWorkspaceOnly();

        $this->assertSame($onlyId, (int) $m1->fresh()->workspace_id);
        $this->assertSame($onlyId, (int) $m2->fresh()->workspace_id);
    }

    public function test_single_workspace_skipped_when_multiple_workspaces(): void
    {
        Workspace::create(['name' => 'W1', 'slug' => 'w1']);
        Workspace::create(['name' => 'W2', 'slug' => 'w2']);
        $m = Member::create(['name' => 'X', 'type' => 'active']);

        (new MemberWorkspaceBackfillService())->backfillWhenSingleWorkspaceOnly();

        $this->assertNull($m->fresh()->workspace_id);
    }
}
