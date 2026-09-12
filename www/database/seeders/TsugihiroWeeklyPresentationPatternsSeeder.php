<?php

namespace Database\Seeders;

use App\Models\Member;
use Illuminate\Database\Seeder;

/**
 * 次廣（members.id=37）のウィークリー稿 A〜E。Living Document §2.5.7 / §2.5.8。
 */
class TsugihiroWeeklyPresentationPatternsSeeder extends Seeder
{
    public const MEMBER_ID = 37;

    public function run(): void
    {
        $member = Member::query()->find(self::MEMBER_ID);
        if ($member === null) {
            return;
        }

        $patterns = self::patterns();
        $member->weekly_presentation_patterns = $patterns;
        $member->weekly_presentation_active_id = 'A';
        $member->weekly_presentation_body = $patterns[0]['body'];
        $member->save();
    }

    /**
     * @return list<array{id: string, label: string, body: string}>
     */
    public static function patterns(): array
    {
        return [
            [
                'id' => 'A',
                'label' => '定番',
                'body' => <<<'TEXT'
AI業務改善システム構築の次廣です。

探す・書き写す・確認する。
私はそれを減らして、時間を取り戻す仕事をしています。

紹介してほしいのは、
忙しいのに社内の作業に追われている会社と、
その会社を顧問先に持つ士業の方です。

AI業務改善システム構築の次廣でした。
TEXT,
            ],
            [
                'id' => 'B',
                'label' => '26年',
                'body' => <<<'TEXT'
AI業務改善システム構築の次廣です。

システムエンジニアとして26年。
探す・書き写す・確認するを減らす仕事をしています。

紹介してほしいのは、
忙しいのに社内の作業に追われている会社と、
その会社を顧問先に持つ士業の方です。

AI業務改善システム構築の次廣でした。
TEXT,
            ],
            [
                'id' => 'C',
                'label' => '属人化',
                'body' => <<<'TEXT'
AI業務改善システム構築の次廣です。

あの人しか分からない仕事を、
誰でも追える形にする仕事をしています。

紹介してほしいのは、
特定の人に業務が集中している会社と、
その会社を顧問先に持つ士業の方です。

AI業務改善システム構築の次廣でした。
TEXT,
            ],
            [
                'id' => 'D',
                'label' => '士業',
                'body' => <<<'TEXT'
AI業務改善システム構築の次廣です。

探す・書き写す・確認するを減らして、
顧問先の時間を取り戻す仕事をしています。

紹介してほしいのは、
忙しい会社を顧問先に持つ、
税理士・社労士・コンサルの方です。

AI業務改善システム構築の次廣でした。
TEXT,
            ],
            [
                'id' => 'E',
                'label' => '多店舗',
                'body' => <<<'TEXT'
AI業務改善システム構築の次廣です。

多店舗の注文と顧客情報を一つにまとめ、
人を増やさずに回る土台を作っています。

紹介してほしいのは、
店舗や現場が増えて、社内作業が追いつかない会社です。

AI業務改善システム構築の次廣でした。
TEXT,
            ],
        ];
    }
}
