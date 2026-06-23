<?php

namespace Tests\Unit\Religo;

use App\Services\Religo\OneToOneNotesMarkdownParser;
use PHPUnit\Framework\TestCase;

class OneToOneNotesMarkdownParserTest extends TestCase
{
    private OneToOneNotesMarkdownParser $parser;

    protected function setUp(): void
    {
        parent::setUp();
        $this->parser = new OneToOneNotesMarkdownParser();
    }

    public function test_parse_sessions_splits_by_heading(): void
    {
        $body = <<<'MD'
## ■ 基本プロフィール

Profile here.

### 【第1回】2026-05-08

`one_to_ones.id` = **10**
First.

### 【第2回】2026-05-29

`one_to_ones.id` = **11**
Second.
MD;

        $sessions = $this->parser->parseSessions($body);
        $this->assertCount(2, $sessions);
        $this->assertSame(1, $sessions[0]['session_number']);
        $this->assertSame(10, $sessions[0]['one_to_one_id']);
        $this->assertStringContainsString('First.', $sessions[0]['content']);
        $this->assertSame(2, $sessions[1]['session_number']);
        $this->assertSame(11, $sessions[1]['one_to_one_id']);
    }

    public function test_extract_source_path_with_session_anchor(): void
    {
        $text = "【ソース: docs/meetings/1to1/1to1_test.md#第2回】\n\nBody";
        $this->assertSame('docs/meetings/1to1/1to1_test.md', $this->parser->extractSourcePath($text));
    }
}
