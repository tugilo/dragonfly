<?php

namespace Tests\Unit\Religo;

use App\Services\Religo\ParticipantPdfMembersPageParser;
use PHPUnit\Framework\TestCase;

class ParticipantPdfMembersPageParserTest extends TestCase
{
    private ParticipantPdfMembersPageParser $parser;

    protected function setUp(): void
    {
        parent::setUp();
        $this->parser = new ParticipantPdfMembersPageParser();
    }

    public function test_excludes_header_line_with_no_and_name(): void
    {
        $text = "No. 名前 よみがな カテゴリー 役職 備考\n01 山田 太郎 やまだ たろう 建設 会員";
        $result = $this->parser->parse($text);
        $names = array_column($result['candidates'], 'name');
        $this->assertNotContains('No. 名前 よみがな', $names);
        $this->assertContains('山田 太郎 やまだ たろう 建設 会員', array_map(function ($c) {
            return $c['name'];
        }, $result['candidates']));
    }

    public function test_excludes_category_header_line(): void
    {
        $text = "建設・不動産\n山田 太郎\nIT・通信\n佐藤 花子";
        $result = $this->parser->parse($text);
        $names = array_column($result['candidates'], 'name');
        $this->assertNotContains('建設・不動産', $names);
        $this->assertNotContains('IT・通信', $names);
        $this->assertContains('山田 太郎', $names);
        $this->assertContains('佐藤 花子', $names);
    }

    public function test_member_name_row_becomes_regular_candidate_with_page_type_members(): void
    {
        $text = "01 帆苅 有希 ほかり ゆき 建設 会員";
        $result = $this->parser->parse($text);
        $this->assertCount(1, $result['candidates']);
        $c = $result['candidates'][0];
        $this->assertSame('帆苅 有希 ほかり ゆき 建設 会員', $c['name']);
        $this->assertSame('regular', $c['type_hint']);
        $this->assertSame('members', $c['page_type']);
        $this->assertNull($c['source_section']);
    }

    public function test_excludes_line_with_meber_list_header_keyword(): void
    {
        $text = "メンバー表\n01 山田 太郎";
        $result = $this->parser->parse($text);
        $this->assertCount(1, $result['candidates']);
        $this->assertSame('01 山田 太郎', $result['candidates'][0]['raw_line']);
    }

    public function test_strips_leading_number_from_name(): void
    {
        $text = "02 鈴木 一郎";
        $result = $this->parser->parse($text);
        $this->assertCount(1, $result['candidates']);
        $this->assertSame('鈴木 一郎', $result['candidates'][0]['name']);
    }
}
