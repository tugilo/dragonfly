<?php

namespace Tests\Feature\Religo;

use App\Models\Category;
use App\Models\Meeting;
use App\Models\MeetingCsvApplyLog;
use App\Models\MeetingCsvImport;
use App\Models\MeetingCsvImportResolution;
use App\Models\Member;
use App\Models\MemberRole;
use App\Models\Participant;
use App\Models\Role;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

/**
 * M7-C1: 参加者CSVアップロード保存の Feature テスト。
 */
class MeetingCsvImportControllerTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        Storage::fake('local');
    }

    public function test_csv_upload_success_creates_record_and_stores_file(): void
    {
        $meeting = Meeting::create(['number' => 301, 'held_on' => '2026-03-20', 'name' => '第301回定例会']);

        $file = UploadedFile::fake()->createWithContent('participants.csv', "種別,名前\nメンバー,山田 太郎\n");

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import", [], [
            'Content-Type' => 'multipart/form-data',
        ]);
        $res->assertUnprocessable();

        $res = $this->post("/api/meetings/{$meeting->id}/csv-import", [
            'csv' => $file,
        ]);
        $res->assertStatus(201);
        $res->assertJsonStructure(['id', 'file_name', 'uploaded_at']);
        $res->assertJson(['file_name' => 'participants.csv']);

        $this->assertDatabaseHas('meeting_csv_imports', [
            'meeting_id' => $meeting->id,
            'file_name' => 'participants.csv',
        ]);

        $import = MeetingCsvImport::where('meeting_id', $meeting->id)->first();
        $this->assertNotNull($import);
        $this->assertNotEmpty($import->file_path);
        Storage::disk('local')->assertExists($import->file_path);
    }

    public function test_csv_upload_returns_404_when_meeting_not_found(): void
    {
        $file = UploadedFile::fake()->createWithContent('a.csv', 'a');
        $res = $this->post("/api/meetings/99999/csv-import", ['csv' => $file]);
        $res->assertNotFound();
    }

    public function test_csv_upload_rejects_non_csv_file(): void
    {
        $meeting = Meeting::create(['number' => 302, 'held_on' => '2026-03-21', 'name' => '第302回定例会']);
        $file = UploadedFile::fake()->create('document.pdf', 100, 'application/pdf');
        $res = $this->post("/api/meetings/{$meeting->id}/csv-import", ['csv' => $file], ['Accept' => 'application/json']);
        $res->assertUnprocessable();
    }

    // --- M7-C2: プレビュー ---

    public function test_preview_returns_headers_rows_and_row_count(): void
    {
        $meeting = Meeting::create(['number' => 303, 'held_on' => '2026-03-22', 'name' => '第303回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/20260322120000_preview.csv";
        $content = "種別,名前,よみがな,カテゴリー,紹介者,アテンド,オリエン\n";
        $content .= "メンバー,山田 太郎,やまだ たろう,IT,,,\n";
        $content .= "ビジター,帆苅 有希,ほかり あき,toB向けビジネススクール,芳賀 崇利,平岡 国彦,平岡 国彦\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'preview.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/preview");
        $res->assertOk();
        $res->assertJsonStructure(['headers', 'rows', 'row_count']);
        $res->assertJson(['row_count' => 2]);
        $data = $res->json();
        $this->assertIsArray($data['headers']);
        $this->assertCount(10, $data['headers']);
        $this->assertContains('大カテゴリー', $data['headers']);
        $this->assertContains('役職', $data['headers']);
        $this->assertIsArray($data['rows']);
        $this->assertCount(2, $data['rows']);
        $this->assertSame('メンバー', $data['rows'][0]['type']);
        $this->assertSame('山田 太郎', $data['rows'][0]['name']);
        $this->assertSame('ビジター', $data['rows'][1]['type']);
        $this->assertSame('帆苅 有希', $data['rows'][1]['name']);
    }

    public function test_preview_returns_404_when_no_csv(): void
    {
        $meeting = Meeting::create(['number' => 304, 'held_on' => '2026-03-23', 'name' => '第304回定例会']);
        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/preview");
        $res->assertNotFound();
    }

    public function test_preview_returns_404_when_meeting_not_found(): void
    {
        $res = $this->getJson('/api/meetings/99999/csv-import/preview');
        $res->assertNotFound();
    }

    public function test_preview_returns_404_when_file_missing(): void
    {
        $meeting = Meeting::create(['number' => 305, 'held_on' => '2026-03-24', 'name' => '第305回定例会']);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => "meeting_csv_imports/{$meeting->id}/missing.csv",
            'file_name' => 'missing.csv',
            'uploaded_at' => now(),
        ]);
        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/preview");
        $res->assertNotFound();
    }

    public function test_preview_excludes_empty_lines(): void
    {
        $meeting = Meeting::create(['number' => 306, 'held_on' => '2026-03-25', 'name' => '第306回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/empty_lines.csv";
        $content = "種別,名前\n";
        $content .= "メンバー, A\n";
        $content .= "\n";
        $content .= "ビジター, B\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'empty_lines.csv',
            'uploaded_at' => now(),
        ]);
        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/preview");
        $res->assertOk();
        $res->assertJson(['row_count' => 2]);
        $data = $res->json();
        $this->assertCount(2, $data['rows']);
    }

    public function test_preview_returns_422_when_missing_required_header(): void
    {
        $meeting = Meeting::create(['number' => 307, 'held_on' => '2026-03-26', 'name' => '第307回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/no_kind.csv";
        Storage::disk('local')->put($path, "名前,よみがな\n山田,やまだ\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'no_kind.csv',
            'uploaded_at' => now(),
        ]);
        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/preview");
        $res->assertStatus(422);
    }

    public function test_preview_returns_empty_rows_when_header_only(): void
    {
        $meeting = Meeting::create(['number' => 308, 'held_on' => '2026-03-27', 'name' => '第308回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/header_only.csv";
        Storage::disk('local')->put($path, "種別,名前,よみがな\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'header_only.csv',
            'uploaded_at' => now(),
        ]);
        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/preview");
        $res->assertOk();
        $res->assertJson(['row_count' => 0]);
        $data = $res->json();
        $this->assertSame([], $data['rows']);
    }

    // --- M7-C3 + M1: apply（差分更新） ---

    public function test_apply_success_creates_participants_and_returns_diff_counts(): void
    {
        $meeting = Meeting::create(['number' => 310, 'held_on' => '2026-03-28', 'name' => '第310回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/apply_test.csv";
        $content = "種別,名前,よみがな\n";
        $content .= "メンバー,山田 太郎,やまだ\n";
        $content .= "ビジター,鈴木 花子,すずき\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'apply_test.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply");
        $res->assertOk();
        $res->assertJson([
            'added_count' => 2,
            'updated_count' => 0,
            'missing_count' => 0,
            'deleted_count' => 0,
            'protected_count' => 0,
            'applied_count' => 2,
            'message' => 'participants を差分更新しました',
        ]);

        $this->assertSame(2, Participant::where('meeting_id', $meeting->id)->count());
        $import = MeetingCsvImport::where('meeting_id', $meeting->id)->first();
        $this->assertNotNull($import->imported_at);
        $this->assertSame(2, $import->applied_count);
    }

    public function test_apply_returns_422_when_csv_has_no_data_rows(): void
    {
        $meeting = Meeting::create(['number' => 311, 'held_on' => '2026-03-29', 'name' => '第311回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/empty.csv";
        Storage::disk('local')->put($path, "種別,名前\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'empty.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply");
        $res->assertStatus(422);
    }

    public function test_apply_returns_404_when_no_csv(): void
    {
        $meeting = Meeting::create(['number' => 312, 'held_on' => '2026-03-30', 'name' => '第312回定例会']);
        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply");
        $res->assertNotFound();
    }

    /** M1: CSV にない既存 participant は削除されず残る（安全モード）。 */
    public function test_apply_keeps_existing_participants_not_in_csv(): void
    {
        $meeting = Meeting::create(['number' => 313, 'held_on' => '2026-03-31', 'name' => '第313回定例会']);
        $memberOld = Member::create(['name' => '既存 太郎', 'type' => 'member', 'display_no' => null]);
        Participant::create(['meeting_id' => $meeting->id, 'member_id' => $memberOld->id, 'type' => 'regular']);

        $path = "meeting_csv_imports/{$meeting->id}/replace.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,新規 花子\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'replace.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply");
        $res->assertOk();
        $res->assertJson([
            'added_count' => 1,
            'updated_count' => 0,
            'missing_count' => 1,
            'deleted_count' => 0,
            'protected_count' => 0,
            'applied_count' => 1,
        ]);

        $participants = Participant::where('meeting_id', $meeting->id)->with('member')->get();
        $this->assertCount(2, $participants);
        $names = $participants->pluck('member.name')->values()->toArray();
        $this->assertContains('既存 太郎', $names);
        $this->assertContains('新規 花子', $names);
    }

    public function test_apply_maps_type_to_participant_type(): void
    {
        $meeting = Meeting::create(['number' => 314, 'held_on' => '2026-04-01', 'name' => '第314回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/types.csv";
        $content = "種別,名前\nメンバー,A\nビジター,B\nゲスト,C\n代理出席,D\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'types.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply");
        $res->assertOk();
        $res->assertJsonStructure(['added_count', 'updated_count', 'missing_count', 'applied_count']);

        $types = Participant::where('meeting_id', $meeting->id)->with('member')->get()->keyBy(fn ($p) => $p->member->name);
        $this->assertSame('regular', $types['A']->type);
        $this->assertSame('visitor', $types['B']->type);
        $this->assertSame('guest', $types['C']->type);
        $this->assertSame('proxy', $types['D']->type);
    }

    public function test_apply_uses_existing_member_and_creates_new(): void
    {
        $meeting = Meeting::create(['number' => 315, 'held_on' => '2026-04-02', 'name' => '第315回定例会']);
        $existing = Member::create(['name' => '既存 一郎', 'type' => 'member', 'display_no' => null]);

        $path = "meeting_csv_imports/{$meeting->id}/members.csv";
        $content = "種別,名前\nメンバー,既存 一郎\nメンバー,新規 二郎\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'members.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply");
        $res->assertOk();
        $res->assertJson(['added_count' => 2, 'updated_count' => 0, 'missing_count' => 0]);

        $this->assertSame(2, Member::count());
        $newMember = Member::where('name', '新規 二郎')->first();
        $this->assertNotNull($newMember);

        $participants = Participant::where('meeting_id', $meeting->id)->with('member')->get();
        $memberIds = $participants->pluck('member_id')->toArray();
        $this->assertContains($existing->id, $memberIds);
        $this->assertContains($newMember->id, $memberIds);
    }

    /** M1: 既存 participant が CSV に同じ member で載っている場合は type のみ更新される。 */
    public function test_apply_updates_existing_participant_type(): void
    {
        $meeting = Meeting::create(['number' => 316, 'held_on' => '2026-04-03', 'name' => '第316回定例会']);
        $member = Member::create(['name' => '山田 太郎', 'type' => 'member', 'display_no' => null]);
        Participant::create([
            'meeting_id' => $meeting->id,
            'member_id' => $member->id,
            'type' => 'regular',
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/update_type.csv";
        Storage::disk('local')->put($path, "種別,名前\nビジター,山田 太郎\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'update_type.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply");
        $res->assertOk();
        $res->assertJson(['added_count' => 0, 'updated_count' => 1, 'missing_count' => 0]);

        $participant = Participant::where('meeting_id', $meeting->id)->where('member_id', $member->id)->first();
        $this->assertSame('visitor', $participant->type);
        $this->assertSame(1, Participant::where('meeting_id', $meeting->id)->count());
    }

    /** M1: BO 付き participant は削除されず残る。 */
    public function test_apply_preserves_participants_with_breakout(): void
    {
        $meeting = Meeting::create(['number' => 317, 'held_on' => '2026-04-04', 'name' => '第317回定例会']);
        $round = $meeting->breakoutRounds()->create(['round_no' => 1, 'label' => 'Round 1']);
        $room = $round->breakoutRooms()->create([
            'meeting_id' => $meeting->id,
            'room_label' => 'BO1',
            'sort_order' => 1,
        ]);
        $memberInBo = Member::create(['name' => 'BO参加 太郎', 'type' => 'member', 'display_no' => null]);
        $participantInBo = Participant::create([
            'meeting_id' => $meeting->id,
            'member_id' => $memberInBo->id,
            'type' => 'regular',
        ]);
        $participantInBo->breakoutRooms()->attach($room->id);

        $path = "meeting_csv_imports/{$meeting->id}/other_only.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,別 花子\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'other_only.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply");
        $res->assertOk();
        $res->assertJson(['added_count' => 1, 'updated_count' => 0, 'missing_count' => 1, 'deleted_count' => 0, 'protected_count' => 0]);

        $this->assertSame(2, Participant::where('meeting_id', $meeting->id)->count());
        $kept = Participant::where('meeting_id', $meeting->id)->where('member_id', $memberInBo->id)->first();
        $this->assertNotNull($kept);
        $this->assertSame(1, $kept->breakoutRooms()->count());
    }

    // --- D3: delete_missing + BO 保護 ---

    /** D3: delete_missing 未指定または false では missing participant は削除されない。 */
    public function test_apply_delete_missing_false_does_not_delete_missing(): void
    {
        $meeting = Meeting::create(['number' => 330, 'held_on' => '2026-04-15', 'name' => '第330回定例会']);
        $memberMissing = Member::create(['name' => '削除候補 太郎', 'type' => 'member', 'display_no' => null]);
        Participant::create(['meeting_id' => $meeting->id, 'member_id' => $memberMissing->id, 'type' => 'regular']);

        $path = "meeting_csv_imports/{$meeting->id}/other_only.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,別 花子\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'other_only.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply", []);
        $res->assertOk();
        $res->assertJson([
            'missing_count' => 1,
            'deleted_count' => 0,
            'protected_count' => 0,
            'applied_count' => 1,
        ]);

        $this->assertNotNull(Participant::where('meeting_id', $meeting->id)->where('member_id', $memberMissing->id)->first());
    }

    /** D3: delete_missing=true で has_breakout=false の missing participant が削除される。 */
    public function test_apply_delete_missing_true_deletes_missing_without_breakout(): void
    {
        $meeting = Meeting::create(['number' => 331, 'held_on' => '2026-04-16', 'name' => '第331回定例会']);
        $memberMissing = Member::create(['name' => '削除される 太郎', 'type' => 'member', 'display_no' => null]);
        Participant::create(['meeting_id' => $meeting->id, 'member_id' => $memberMissing->id, 'type' => 'regular']);

        $path = "meeting_csv_imports/{$meeting->id}/other_only.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,別 花子\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'other_only.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply", ['delete_missing' => true]);
        $res->assertOk();
        $res->assertJson([
            'missing_count' => 1,
            'deleted_count' => 1,
            'protected_count' => 0,
            'applied_count' => 2,
        ]);

        $this->assertNull(Participant::where('meeting_id', $meeting->id)->where('member_id', $memberMissing->id)->first());
    }

    /** D3: delete_missing=true でも has_breakout=true の participant は削除されない。 */
    public function test_apply_delete_missing_true_does_not_delete_participant_with_breakout(): void
    {
        $meeting = Meeting::create(['number' => 332, 'held_on' => '2026-04-17', 'name' => '第332回定例会']);
        $round = $meeting->breakoutRounds()->create(['round_no' => 1, 'label' => 'Round 1']);
        $room = $round->breakoutRooms()->create([
            'meeting_id' => $meeting->id,
            'room_label' => 'BO1',
            'sort_order' => 1,
        ]);
        $memberInBo = Member::create(['name' => 'BO保護 太郎', 'type' => 'member', 'display_no' => null]);
        $participantInBo = Participant::create([
            'meeting_id' => $meeting->id,
            'member_id' => $memberInBo->id,
            'type' => 'regular',
        ]);
        $participantInBo->breakoutRooms()->attach($room->id);

        $path = "meeting_csv_imports/{$meeting->id}/other_only.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,別 花子\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'other_only.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply", ['delete_missing' => true]);
        $res->assertOk();
        $res->assertJson([
            'missing_count' => 1,
            'deleted_count' => 0,
            'protected_count' => 1,
            'applied_count' => 1,
        ]);

        $kept = Participant::where('meeting_id', $meeting->id)->where('member_id', $memberInBo->id)->first();
        $this->assertNotNull($kept);
        $this->assertSame(1, $kept->breakoutRooms()->count());
    }

    /** D3: delete_missing=true で mixed（BO あり1件・BO なし1件）のとき deleted_count=1, protected_count=1。 */
    public function test_apply_delete_missing_mixed_deleted_and_protected_counts(): void
    {
        $meeting = Meeting::create(['number' => 333, 'held_on' => '2026-04-18', 'name' => '第333回定例会']);
        $round = $meeting->breakoutRounds()->create(['round_no' => 1, 'label' => 'Round 1']);
        $room = $round->breakoutRooms()->create([
            'meeting_id' => $meeting->id,
            'room_label' => 'BO1',
            'sort_order' => 1,
        ]);
        $memberNoBo = Member::create(['name' => '削除可 太郎', 'type' => 'member', 'display_no' => null]);
        $memberInBo = Member::create(['name' => 'BO保護 花子', 'type' => 'member', 'display_no' => null]);
        Participant::create(['meeting_id' => $meeting->id, 'member_id' => $memberNoBo->id, 'type' => 'regular']);
        $pInBo = Participant::create(['meeting_id' => $meeting->id, 'member_id' => $memberInBo->id, 'type' => 'regular']);
        $pInBo->breakoutRooms()->attach($room->id);

        $path = "meeting_csv_imports/{$meeting->id}/other_only.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,別 一郎\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'other_only.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply", ['delete_missing' => true]);
        $res->assertOk();
        $res->assertJson([
            'missing_count' => 2,
            'deleted_count' => 1,
            'protected_count' => 1,
            'applied_count' => 2,
        ]);

        $this->assertNull(Participant::where('meeting_id', $meeting->id)->where('member_id', $memberNoBo->id)->first());
        $this->assertNotNull(Participant::where('meeting_id', $meeting->id)->where('member_id', $memberInBo->id)->first());
    }

    /** D3: diff-preview の missing に deletable と reason が含まれる。 */
    public function test_diff_preview_missing_has_deletable_and_reason(): void
    {
        $meeting = Meeting::create(['number' => 334, 'held_on' => '2026-04-19', 'name' => '第334回定例会']);
        $memberNoBo = Member::create(['name' => '削除可 太郎', 'type' => 'member', 'display_no' => null]);
        $memberInBo = Member::create(['name' => 'BO 花子', 'type' => 'member', 'display_no' => null]);
        Participant::create(['meeting_id' => $meeting->id, 'member_id' => $memberNoBo->id, 'type' => 'regular']);
        $round = $meeting->breakoutRounds()->create(['round_no' => 1, 'label' => 'R1']);
        $room = $round->breakoutRooms()->create(['meeting_id' => $meeting->id, 'room_label' => 'BO1', 'sort_order' => 1]);
        $pInBo = Participant::create(['meeting_id' => $meeting->id, 'member_id' => $memberInBo->id, 'type' => 'regular']);
        $pInBo->breakoutRooms()->attach($room->id);

        $path = "meeting_csv_imports/{$meeting->id}/other_only.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,別 一郎\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'other_only.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertCount(2, $data['missing']);
        $byName = collect($data['missing'])->keyBy('name');
        $this->assertTrue($byName['削除可 太郎']['deletable']);
        $this->assertNull($byName['削除可 太郎']['reason']);
        $this->assertFalse($byName['BO 花子']['deletable']);
        $this->assertSame('breakout_attached', $byName['BO 花子']['reason']);
    }

    // --- D2: diff-preview ---

    public function test_diff_preview_success_returns_summary_and_lists(): void
    {
        $meeting = Meeting::create(['number' => 320, 'held_on' => '2026-04-05', 'name' => '第320回定例会']);
        $member = Member::create(['name' => '既存 一郎', 'type' => 'member', 'display_no' => null]);
        Participant::create(['meeting_id' => $meeting->id, 'member_id' => $member->id, 'type' => 'regular']);

        $path = "meeting_csv_imports/{$meeting->id}/diff_test.csv";
        $content = "種別,No,名前\nメンバー,1,既存 一郎\nビジター,2,新規 二郎\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'diff_test.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/diff-preview");
        $res->assertOk();
        $res->assertJsonStructure([
            'summary' => ['added_count', 'updated_count', 'unchanged_count', 'missing_count'],
            'added',
            'updated',
            'missing',
        ]);
        $data = $res->json();
        $this->assertSame(1, $data['summary']['added_count']);
        $this->assertSame(0, $data['summary']['updated_count']);
        $this->assertSame(1, $data['summary']['unchanged_count']);
        $this->assertSame(0, $data['summary']['missing_count']);
        $this->assertCount(1, $data['added']);
        $this->assertSame('新規 二郎', $data['added'][0]['name']);
        $this->assertCount(0, $data['updated']);
    }

    /** D2: 既存 participant の種別が CSV で異なる場合は updated に入る。 */
    public function test_diff_preview_returns_updated_when_type_changes(): void
    {
        $meeting = Meeting::create(['number' => 326, 'held_on' => '2026-04-11', 'name' => '第326回定例会']);
        $member = Member::create(['name' => '種別変更 太郎', 'type' => 'member', 'display_no' => null]);
        Participant::create(['meeting_id' => $meeting->id, 'member_id' => $member->id, 'type' => 'regular']);

        $path = "meeting_csv_imports/{$meeting->id}/type_change.csv";
        Storage::disk('local')->put($path, "種別,名前\nビジター,種別変更 太郎\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'type_change.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(0, $data['summary']['added_count']);
        $this->assertSame(1, $data['summary']['updated_count']);
        $this->assertCount(1, $data['updated']);
        $this->assertSame('種別変更 太郎', $data['updated'][0]['name']);
        $this->assertSame('regular', $data['updated'][0]['current_type']);
        $this->assertSame('visitor', $data['updated'][0]['new_type']);
    }

    /** D2: CSV にない既存 participant は missing に入る。member_id ベースで判定する。 */
    public function test_diff_preview_existing_participant_not_in_csv_is_missing(): void
    {
        $meeting = Meeting::create(['number' => 321, 'held_on' => '2026-04-06', 'name' => '第321回定例会']);
        $member = Member::create(['name' => '残存 太郎', 'type' => 'member', 'display_no' => null]);
        Participant::create(['meeting_id' => $meeting->id, 'member_id' => $member->id, 'type' => 'regular']);

        $path = "meeting_csv_imports/{$meeting->id}/only_other.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,別 花子\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'only_other.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/diff-preview");
        $res->assertOk();
        $res->assertJsonPath('summary.missing_count', 1);
        $data = $res->json();
        $this->assertCount(1, $data['missing']);
        $this->assertSame('残存 太郎', $data['missing'][0]['name']);
        $this->assertSame($member->id, $data['missing'][0]['member_id']);
    }

    /** D2: No は識別に使わず、名前解決 → member_id で判定する。同じ名前で No が違っても 1 件。 */
    public function test_diff_preview_uses_member_id_not_no(): void
    {
        $meeting = Meeting::create(['number' => 322, 'held_on' => '2026-04-07', 'name' => '第322回定例会']);
        $member = Member::create(['name' => '山田 太郎', 'type' => 'member', 'display_no' => null]);
        Participant::create(['meeting_id' => $meeting->id, 'member_id' => $member->id, 'type' => 'regular']);

        $path = "meeting_csv_imports/{$meeting->id}/same_name_different_no.csv";
        Storage::disk('local')->put($path, "種別,No,名前\nメンバー,1,山田 太郎\nメンバー,99,山田 太郎\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'same_name_different_no.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(0, $data['summary']['added_count']);
        $this->assertSame(0, $data['summary']['updated_count']);
        $this->assertSame(1, $data['summary']['unchanged_count']);
        $this->assertCount(0, $data['added']);
        $this->assertCount(0, $data['updated']);
    }

    /** D2: BO 付き participant が missing のとき has_breakout が true。 */
    public function test_diff_preview_missing_with_breakout_has_has_breakout_true(): void
    {
        $meeting = Meeting::create(['number' => 323, 'held_on' => '2026-04-08', 'name' => '第323回定例会']);
        $round = $meeting->breakoutRounds()->create(['round_no' => 1, 'label' => 'Round 1']);
        $room = $round->breakoutRooms()->create([
            'meeting_id' => $meeting->id,
            'room_label' => 'BO1',
            'sort_order' => 1,
        ]);
        $memberInBo = Member::create(['name' => 'BO 太郎', 'type' => 'member', 'display_no' => null]);
        $participantInBo = Participant::create([
            'meeting_id' => $meeting->id,
            'member_id' => $memberInBo->id,
            'type' => 'regular',
        ]);
        $participantInBo->breakoutRooms()->attach($room->id);

        $path = "meeting_csv_imports/{$meeting->id}/no_bo_member.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,別 花子\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'no_bo_member.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['summary']['missing_count']);
        $missing = $data['missing'];
        $this->assertCount(1, $missing);
        $this->assertSame('BO 太郎', $missing[0]['name']);
        $this->assertTrue($missing[0]['has_breakout']);
    }

    public function test_diff_preview_returns_404_when_no_csv(): void
    {
        $meeting = Meeting::create(['number' => 324, 'held_on' => '2026-04-09', 'name' => '第324回定例会']);
        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/diff-preview");
        $res->assertNotFound();
    }

    public function test_diff_preview_returns_422_when_csv_has_no_data_rows(): void
    {
        $meeting = Meeting::create(['number' => 325, 'held_on' => '2026-04-10', 'name' => '第325回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/empty.csv";
        Storage::disk('local')->put($path, "種別,名前\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'empty.csv',
            'uploaded_at' => now(),
        ]);
        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/diff-preview");
        $res->assertStatus(422);
    }

    // --- M7-M2: member-diff-preview（members 基本情報更新候補） ---

    public function test_member_diff_preview_success_returns_summary_and_lists(): void
    {
        $meeting = Meeting::create(['number' => 400, 'held_on' => '2026-05-01', 'name' => '第400回定例会']);
        Member::create(['name' => '一致 太郎', 'type' => 'member', 'display_no' => null, 'name_kana' => 'いっち たろう']);

        $path = "meeting_csv_imports/{$meeting->id}/member_diff_ok.csv";
        $content = "種別,名前,よみがな\nメンバー,一致 太郎,いっち たろう\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'member_diff_ok.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/member-diff-preview");
        $res->assertOk();
        $res->assertJsonStructure([
            'summary' => [
                'updated_member_basic_count',
                'category_changed_count',
                'unresolved_member_count',
                'unchanged_member_count',
            ],
            'updated_member_basic',
            'category_changed',
            'unresolved_member',
        ]);
        $data = $res->json();
        $this->assertSame(0, $data['summary']['updated_member_basic_count']);
        $this->assertSame(0, $data['summary']['category_changed_count']);
        $this->assertSame(0, $data['summary']['unresolved_member_count']);
        $this->assertSame(1, $data['summary']['unchanged_member_count']);
    }

    public function test_member_diff_preview_kana_difference_in_updated_member_basic(): void
    {
        $meeting = Meeting::create(['number' => 401, 'held_on' => '2026-05-02', 'name' => '第401回定例会']);
        Member::create(['name' => 'かな 太郎', 'type' => 'member', 'display_no' => null, 'name_kana' => 'つぎひろ じゅん']);

        $path = "meeting_csv_imports/{$meeting->id}/kana.csv";
        $content = "種別,名前,よみがな\nメンバー,かな 太郎,つぎひろじゅん\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'kana.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/member-diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['summary']['updated_member_basic_count']);
        $this->assertSame(0, $data['summary']['unchanged_member_count']);
        $this->assertCount(1, $data['updated_member_basic']);
        $this->assertSame('かな 太郎', $data['updated_member_basic'][0]['name']);
        $this->assertSame('つぎひろ じゅん', $data['updated_member_basic'][0]['current_name_kana']);
        $this->assertSame('つぎひろじゅん', $data['updated_member_basic'][0]['new_name_kana']);
    }

    public function test_member_diff_preview_category_difference_in_category_changed(): void
    {
        $meeting = Meeting::create(['number' => 402, 'held_on' => '2026-05-03', 'name' => '第402回定例会']);
        $catIt = Category::create(['group_name' => 'IT', 'name' => 'Web']);
        $catBuild = Category::create(['group_name' => '建設', 'name' => '不動産']);
        $member = Member::create([
            'name' => 'カテゴリ 花子',
            'type' => 'member',
            'display_no' => null,
            'name_kana' => 'かてごり はなこ',
            'category_id' => $catIt->id,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/cat.csv";
        $content = "種別,名前,よみがな,大カテゴリー,カテゴリー\n";
        $content .= "メンバー,カテゴリ 花子,かてごり はなこ,建設,不動産\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'cat.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/member-diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['summary']['category_changed_count']);
        $this->assertCount(1, $data['category_changed']);
        $this->assertSame($member->id, $data['category_changed'][0]['member_id']);
        $this->assertTrue($data['category_changed'][0]['category_master_resolved']);
        $this->assertSame($catBuild->id, $data['category_changed'][0]['resolved_category_id']);
        $this->assertStringContainsString('建設', $data['category_changed'][0]['new_category']);
        $this->assertSame(0, $data['summary']['unchanged_member_count']);
    }

    /** カテゴリー一致なら category_changed に入らない */
    public function test_member_diff_preview_same_category_not_category_changed(): void
    {
        $meeting = Meeting::create(['number' => 403, 'held_on' => '2026-05-04', 'name' => '第403回定例会']);
        $cat = Category::create(['group_name' => 'IT', 'name' => 'Web']);
        Member::create([
            'name' => '同カテ 一郎',
            'type' => 'member',
            'display_no' => null,
            'name_kana' => null,
            'category_id' => $cat->id,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/same_cat.csv";
        $content = "種別,名前,大カテゴリー,カテゴリー\nメンバー,同カテ 一郎,IT,Web\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'same_cat.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/member-diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(0, $data['summary']['category_changed_count']);
        $this->assertSame(1, $data['summary']['unchanged_member_count']);
    }

    public function test_member_diff_preview_unresolved_member_when_name_not_in_db(): void
    {
        $meeting = Meeting::create(['number' => 404, 'held_on' => '2026-05-05', 'name' => '第404回定例会']);

        $path = "meeting_csv_imports/{$meeting->id}/unknown.csv";
        $content = "種別,名前,カテゴリー\nメンバー,存在しない 名前,士業\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'unknown.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/member-diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['summary']['unresolved_member_count']);
        $this->assertCount(1, $data['unresolved_member']);
        $this->assertSame('存在しない 名前', $data['unresolved_member'][0]['csv_name']);
        $this->assertSame('士業', $data['unresolved_member'][0]['csv_category']);
    }

    public function test_member_diff_preview_unresolved_category_master_flag(): void
    {
        $meeting = Meeting::create(['number' => 405, 'held_on' => '2026-05-06', 'name' => '第405回定例会']);
        Member::create(['name' => '未登録カテゴリ 次郎', 'type' => 'member', 'display_no' => null, 'category_id' => null]);

        $path = "meeting_csv_imports/{$meeting->id}/unk_cat.csv";
        $content = "種別,名前,大カテゴリー,カテゴリー\nメンバー,未登録カテゴリ 次郎,存在しないG,存在しないN\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'unk_cat.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/member-diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['summary']['category_changed_count']);
        $this->assertFalse($data['category_changed'][0]['category_master_resolved']);
        $this->assertSame(0, $data['summary']['unchanged_member_count']);
    }

    public function test_member_diff_preview_returns_404_when_no_csv(): void
    {
        $meeting = Meeting::create(['number' => 406, 'held_on' => '2026-05-07', 'name' => '第406回定例会']);
        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/member-diff-preview");
        $res->assertNotFound();
    }

    public function test_member_diff_preview_returns_422_when_csv_has_no_data_rows(): void
    {
        $meeting = Meeting::create(['number' => 407, 'held_on' => '2026-05-08', 'name' => '第407回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/empty.csv";
        Storage::disk('local')->put($path, "種別,名前\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'empty.csv',
            'uploaded_at' => now(),
        ]);
        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/member-diff-preview");
        $res->assertStatus(422);
    }

    // --- M7-M3: member-apply（members 基本情報の確定反映） ---

    public function test_member_apply_success_updates_name_kana(): void
    {
        $meeting = Meeting::create(['number' => 410, 'held_on' => '2026-05-10', 'name' => '第410回定例会']);
        $member = Member::create(['name' => '反映 太郎', 'type' => 'member', 'display_no' => null, 'name_kana' => 'ふるい']);

        $path = "meeting_csv_imports/{$meeting->id}/apply_kana.csv";
        Storage::disk('local')->put($path, "種別,名前,よみがな\nメンバー,反映 太郎,あたらしいかな\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'apply_kana.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/member-apply");
        $res->assertOk();
        $res->assertJson([
            'updated_member_basic_count' => 1,
            'updated_category_count' => 0,
            'skipped_unresolved_count' => 0,
            'message' => 'members の基本情報を更新しました',
        ]);

        $member->refresh();
        $this->assertSame('あたらしいかな', $member->name_kana);
    }

    public function test_member_apply_updates_category_when_master_resolved(): void
    {
        $meeting = Meeting::create(['number' => 411, 'held_on' => '2026-05-11', 'name' => '第411回定例会']);
        $catA = Category::create(['group_name' => 'A', 'name' => 'A1']);
        $catB = Category::create(['group_name' => 'B', 'name' => 'B1']);
        $member = Member::create([
            'name' => 'カテゴリ反映 花子',
            'type' => 'member',
            'display_no' => null,
            'name_kana' => 'かてごり',
            'category_id' => $catA->id,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/apply_cat.csv";
        $content = "種別,名前,よみがな,大カテゴリー,カテゴリー\n";
        $content .= "メンバー,カテゴリ反映 花子,かてごり,B,B1\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'apply_cat.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/member-apply");
        $res->assertOk();
        $res->assertJson([
            'updated_member_basic_count' => 0,
            'updated_category_count' => 1,
            'skipped_unresolved_count' => 0,
        ]);

        $member->refresh();
        $this->assertSame($catB->id, $member->category_id);
    }

    public function test_member_apply_returns_skipped_unresolved_member_count(): void
    {
        $meeting = Meeting::create(['number' => 412, 'held_on' => '2026-05-12', 'name' => '第412回定例会']);
        Member::create(['name' => 'だけ 更新', 'type' => 'member', 'display_no' => null, 'name_kana' => 'x']);

        $path = "meeting_csv_imports/{$meeting->id}/mix.csv";
        $content = "種別,名前,よみがな\nメンバー,存在しない 人,\nメンバー,だけ 更新,y\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'mix.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/member-apply");
        $res->assertOk();
        $res->assertJson([
            'updated_member_basic_count' => 1,
            'skipped_unresolved_count' => 1,
        ]);
    }

    public function test_member_apply_skips_unresolved_category(): void
    {
        $meeting = Meeting::create(['number' => 413, 'held_on' => '2026-05-13', 'name' => '第413回定例会']);
        Member::create(['name' => '未登録カテのみ', 'type' => 'member', 'display_no' => null, 'name_kana' => 'かな', 'category_id' => null]);

        $path = "meeting_csv_imports/{$meeting->id}/unk_only.csv";
        $content = "種別,名前,よみがな,大カテゴリー,カテゴリー\nメンバー,未登録カテのみ,かな,存在X,存在Y\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'unk_only.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/member-apply");
        $res->assertStatus(422);
        $res->assertJsonFragment(['message' => '反映対象の差分がありません。']);
    }

    public function test_member_apply_does_not_touch_member_roles(): void
    {
        $meeting = Meeting::create(['number' => 414, 'held_on' => '2026-05-14', 'name' => '第414回定例会']);
        $member = Member::create(['name' => '役職 保持', 'type' => 'member', 'display_no' => null, 'name_kana' => 'old']);
        $role = Role::create(['name' => 'テスト役', 'description' => null]);
        MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $role->id,
            'term_start' => '2026-01-01',
            'term_end' => null,
        ]);
        $before = MemberRole::count();

        $path = "meeting_csv_imports/{$meeting->id}/role_safe.csv";
        Storage::disk('local')->put($path, "種別,名前,よみがな\nメンバー,役職 保持,newkana\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_safe.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/member-apply");
        $res->assertOk();
        $this->assertSame($before, MemberRole::count());
        $member->refresh();
        $this->assertSame('newkana', $member->name_kana);
    }

    public function test_member_apply_returns_404_when_no_csv(): void
    {
        $meeting = Meeting::create(['number' => 415, 'held_on' => '2026-05-15', 'name' => '第415回定例会']);
        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/member-apply");
        $res->assertNotFound();
    }

    public function test_member_apply_returns_422_when_no_applicable_diff(): void
    {
        $meeting = Meeting::create(['number' => 416, 'held_on' => '2026-05-16', 'name' => '第416回定例会']);

        $path = "meeting_csv_imports/{$meeting->id}/only_unknown.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,誰でもない\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'only_unknown.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/member-apply");
        $res->assertStatus(422);
    }

    public function test_member_apply_returns_422_when_all_unchanged(): void
    {
        $meeting = Meeting::create(['number' => 417, 'held_on' => '2026-05-17', 'name' => '第417回定例会']);
        Member::create(['name' => '変化なし', 'type' => 'member', 'display_no' => null, 'name_kana' => 'かな']);

        $path = "meeting_csv_imports/{$meeting->id}/same.csv";
        Storage::disk('local')->put($path, "種別,名前,よみがな\nメンバー,変化なし,かな\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'same.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/member-apply");
        $res->assertStatus(422);
    }

    public function test_member_apply_applies_basic_and_reports_skipped_unresolved_category(): void
    {
        $meeting = Meeting::create(['number' => 418, 'held_on' => '2026-05-18', 'name' => '第418回定例会']);
        Member::create(['name' => '混合 一郎', 'type' => 'member', 'display_no' => null, 'name_kana' => 'old', 'category_id' => null]);

        $path = "meeting_csv_imports/{$meeting->id}/mix_cat.csv";
        $content = "種別,名前,よみがな,大カテゴリー,カテゴリー\nメンバー,混合 一郎,new,存在しないG,存在しないN\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'mix_cat.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/member-apply");
        $res->assertOk();
        $res->assertJson([
            'updated_member_basic_count' => 1,
            'updated_category_count' => 0,
            'skipped_unresolved_category_count' => 1,
        ]);
    }

    // --- M7-M4: role-diff-preview（Role History 差分検知・表示のみ） ---

    public function test_role_diff_preview_success_returns_structure(): void
    {
        $meeting = Meeting::create(['number' => 420, 'held_on' => '2026-06-01', 'name' => '第420回定例会']);
        Member::create(['name' => '役職 テスト', 'type' => 'member', 'display_no' => null]);

        $path = "meeting_csv_imports/{$meeting->id}/role_ok.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,役職 テスト,\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_ok.csv',
            'uploaded_at' => now(),
        ]);

        $beforeMr = MemberRole::count();
        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/role-diff-preview");
        $res->assertOk();
        $this->assertSame($beforeMr, MemberRole::count());

        $res->assertJsonStructure([
            'summary' => [
                'changed_role_count',
                'csv_role_only_count',
                'current_role_only_count',
                'unchanged_role_count',
                'unresolved_member_count',
            ],
            'changed_role',
            'csv_role_only',
            'current_role_only',
            'unresolved_member',
        ]);
    }

    /** 同じ役職名なら changed に入らず継続カウントのみ */
    public function test_role_diff_preview_same_role_is_unchanged_not_changed(): void
    {
        $meeting = Meeting::create(['number' => 421, 'held_on' => '2026-06-02', 'name' => '第421回定例会']);
        $role = Role::create(['name' => '書記', 'description' => null]);
        $member = Member::create(['name' => '継続 太郎', 'type' => 'member', 'display_no' => null]);
        MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $role->id,
            'term_start' => '2020-01-01',
            'term_end' => null,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/role_same.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,継続 太郎,書記\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_same.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/role-diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(0, $data['summary']['changed_role_count']);
        $this->assertSame(1, $data['summary']['unchanged_role_count']);
        $this->assertCount(0, $data['changed_role']);
    }

    public function test_role_diff_preview_changed_when_csv_differs_from_current(): void
    {
        $meeting = Meeting::create(['number' => 422, 'held_on' => '2026-06-03', 'name' => '第422回定例会']);
        $rPres = Role::create(['name' => 'プレジデント', 'description' => null]);
        $rSec = Role::create(['name' => '書記', 'description' => null]);
        $member = Member::create(['name' => '変更 花子', 'type' => 'member', 'display_no' => null]);
        MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $rPres->id,
            'term_start' => '2020-01-01',
            'term_end' => null,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/role_chg.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,変更 花子,書記\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_chg.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/role-diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['summary']['changed_role_count']);
        $this->assertCount(1, $data['changed_role']);
        $this->assertSame('プレジデント', $data['changed_role'][0]['current_role']);
        $this->assertSame('書記', $data['changed_role'][0]['csv_role']);
        $this->assertTrue($data['changed_role'][0]['role_master_resolved']);
    }

    public function test_role_diff_preview_csv_role_only_when_no_current_role(): void
    {
        $meeting = Meeting::create(['number' => 423, 'held_on' => '2026-06-04', 'name' => '第423回定例会']);
        Role::create(['name' => '会計', 'description' => null]);
        Member::create(['name' => '新任 一郎', 'type' => 'member', 'display_no' => null]);

        $path = "meeting_csv_imports/{$meeting->id}/role_csv_only.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,新任 一郎,会計\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_csv_only.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/role-diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['summary']['csv_role_only_count']);
        $this->assertCount(1, $data['csv_role_only']);
        $this->assertSame('会計', $data['csv_role_only'][0]['csv_role']);
        $this->assertTrue($data['csv_role_only'][0]['role_master_resolved']);
        $this->assertNull($data['csv_role_only'][0]['current_role']);
    }

    /** 役職列なし CSV → CSV 側は空扱い、current のみ */
    public function test_role_diff_preview_current_role_only_when_csv_has_no_role_column(): void
    {
        $meeting = Meeting::create(['number' => 424, 'held_on' => '2026-06-05', 'name' => '第424回定例会']);
        $role = Role::create(['name' => '副会長', 'description' => null]);
        $member = Member::create(['name' => '副会 次郎', 'type' => 'member', 'display_no' => null]);
        MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $role->id,
            'term_start' => '2020-01-01',
            'term_end' => null,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/no_role_col.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,副会 次郎\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'no_role_col.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/role-diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['summary']['current_role_only_count']);
        $this->assertCount(1, $data['current_role_only']);
        $this->assertSame('副会長', $data['current_role_only'][0]['current_role']);
        $this->assertNull($data['current_role_only'][0]['csv_role']);
    }

    public function test_role_diff_preview_unresolved_member_count(): void
    {
        $meeting = Meeting::create(['number' => 425, 'held_on' => '2026-06-06', 'name' => '第425回定例会']);

        $path = "meeting_csv_imports/{$meeting->id}/role_unk.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,マスタにいない名前,書記\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_unk.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/role-diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['summary']['unresolved_member_count']);
        $this->assertSame('マスタにいない名前', $data['unresolved_member'][0]['csv_name']);
    }

    public function test_role_diff_preview_changed_role_master_unresolved(): void
    {
        $meeting = Meeting::create(['number' => 426, 'held_on' => '2026-06-07', 'name' => '第426回定例会']);
        $rOld = Role::create(['name' => '既存役', 'description' => null]);
        $member = Member::create(['name' => 'マスタ外 三郎', 'type' => 'member', 'display_no' => null]);
        MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $rOld->id,
            'term_start' => '2020-01-01',
            'term_end' => null,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/role_not_in_master.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,マスタ外 三郎,存在しない役職名\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_not_in_master.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/role-diff-preview");
        $res->assertOk();
        $data = $res->json();
        $this->assertSame(1, $data['summary']['changed_role_count']);
        $this->assertFalse($data['changed_role'][0]['role_master_resolved']);
    }

    public function test_role_diff_preview_returns_404_when_no_csv(): void
    {
        $meeting = Meeting::create(['number' => 427, 'held_on' => '2026-06-08', 'name' => '第427回定例会']);
        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/role-diff-preview");
        $res->assertNotFound();
    }

    public function test_role_diff_preview_returns_422_when_csv_has_no_data_rows(): void
    {
        $meeting = Meeting::create(['number' => 428, 'held_on' => '2026-06-09', 'name' => '第428回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/role_empty.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_empty.csv',
            'uploaded_at' => now(),
        ]);
        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/role-diff-preview");
        $res->assertStatus(422);
    }

    // --- M7-M5: role-apply（Role History 確定反映） ---

    public function test_role_apply_changed_role_closes_current_and_starts_new(): void
    {
        $effective = '2026-07-01';
        $meeting = Meeting::create(['number' => 429, 'held_on' => $effective, 'name' => '第429回定例会']);
        $rPres = Role::create(['name' => 'プレジデント', 'description' => null]);
        $rSec = Role::create(['name' => '書記', 'description' => null]);
        $member = Member::create(['name' => '変更 太郎', 'type' => 'member', 'display_no' => null]);
        $oldMr = MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $rPres->id,
            'term_start' => '2020-01-01',
            'term_end' => null,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/role_apply_chg.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,変更 太郎,書記\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_apply_chg.csv',
            'uploaded_at' => now(),
        ]);

        $beforeCount = MemberRole::count();
        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/role-apply");
        $res->assertOk();
        $res->assertJson([
            'changed_role_applied_count' => 1,
            'csv_role_only_applied_count' => 0,
            'current_role_only_closed_count' => 0,
            'skipped_unresolved_role_count' => 0,
        ]);
        $this->assertSame($beforeCount + 1, MemberRole::count());

        $oldMr->refresh();
        $this->assertSame($effective, $oldMr->term_end->toDateString());

        $newMr = MemberRole::where('member_id', $member->id)
            ->where('role_id', $rSec->id)
            ->whereNull('term_end')
            ->first();
        $this->assertNotNull($newMr);
        $this->assertSame($effective, $newMr->term_start->toDateString());
    }

    public function test_role_apply_csv_role_only_creates_open_member_role(): void
    {
        $effective = '2026-07-02';
        $meeting = Meeting::create(['number' => 430, 'held_on' => $effective, 'name' => '第430回定例会']);
        Role::create(['name' => '会計', 'description' => null]);
        $member = Member::create(['name' => '新任 一郎', 'type' => 'member', 'display_no' => null]);

        $path = "meeting_csv_imports/{$meeting->id}/role_apply_csvonly.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,新任 一郎,会計\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_apply_csvonly.csv',
            'uploaded_at' => now(),
        ]);

        $this->assertSame(0, MemberRole::where('member_id', $member->id)->count());
        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/role-apply");
        $res->assertOk();
        $res->assertJson([
            'changed_role_applied_count' => 0,
            'csv_role_only_applied_count' => 1,
            'current_role_only_closed_count' => 0,
            'skipped_unresolved_role_count' => 0,
        ]);
        $mr = MemberRole::where('member_id', $member->id)->whereNull('term_end')->first();
        $this->assertNotNull($mr);
        $this->assertSame('会計', $mr->role->name);
        $this->assertSame($effective, $mr->term_start->toDateString());
    }

    public function test_role_apply_current_role_only_closes_open_role(): void
    {
        $effective = '2026-07-03';
        $meeting = Meeting::create(['number' => 431, 'held_on' => $effective, 'name' => '第431回定例会']);
        $role = Role::create(['name' => '副会長', 'description' => null]);
        $member = Member::create(['name' => '終了 花子', 'type' => 'member', 'display_no' => null]);
        $openMr = MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $role->id,
            'term_start' => '2020-01-01',
            'term_end' => null,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/role_apply_curonly.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,終了 花子\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_apply_curonly.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/role-apply");
        $res->assertOk();
        $res->assertJson([
            'changed_role_applied_count' => 0,
            'csv_role_only_applied_count' => 0,
            'current_role_only_closed_count' => 1,
            'skipped_unresolved_role_count' => 0,
        ]);
        $openMr->refresh();
        $this->assertSame($effective, $openMr->term_end->toDateString());
        $this->assertNull(MemberRole::where('member_id', $member->id)->whereNull('term_end')->first());
    }

    public function test_role_apply_returns_422_when_only_unchanged_roles(): void
    {
        $meeting = Meeting::create(['number' => 432, 'held_on' => '2026-07-04', 'name' => '第432回定例会']);
        $role = Role::create(['name' => '書記', 'description' => null]);
        $member = Member::create(['name' => '継続 次郎', 'type' => 'member', 'display_no' => null]);
        MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $role->id,
            'term_start' => '2020-01-01',
            'term_end' => null,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/role_apply_same.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,継続 次郎,書記\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_apply_same.csv',
            'uploaded_at' => now(),
        ]);

        $before = MemberRole::count();
        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/role-apply");
        $res->assertStatus(422);
        $this->assertSame($before, MemberRole::count());
    }

    public function test_role_apply_skips_unresolved_role_but_applies_current_role_only(): void
    {
        $effective = '2026-07-05';
        $meeting = Meeting::create(['number' => 433, 'held_on' => $effective, 'name' => '第433回定例会']);
        $rPres = Role::create(['name' => 'プレジデント', 'description' => null]);
        $rVice = Role::create(['name' => '副会長', 'description' => null]);
        $mBad = Member::create(['name' => '未登録役 太郎', 'type' => 'member', 'display_no' => null]);
        MemberRole::create([
            'member_id' => $mBad->id,
            'role_id' => $rPres->id,
            'term_start' => '2020-01-01',
            'term_end' => null,
        ]);
        $mClose = Member::create(['name' => '終了のみ 三郎', 'type' => 'member', 'display_no' => null]);
        $mrClose = MemberRole::create([
            'member_id' => $mClose->id,
            'role_id' => $rVice->id,
            'term_start' => '2020-01-01',
            'term_end' => null,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/role_apply_mix.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,未登録役 太郎,存在しない役職名\nメンバー,終了のみ 三郎\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_apply_mix.csv',
            'uploaded_at' => now(),
        ]);

        $beforeCount = MemberRole::count();
        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/role-apply");
        $res->assertOk();
        $res->assertJson([
            'changed_role_applied_count' => 0,
            'csv_role_only_applied_count' => 0,
            'current_role_only_closed_count' => 1,
            'skipped_unresolved_role_count' => 1,
        ]);
        $this->assertSame($beforeCount, MemberRole::count());

        $mrClose->refresh();
        $this->assertSame($effective, $mrClose->term_end->toDateString());
        $badOpen = MemberRole::where('member_id', $mBad->id)->whereNull('term_end')->first();
        $this->assertNotNull($badOpen);
        $this->assertSame($rPres->id, $badOpen->role_id);
    }

    public function test_role_apply_returns_422_when_only_unresolved_member_rows(): void
    {
        $meeting = Meeting::create(['number' => 434, 'held_on' => '2026-07-06', 'name' => '第434回定例会']);
        Role::create(['name' => '書記', 'description' => null]);

        $path = "meeting_csv_imports/{$meeting->id}/role_apply_noname.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,存在しないメンバー,書記\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_apply_noname.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/role-apply");
        $res->assertStatus(422);
    }

    public function test_role_apply_returns_422_when_only_unresolved_role_no_current_only(): void
    {
        $meeting = Meeting::create(['number' => 435, 'held_on' => '2026-07-07', 'name' => '第435回定例会']);
        $rOld = Role::create(['name' => '既存役', 'description' => null]);
        $member = Member::create(['name' => 'マスタ外のみ', 'type' => 'member', 'display_no' => null]);
        MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $rOld->id,
            'term_start' => '2020-01-01',
            'term_end' => null,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/role_apply_unresolved_only.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,マスタ外のみ,存在しない役職名\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_apply_unresolved_only.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/role-apply");
        $res->assertStatus(422);
    }

    public function test_role_apply_returns_404_when_no_csv(): void
    {
        $meeting = Meeting::create(['number' => 436, 'held_on' => '2026-07-08', 'name' => '第436回定例会']);
        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/role-apply");
        $res->assertNotFound();
    }

    public function test_role_apply_success_returns_message_and_does_not_touch_member_or_participant(): void
    {
        $meeting = Meeting::create(['number' => 437, 'held_on' => '2026-07-09', 'name' => '第437回定例会']);
        $rA = Role::create(['name' => '役A', 'description' => null]);
        $rB = Role::create(['name' => '役B', 'description' => null]);
        $member = Member::create(['name' => '固定名 メンバー', 'type' => 'member', 'display_no' => null]);
        MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $rA->id,
            'term_start' => '2020-01-01',
            'term_end' => null,
        ]);
        Participant::create(['meeting_id' => $meeting->id, 'member_id' => $member->id, 'type' => 'regular']);

        $path = "meeting_csv_imports/{$meeting->id}/role_apply_part.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,固定名 メンバー,役B\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_apply_part.csv',
            'uploaded_at' => now(),
        ]);

        $nameBefore = Member::find($member->id)->name;
        $pCount = Participant::where('meeting_id', $meeting->id)->count();

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/role-apply");
        $res->assertOk();
        $res->assertJsonFragment(['message' => 'Role History を更新しました']);
        $this->assertSame('2026-07-09', $res->json('effective_date'));
        $this->assertSame('held_on', $res->json('effective_date_source'));

        $this->assertSame($nameBefore, Member::find($member->id)->name);
        $this->assertSame($pCount, Participant::where('meeting_id', $meeting->id)->count());
    }

    /** M7-M6: effective_date 指定が例会日より優先される */
    public function test_role_apply_effective_date_request_overrides_held_on(): void
    {
        $meeting = Meeting::create(['number' => 438, 'held_on' => '2026-01-10', 'name' => '第438回定例会']);
        $rA = Role::create(['name' => '役A', 'description' => null]);
        $rB = Role::create(['name' => '役B', 'description' => null]);
        $member = Member::create(['name' => '上書 基準日', 'type' => 'member', 'display_no' => null]);
        MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $rA->id,
            'term_start' => '2019-01-01',
            'term_end' => null,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/role_eff.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,上書 基準日,役B\n");
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_eff.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/role-apply", [
            'effective_date' => '2026-03-19',
        ]);
        $res->assertOk();
        $this->assertSame('2026-03-19', $res->json('effective_date'));
        $this->assertSame('request', $res->json('effective_date_source'));

        $newMr = MemberRole::where('member_id', $member->id)->where('role_id', $rB->id)->whereNull('term_end')->first();
        $this->assertNotNull($newMr);
        $this->assertSame('2026-03-19', $newMr->term_start->toDateString());

        $log = MeetingCsvApplyLog::where('meeting_id', $meeting->id)->where('apply_type', 'roles')->first();
        $this->assertNotNull($log);
        $this->assertSame('2026-03-19', $log->applied_on->toDateString());
        $this->assertSame('request', $log->meta['effective_date_source']);
    }

    public function test_participants_apply_creates_audit_log(): void
    {
        $meeting = Meeting::create(['number' => 439, 'held_on' => '2026-08-01', 'name' => '第439回定例会']);
        $member = Member::create(['name' => 'ログ 太郎', 'type' => 'member', 'display_no' => null]);

        $path = "meeting_csv_imports/{$meeting->id}/audit_p.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,ログ 太郎\n");
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'audit_p.csv',
            'uploaded_at' => now(),
        ]);

        $this->assertSame(0, MeetingCsvApplyLog::where('meeting_id', $meeting->id)->count());
        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply", []);
        $res->assertOk();

        $this->assertSame(1, MeetingCsvApplyLog::where('meeting_id', $meeting->id)->count());
        $log = MeetingCsvApplyLog::where('meeting_id', $meeting->id)->first();
        $this->assertSame('participants', $log->apply_type);
        $this->assertSame($import->id, $log->meeting_csv_import_id);
        $this->assertGreaterThan(0, $log->applied_count);
        $this->assertNotNull($log->added_count);
    }

    public function test_members_apply_creates_audit_log(): void
    {
        $meeting = Meeting::create(['number' => 440, 'held_on' => '2026-08-02', 'name' => '第440回定例会']);
        Member::create(['name' => 'ログ メンバー', 'type' => 'member', 'display_no' => null, 'name_kana' => 'old']);

        $path = "meeting_csv_imports/{$meeting->id}/audit_m.csv";
        Storage::disk('local')->put($path, "種別,名前,よみがな\nメンバー,ログ メンバー,newかな\n");
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'audit_m.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/member-apply");
        $res->assertOk();

        $log = MeetingCsvApplyLog::where('meeting_id', $meeting->id)->where('apply_type', 'members')->first();
        $this->assertNotNull($log);
        $this->assertSame($import->id, $log->meeting_csv_import_id);
        $this->assertSame(1, (int) $log->meta['updated_member_basic_count']);
    }

    public function test_roles_apply_creates_audit_log_with_skipped_in_meta(): void
    {
        $effective = '2026-08-03';
        $meeting = Meeting::create(['number' => 441, 'held_on' => $effective, 'name' => '第441回定例会']);
        $r = Role::create(['name' => '書記', 'description' => null]);
        $member = Member::create(['name' => 'ログ 役職', 'type' => 'member', 'display_no' => null]);
        MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $r->id,
            'term_start' => '2018-01-01',
            'term_end' => null,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/audit_r.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,ログ 役職\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'audit_r.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/role-apply");
        $res->assertOk();

        $log = MeetingCsvApplyLog::where('meeting_id', $meeting->id)->where('apply_type', 'roles')->first();
        $this->assertNotNull($log);
        $this->assertSame($effective, $log->applied_on->toDateString());
        $this->assertSame('held_on', $log->meta['effective_date_source']);
        $this->assertSame(1, (int) $log->meta['current_role_only_closed_count']);
    }

    public function test_role_apply_422_does_not_create_audit_log(): void
    {
        $meeting = Meeting::create(['number' => 442, 'held_on' => '2026-08-04', 'name' => '第442回定例会']);
        $role = Role::create(['name' => '書記', 'description' => null]);
        $member = Member::create(['name' => '継続のみ', 'type' => 'member', 'display_no' => null]);
        MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $role->id,
            'term_start' => '2018-01-01',
            'term_end' => null,
        ]);

        $path = "meeting_csv_imports/{$meeting->id}/no_apply.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,継続のみ,書記\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'no_apply.csv',
            'uploaded_at' => now(),
        ]);

        $before = MeetingCsvApplyLog::count();
        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/role-apply");
        $res->assertStatus(422);
        $this->assertSame($before, MeetingCsvApplyLog::count());
    }

    public function test_apply_logs_index_returns_recent(): void
    {
        $meeting = Meeting::create(['number' => 443, 'held_on' => '2026-08-05', 'name' => '第443回定例会']);
        $member = Member::create(['name' => 'APIログ', 'type' => 'member', 'display_no' => null]);
        $path = "meeting_csv_imports/{$meeting->id}/logs.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,APIログ\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'logs.csv',
            'uploaded_at' => now(),
        ]);

        $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply")->assertOk();

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/apply-logs");
        $res->assertOk();
        $data = $res->json('logs');
        $this->assertIsArray($data);
        $this->assertGreaterThanOrEqual(1, count($data));
        $this->assertSame('participants', $data[0]['apply_type']);
        $this->assertArrayHasKey('summary', $data[0]);
    }

    // --- M7-M7: CSV 未解決ガイド付き解決（resolutions） ---

    public function test_csv_unresolved_returns_404_when_no_csv(): void
    {
        $meeting = Meeting::create(['number' => 450, 'held_on' => '2026-09-01', 'name' => '第450回定例会']);
        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/unresolved");
        $res->assertNotFound();
        $res->assertJsonFragment(['message' => 'CSVが登録されていません。']);
    }

    public function test_csv_unresolved_returns_404_when_meeting_missing(): void
    {
        $res = $this->getJson('/api/meetings/99999/csv-import/unresolved');
        $res->assertNotFound();
    }

    public function test_csv_unresolved_returns_three_lists(): void
    {
        $meeting = Meeting::create(['number' => 451, 'held_on' => '2026-09-02', 'name' => '第451回定例会']);
        Member::create(['name' => '既存 メンバー', 'type' => 'member', 'display_no' => null]);
        $path = "meeting_csv_imports/{$meeting->id}/unres.csv";
        Storage::disk('local')->put($path, "種別,名前,大カテゴリー,カテゴリー,役職\nメンバー,既存 メンバー,G,N,書記\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'unres.csv',
            'uploaded_at' => now(),
        ]);
        Category::create(['group_name' => 'G', 'name' => 'N']);
        Role::create(['name' => '書記', 'description' => null]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/unresolved");
        $res->assertOk();
        $res->assertJsonStructure([
            'unresolved_member',
            'unresolved_category',
            'unresolved_role',
        ]);
        $data = $res->json();
        $this->assertNotEmpty($data['unresolved_member']);
        $this->assertSame('resolved', $data['unresolved_member'][0]['status']);
    }

    public function test_store_member_resolution_maps_unknown_csv_name(): void
    {
        $meeting = Meeting::create(['number' => 452, 'held_on' => '2026-09-03', 'name' => '第452回定例会']);
        $member = Member::create(['name' => '本物 太郎', 'type' => 'member', 'display_no' => null]);
        $path = "meeting_csv_imports/{$meeting->id}/map_m.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,別名 花子\n");
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'map_m.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/resolutions", [
            'resolution_type' => 'member',
            'source_value' => '別名 花子',
            'resolved_id' => $member->id,
            'action_type' => 'mapped',
        ]);
        $res->assertOk();
        $this->assertDatabaseHas('meeting_csv_import_resolutions', [
            'meeting_csv_import_id' => $import->id,
            'resolution_type' => 'member',
            'source_value' => '別名 花子',
            'resolved_id' => $member->id,
            'action_type' => 'mapped',
        ]);

        $preview = $this->getJson("/api/meetings/{$meeting->id}/csv-import/member-diff-preview");
        $preview->assertOk();
        $this->assertSame(0, $preview->json('summary.unresolved_member_count'));
    }

    public function test_store_category_resolution_422_when_category_missing(): void
    {
        $meeting = Meeting::create(['number' => 453, 'held_on' => '2026-09-04', 'name' => '第453回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/cat.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,A\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'cat.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/resolutions", [
            'resolution_type' => 'category',
            'source_value' => 'X / Y',
            'resolved_id' => 99999,
            'action_type' => 'mapped',
        ]);
        $res->assertStatus(422);
        $res->assertJsonFragment(['message' => '指定の Category が見つかりません。']);
    }

    public function test_store_role_resolution_then_role_diff_resolves_master(): void
    {
        $meeting = Meeting::create(['number' => 454, 'held_on' => '2026-09-05', 'name' => '第454回定例会']);
        $roleOld = Role::create(['name' => '書記', 'description' => null]);
        $roleNew = Role::create(['name' => '社長', 'description' => null]);
        $m = Member::create(['name' => '役職テスト', 'type' => 'member', 'display_no' => null]);
        MemberRole::create([
            'member_id' => $m->id,
            'role_id' => $roleOld->id,
            'term_start' => '2020-01-01',
            'term_end' => null,
        ]);
        $path = "meeting_csv_imports/{$meeting->id}/role_map.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,役職テスト,CSV別名社長\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'role_map.csv',
            'uploaded_at' => now(),
        ]);

        $this->postJson("/api/meetings/{$meeting->id}/csv-import/resolutions", [
            'resolution_type' => 'role',
            'source_value' => 'CSV別名社長',
            'resolved_id' => $roleNew->id,
            'action_type' => 'mapped',
        ])->assertOk();

        $rp = $this->getJson("/api/meetings/{$meeting->id}/csv-import/role-diff-preview");
        $rp->assertOk();
        $changed = collect($rp->json('changed_role'));
        $row = $changed->firstWhere('member_id', $m->id);
        $this->assertNotNull($row);
        $this->assertTrue((bool) $row['role_master_resolved']);
        $this->assertSame('CSV別名社長', $row['csv_role']);
    }

    public function test_create_member_resolution_creates_member_and_row(): void
    {
        $meeting = Meeting::create(['number' => 455, 'held_on' => '2026-09-06', 'name' => '第455回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/new_m.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,新規CSV名\n");
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'new_m.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meeting->id}/csv-import/resolutions/create-member", [
            'source_value' => '新規CSV名',
            'name' => 'DB上の名前',
            'name_kana' => 'てすと',
            'type' => 'regular',
        ]);
        $res->assertStatus(201);
        $mid = $res->json('member.id');
        $this->assertDatabaseHas('members', ['id' => $mid, 'name' => 'DB上の名前']);
        $this->assertDatabaseHas('meeting_csv_import_resolutions', [
            'meeting_csv_import_id' => $import->id,
            'resolution_type' => 'member',
            'source_value' => '新規CSV名',
            'resolved_id' => $mid,
            'action_type' => MeetingCsvImportResolution::ACTION_CREATED,
        ]);
    }

    public function test_create_category_and_role_resolution(): void
    {
        $meeting = Meeting::create(['number' => 456, 'held_on' => '2026-09-07', 'name' => '第456回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/new_cr.csv";
        Storage::disk('local')->put($path, "種別,名前,大カテゴリー,カテゴリー,役職\nメンバー,A,?,?,?\n");
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'new_cr.csv',
            'uploaded_at' => now(),
        ]);

        // 大カテゴリー・カテゴリーが同一「?」のときラベルは「?」（MeetingCsvUnresolvedSummaryService と一致）
        $catSource = '?';
        $cres = $this->postJson("/api/meetings/{$meeting->id}/csv-import/resolutions/create-category", [
            'source_value' => $catSource,
            'group_name' => 'Gnew',
            'name' => 'Nnew',
        ]);
        $cres->assertStatus(201);
        $cid = $cres->json('category.id');
        $this->assertDatabaseHas('categories', ['id' => $cid, 'group_name' => 'Gnew', 'name' => 'Nnew']);

        $rres = $this->postJson("/api/meetings/{$meeting->id}/csv-import/resolutions/create-role", [
            'source_value' => '?',
            'name' => '役Rnew',
        ]);
        $rres->assertStatus(201);
        $rid = $rres->json('role.id');
        $this->assertDatabaseHas('roles', ['id' => $rid, 'name' => '役Rnew']);
        $this->assertDatabaseHas('meeting_csv_import_resolutions', [
            'meeting_csv_import_id' => $import->id,
            'resolution_type' => 'category',
            'source_value' => $catSource,
        ]);
    }

    public function test_store_resolution_validation_422(): void
    {
        $meeting = Meeting::create(['number' => 457, 'held_on' => '2026-09-08', 'name' => '第457回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/v.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,X\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'v.csv',
            'uploaded_at' => now(),
        ]);

        $this->postJson("/api/meetings/{$meeting->id}/csv-import/resolutions", [
            'resolution_type' => 'member',
            'source_value' => 'X',
            'resolved_id' => 1,
            'action_type' => 'invalid',
        ])->assertUnprocessable();
    }

    // --- M8: 未解決向けあいまい一致候補（unresolved-suggestions） ---

    public function test_unresolved_suggestions_returns_404_when_no_csv(): void
    {
        $meeting = Meeting::create(['number' => 458, 'held_on' => '2026-09-09', 'name' => '第458回定例会']);
        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/unresolved-suggestions");
        $res->assertNotFound();
    }

    public function test_unresolved_suggestions_empty_when_all_resolved(): void
    {
        $meeting = Meeting::create(['number' => 459, 'held_on' => '2026-09-10', 'name' => '第459回定例会']);
        Member::create(['name' => '既存 メンバー', 'type' => 'member', 'display_no' => null]);
        $path = "meeting_csv_imports/{$meeting->id}/sug_all_res.csv";
        Storage::disk('local')->put($path, "種別,名前,大カテゴリー,カテゴリー,役職\nメンバー,既存 メンバー,G,N,書記\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'sug_all_res.csv',
            'uploaded_at' => now(),
        ]);
        Category::create(['group_name' => 'G', 'name' => 'N']);
        Role::create(['name' => '書記', 'description' => null]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/unresolved-suggestions");
        $res->assertOk();
        $res->assertJson([
            'unresolved_member' => [],
            'unresolved_category' => [],
            'unresolved_role' => [],
        ]);
    }

    public function test_unresolved_suggestions_returns_scored_candidates_for_open_rows(): void
    {
        $meeting = Meeting::create(['number' => 460, 'held_on' => '2026-09-11', 'name' => '第460回定例会']);
        Member::create(['name' => '山田 太郎', 'name_kana' => null, 'type' => 'member', 'display_no' => null]);
        Category::create(['group_name' => 'IT・通信', 'name' => '開発']);
        Role::create(['name' => '副会長', 'description' => null]);
        $path = "meeting_csv_imports/{$meeting->id}/sug_open.csv";
        $content = "種別,名前,大カテゴリー,カテゴリー,役職\n";
        $content .= "メンバー,山田　太郎,IT通信,開発,副　会長\n";
        Storage::disk('local')->put($path, $content);
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'sug_open.csv',
            'uploaded_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meeting->id}/csv-import/unresolved-suggestions");
        $res->assertOk();
        $data = $res->json();
        $this->assertCount(1, $data['unresolved_member']);
        $this->assertSame('山田　太郎', $data['unresolved_member'][0]['source_value']);
        $this->assertNotEmpty($data['unresolved_member'][0]['suggestions']);
        $this->assertSame('山田 太郎', $data['unresolved_member'][0]['suggestions'][0]['label']);

        $this->assertCount(1, $data['unresolved_category']);
        $this->assertSame('IT通信 / 開発', $data['unresolved_category'][0]['source_value']);
        $this->assertNotEmpty($data['unresolved_category'][0]['suggestions']);
        $this->assertSame(90, $data['unresolved_category'][0]['suggestions'][0]['score']);

        $this->assertCount(1, $data['unresolved_role']);
        $this->assertSame('副　会長', $data['unresolved_role'][0]['source_value']);
        $this->assertNotEmpty($data['unresolved_role'][0]['suggestions']);
        $this->assertSame('副会長', $data['unresolved_role'][0]['suggestions'][0]['label']);

        $scores = array_column($data['unresolved_member'][0]['suggestions'], 'score');
        $sorted = $scores;
        rsort($sorted, SORT_NUMERIC);
        $this->assertSame($sorted, $scores);
    }

    public function test_member_suggestion_resolution_reflects_in_member_diff_preview(): void
    {
        $meeting = Meeting::create(['number' => 461, 'held_on' => '2026-09-12', 'name' => '第461回定例会']);
        $member = Member::create(['name' => '山田 太郎', 'name_kana' => null, 'type' => 'member', 'display_no' => null]);
        $path = "meeting_csv_imports/{$meeting->id}/sug_map.csv";
        Storage::disk('local')->put($path, "種別,名前,よみがな\nメンバー,山田　太郎,やまだ\n");
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'sug_map.csv',
            'uploaded_at' => now(),
        ]);

        $sug = $this->getJson("/api/meetings/{$meeting->id}/csv-import/unresolved-suggestions");
        $sug->assertOk();
        $mid = $sug->json('unresolved_member.0.suggestions.0.id');
        $this->assertSame($member->id, $mid);

        $this->postJson("/api/meetings/{$meeting->id}/csv-import/resolutions", [
            'resolution_type' => 'member',
            'source_value' => '山田　太郎',
            'resolved_id' => $member->id,
            'action_type' => 'mapped',
        ])->assertOk();

        $this->assertDatabaseHas('meeting_csv_import_resolutions', [
            'meeting_csv_import_id' => $import->id,
            'resolution_type' => 'member',
            'source_value' => '山田　太郎',
            'resolved_id' => $member->id,
        ]);

        $preview = $this->getJson("/api/meetings/{$meeting->id}/csv-import/member-diff-preview");
        $preview->assertOk();
        $this->assertSame(0, $preview->json('summary.unresolved_member_count'));
    }

    // --- M8.5: member 解決順（resolution → 名前一致）統一・同名競合 ---

    public function test_m85_duplicate_member_name_resolution_wins_across_preview_apply_and_unresolved(): void
    {
        $meeting = Meeting::create(['number' => 462, 'held_on' => '2026-09-13', 'name' => '第462回定例会']);
        $m1 = Member::create(['name' => '山田太郎', 'name_kana' => null, 'type' => 'member', 'display_no' => null]);
        $m2 = Member::create(['name' => '山田太郎', 'name_kana' => null, 'type' => 'member', 'display_no' => null]);
        $this->assertLessThan($m2->id, $m1->id);

        $path = "meeting_csv_imports/{$meeting->id}/m85.csv";
        Storage::disk('local')->put($path, "種別,名前,役職\nメンバー,山田太郎,書記\n");
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'm85.csv',
            'uploaded_at' => now(),
        ]);

        MeetingCsvImportResolution::create([
            'meeting_csv_import_id' => $import->id,
            'resolution_type' => MeetingCsvImportResolution::TYPE_MEMBER,
            'source_value' => '山田太郎',
            'resolved_id' => $m2->id,
            'resolved_label' => $m2->name,
            'action_type' => MeetingCsvImportResolution::ACTION_MAPPED,
        ]);

        $role = Role::create(['name' => '書記', 'description' => null]);
        MemberRole::create([
            'member_id' => $m2->id,
            'role_id' => $role->id,
            'term_start' => '2020-01-01',
            'term_end' => null,
        ]);

        $diff = $this->getJson("/api/meetings/{$meeting->id}/csv-import/diff-preview");
        $diff->assertOk();
        $added = $diff->json('added');
        $this->assertCount(1, $added);
        $this->assertSame($m2->id, $added[0]['member_id']);

        $md = $this->getJson("/api/meetings/{$meeting->id}/csv-import/member-diff-preview");
        $md->assertOk();
        $this->assertSame(0, $md->json('summary.unresolved_member_count'));
        $this->assertSame(1, $md->json('summary.unchanged_member_count'));

        $rd = $this->getJson("/api/meetings/{$meeting->id}/csv-import/role-diff-preview");
        $rd->assertOk();
        $this->assertSame(0, $rd->json('summary.unresolved_member_count'));
        $this->assertGreaterThanOrEqual(1, $rd->json('summary.unchanged_role_count'));

        $unr = $this->getJson("/api/meetings/{$meeting->id}/csv-import/unresolved");
        $unr->assertOk();
        $yamadaRow = collect($unr->json('unresolved_member'))->firstWhere('source_value', '山田太郎');
        $this->assertNotNull($yamadaRow);
        $this->assertSame('resolved', $yamadaRow['status']);
        $this->assertSame($m2->id, $yamadaRow['resolved_member_id']);

        $this->postJson("/api/meetings/{$meeting->id}/csv-import/apply")->assertOk();
        $this->assertNotNull(Participant::where('meeting_id', $meeting->id)->where('member_id', $m2->id)->first());
        $this->assertNull(Participant::where('meeting_id', $meeting->id)->where('member_id', $m1->id)->first());
    }

    // --- M9: resolution 一覧・解除・再マップ + 同名警告 ---

    public function test_m9_list_resolutions_returns_rows_for_latest_import(): void
    {
        $meeting = Meeting::create(['number' => 470, 'held_on' => '2026-09-20', 'name' => '第470回定例会']);
        $path = "meeting_csv_imports/{$meeting->id}/m9_list.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,A\n");
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'm9_list.csv',
            'uploaded_at' => now(),
        ]);
        $m = Member::create(['name' => 'A', 'type' => 'member', 'display_no' => null]);
        $res = MeetingCsvImportResolution::create([
            'meeting_csv_import_id' => $import->id,
            'resolution_type' => MeetingCsvImportResolution::TYPE_MEMBER,
            'source_value' => 'A',
            'resolved_id' => $m->id,
            'resolved_label' => $m->name,
            'action_type' => MeetingCsvImportResolution::ACTION_MAPPED,
        ]);

        $r = $this->getJson("/api/meetings/{$meeting->id}/csv-import/resolutions");
        $r->assertOk();
        $rows = $r->json('resolutions');
        $this->assertCount(1, $rows);
        $this->assertSame($res->id, $rows[0]['id']);
        $this->assertSame('member', $rows[0]['resolution_type']);
    }

    public function test_m9_list_resolutions_404_when_no_csv(): void
    {
        $meeting = Meeting::create(['number' => 471, 'held_on' => '2026-09-21', 'name' => '第471回定例会']);
        $this->getJson("/api/meetings/{$meeting->id}/csv-import/resolutions")->assertNotFound();
    }

    public function test_m9_destroy_resolution_404_for_stale_import(): void
    {
        $meeting = Meeting::create(['number' => 472, 'held_on' => '2026-09-22', 'name' => '第472回定例会']);
        $path1 = "meeting_csv_imports/{$meeting->id}/old.csv";
        Storage::disk('local')->put($path1, "種別,名前\nメンバー,X\n");
        $old = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path1,
            'file_name' => 'old.csv',
            'uploaded_at' => now()->subHour(),
        ]);
        $row = MeetingCsvImportResolution::create([
            'meeting_csv_import_id' => $old->id,
            'resolution_type' => MeetingCsvImportResolution::TYPE_MEMBER,
            'source_value' => 'X',
            'resolved_id' => 1,
            'resolved_label' => 'x',
            'action_type' => MeetingCsvImportResolution::ACTION_MAPPED,
        ]);
        $path2 = "meeting_csv_imports/{$meeting->id}/new.csv";
        Storage::disk('local')->put($path2, "種別,名前\nメンバー,Y\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path2,
            'file_name' => 'new.csv',
            'uploaded_at' => now(),
        ]);

        $this->deleteJson("/api/meetings/{$meeting->id}/csv-import/resolutions/{$row->id}")->assertNotFound();
        $this->assertDatabaseHas('meeting_csv_import_resolutions', ['id' => $row->id]);
    }

    public function test_m9_destroy_resolution_then_name_resolution_reverts(): void
    {
        $meeting = Meeting::create(['number' => 473, 'held_on' => '2026-09-23', 'name' => '第473回定例会']);
        $m1 = Member::create(['name' => '山田', 'type' => 'member', 'display_no' => null]);
        $m2 = Member::create(['name' => '山田', 'type' => 'member', 'display_no' => null]);
        $path = "meeting_csv_imports/{$meeting->id}/m9_del.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,山田\n");
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'm9_del.csv',
            'uploaded_at' => now(),
        ]);
        $row = MeetingCsvImportResolution::create([
            'meeting_csv_import_id' => $import->id,
            'resolution_type' => MeetingCsvImportResolution::TYPE_MEMBER,
            'source_value' => '山田',
            'resolved_id' => $m2->id,
            'resolved_label' => $m2->name,
            'action_type' => MeetingCsvImportResolution::ACTION_MAPPED,
        ]);

        $this->deleteJson("/api/meetings/{$meeting->id}/csv-import/resolutions/{$row->id}")->assertOk();
        $this->assertDatabaseMissing('meeting_csv_import_resolutions', ['id' => $row->id]);

        $unr = $this->getJson("/api/meetings/{$meeting->id}/csv-import/unresolved");
        $unr->assertOk();
        $yamada = collect($unr->json('unresolved_member'))->firstWhere('source_value', '山田');
        $this->assertNotNull($yamada);
        $this->assertSame('resolved', $yamada['status']);
        $this->assertSame($m1->id, $yamada['resolved_member_id']);
        $this->assertTrue($yamada['duplicate_name_warning']);
        $this->assertSame(2, $yamada['duplicate_count']);
    }

    public function test_m9_put_resolution_remaps_member_for_diff_preview(): void
    {
        $meeting = Meeting::create(['number' => 474, 'held_on' => '2026-09-24', 'name' => '第474回定例会']);
        $ma = Member::create(['name' => 'A氏', 'type' => 'member', 'display_no' => null]);
        $mb = Member::create(['name' => 'B氏', 'type' => 'member', 'display_no' => null]);
        $path = "meeting_csv_imports/{$meeting->id}/m9_put.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,CSV名\n");
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'm9_put.csv',
            'uploaded_at' => now(),
        ]);
        $row = MeetingCsvImportResolution::create([
            'meeting_csv_import_id' => $import->id,
            'resolution_type' => MeetingCsvImportResolution::TYPE_MEMBER,
            'source_value' => 'CSV名',
            'resolved_id' => $ma->id,
            'resolved_label' => $ma->name,
            'action_type' => MeetingCsvImportResolution::ACTION_MAPPED,
        ]);

        $this->putJson("/api/meetings/{$meeting->id}/csv-import/resolutions/{$row->id}", [
            'resolved_id' => $mb->id,
            'action_type' => 'mapped',
        ])->assertOk()->assertJson(['resolved_id' => $mb->id]);

        $this->assertDatabaseHas('meeting_csv_import_resolutions', [
            'id' => $row->id,
            'resolved_id' => $mb->id,
        ]);

        $md = $this->getJson("/api/meetings/{$meeting->id}/csv-import/member-diff-preview");
        $md->assertOk();
        $this->assertSame(0, $md->json('summary.unresolved_member_count'));
        $upd = $md->json('updated_member_basic');
        $this->assertIsArray($upd);
        $hit = collect($upd)->firstWhere('member_id', $mb->id);
        $this->assertNotNull($hit);
        $this->assertSame('CSV名', $hit['new_name'] ?? null);
    }

    public function test_m9_put_resolution_422_when_member_missing(): void
    {
        $meeting = Meeting::create(['number' => 475, 'held_on' => '2026-09-25', 'name' => '第475回定例会']);
        $m = Member::create(['name' => 'Z', 'type' => 'member', 'display_no' => null]);
        $path = "meeting_csv_imports/{$meeting->id}/m9_422.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,Z\n");
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'm9_422.csv',
            'uploaded_at' => now(),
        ]);
        $row = MeetingCsvImportResolution::create([
            'meeting_csv_import_id' => $import->id,
            'resolution_type' => MeetingCsvImportResolution::TYPE_MEMBER,
            'source_value' => 'Z',
            'resolved_id' => $m->id,
            'resolved_label' => $m->name,
            'action_type' => MeetingCsvImportResolution::ACTION_MAPPED,
        ]);

        $this->putJson("/api/meetings/{$meeting->id}/csv-import/resolutions/{$row->id}", [
            'resolved_id' => 999998,
            'action_type' => 'mapped',
        ])->assertUnprocessable();
    }

    public function test_m9_preview_row_has_duplicate_flags_when_two_same_name(): void
    {
        $meeting = Meeting::create(['number' => 476, 'held_on' => '2026-09-26', 'name' => '第476回定例会']);
        Member::create(['name' => '太郎', 'type' => 'member', 'display_no' => null]);
        Member::create(['name' => '太郎', 'type' => 'member', 'display_no' => null]);
        $path = "meeting_csv_imports/{$meeting->id}/m9_prev.csv";
        Storage::disk('local')->put($path, "種別,名前\nメンバー,太郎\n");
        MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => $path,
            'file_name' => 'm9_prev.csv',
            'uploaded_at' => now(),
        ]);

        $p = $this->getJson("/api/meetings/{$meeting->id}/csv-import/preview");
        $p->assertOk();
        $rows = $p->json('rows');
        $this->assertNotEmpty($rows);
        $this->assertTrue($rows[0]['duplicate_name_warning']);
        $this->assertSame(2, $rows[0]['duplicate_count']);
    }
}
