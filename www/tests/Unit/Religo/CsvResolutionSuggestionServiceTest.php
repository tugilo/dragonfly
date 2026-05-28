<?php

namespace Tests\Unit\Religo;

use App\Models\Category;
use App\Models\Member;
use App\Models\Role;
use App\Services\Religo\CsvResolutionSuggestionService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

/**
 * M8: CsvResolutionSuggestionService の正規化・スコア・並び順。
 */
class CsvResolutionSuggestionServiceTest extends TestCase
{
    use RefreshDatabase;

    private CsvResolutionSuggestionService $svc;

    protected function setUp(): void
    {
        parent::setUp();
        $this->svc = new CsvResolutionSuggestionService();
    }

    public function test_normalize_equates_category_label_with_middle_dot_variation(): void
    {
        $a = $this->svc->normalizeForCompare('IT・通信 / ソフト');
        $b = $this->svc->normalizeForCompare('IT通信 / ソフト');
        $this->assertSame($a, $b);
        $this->assertNotSame('', $a);
    }

    public function test_suggest_members_matches_when_only_spacing_differs(): void
    {
        Member::create([
            'name' => '山田 太郎',
            'name_kana' => null,
            'type' => 'member',
            'display_no' => null,
        ]);
        $s = $this->svc->suggestMembers('山田　太郎', null);
        $this->assertNotEmpty($s);
        $this->assertSame('山田 太郎', $s[0]['label']);
        $this->assertSame(90, $s[0]['score']);
        $this->assertSame(CsvResolutionSuggestionService::REASON_NORMALIZED_MATCH, $s[0]['match_reason']);
    }

    public function test_suggest_members_kana_match_when_display_name_differs(): void
    {
        Member::create([
            'name' => '山田 太郎',
            'name_kana' => 'やまだ たろう',
            'type' => 'member',
            'display_no' => null,
        ]);
        $s = $this->svc->suggestMembers('別表記 表示', 'やまだ　たろう');
        $this->assertNotEmpty($s);
        $this->assertSame('山田 太郎', $s[0]['label']);
        $this->assertGreaterThanOrEqual(70, $s[0]['score']);
        $this->assertSame(CsvResolutionSuggestionService::REASON_KANA_MATCH, $s[0]['match_reason']);
    }

    public function test_suggest_categories_matches_it_telecom_label_with_dot_variation(): void
    {
        Category::create(['group_name' => 'IT・通信', 'name' => '開発']);
        $s = $this->svc->suggestCategories('IT通信 / 開発');
        $this->assertNotEmpty($s);
        $this->assertStringContainsString('IT', $s[0]['label']);
        $this->assertSame(90, $s[0]['score']);
        $this->assertSame(CsvResolutionSuggestionService::REASON_NORMALIZED_MATCH, $s[0]['match_reason']);
    }

    public function test_suggest_roles_matches_when_fullwidth_space_in_csv(): void
    {
        Role::create(['name' => '副会長', 'description' => null]);
        $s = $this->svc->suggestRoles('副　会長');
        $this->assertNotEmpty($s);
        $this->assertSame('副会長', $s[0]['label']);
        $this->assertGreaterThanOrEqual(90, $s[0]['score']);
    }

    public function test_suggestions_sorted_by_score_desc_then_id(): void
    {
        Member::create(['name' => 'Test User', 'name_kana' => null, 'type' => 'member', 'display_no' => null]);
        Member::create(['name' => 'Test User Extra Long', 'name_kana' => null, 'type' => 'member', 'display_no' => null]);
        $s = $this->svc->suggestMembers('Test User', null);
        $this->assertCount(2, $s);
        $this->assertSame(100, $s[0]['score']);
        $this->assertSame('Test User', $s[0]['label']);
        $this->assertGreaterThan($s[1]['score'], $s[0]['score']);
    }

    public function test_suggest_returns_empty_for_blank_source(): void
    {
        $this->assertSame([], $this->svc->suggestMembers('   ', null));
        $this->assertSame([], $this->svc->suggestCategories(''));
        $this->assertSame([], $this->svc->suggestRoles("\t"));
    }
}
