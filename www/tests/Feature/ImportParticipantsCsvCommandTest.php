<?php

namespace Tests\Feature;

use App\Models\Category;
use App\Models\Meeting;
use App\Models\Member;
use App\Models\OneToOne;
use App\Models\Participant;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\File;
use Tests\TestCase;

/**
 * dragonfly:import-participants-csv コマンドの Feature テスト.
 * PLAN: PHASE_MEMBERS_CSV_IMPORT_200_PLAN.md
 */
class ImportParticipantsCsvCommandTest extends TestCase
{
    use RefreshDatabase;

    private string $csvPath;

    protected function setUp(): void
    {
        parent::setUp();
        $this->csvPath = database_path('csv/dragonfly_59people.csv');
    }

    public function test_csv_file_is_readable_and_has_required_headers(): void
    {
        $this->assertFileExists($this->csvPath);
        $content = file_get_contents($this->csvPath);
        $this->assertStringContainsString('種別', $content);
        $this->assertStringContainsString('名前', $content);
    }

    public function test_meeting_is_created_when_not_exists(): void
    {
        $this->assertDatabaseMissing('meetings', ['number' => 200]);
        $exitCode = Artisan::call('dragonfly:import-participants-csv', [
            'meeting_number' => '200',
            'csv_path' => $this->csvPath,
            '--held_on' => '2026-03-10',
        ]);
        $this->assertEquals(0, $exitCode);
        $meeting = Meeting::where('number', 200)->first();
        $this->assertNotNull($meeting);
        $this->assertSame('2026-03-10', $meeting->held_on->format('Y-m-d'));
    }

    public function test_imports_59_rows_and_participants_types(): void
    {
        Artisan::call('dragonfly:import-participants-csv', [
            'meeting_number' => '200',
            'csv_path' => $this->csvPath,
            '--held_on' => '2026-03-10',
        ]);
        $meeting = Meeting::where('number', 200)->first();
        $this->assertNotNull($meeting);
        $participants = Participant::where('meeting_id', $meeting->id)->get();
        $this->assertCount(59, $participants);
        $types = $participants->pluck('type')->countBy();
        $this->assertSame(54, $types->get('regular', 0), '54 メンバー → regular');
        $this->assertSame(3, $types->get('visitor', 0), '3 ビジター');
        $this->assertSame(1, $types->get('proxy', 0), '1 代理出席 → proxy');
        $this->assertSame(1, $types->get('guest', 0), '1 ゲスト');
    }

    public function test_proxy_participant_is_registered(): void
    {
        Artisan::call('dragonfly:import-participants-csv', [
            'meeting_number' => '200',
            'csv_path' => $this->csvPath,
            '--held_on' => '2026-03-10',
        ]);
        $proxy = Participant::where('type', 'proxy')->whereHas('meeting', fn ($q) => $q->where('number', 200))->first();
        $this->assertNotNull($proxy);
        $member = $proxy->member;
        $this->assertSame('山本 昌広', $member->name);
        $this->assertSame('guest', $member->type);
        $this->assertSame('P1', $member->display_no);
    }

    public function test_categories_resolved_by_group_name_and_name(): void
    {
        Artisan::call('dragonfly:import-participants-csv', [
            'meeting_number' => '200',
            'csv_path' => $this->csvPath,
            '--held_on' => '2026-03-10',
        ]);
        $cat = Category::where('group_name', '建設・不動産')->where('name', '大型物件対応解体工事')->first();
        $this->assertNotNull($cat);
        $member = Member::where('name', '平岡 国彦')->first();
        $this->assertNotNull($member);
        $this->assertSame($cat->id, $member->category_id);
    }

    public function test_orient_column_is_not_stored(): void
    {
        Artisan::call('dragonfly:import-participants-csv', [
            'meeting_number' => '200',
            'csv_path' => $this->csvPath,
            '--held_on' => '2026-03-10',
        ]);
        $this->assertCount(59, Participant::whereHas('meeting', fn ($q) => $q->where('number', 200))->get());
        $tables = ['members', 'participants', 'categories', 'roles', 'member_roles'];
        foreach ($tables as $table) {
            $columns = \Schema::getColumnListing($table);
            $this->assertNotContains('orient', $columns);
            $this->assertNotContains('オリエン', $columns);
        }
    }

    public function test_attendant_multi_name_resolves_first_match(): void
    {
        $path = $this->createCsvWithMultiAttendant();
        $exitCode = Artisan::call('dragonfly:import-participants-csv', [
            'meeting_number' => '990',
            'csv_path' => $path,
            '--held_on' => '2026-01-01',
        ]);
        $this->assertSame(0, $exitCode);
        $first = Member::where('name', '甲　一郎')->where('type', 'member')->first();
        $second = Member::where('name', '乙　二郎')->where('type', 'member')->first();
        $visitor = Member::where('name', 'Vテスト')->where('type', 'visitor')->first();
        $this->assertNotNull($first);
        $this->assertNotNull($second);
        $this->assertNotNull($visitor);
        $this->assertNull($visitor->introducer_member_id);
        $this->assertSame($first->id, $visitor->attendant_member_id);
        $p = Participant::where('member_id', $visitor->id)->first();
        $this->assertNotNull($p);
        $this->assertSame($first->id, $p->attendant_member_id);
    }

    public function test_unresolved_introducer_produces_warning(): void
    {
        $minimalCsv = $this->createMinimalCsvWithUnknownIntroducer();
        $exitCode = Artisan::call('dragonfly:import-participants-csv', [
            'meeting_number' => '201',
            'csv_path' => $minimalCsv,
            '--held_on' => '2026-03-15',
        ]);
        $this->assertEquals(0, $exitCode);
        $output = Artisan::output();
        $this->assertStringContainsString('Warnings', $output);
        $this->assertStringContainsString('紹介者', $output);
    }

