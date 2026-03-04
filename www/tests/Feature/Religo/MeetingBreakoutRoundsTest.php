<?php

namespace Tests\Feature\Religo;

use App\Models\Meeting;
use App\Models\Participant;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\TestCase;

/**
 * GET/PUT /api/meetings/{meetingId}/breakout-rounds. Phase10R. SSOT: PHASE10R PLAN.
 */
class MeetingBreakoutRoundsTest extends TestCase
{
    use RefreshDatabase;

    private int $meetingId;
    private int $member1;
    private int $member2;
    private int $member3;
    private int $member4;

    protected function setUp(): void
    {
        parent::setUp();
        $this->meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 200,
            'held_on' => now()->toDateString(),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        foreach (['M1', 'M2', 'M3', 'M4'] as $i => $name) {
            $key = 'member' . ($i + 1);
            $this->{$key} = (int) DB::table('members')->insertGetId([
                'name' => $name,
                'type' => 'active',
                'created_at' => now(),
                'updated_at' => now(),
            ]);
        }
    }

    public function test_put_round1_and_round2_then_get_matches(): void
    {
        $payload = [
            'rounds' => [
                [
                    'round_no' => 1,
                    'label' => 'Round 1',
                    'rooms' => [
                        ['room_label' => 'BO1', 'notes' => 'R1 BO1 memo', 'member_ids' => [$this->member1, $this->member2]],
                        ['room_label' => 'BO2', 'notes' => 'R1 BO2 memo', 'member_ids' => [$this->member3]],
                    ],
                ],
                [
                    'round_no' => 2,
                    'label' => 'Round 2',
                    'rooms' => [
                        ['room_label' => 'BO1', 'notes' => 'R2 BO1', 'member_ids' => [$this->member1, $this->member3]],
                        ['room_label' => 'BO2', 'notes' => '', 'member_ids' => [$this->member2]],
                    ],
                ],
            ],
        ];
        $put = $this->putJson("/api/meetings/{$this->meetingId}/breakout-rounds", $payload);
        $put->assertOk();
        $get = $this->getJson("/api/meetings/{$this->meetingId}/breakout-rounds");
        $get->assertOk();
        $data = $get->json();
        $this->assertArrayHasKey('meeting', $data);
        $this->assertSame($this->meetingId, $data['meeting']['id']);
        $rounds = $data['rounds'];
        $this->assertCount(2, $rounds);

        $r1 = collect($rounds)->firstWhere('round_no', 1);
        $this->assertNotNull($r1);
        $this->assertSame('Round 1', $r1['label']);
        $bo1r1 = collect($r1['rooms'])->firstWhere('room_label', 'BO1');
        $bo2r1 = collect($r1['rooms'])->firstWhere('room_label', 'BO2');
        $this->assertSame('R1 BO1 memo', $bo1r1['notes']);
        $this->assertSame('R1 BO2 memo', $bo2r1['notes']);
        sort($bo1r1['member_ids']);
        $this->assertSame([$this->member1, $this->member2], $bo1r1['member_ids']);
        $this->assertSame([$this->member3], $bo2r1['member_ids']);

        $r2 = collect($rounds)->firstWhere('round_no', 2);
        $this->assertNotNull($r2);
        $this->assertSame('Round 2', $r2['label']);
        $bo1r2 = collect($r2['rooms'])->firstWhere('room_label', 'BO1');
        $bo2r2 = collect($r2['rooms'])->firstWhere('room_label', 'BO2');
        $this->assertSame('R2 BO1', $bo1r2['notes']);
        sort($bo1r2['member_ids']);
        $this->assertSame([$this->member1, $this->member3], $bo1r2['member_ids']);
        $this->assertSame([$this->member2], $bo2r2['member_ids']);
    }

    public function test_same_member_in_same_round_returns_422(): void
    {
        $payload = [
            'rounds' => [
                [
                    'round_no' => 1,
                    'label' => 'Round 1',
                    'rooms' => [
                        ['room_label' => 'BO1', 'notes' => null, 'member_ids' => [$this->member1, $this->member2]],
                        ['room_label' => 'BO2', 'notes' => null, 'member_ids' => [$this->member1]],
                    ],
                ],
            ],
        ];
        $res = $this->putJson("/api/meetings/{$this->meetingId}/breakout-rounds", $payload);
        $res->assertStatus(422);
    }

    public function test_same_member_in_different_rounds_ok(): void
    {
        $payload = [
            'rounds' => [
                [
                    'round_no' => 1,
                    'label' => 'Round 1',
                    'rooms' => [
                        ['room_label' => 'BO1', 'notes' => null, 'member_ids' => [$this->member1]],
                        ['room_label' => 'BO2', 'notes' => null, 'member_ids' => [$this->member2]],
                    ],
                ],
                [
                    'round_no' => 2,
                    'label' => 'Round 2',
                    'rooms' => [
                        ['room_label' => 'BO1', 'notes' => null, 'member_ids' => [$this->member1]],
                        ['room_label' => 'BO2', 'notes' => null, 'member_ids' => [$this->member2]],
                    ],
                ],
            ],
        ];
        $put = $this->putJson("/api/meetings/{$this->meetingId}/breakout-rounds", $payload);
        $put->assertOk();
        $get = $this->getJson("/api/meetings/{$this->meetingId}/breakout-rounds");
        $rounds = $get->json('rounds');
        $r1 = collect($rounds)->firstWhere('round_no', 1);
        $r2 = collect($rounds)->firstWhere('round_no', 2);
        $this->assertSame([$this->member1], collect($r1['rooms'])->firstWhere('room_label', 'BO1')['member_ids']);
        $this->assertSame([$this->member1], collect($r2['rooms'])->firstWhere('room_label', 'BO1')['member_ids']);
    }

    public function test_member_without_participant_gets_created_and_assigned(): void
    {
        $this->assertSame(0, Participant::where('meeting_id', $this->meetingId)->count());
        $payload = [
            'rounds' => [
                [
                    'round_no' => 1,
                    'label' => 'Round 1',
                    'rooms' => [
                        ['room_label' => 'BO1', 'notes' => null, 'member_ids' => [$this->member1]],
                        ['room_label' => 'BO2', 'notes' => null, 'member_ids' => []],
                    ],
                ],
            ],
        ];
        $this->putJson("/api/meetings/{$this->meetingId}/breakout-rounds", $payload)->assertOk();
        $p = Participant::where('meeting_id', $this->meetingId)->where('member_id', $this->member1)->first();
        $this->assertNotNull($p);
        $this->assertSame('regular', $p->type);
        $get = $this->getJson("/api/meetings/{$this->meetingId}/breakout-rounds");
        $bo1 = collect($get->json('rounds')[0]['rooms'])->firstWhere('room_label', 'BO1');
        $this->assertSame([$this->member1], $bo1['member_ids']);
    }

    public function test_absent_proxy_participant_in_member_ids_returns_422(): void
    {
        Participant::create([
            'meeting_id' => $this->meetingId,
            'member_id' => $this->member1,
            'type' => 'absent',
        ]);
        $payload = [
            'rounds' => [
                [
                    'round_no' => 1,
                    'label' => 'Round 1',
                    'rooms' => [
                        ['room_label' => 'BO1', 'notes' => null, 'member_ids' => [$this->member1]],
                        ['room_label' => 'BO2', 'notes' => null, 'member_ids' => []],
                    ],
                ],
            ],
        ];
        $res = $this->putJson("/api/meetings/{$this->meetingId}/breakout-rounds", $payload);
        $res->assertStatus(422);
    }
}
