<?php

namespace Tests\Unit\Religo;

use App\Models\Meeting;
use App\Models\MeetingCsvImport;
use App\Models\MeetingCsvImportResolution;
use App\Models\Member;
use App\Services\Religo\MeetingCsvMemberResolver;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

/**
 * M8.5: MeetingCsvMemberResolver の解決順（resolution → 名前一致）。
 */
class MeetingCsvMemberResolverTest extends TestCase
{
    use RefreshDatabase;

    public function test_resolution_wins_over_earlier_same_name_row(): void
    {
        $meeting = Meeting::create(['number' => 900, 'held_on' => '2026-10-01', 'name' => '第900回']);
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => 'x.csv',
            'file_name' => 'x.csv',
            'uploaded_at' => now(),
        ]);
        $m1 = Member::create(['name' => '山田太郎', 'type' => 'member', 'display_no' => null]);
        $m2 = Member::create(['name' => '山田太郎', 'type' => 'member', 'display_no' => null]);
        $this->assertLessThan($m2->id, $m1->id);

        MeetingCsvImportResolution::create([
            'meeting_csv_import_id' => $import->id,
            'resolution_type' => MeetingCsvImportResolution::TYPE_MEMBER,
            'source_value' => '山田太郎',
            'resolved_id' => $m2->id,
            'resolved_label' => $m2->name,
            'action_type' => MeetingCsvImportResolution::ACTION_MAPPED,
        ]);

        $resolver = new MeetingCsvMemberResolver();
        $got = $resolver->resolveExistingForCsvName($import->id, '山田太郎');
        $this->assertNotNull($got);
        $this->assertSame($m2->id, $got->id);
    }

    public function test_name_match_when_no_resolution(): void
    {
        $meeting = Meeting::create(['number' => 901, 'held_on' => '2026-10-02', 'name' => '第901回']);
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => 'y.csv',
            'file_name' => 'y.csv',
            'uploaded_at' => now(),
        ]);
        $m1 = Member::create(['name' => '鈴木', 'type' => 'member', 'display_no' => null]);

        $resolver = new MeetingCsvMemberResolver();
        $got = $resolver->resolveExistingForCsvName($import->id, '鈴木');
        $this->assertNotNull($got);
        $this->assertSame($m1->id, $got->id);
    }

    public function test_resolve_existing_with_meta_duplicate_warning_without_resolution(): void
    {
        $meeting = Meeting::create(['number' => 902, 'held_on' => '2026-10-03', 'name' => '第902回']);
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => 'z.csv',
            'file_name' => 'z.csv',
            'uploaded_at' => now(),
        ]);
        Member::create(['name' => '同名', 'type' => 'member', 'display_no' => null]);
        Member::create(['name' => '同名', 'type' => 'member', 'display_no' => null]);

        $resolver = new MeetingCsvMemberResolver();
        $meta = $resolver->resolveExistingWithMeta($import->id, '同名');
        $this->assertNotNull($meta['member']);
        $this->assertSame('name', $meta['resolved_via']);
        $this->assertTrue($meta['duplicate_name_warning']);
        $this->assertSame(2, $meta['exact_name_match_count']);
        $this->assertCount(2, $meta['duplicate_candidates']);
    }

    public function test_resolve_existing_with_meta_no_duplicate_when_resolution_maps(): void
    {
        $meeting = Meeting::create(['number' => 903, 'held_on' => '2026-10-04', 'name' => '第903回']);
        $import = MeetingCsvImport::create([
            'meeting_id' => $meeting->id,
            'file_path' => 'w.csv',
            'file_name' => 'w.csv',
            'uploaded_at' => now(),
        ]);
        $m1 = Member::create(['name' => '同名', 'type' => 'member', 'display_no' => null]);
        $m2 = Member::create(['name' => '同名', 'type' => 'member', 'display_no' => null]);
        MeetingCsvImportResolution::create([
            'meeting_csv_import_id' => $import->id,
            'resolution_type' => MeetingCsvImportResolution::TYPE_MEMBER,
            'source_value' => '同名',
            'resolved_id' => $m2->id,
            'resolved_label' => $m2->name,
            'action_type' => MeetingCsvImportResolution::ACTION_MAPPED,
        ]);

        $resolver = new MeetingCsvMemberResolver();
        $meta = $resolver->resolveExistingWithMeta($import->id, '同名');
        $this->assertSame($m2->id, $meta['member']->id);
        $this->assertSame('resolution', $meta['resolved_via']);
        $this->assertFalse($meta['duplicate_name_warning']);
        $this->assertSame(2, $meta['exact_name_match_count']);
    }
}