    public function test_rerun_is_idempotent_no_duplicate_participants(): void
    {
        Artisan::call('dragonfly:import-participants-csv', [
            'meeting_number' => '200',
            'csv_path' => $this->csvPath,
            '--held_on' => '2026-03-10',
        ]);
        $meeting = Meeting::where('number', 200)->first();
        $count1 = Participant::where('meeting_id', $meeting->id)->count();
        Artisan::call('dragonfly:import-participants-csv', [
            'meeting_number' => '200',
            'csv_path' => $this->csvPath,
            '--held_on' => '2026-03-10',
        ]);
        $count2 = Participant::where('meeting_id', $meeting->id)->count();
        $this->assertSame($count1, $count2);
        $this->assertSame(59, $count2);
    }

    public function test_invalid_meeting_number_fails(): void
    {
        $exitCode = Artisan::call('dragonfly:import-participants-csv', [
            'meeting_number' => '0',
            'csv_path' => $this->csvPath,
        ]);
        $this->assertSame(1, $exitCode);
    }

    public function test_missing_csv_file_fails(): void
    {
        $exitCode = Artisan::call('dragonfly:import-participants-csv', [
            'meeting_number' => '200',
            'csv_path' => 'nonexistent.csv',
        ]);
        $this->assertSame(1, $exitCode);
    }

    /**
     * 席番（CSV の No）だけ入替しても、member.id と one_to_ones.target の人物がずれないこと。
     * （display_no のみを updateOrCreate キーにしていたときの退行防止）
     */
    public function test_seat_number_shuffle_preserves_member_id_for_one_to_one_fk(): void
    {
        $dir = storage_path('app/test_csv');
        if (! File::isDirectory($dir)) {
            File::makeDirectory($dir, 0755, true);
        }
        $path1 = $dir.'/seat_swap_round1.csv';
        $path2 = $dir.'/seat_swap_round2.csv';
        $header = "種別,No,名前,よみがな,大カテゴリー,カテゴリー,役職,紹介者,アテンド,オリエン\n";
        File::put($path1, $header
            ."メンバー,1,佐藤　拓斗,さとう,,,,,,\n"
            ."メンバー,2,原田　里織,はらだ,,,,,,\n");
        File::put($path2, $header
            ."メンバー,1,原田　里織,はらだ,,,,,,\n"
            ."メンバー,2,佐藤　拓斗,さとう,,,,,,\n");

        Artisan::call('dragonfly:import-participants-csv', [
            'meeting_number' => '880',
            'csv_path' => $path1,
            '--held_on' => '2026-04-01',
        ]);
        $sato = Member::where('name', '佐藤　拓斗')->where('type', 'member')->first();
        $harada = Member::where('name', '原田　里織')->where('type', 'member')->first();
        $this->assertNotNull($sato);
        $this->assertNotNull($harada);
        $this->assertSame('1', $sato->display_no);
        $this->assertSame('2', $harada->display_no);

        $owner = Member::create([
            'name' => 'オーナー用',
            'type' => 'member',
            'display_no' => 'O1',
        ]);
        $o2o = OneToOne::create([
            'owner_member_id' => $owner->id,
            'target_member_id' => $sato->id,
            'status' => 'completed',
            'ended_at' => '2026-04-03 08:00:00',
        ]);

        Artisan::call('dragonfly:import-participants-csv', [
            'meeting_number' => '881',
            'csv_path' => $path2,
            '--held_on' => '2026-04-08',
        ]);

        $sato->refresh();
        $harada->refresh();
        $this->assertSame('2', $sato->display_no);
        $this->assertSame('1', $harada->display_no);
        $this->assertSame('佐藤　拓斗', $sato->name);
        $o2o->refresh();
        $this->assertSame($sato->id, $o2o->target_member_id);
        $this->assertSame('佐藤　拓斗', $o2o->targetMember->name);
    }

    private function createMinimalCsvWithUnknownIntroducer(): string
    {
        $dir = storage_path('app/test_csv');
        if (! File::isDirectory($dir)) {
            File::makeDirectory($dir, 0755, true);
        }
        $path = $dir.'/minimal_unknown_introducer.csv';
        $csv = "種別,No,名前,よみがな,大カテゴリー,カテゴリー,役職,紹介者,アテンド,オリエン\n";
        $csv .= "ビジター,,テスト ビジター,てすと,,IT,,存在しない紹介者,存在しないアテンド,\n";
        File::put($path, $csv);

        return $path;
    }

    /** アテンド「甲、乙」で両方メンバーに存在する場合、先頭（甲）が attendant に紐づく */
    private function createCsvWithMultiAttendant(): string
    {
        $dir = storage_path('app/test_csv');
        if (! File::isDirectory($dir)) {
            File::makeDirectory($dir, 0755, true);
        }
        $path = $dir.'/multi_attendant.csv';
        $csv = "種別,No,名前,よみがな,大カテゴリー,カテゴリー,役職,紹介者,アテンド,オリエン\n";
        $csv .= "メンバー,1,甲　一郎,か,,,,,,\n";
        $csv .= "メンバー,2,乙　二郎,おつ,,,,,,\n";
        $csv .= "ビジター,,Vテスト,てすと,,,,,甲　一郎、乙　二郎,\n";
        File::put($path, $csv);

        return $path;
    }
}
