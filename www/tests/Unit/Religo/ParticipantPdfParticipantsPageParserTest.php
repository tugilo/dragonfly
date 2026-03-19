<?php

namespace Tests\Unit\Religo;

use App\Services\Religo\ParticipantPdfParticipantsPageParser;
use PHPUnit\Framework\TestCase;

class ParticipantPdfParticipantsPageParserTest extends TestCase
{
    private ParticipantPdfParticipantsPageParser $parser;

    protected function setUp(): void
    {
        parent::setUp();
        $this->parser = new ParticipantPdfParticipantsPageParser();
    }

    public function test_visitor_section_candidates_get_visitor_type_hint(): void
    {
        $text = "ミーティング参加者\nビジター様\n山田 太郎\n佐藤 花子";
        $result = $this->parser->parse($text);
        $this->assertCount(2, $result['candidates']);
        foreach ($result['candidates'] as $c) {
            $this->assertSame('visitor', $c['type_hint']);
            $this->assertSame('visitor', $c['source_section']);
            $this->assertSame('participants', $c['page_type']);
        }
        $this->assertSame('山田 太郎', $result['candidates'][0]['name']);
        $this->assertSame('佐藤 花子', $result['candidates'][1]['name']);
    }

    public function test_proxy_section_candidates_get_proxy_type_hint(): void
    {
        $text = "代理出席者様\n高橋 三郎";
        $result = $this->parser->parse($text);
        $this->assertCount(1, $result['candidates']);
        $c = $result['candidates'][0];
        $this->assertSame('高橋 三郎', $c['name']);
        $this->assertSame('proxy', $c['type_hint']);
        $this->assertSame('proxy', $c['source_section']);
        $this->assertSame('participants', $c['page_type']);
    }

    public function test_guest_section_candidates_get_guest_type_hint(): void
    {
        $text = "ゲスト様\n田中 ゲスト";
        $result = $this->parser->parse($text);
        $this->assertCount(1, $result['candidates']);
        $c = $result['candidates'][0];
        $this->assertSame('guest', $c['type_hint']);
        $this->assertSame('guest', $c['source_section']);
    }

    public function test_section_marker_line_is_not_candidate(): void
    {
        $text = "ビジター様\n山田 太郎";
        $result = $this->parser->parse($text);
        $names = array_column($result['candidates'], 'name');
        $this->assertNotContains('ビジター様', $names);
        $this->assertContains('山田 太郎', $names);
    }

    public function test_multiple_sections_switch_type_hint(): void
    {
        $text = "ビジター様\nA さん\n代理出席者様\nB さん\nゲスト様\nC さん";
        $result = $this->parser->parse($text);
        $this->assertCount(3, $result['candidates']);
        $this->assertSame('visitor', $result['candidates'][0]['type_hint']);
        $this->assertSame('proxy', $result['candidates'][1]['type_hint']);
        $this->assertSame('guest', $result['candidates'][2]['type_hint']);
    }
}
