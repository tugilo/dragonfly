<?php

namespace Tests\Feature\Religo;

use App\Models\Member;
use App\Models\MeetingParticipantImport;
use App\Models\Participant;
use App\Services\Religo\PdfParticipantParseService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Mockery;
use Tests\TestCase;

/**
 * M7-P1: GET/POST /api/meetings/{id}/participants/import, GET .../import/download.
 */
class MeetingParticipantImportControllerTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        Storage::fake('local');
    }

    private function createMeeting(int $number, string $heldOn): int
    {
        return (int) DB::table('meetings')->insertGetId([
            'number' => $number,
            'held_on' => $heldOn,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
    }

    public function test_show_returns_404_for_unknown_meeting(): void
    {
        $this->getJson('/api/meetings/99999/participants/import')->assertNotFound();
    }

    public function test_show_returns_has_pdf_false_when_no_import(): void
    {
        $meetingId = $this->createMeeting(100, '2026-03-17');

        $res = $this->getJson("/api/meetings/{$meetingId}/participants/import");
        $res->assertOk();
        $res->assertJson(['has_pdf' => false, 'original_filename' => null]);
    }

    public function test_show_returns_has_pdf_true_when_import_exists(): void
    {
        $meetingId = $this->createMeeting(101, '2026-03-18');

        $path = 'meeting_participant_imports/' . $meetingId . '/test.pdf';
        Storage::disk('local')->put($path, 'dummy pdf content');

        MeetingParticipantImport::create([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => '参加者一覧.pdf',
            'status' => 'uploaded',
        ]);

        $res = $this->getJson("/api/meetings/{$meetingId}/participants/import");
        $res->assertOk();
        $res->assertJson(['has_pdf' => true, 'original_filename' => '参加者一覧.pdf']);
    }

    public function test_store_creates_import_and_returns_meta(): void
    {
        $meetingId = $this->createMeeting(102, '2026-03-19');

        $file = UploadedFile::fake()->create('members.pdf', 100, 'application/pdf');

        $res = $this->post("/api/meetings/{$meetingId}/participants/import", [
            'pdf' => $file,
        ]);

        $res->assertCreated();
        $res->assertJson(['has_pdf' => true, 'original_filename' => 'members.pdf']);

        $this->assertDatabaseHas('meeting_participant_imports', [
            'meeting_id' => $meetingId,
            'original_filename' => 'members.pdf',
            'status' => 'uploaded',
        ]);

        $import = MeetingParticipantImport::where('meeting_id', $meetingId)->first();
        $this->assertNotNull($import);
        $this->assertTrue(Storage::disk('local')->exists($import->file_path));
    }

    public function test_store_rejects_non_pdf(): void
    {
        $meetingId = $this->createMeeting(103, '2026-03-20');

        $file = UploadedFile::fake()->create('doc.txt', 100, 'text/plain');

        $res = $this->post("/api/meetings/{$meetingId}/participants/import", [
            'pdf' => $file,
        ], ['Accept' => 'application/json']);

        $res->assertUnprocessable();
        $this->assertDatabaseMissing('meeting_participant_imports', ['meeting_id' => $meetingId]);
    }

    public function test_download_returns_404_when_no_import(): void
    {
        $meetingId = $this->createMeeting(104, '2026-03-21');

        $res = $this->get("/api/meetings/{$meetingId}/participants/import/download");
        $res->assertNotFound();
    }

    public function test_download_returns_file_when_import_exists(): void
    {
        $meetingId = $this->createMeeting(105, '2026-03-22');

        $path = 'meeting_participant_imports/' . $meetingId . '/stored.pdf';
        $content = 'binary pdf content';
        Storage::disk('local')->put($path, $content);

        MeetingParticipantImport::create([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => '定例会参加者.pdf',
            'status' => 'uploaded',
        ]);

        $res = $this->get("/api/meetings/{$meetingId}/participants/import/download");
        $res->assertOk();
        $res->assertHeader('Content-Type', 'application/pdf');
        $this->assertStringContainsString('attachment', $res->headers->get('Content-Disposition'));
        $this->assertStringContainsString('定例会参加者.pdf', $res->headers->get('Content-Disposition'));
        $this->assertSame($content, $res->getContent());
    }

    public function test_parse_returns_404_when_meeting_not_found(): void
    {
        $this->postJson('/api/meetings/99999/participants/import/parse')->assertNotFound();
    }

    public function test_parse_returns_422_when_no_participant_import(): void
    {
        $meetingId = $this->createMeeting(106, '2026-03-25');

        $res = $this->postJson("/api/meetings/{$meetingId}/participants/import/parse");
        $res->assertUnprocessable();
        $res->assertJsonFragment(['message' => 'No participant PDF for this meeting.']);
    }

    public function test_parse_returns_422_when_pdf_file_missing(): void
    {
        $meetingId = $this->createMeeting(107, '2026-03-26');
        MeetingParticipantImport::create([
            'meeting_id' => $meetingId,
            'file_path' => 'meeting_participant_imports/107/missing.pdf',
            'original_filename' => 'missing.pdf',
            'status' => 'uploaded',
        ]);

        $res = $this->postJson("/api/meetings/{$meetingId}/participants/import/parse");
        $res->assertUnprocessable();
        $res->assertJsonFragment(['message' => 'PDF file not found.']);
    }

    public function test_parse_success_saves_extracted_text_and_result_and_returns_candidate_count(): void
    {
        $meetingId = $this->createMeeting(108, '2026-03-27');
        $path = 'meeting_participant_imports/108/parse-test.pdf';
        Storage::disk('local')->put($path, '%PDF-1.4 dummy content for storage existence check');

        MeetingParticipantImport::create([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'test.pdf',
            'status' => 'uploaded',
        ]);

        $mockService = Mockery::mock(PdfParticipantParseService::class);
        $mockService->shouldReceive('extractText')->once()->andReturn("山田 太郎\n佐藤 花子");
        $mockService->shouldReceive('buildCandidates')->once()->with("山田 太郎\n佐藤 花子")->andReturn([
            'candidates' => [
                ['name' => '山田 太郎', 'raw_line' => '山田 太郎', 'type_hint' => 'regular'],
                ['name' => '佐藤 花子', 'raw_line' => '佐藤 花子', 'type_hint' => 'regular'],
            ],
            'meta' => ['line_count' => 2, 'parser_version' => 1],
        ]);
        $this->app->instance(PdfParticipantParseService::class, $mockService);

        $res = $this->postJson("/api/meetings/{$meetingId}/participants/import/parse");
        $res->assertOk();
        $res->assertJson([
            'parse_status' => 'success',
            'candidate_count' => 2,
        ]);
        $res->assertJsonStructure(['parsed_at']);

        $import = MeetingParticipantImport::where('meeting_id', $meetingId)->first();
        $this->assertNotNull($import);
        $this->assertSame('success', $import->parse_status);
        $this->assertNotNull($import->parsed_at);
        $this->assertSame("山田 太郎\n佐藤 花子", $import->extracted_text);
        $this->assertIsArray($import->extracted_result);
        $this->assertSame('山田 太郎', $import->extracted_result['candidates'][0]['name']);
        $this->assertSame(2, count($import->extracted_result['candidates']));
    }

    public function test_show_returns_parse_status_and_candidate_count_in_meeting_detail(): void
    {
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 209,
            'held_on' => '2026-03-28',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/209/detail.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'detail.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_text' => 'A',
            'extracted_result' => json_encode([
                'candidates' => [
                    ['name' => 'A', 'raw_line' => 'A', 'type_hint' => 'regular'],
                ],
                'meta' => ['line_count' => 1, 'parser_version' => 1],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meetingId}");
        $res->assertOk();
        $pi = $res->json('participant_import');
        $this->assertSame('success', $pi['parse_status']);
        $this->assertNotNull($pi['parsed_at']);
        $this->assertSame(1, $pi['candidate_count']);
        $this->assertIsArray($pi['candidates']);
        $this->assertCount(1, $pi['candidates']);
        $this->assertSame('A', $pi['candidates'][0]['name']);
    }

    public function test_update_candidates_success_updates_extracted_result_and_preserves_meta(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 210,
            'held_on' => '2026-03-29',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/210/candidates.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'candidates.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_text' => 'X',
            'extracted_result' => json_encode([
                'candidates' => [
                    ['name' => 'Original', 'raw_line' => 'Orig', 'type_hint' => 'regular'],
                ],
                'meta' => ['line_count' => 10, 'parser_version' => 1],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->putJson("/api/meetings/{$meetingId}/participants/import/candidates", [
            'candidates' => [
                ['name' => '山田 太郎', 'raw_line' => '山田 太郎 建設', 'type_hint' => 'regular'],
                ['name' => '佐藤 花子', 'raw_line' => '', 'type_hint' => 'guest'],
            ],
        ]);

        $res->assertOk();
        $res->assertJson(['candidate_count' => 2]);
        $this->assertCount(2, $res->json('candidates'));

        $import = MeetingParticipantImport::where('meeting_id', $meetingId)->first();
        $this->assertSame('success', $import->parse_status);
        $this->assertSame('山田 太郎', $import->extracted_result['candidates'][0]['name']);
        $this->assertSame('guest', $import->extracted_result['candidates'][1]['type_hint']);
        $this->assertSame(10, $import->extracted_result['meta']['line_count']);
        $this->assertSame(1, $import->extracted_result['meta']['parser_version']);
    }

    public function test_update_candidates_excludes_empty_name_rows(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 211,
            'held_on' => '2026-03-30',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/211/empty.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'empty.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_text' => '',
            'extracted_result' => json_encode([
                'candidates' => [['name' => 'A', 'raw_line' => 'A', 'type_hint' => 'regular']],
                'meta' => ['line_count' => 1, 'parser_version' => 1],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->putJson("/api/meetings/{$meetingId}/participants/import/candidates", [
            'candidates' => [
                ['name' => 'Keep', 'raw_line' => 'K', 'type_hint' => 'regular'],
                ['name' => '', 'raw_line' => 'empty', 'type_hint' => 'guest'],
                ['name' => '  ', 'raw_line' => 'blank', 'type_hint' => null],
            ],
        ]);

        $res->assertOk();
        $res->assertJson(['candidate_count' => 1]);
        $this->assertSame('Keep', $res->json('candidates')[0]['name']);

        $import = MeetingParticipantImport::where('meeting_id', $meetingId)->first();
        $this->assertCount(1, $import->extracted_result['candidates']);
    }

    public function test_update_candidates_returns_422_when_no_import(): void
    {
        $meetingId = $this->createMeeting(212, '2026-03-31');

        $res = $this->putJson("/api/meetings/{$meetingId}/participants/import/candidates", [
            'candidates' => [['name' => 'A', 'raw_line' => '', 'type_hint' => 'regular']],
        ]);

        $res->assertUnprocessable();
    }

    public function test_update_candidates_returns_422_when_parse_status_not_success(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 213,
            'held_on' => '2026-04-01',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/213/pending.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'pending.pdf',
            'status' => 'uploaded',
            'parse_status' => 'pending',
            'parsed_at' => null,
            'extracted_text' => null,
            'extracted_result' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->putJson("/api/meetings/{$meetingId}/participants/import/candidates", [
            'candidates' => [['name' => 'A', 'raw_line' => '', 'type_hint' => 'regular']],
        ]);

        $res->assertUnprocessable();
    }

    public function test_show_meeting_returns_updated_candidates_after_update_candidates(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 214,
            'held_on' => '2026-04-02',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/214/updated.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'updated.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_text' => 'T',
            'extracted_result' => json_encode([
                'candidates' => [['name' => 'Before', 'raw_line' => 'B', 'type_hint' => 'regular']],
                'meta' => ['line_count' => 1, 'parser_version' => 1],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->putJson("/api/meetings/{$meetingId}/participants/import/candidates", [
            'candidates' => [
                ['name' => 'After', 'raw_line' => 'A', 'type_hint' => 'guest'],
            ],
        ])->assertOk();

        $res = $this->getJson("/api/meetings/{$meetingId}");
        $res->assertOk();
        $pi = $res->json('participant_import');
        $this->assertSame(1, $pi['candidate_count']);
        $this->assertSame('After', $pi['candidates'][0]['name']);
        $this->assertSame('guest', $pi['candidates'][0]['type_hint']);
    }

    public function test_apply_success_replaces_participants_and_returns_applied_count(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 220,
            'held_on' => '2026-04-10',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/220/apply.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'apply.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_text' => 'T',
            'extracted_result' => json_encode([
                'candidates' => [
                    ['name' => ' apply one ', 'raw_line' => 'r1', 'type_hint' => 'regular'],
                    ['name' => 'apply two', 'raw_line' => 'r2', 'type_hint' => 'guest'],
                ],
                'meta' => ['line_count' => 2, 'parser_version' => 1],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->postJson("/api/meetings/{$meetingId}/participants/import/apply");
        $res->assertOk();
        $res->assertJson(['message' => 'participants を更新しました']);
        $this->assertSame(2, $res->json('applied_count'));

        $participants = Participant::where('meeting_id', $meetingId)->get();
        $this->assertCount(2, $participants);
        $types = $participants->pluck('type')->values()->all();
        $this->assertContains('regular', $types);
        $this->assertContains('guest', $types);
        $names = $participants->map(fn ($p) => $p->member->name)->values()->all();
        $this->assertContains('apply one', $names);
        $this->assertContains('apply two', $names);

        $import = MeetingParticipantImport::where('meeting_id', $meetingId)->first();
        $this->assertNotNull($import->imported_at);
        $this->assertSame(2, $import->applied_count);
    }

    public function test_apply_failure_does_not_update_import_history(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 229,
            'held_on' => '2026-04-19',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/229/fail.pdf';
        Storage::disk('local')->put($path, 'dummy');
        $importId = (int) DB::table('meeting_participant_imports')->insertGetId([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'fail.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_text' => 'x',
            'extracted_result' => json_encode(['candidates' => [], 'meta' => []]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->postJson("/api/meetings/{$meetingId}/participants/import/apply")->assertUnprocessable();

        $import = MeetingParticipantImport::find($importId);
        $this->assertNull($import->imported_at);
        $this->assertNull($import->applied_count);
    }

    public function test_apply_overwrites_import_history_on_reapply(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 230,
            'held_on' => '2026-04-20',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/230/reapply.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'reapply.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_result' => json_encode([
                'candidates' => [
                    ['name' => 'First', 'raw_line' => 'a', 'type_hint' => 'regular'],
                ],
                'meta' => ['line_count' => 1, 'parser_version' => 1],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->postJson("/api/meetings/{$meetingId}/participants/import/apply")->assertOk();
        $import = MeetingParticipantImport::where('meeting_id', $meetingId)->first();
        $firstImportedAt = $import->imported_at;
        $this->assertSame(1, $import->applied_count);

        $import->update([
            'extracted_result' => [
                'candidates' => [
                    ['name' => 'First', 'raw_line' => 'a', 'type_hint' => 'regular'],
                    ['name' => 'Second', 'raw_line' => 'b', 'type_hint' => 'guest'],
                ],
                'meta' => ['line_count' => 2, 'parser_version' => 1],
            ],
        ]);

        $this->postJson("/api/meetings/{$meetingId}/participants/import/apply")->assertOk();
        $import->refresh();
        $this->assertSame(2, $import->applied_count);
        $this->assertTrue($import->imported_at >= $firstImportedAt);
    }

    public function test_show_includes_imported_at_and_applied_count_after_apply(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 231,
            'held_on' => '2026-04-21',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/231/show-history.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'show-history.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_result' => json_encode([
                'candidates' => [['name' => 'One', 'raw_line' => 'o', 'type_hint' => 'regular']],
                'meta' => ['line_count' => 1, 'parser_version' => 1],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->getJson("/api/meetings/{$meetingId}")->assertOk();
        $piBefore = $this->getJson("/api/meetings/{$meetingId}")->json('participant_import');
        $this->assertNull($piBefore['imported_at']);
        $this->assertNull($piBefore['applied_count']);

        $this->postJson("/api/meetings/{$meetingId}/participants/import/apply")->assertOk();

        $res = $this->getJson("/api/meetings/{$meetingId}");
        $res->assertOk();
        $pi = $res->json('participant_import');
        $this->assertNotNull($pi['imported_at']);
        $this->assertSame(1, $pi['applied_count']);
    }

    public function test_apply_replaces_existing_participants(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 221,
            'held_on' => '2026-04-11',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $memberId = (int) DB::table('members')->insertGetId([
            'name' => 'Old Member',
            'name_kana' => null,
            'category_id' => null,
            'type' => 'member',
            'display_no' => '1',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        DB::table('participants')->insert([
            'meeting_id' => $meetingId,
            'member_id' => $memberId,
            'type' => 'regular',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/221/replace.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'replace.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_text' => 'x',
            'extracted_result' => json_encode([
                'candidates' => [['name' => 'New One', 'raw_line' => 'n', 'type_hint' => 'regular']],
                'meta' => ['line_count' => 1, 'parser_version' => 1],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->postJson("/api/meetings/{$meetingId}/participants/import/apply")->assertOk();

        $participants = Participant::where('meeting_id', $meetingId)->get();
        $this->assertCount(1, $participants);
        $this->assertSame('New One', $participants->first()->member->name);
    }

    public function test_apply_returns_422_when_no_import(): void
    {
        $meetingId = $this->createMeeting(222, '2026-04-12');
        $this->postJson("/api/meetings/{$meetingId}/participants/import/apply")->assertUnprocessable();
    }

    public function test_apply_returns_422_when_parse_status_not_success(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 223,
            'held_on' => '2026-04-13',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/223/pending.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'pending.pdf',
            'status' => 'uploaded',
            'parse_status' => 'pending',
            'parsed_at' => null,
            'extracted_text' => null,
            'extracted_result' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->postJson("/api/meetings/{$meetingId}/participants/import/apply")->assertUnprocessable();
    }

    public function test_apply_returns_422_when_candidates_empty(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 224,
            'held_on' => '2026-04-14',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/224/empty.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'empty.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_text' => '',
            'extracted_result' => json_encode([
                'candidates' => [],
                'meta' => ['line_count' => 0, 'parser_version' => 1],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $this->postJson("/api/meetings/{$meetingId}/participants/import/apply")->assertUnprocessable();
    }

    public function test_apply_creates_member_when_not_found_and_maps_type_hint(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 225,
            'held_on' => '2026-04-15',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/225/visitor.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'visitor.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_text' => 'x',
            'extracted_result' => json_encode([
                'candidates' => [
                    ['name' => 'Unknown Visitor', 'raw_line' => 'v', 'type_hint' => 'visitor'],
                ],
                'meta' => ['line_count' => 1, 'parser_version' => 1],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->assertDatabaseMissing('members', ['name' => 'Unknown Visitor']);
        $this->postJson("/api/meetings/{$meetingId}/participants/import/apply")->assertOk();

        $member = Member::where('name', 'Unknown Visitor')->first();
        $this->assertNotNull($member);
        $this->assertSame('visitor', $member->type);
        $p = Participant::where('meeting_id', $meetingId)->first();
        $this->assertSame('visitor', $p->type);
    }

    public function test_update_candidates_stores_manual_match_and_show_returns_it(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 226,
            'held_on' => '2026-04-16',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $memberId = (int) DB::table('members')->insertGetId([
            'name' => 'Existing Member',
            'type' => 'member',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/226/manual.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'manual.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_result' => json_encode([
                'candidates' => [['name' => 'Typo Name', 'raw_line' => 'r', 'type_hint' => 'regular']],
                'meta' => ['line_count' => 1, 'parser_version' => 1],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->putJson("/api/meetings/{$meetingId}/participants/import/candidates", [
            'candidates' => [
                [
                    'name' => 'Typo Name',
                    'raw_line' => 'r',
                    'type_hint' => 'regular',
                    'matched_member_id' => $memberId,
                    'matched_member_name' => 'Existing Member',
                    'match_source' => 'manual',
                ],
            ],
        ])->assertOk();

        $res = $this->getJson("/api/meetings/{$meetingId}");
        $res->assertOk();
        $pi = $res->json('participant_import');
        $this->assertSame(1, $pi['matched_count']);
        $this->assertSame(0, $pi['new_count']);
        $this->assertSame('matched', $pi['candidates'][0]['match_status']);
        $this->assertSame('manual', $pi['candidates'][0]['match_source']);
        $this->assertSame($memberId, $pi['candidates'][0]['matched_member_id']);
        $this->assertSame('Existing Member', $pi['candidates'][0]['matched_member_name']);
    }

    public function test_apply_uses_matched_member_id_when_set(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 227,
            'held_on' => '2026-04-17',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $memberId = (int) DB::table('members')->insertGetId([
            'name' => 'Chosen Member',
            'type' => 'member',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/227/apply-manual.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'a.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_result' => json_encode([
                'candidates' => [
                    [
                        'name' => 'PDF Name',
                        'raw_line' => 'r',
                        'type_hint' => 'regular',
                        'matched_member_id' => $memberId,
                        'matched_member_name' => 'Chosen Member',
                        'match_source' => 'manual',
                    ],
                ],
                'meta' => ['line_count' => 1, 'parser_version' => 1],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $this->postJson("/api/meetings/{$meetingId}/participants/import/apply")->assertOk();

        $p = Participant::where('meeting_id', $meetingId)->first();
        $this->assertNotNull($p);
        $this->assertSame($memberId, $p->member_id);
        $this->assertSame('Chosen Member', $p->member->name);
    }

    public function test_clear_manual_reverts_to_auto_or_new(): void
    {
        Storage::fake('local');
        $meetingId = (int) DB::table('meetings')->insertGetId([
            'number' => 228,
            'held_on' => '2026-04-18',
            'created_at' => now(),
            'updated_at' => now(),
        ]);
        $path = 'meeting_participant_imports/228/clear.pdf';
        Storage::disk('local')->put($path, 'dummy');
        DB::table('meeting_participant_imports')->insert([
            'meeting_id' => $meetingId,
            'file_path' => $path,
            'original_filename' => 'clear.pdf',
            'status' => 'uploaded',
            'parse_status' => 'success',
            'parsed_at' => now(),
            'extracted_result' => json_encode([
                'candidates' => [
                    ['name' => 'No Match', 'raw_line' => 'r', 'type_hint' => 'regular', 'matched_member_id' => null, 'matched_member_name' => null, 'match_source' => null],
                ],
                'meta' => ['line_count' => 1, 'parser_version' => 1],
            ]),
            'created_at' => now(),
            'updated_at' => now(),
        ]);

        $res = $this->getJson("/api/meetings/{$meetingId}");
        $res->assertOk();
        $pi = $res->json('participant_import');
        $this->assertSame(0, $pi['matched_count']);
        $this->assertSame(1, $pi['new_count']);
        $this->assertSame('new', $pi['candidates'][0]['match_status']);
    }
}
