<?php

namespace Tests\Feature\Religo;

use App\Models\ContactMemo;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * GET /api/contact-memos. Phase17A. owner/target 必須、limit 任意.
 */
class ContactMemosIndexTest extends TestCase
{
    use RefreshDatabase;

    private int $ownerId;
    private int $targetId;

    protected function setUp(): void
    {
        parent::setUp();
        $this->ownerId = (int) DB::table('members')->insertGetId([
            'name' => 'Owner',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->targetId = (int) DB::table('members')->insertGetId([
            'name' => 'Target',
            'type' => 'active',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function test_index_returns_200_with_owner_and_target(): void
    {
        $res = $this->getJson('/api/contact-memos?' . http_build_query([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
        ]));
        $res->assertOk();
        $data = $res->json();
        $this->assertIsArray($data);
        $this->assertCount(0, $data);
    }

    public function test_index_returns_memos_ordered_by_created_at_desc(): void
    {
        ContactMemo::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'memo_type' => 'other',
            'body' => 'First',
        ]);
        ContactMemo::create([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'memo_type' => 'other',
            'body' => 'Second',
        ]);
        $res = $this->getJson('/api/contact-memos?' . http_build_query([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
        ]));
        $res->assertOk();
        $data = $res->json();
        $this->assertCount(2, $data);
        $this->assertSame('Second', $data[0]['body']);
        $this->assertSame('First', $data[1]['body']);
    }

    public function test_index_requires_owner_member_id(): void
    {
        $res = $this->getJson('/api/contact-memos?target_member_id=' . $this->targetId);
        $res->assertStatus(422);
    }

    public function test_index_requires_target_member_id(): void
    {
        $res = $this->getJson('/api/contact-memos?owner_member_id=' . $this->ownerId);
        $res->assertStatus(422);
    }

    public function test_limit_applied(): void
    {
        for ($i = 0; $i < 5; $i++) {
            ContactMemo::create([
                'owner_member_id' => $this->ownerId,
                'target_member_id' => $this->targetId,
                'memo_type' => 'other',
                'body' => "Memo {$i}",
            ]);
        }
        $res = $this->getJson('/api/contact-memos?' . http_build_query([
            'owner_member_id' => $this->ownerId,
            'target_member_id' => $this->targetId,
            'limit' => 2,
        ]));
        $res->assertOk();
        $data = $res->json();
        $this->assertCount(2, $data);
    }
}
