<?php

namespace Tests\Unit\Zoom;

use App\Services\Zoom\ZoomOneToOneDetector;
use PHPUnit\Framework\TestCase;

class ZoomOneToOneDetectorTest extends TestCase
{
    private ZoomOneToOneDetector $detector;

    protected function setUp(): void
    {
        parent::setUp();
        $this->detector = new ZoomOneToOneDetector;
    }

    public function test_two_participants_with_keyword_is_high_confidence(): void
    {
        $result = $this->detector->evaluate('鈴木さん 1to1調整用', 2);
        $this->assertTrue($result['is_candidate']);
        $this->assertSame('high', $result['confidence']);
    }

    public function test_regular_meeting_is_excluded(): void
    {
        $result = $this->detector->evaluate('DragonFly 定例会 第210回', 50);
        $this->assertFalse($result['is_candidate']);
    }

    public function test_team_meeting_is_excluded(): void
    {
        $result = $this->detector->evaluate('スリーバイス チームMTG', 4);
        $this->assertFalse($result['is_candidate']);
    }

    public function test_two_participants_without_keyword_is_medium(): void
    {
        $result = $this->detector->evaluate('打ち合わせ', 2);
        $this->assertTrue($result['is_candidate']);
        $this->assertSame('medium', $result['confidence']);
    }

    public function test_guess_counterpart_name_from_topic(): void
    {
        $this->assertSame('木村秀継', $this->detector->guessCounterpartName('木村秀継さんミーティング'));
        $this->assertSame('田渕', $this->detector->guessCounterpartName('田渕様 1to1'));
        $this->assertNull($this->detector->guessCounterpartName('定例'));
    }
}
