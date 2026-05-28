<?php

namespace Tests\Unit\Religo;

use App\Services\Religo\ParticipantPdfPageClassifier;
use PHPUnit\Framework\TestCase;

/**
 * M7-P7: 内容ベースのページ判定。
 */
class ParticipantPdfPageClassifierTest extends TestCase
{
    private ParticipantPdfPageClassifier $classifier;

    protected function setUp(): void
    {
        parent::setUp();
        $this->classifier = new ParticipantPdfPageClassifier();
    }

    public function test_classifies_ignore_page_with_bni_intro(): void
    {
        $text = "BNIとは\nBusiness Network International の略で...";
        $this->assertSame(ParticipantPdfPageClassifier::TYPE_IGNORE, $this->classifier->classify($text));
    }

    public function test_classifies_ignore_page_with_time_schedule(): void
    {
        $text = "TIME SCHEDULE\n08:00 受付\n08:30 開始";
        $this->assertSame(ParticipantPdfPageClassifier::TYPE_IGNORE, $this->classifier->classify($text));
    }

    public function test_classifies_ignore_page_with_core_values(): void
    {
        $text = "コアバリュー\nGivers Gain 等";
        $this->assertSame(ParticipantPdfPageClassifier::TYPE_IGNORE, $this->classifier->classify($text));
    }

    public function test_classifies_members_page_with_member_list(): void
    {
        $text = "メンバー表\nよみがな 氏名 カテゴリー 役職\nあ 山田 太郎 建設 会員";
        $this->assertSame(ParticipantPdfPageClassifier::TYPE_MEMBERS, $this->classifier->classify($text));
    }

    public function test_classifies_members_page_with_yomigana_only(): void
    {
        $text = "よみがな\nあ\nい\nう";
        $this->assertSame(ParticipantPdfPageClassifier::TYPE_MEMBERS, $this->classifier->classify($text));
    }

    public function test_classifies_participants_page_with_meeting_attendees(): void
    {
        $text = "ミーティング参加者\n山田 太郎\n佐藤 花子";
        $this->assertSame(ParticipantPdfPageClassifier::TYPE_PARTICIPANTS, $this->classifier->classify($text));
    }

    public function test_classifies_participants_page_with_visitor_guest(): void
    {
        $text = "ビジター様\n田中 一郎\nゲスト様\n鈴木 次郎\n代理出席者様\n高橋 三郎";
        $this->assertSame(ParticipantPdfPageClassifier::TYPE_PARTICIPANTS, $this->classifier->classify($text));
    }

    public function test_classifies_unknown_content_as_ignore(): void
    {
        $text = "何か別の内容\nタイトルなし";
        $this->assertSame(ParticipantPdfPageClassifier::TYPE_IGNORE, $this->classifier->classify($text));
    }

    public function test_participants_takes_precedence_over_members_when_both_keywords(): void
    {
        $text = "メンバー表 ミーティング参加者\n山田 太郎";
        $this->assertSame(ParticipantPdfPageClassifier::TYPE_PARTICIPANTS, $this->classifier->classify($text));
    }

    public function test_ignore_takes_precedence_when_ignore_and_participants(): void
    {
        $text = "BNIとは ミーティング参加者";
        $this->assertSame(ParticipantPdfPageClassifier::TYPE_IGNORE, $this->classifier->classify($text));
    }
}
