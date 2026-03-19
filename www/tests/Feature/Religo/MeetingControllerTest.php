<?php

namespace Tests\Feature\Religo;

use App\Models\BreakoutRoom;
use App\Models\ContactMemo;
use App\Models\Meeting;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

/**
 * GET /api/meetings — 一覧. Phase M1: breakout_count, has_memo. Phase M5: q, has_memo フィルタ.
 * GET /api/meetings/stats — 統計. Phase M6: total_meetings, total_breakouts, meetings_with_memo, next_meeting.
 * GET /api/meetings/{meetingId} — 詳細. Phase M3: meeting, memo_body, rooms を検証.
 * POST /api/meetings — 新規作成. MEETINGS_CREATE_IMPLEMENT: 既定名・重複 422・未来日.
 * PATCH /api/meetings/{id} — 更新. MEETINGS_UPDATE_IMPLEMENT: ignore unique・404・一覧行形式（name 含む）.
 */
class MeetingControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_index_returns_meetings_with_breakout_count_and_has_memo(): void
    {
        $mid = (int) DB::table('meetings')->insertGetId([
            'number' => 200,
            'held_on' => '2026-03-01',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson('/api/meetings');
        $res->assertOk();
        $data = $res->json();
        $this->assertIsArray($data);
        $meeting = collect($data)->firstWhere('id', $mid);
        $this->assertNotNull($meeting);
        $this->assertArrayHasKey('number', $meeting);
        $this->assertArrayHasKey('held_on', $meeting);
        $this->assertArrayHasKey('breakout_count', $meeting);
        $this->assertArrayHasKey('has_memo', $meeting);
        $this->assertArrayHasKey('has_participant_pdf', $meeting);
        $this->assertArrayHasKey('name', $meeting);
        $this->assertSame(200, $meeting['number']);
        $this->assertSame('2026-03-01', $meeting['held_on']);
        $this->assertSame(0, $meeting['breakout_count']);
        $this->assertFalse($meeting['has_memo']);
        $this->assertFalse($meeting['has_participant_pdf']);
    }

    public function test_index_breakout_count_reflects_breakout_rooms(): void
    {
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 201,
            'held_on' => '2026-03-10',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        BreakoutRoom::create([
            'meeting_id' => $meetingId,
            'room_label' => 'BO1',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        BreakoutRoom::create([
            'meeting_id' => $meetingId,
            'room_label' => 'BO2',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson('/api/meetings');
        $res->assertOk();
        $meetingData = collect($res->json())->firstWhere('id', $meetingId);
        $this->assertNotNull($meetingData);
        $this->assertSame(2, $meetingData['breakout_count']);
    }

    public function test_index_has_memo_true_when_meeting_memo_exists(): void
    {
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 202,
            'held_on' => '2026-03-15',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $owner = (int) DB::table('members')->insertGetId([
            'name' => 'Owner', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $target = (int) DB::table('members')->insertGetId([
            'name' => 'Target', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        ContactMemo::create([
            'owner_member_id' => $owner,
            'target_member_id' => $target,
            'meeting_id' => $meetingId,
            'memo_type' => 'meeting',
            'body' => '例会メモ',
        ]);

        $res = $this->getJson('/api/meetings');
        $res->assertOk();
        $meetingData = collect($res->json())->firstWhere('id', $meetingId);
        $this->assertNotNull($meetingData);
        $this->assertTrue($meetingData['has_memo']);
    }

    public function test_show_returns_404_for_unknown_meeting(): void
    {
        $res = $this->getJson('/api/meetings/99999');
        $res->assertNotFound();
    }

    public function test_show_returns_meeting_detail_with_memo_body_and_rooms(): void
    {
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 203,
            'held_on' => '2026-03-20',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $owner = (int) DB::table('members')->insertGetId([
            'name' => 'O', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        $target = (int) DB::table('members')->insertGetId([
            'name' => 'T', 'type' => 'active', 'created_at' => now(), 'updated_at' => now(),
        ]);
        ContactMemo::create([
            'owner_member_id' => $owner,
            'target_member_id' => $target,
            'meeting_id' => $meetingId,
            'memo_type' => 'meeting',
            'body' => 'Detail memo body',
        ]);

        $res = $this->getJson("/api/meetings/{$meetingId}");
        $res->assertOk();
        $data = $res->json();
        $this->assertArrayHasKey('meeting', $data);
        $this->assertArrayHasKey('memo_body', $data);
        $this->assertArrayHasKey('participant_import', $data);
        $this->assertArrayHasKey('csv_import', $data);
        $this->assertArrayHasKey('csv_apply_logs_recent', $data);
        $this->assertIsArray($data['csv_apply_logs_recent']);
        $this->assertArrayHasKey('rooms', $data);
        $this->assertSame(203, $data['meeting']['number']);
        $this->assertSame('Detail memo body', $data['memo_body']);
        $this->assertSame([
            'has_pdf' => false,
            'original_filename' => null,
            'parse_status' => null,
            'parsed_at' => null,
            'candidate_count' => null,
            'candidates' => null,
            'matched_count' => null,
            'new_count' => null,
            'total_count' => null,
            'imported_at' => null,
            'applied_count' => null,
        ], $data['participant_import']);
        $this->assertSame(['has_csv' => false, 'file_name' => null, 'uploaded_at' => null, 'imported_at' => null, 'applied_count' => null], $data['csv_import']);
        $this->assertIsArray($data['rooms']);
    }

    public function test_show_includes_participant_import_when_pdf_exists(): void
    {
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 204,
            'held_on' => '2026-03-21',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => 'meeting_participant_imports/204/sample.pdf',
            'original_filename' => '参加者一覧.pdf',
            'status' => 'uploaded',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meetingId}");
        $res->assertOk();
        $pi = $res->json('participant_import');
        $this->assertSame(true, $pi['has_pdf']);
        $this->assertSame('参加者一覧.pdf', $pi['original_filename']);
        $this->assertSame('pending', $pi['parse_status']);
        $this->assertNull($pi['parsed_at']);
        $this->assertNull($pi['candidate_count']);
        $this->assertNull($pi['candidates']);
        $this->assertNull($pi['matched_count']);
        $this->assertNull($pi['new_count']);
        $this->assertNull($pi['total_count']);
        $this->assertNull($pi['imported_at']);
        $this->assertNull($pi['applied_count']);
    }

    public function test_show_includes_candidates_when_parse_success(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 208,
            'held_on' => '2026-03-26',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/208/parsed.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'parsed.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_text' => 'A',
            'extracted_result' => json_encode([
                'candidates' => [
                    ['name' => '山田 太郎', 'raw_line' => '山田 太郎 建設', 'type_hint' => 'regular'],
                    ['name' => '佐藤 花子', 'raw_line' => '佐藤 花子 ゲスト', 'type_hint' => 'guest'],
                ],
                'meta' => ['line_count' => 2, 'parser_version' => 1],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meetingId}");
        $res->assertOk();
        $pi = $res->json('participant_import');
        $this->assertSame('success', $pi['parse_status']);
        $this->assertSame(2, $pi['candidate_count']);
        $this->assertIsArray($pi['candidates']);
        $this->assertCount(2, $pi['candidates']);
        $this->assertSame('山田 太郎', $pi['candidates'][0]['name']);
        $this->assertSame('山田 太郎 建設', $pi['candidates'][0]['raw_line']);
        $this->assertSame('regular', $pi['candidates'][0]['type_hint']);
        $this->assertArrayHasKey('match_status', $pi['candidates'][0]);
        $this->assertArrayHasKey('matched_member_id', $pi['candidates'][0]);
        $this->assertArrayHasKey('matched_member_name', $pi['candidates'][0]);
        $this->assertSame('guest', $pi['candidates'][1]['type_hint']);
        $this->assertArrayHasKey('match_status', $pi['candidates'][1]);
        $this->assertArrayHasKey('matched_count', $pi);
        $this->assertArrayHasKey('new_count', $pi);
        $this->assertArrayHasKey('total_count', $pi);
    }

    public function test_show_candidates_include_member_match_matched_when_member_exists(): void
    {
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 209,
            'held_on' => '2026-03-27',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $memberId = (int) DB::table('members')->insertGetId([
            'name' => '山田太郎',
            'type' => 'member',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        Storage::fake('local');
        $path = 'meeting_participant_imports/209/match.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'match.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_result' => json_encode([
                'candidates' => [
                    ['name' => '山田太郎', 'raw_line' => '山田太郎 建設', 'type_hint' => 'regular'],
                ],
                'meta' => [],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meetingId}");
        $res->assertOk();
        $pi = $res->json('participant_import');
        $this->assertSame('matched', $pi['candidates'][0]['match_status']);
        $this->assertSame($memberId, $pi['candidates'][0]['matched_member_id']);
        $this->assertSame('山田太郎', $pi['candidates'][0]['matched_member_name']);
        $this->assertSame(1, $pi['matched_count']);
        $this->assertSame(0, $pi['new_count']);
        $this->assertSame(1, $pi['total_count']);
    }

    public function test_show_candidates_include_member_match_new_when_no_member(): void
    {
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 210,
            'held_on' => '2026-03-28',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        Storage::fake('local');
        $path = 'meeting_participant_imports/210/new.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'new.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_result' => json_encode([
                'candidates' => [
                    ['name' => '未登録花子', 'raw_line' => 'ゲスト 未登録花子', 'type_hint' => 'guest'],
                ],
                'meta' => [],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meetingId}");
        $res->assertOk();
        $pi = $res->json('participant_import');
        $this->assertSame('new', $pi['candidates'][0]['match_status']);
        $this->assertNull($pi['candidates'][0]['matched_member_id']);
        $this->assertNull($pi['candidates'][0]['matched_member_name']);
        $this->assertSame(0, $pi['matched_count']);
        $this->assertSame(1, $pi['new_count']);
        $this->assertSame(1, $pi['total_count']);
    }

    public function test_show_match_counts_are_correct_for_mixed_candidates(): void
    {
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 211,
            'held_on' => '2026-03-29',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DB::table('members')->insert([
            'name' => '既存A',
            'type' => 'member',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DB::table('members')->insert([
            'name' => '既存B',
            'type' => 'member',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        Storage::fake('local');
        $path = 'meeting_participant_imports/211/mixed.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'mixed.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_result' => json_encode([
                'candidates' => [
                    ['name' => '既存A', 'raw_line' => 'A', 'type_hint' => 'regular'],
                    ['name' => '既存B', 'raw_line' => 'B', 'type_hint' => 'regular'],
                    ['name' => '新規C', 'raw_line' => 'C', 'type_hint' => 'guest'],
                ],
                'meta' => [],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meetingId}");
        $res->assertOk();
        $pi = $res->json('participant_import');
        $this->assertSame(2, $pi['matched_count']);
        $this->assertSame(1, $pi['new_count']);
        $this->assertSame(3, $pi['total_count']);
    }

    public function test_index_includes_has_participant_pdf_true_when_import_exists(): void
    {
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 205,
            'held_on' => '2026-03-22',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => 'meeting_participant_imports/205/uploaded.pdf',
            'original_filename' => 'list.pdf',
            'status' => 'uploaded',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson('/api/meetings');
        $res->assertOk();
        $meeting = collect($res->json())->firstWhere('id', $meetingId);
        $this->assertNotNull($meeting);
        $this->assertTrue($meeting['has_participant_pdf']);
    }

    public function test_index_filters_by_has_participant_pdf(): void
    {
        $m1 = (int) DB::table('meetings')->insertGetId(['number' => 206, 'held_on' => '2026-03-23', 'created_at' => now(), 'updated_at' => now()]);
        $m2 = (int) DB::table('meetings')->insertGetId(['number' => 207, 'held_on' => '2026-03-24', 'created_at' => now(), 'updated_at' => now()]);
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $m1,
            'file_path' => 'meeting_participant_imports/206/a.pdf',
            'original_filename' => 'a.pdf',
            'status' => 'uploaded',
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $resPdf = $this->getJson('/api/meetings?has_participant_pdf=1');
        $resPdf->assertOk();
        $idsPdf = collect($resPdf->json())->pluck('id')->all();
        $this->assertContains($m1, $idsPdf);
        $this->assertNotContains($m2, $idsPdf);

        $resNoPdf = $this->getJson('/api/meetings?has_participant_pdf=0');
        $resNoPdf->assertOk();
        $idsNoPdf = collect($resNoPdf->json())->pluck('id')->all();
        $this->assertNotContains($m1, $idsNoPdf);
        $this->assertContains($m2, $idsNoPdf);
    }

    public function test_index_filters_by_q_number(): void
    {
        DB::table('meetings')->insert([
            ['number' => 100, 'held_on' => '2026-01-01', 'created_at' => now(), 'updated_at' => now()],
            ['number' => 210, 'held_on' => '2026-02-01', 'created_at' => now(), 'updated_at' => now()],
            ['number' => 211, 'held_on' => '2026-02-02', 'created_at' => now(), 'updated_at' => now()],
        ]);
        $res = $this->getJson('/api/meetings?q=21');
        $res->assertOk();
        $data = $res->json();
        $this->assertCount(2, $data);
        $this->assertTrue(collect($data)->pluck('number')->contains(210));
        $this->assertTrue(collect($data)->pluck('number')->contains(211));
    }

    public function test_index_filters_by_has_memo(): void
    {
        $m1 = (int) DB::table('meetings')->insertGetId(['number' => 301, 'held_on' => '2026-03-01', 'created_at' => now(), 'updated_at' => now()]);
        $m2 = (int) DB::table('meetings')->insertGetId(['number' => 302, 'held_on' => '2026-03-02', 'created_at' => now(), 'updated_at' => now()]);
        $owner = (int) DB::table('members')->insertGetId(['name' => 'O', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()]);
        $target = (int) DB::table('members')->insertGetId(['name' => 'T', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()]);
        ContactMemo::create(['owner_member_id' => $owner, 'target_member_id' => $target, 'meeting_id' => $m1, 'memo_type' => 'meeting', 'body' => 'x']);
        $resHas = $this->getJson('/api/meetings?has_memo=1');
        $resHas->assertOk();
        $idsHas = collect($resHas->json())->pluck('id')->all();
        $this->assertContains($m1, $idsHas);
        $this->assertNotContains($m2, $idsHas);
        $resNot = $this->getJson('/api/meetings?has_memo=0');
        $resNot->assertOk();
        $idsNot = collect($resNot->json())->pluck('id')->all();
        $this->assertNotContains($m1, $idsNot);
        $this->assertContains($m2, $idsNot);
    }

    public function test_stats_returns_total_meetings_and_breakouts(): void
    {
        $m1 = Meeting::create(['number' => 401, 'held_on' => '2026-01-10']);
        $m2 = Meeting::create(['number' => 402, 'held_on' => '2026-01-17']);
        BreakoutRoom::create(['meeting_id' => $m1->id, 'room_label' => 'BO1']);
        BreakoutRoom::create(['meeting_id' => $m1->id, 'room_label' => 'BO2']);
        BreakoutRoom::create(['meeting_id' => $m2->id, 'room_label' => 'BO1']);

        $res = $this->getJson('/api/meetings/stats');
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(2, $data['total_meetings']);
        $this->assertSame(3, $data['total_breakouts']);
        $this->assertArrayHasKey('meetings_with_memo', $data);
        $this->assertArrayHasKey('next_meeting', $data);
    }

    public function test_stats_meetings_with_memo_count(): void
    {
        $m1 = Meeting::create(['number' => 501, 'held_on' => '2026-02-01']);
        $m2 = Meeting::create(['number' => 502, 'held_on' => '2026-02-02']);
        $owner = (int) DB::table('members')->insertGetId(['name' => 'O', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()]);
        $target = (int) DB::table('members')->insertGetId(['name' => 'T', 'type' => 'active', 'created_at' => now(), 'updated_at' => now()]);
        ContactMemo::create(['owner_member_id' => $owner, 'target_member_id' => $target, 'meeting_id' => $m1->id, 'memo_type' => 'meeting', 'body' => 'x']);

        $res = $this->getJson('/api/meetings/stats');
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['meetings_with_memo']);
    }

    public function test_stats_next_meeting_is_earliest_today_or_future(): void
    {
        $today = Carbon::today();
        $past = Meeting::create(['number' => 601, 'held_on' => $today->copy()->subDays(10)]);
        $future = Meeting::create(['number' => 602, 'held_on' => $today->copy()->addDays(5)]);

        $res = $this->getJson('/api/meetings/stats');
        $res->assertOk();
        $data = $res->json();
        $this->assertNotNull($data['next_meeting']);
        $this->assertSame(602, $data['next_meeting']['number']);
        $this->assertSame($future->id, $data['next_meeting']['id']);
        $this->assertSame($future->held_on->format('Y-m-d'), $data['next_meeting']['held_on']);
    }

    public function test_stats_next_meeting_null_when_no_future_meetings(): void
    {
        $today = Carbon::today();
        Meeting::create(['number' => 701, 'held_on' => $today->copy()->subDays(1)]);

        $res = $this->getJson('/api/meetings/stats');
        $res->assertOk();
        $data = $res->json();
        $this->assertNull($data['next_meeting']);
    }

    public function test_store_creates_meeting_with_default_name(): void
    {
        $res = $this->postJson('/api/meetings', [
            'number' => 910,
            'held_on' => '2026-12-15',
        ]);
        $res->assertCreated();
        $res->assertJsonPath('number', 910);
        $res->assertJsonPath('held_on', '2026-12-15');
        $res->assertJsonPath('breakout_count', 0);
        $res->assertJsonPath('has_memo', false);
        $res->assertJsonPath('has_participant_pdf', false);
        $res->assertJsonPath('name', '第910回定例会');
        $this->assertTrue(
            Meeting::query()->where('number', 910)->whereDate('held_on', '2026-12-15')->where('name', '第910回定例会')->exists()
        );
    }

    public function test_store_accepts_explicit_name(): void
    {
        $res = $this->postJson('/api/meetings', [
            'number' => 911,
            'held_on' => '2026-11-01',
            'name' => '特別例会',
        ]);
        $res->assertCreated();
        $this->assertDatabaseHas('meetings', [
            'number' => 911,
            'name' => '特別例会',
        ]);
    }

    public function test_store_empty_string_name_uses_default(): void
    {
        $res = $this->postJson('/api/meetings', [
            'number' => 912,
            'held_on' => '2026-10-01',
            'name' => '   ',
        ]);
        $res->assertCreated();
        $this->assertDatabaseHas('meetings', [
            'number' => 912,
            'name' => '第912回定例会',
        ]);
    }

    public function test_store_allows_future_held_on(): void
    {
        $future = Carbon::today()->addYear()->format('Y-m-d');
        $res = $this->postJson('/api/meetings', [
            'number' => 913,
            'held_on' => $future,
        ]);
        $res->assertCreated();
        $this->assertTrue(
            Meeting::query()->where('number', 913)->whereDate('held_on', $future)->exists()
        );
    }

    public function test_store_duplicate_number_returns_422(): void
    {
        Meeting::create(['number' => 920, 'held_on' => '2026-01-01', 'name' => '第920回定例会']);

        $res = $this->postJson('/api/meetings', [
            'number' => 920,
            'held_on' => '2026-06-01',
        ]);
        $res->assertUnprocessable();
        $res->assertJsonValidationErrors(['number']);
    }

    public function test_store_requires_number_and_held_on(): void
    {
        $this->postJson('/api/meetings', [])->assertUnprocessable()->assertJsonValidationErrors(['number', 'held_on']);
        $this->postJson('/api/meetings', ['number' => 930])->assertUnprocessable()->assertJsonValidationErrors(['held_on']);
        $this->postJson('/api/meetings', ['held_on' => '2026-01-01'])->assertUnprocessable()->assertJsonValidationErrors(['number']);
    }

    public function test_update_changes_number_held_on_name(): void
    {
        $m = Meeting::create([
            'number' => 1001,
            'held_on' => '2026-04-01',
            'name' => '旧名称',
        ]);

        $res = $this->patchJson("/api/meetings/{$m->id}", [
            'number' => 1002,
            'held_on' => '2026-05-10',
            'name' => '新名称',
        ]);
        $res->assertOk();
        $res->assertJsonPath('id', $m->id);
        $res->assertJsonPath('number', 1002);
        $res->assertJsonPath('held_on', '2026-05-10');
        $res->assertJsonPath('name', '新名称');
        $this->assertTrue(
            Meeting::query()->whereKey($m->id)->where('number', 1002)->whereDate('held_on', '2026-05-10')->where('name', '新名称')->exists()
        );
    }

    public function test_update_empty_string_name_uses_default(): void
    {
        $m = Meeting::create([
            'number' => 1003,
            'held_on' => '2026-04-02',
            'name' => '仮',
        ]);

        $res = $this->patchJson("/api/meetings/{$m->id}", [
            'number' => 1003,
            'held_on' => '2026-04-03',
            'name' => '  ',
        ]);
        $res->assertOk();
        $res->assertJsonPath('name', '第1003回定例会');
        $this->assertTrue(
            Meeting::query()->whereKey($m->id)->where('name', '第1003回定例会')->whereDate('held_on', '2026-04-03')->exists()
        );
    }

    public function test_update_duplicate_number_returns_422(): void
    {
        Meeting::create(['number' => 1010, 'held_on' => '2026-01-01', 'name' => '第1010回定例会']);
        $other = Meeting::create(['number' => 1011, 'held_on' => '2026-01-02', 'name' => '第1011回定例会']);

        $res = $this->patchJson("/api/meetings/{$other->id}", [
            'number' => 1010,
            'held_on' => '2026-01-03',
            'name' => '衝突',
        ]);
        $res->assertUnprocessable();
        $res->assertJsonValidationErrors(['number']);
    }

    public function test_update_allows_future_held_on(): void
    {
        $m = Meeting::create(['number' => 1020, 'held_on' => '2026-01-01', 'name' => '第1020回定例会']);
        $future = Carbon::today()->addMonths(6)->format('Y-m-d');

        $res = $this->patchJson("/api/meetings/{$m->id}", [
            'number' => 1020,
            'held_on' => $future,
        ]);
        $res->assertOk();
        $this->assertTrue(Meeting::query()->whereKey($m->id)->whereDate('held_on', $future)->exists());
    }

    public function test_update_requires_number_and_held_on(): void
    {
        $m = Meeting::create(['number' => 1030, 'held_on' => '2026-01-01', 'name' => 'x']);

        $this->patchJson("/api/meetings/{$m->id}", [])->assertUnprocessable()->assertJsonValidationErrors(['number', 'held_on']);
        $this->patchJson("/api/meetings/{$m->id}", ['number' => 1030])->assertUnprocessable()->assertJsonValidationErrors(['held_on']);
        $this->patchJson("/api/meetings/{$m->id}", ['held_on' => '2026-02-02'])->assertUnprocessable()->assertJsonValidationErrors(['number']);
    }

    public function test_update_can_keep_same_number_for_same_record(): void
    {
        $m = Meeting::create(['number' => 1040, 'held_on' => '2026-01-01', 'name' => '第1040回定例会']);

        $res = $this->patchJson("/api/meetings/{$m->id}", [
            'number' => 1040,
            'held_on' => '2026-08-20',
            'name' => '据え置き番号テスト',
        ]);
        $res->assertOk();
        $res->assertJsonPath('number', 1040);
        $this->assertTrue(
            Meeting::query()->whereKey($m->id)->where('number', 1040)->whereDate('held_on', '2026-08-20')->where('name', '据え置き番号テスト')->exists()
        );
    }

    public function test_update_returns_404_for_unknown(): void
    {
        $this->patchJson('/api/meetings/999999', [
            'number' => 1,
            'held_on' => '2026-01-01',
        ])->assertNotFound();
    }
}
