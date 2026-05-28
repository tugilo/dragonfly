<?php

namespace Database\Seeders;

use App\Models\Category;
use App\Models\Meeting;
use App\Models\Member;
use App\Models\MemberRole;
use App\Models\Participant;
use App\Models\Role;
use Illuminate\Database\Seeder;

/**
 * BNI DragonFly 第199回（2026-03-03）参加者をインポートする Seeder.
 * 元データ: docs/networking/bni/dragonfly/participants/BNI_DragonFly_All_Participants_20260303.md
 */
class BniDragonFly199ParticipantsSeeder extends Seeder
{
    /**
     * 区分 → type のマッピング.
     */
    private const TYPE_MAP = [
        'メンバー' => 'member',
        'ビジター' => 'visitor',
        'ゲスト' => 'guest',
    ];

    /**
     * 統合参加者リスト（元 Markdown の表から抽出）.
     * [区分, No, 氏名, ふりがな, カテゴリー, 役職/備考, 紹介者, アテンド]
     */
    private function participantsData(): array
    {
        return [
            ['メンバー', '1', '平岡 国彦', 'ひらおか くにひこ', '建設・不動産', '-', '-', '-'],
            ['メンバー', '2', '増本 重孝', 'ますもと しげたか', '建設・不動産', 'BODコーディネーター/メンターサポート', '-', '-'],
            ['メンバー', '3', '長谷川 貴志', 'はせがわ たかし', '建設・不動産', 'BCP担当、対面イベントサポート', '-', '-'],
            ['メンバー', '4', '松倉 健治', 'まつくら けんじ', '建設・不動産', 'ビジターホストコーディネーター', '-', '-'],
            ['メンバー', '5', '福上 大輝', 'ふくがみ たいき', '建設・不動産', 'プレジデント', '-', '-'],
            ['メンバー', '6', '太田 一誠', 'おおた いっせい', '建設・不動産', '-', '-', '-'],
            ['メンバー', '7', '高野 和義', 'たかの かずよし', '建設・不動産', '-', '-', '-'],
            ['メンバー', '8', '福士 利明', 'ふくし としあき', '中小企業サポート', 'トレーニングサポート', '-', '-'],
            ['メンバー', '9', '後藤 岳久', 'ごとう たけひさ', '中小企業サポート', '対面イベントサポート', '-', '-'],
            ['メンバー', '10', '倉持 賢一', 'くらもち けんいち', '中小企業サポート', 'WEBマスター', '-', '-'],
            ['メンバー', '11', '岡元 智美', 'おかもと ともみ', '中小企業サポート', '1to1担当・書記兼会計補佐', '-', '-'],
            ['メンバー', '12', '西浦 雅', 'にしうら みやび', '中小企業サポート', 'エデュケーションコーディネーター・OCCサポート', '-', '-'],
            ['メンバー', '13', '芳賀 崇利', 'はが たかとし', '中小企業サポート', 'イベント担当（フォーラム）', '-', '-'],
            ['メンバー', '14', '西岡 優希', 'にしおか ゆうき', '中小企業サポート', '-', '-', '-'],
            ['メンバー', '15', '横山 尚武', 'よこやま なおむ', '中小企業サポート', '-', '-', '-'],
            ['メンバー', '16', 'Rii', 'りー', '中小企業サポート', '-', '-', '-'],
            ['メンバー', '17', '佐藤 拓斗', 'さとう たくと', '中小企業サポート', '-', '-', '-'],
            ['メンバー', '18', '平山 真由美', 'ひらやま まゆみ', 'ライフサポート', 'メンターコーディネイター', '-', '-'],
            ['メンバー', '19', '槇村 翔磨', 'まきむら しょうま', 'ライフサポート', 'ビジターホストサポート', '-', '-'],
            ['メンバー', '20', '舩杉 牧子', 'ふなすぎ まきこ', 'ライフサポート', '書記兼会計', '-', '-'],
            ['メンバー', '21', '渡邊 真大', 'わたなべ まお', 'ライフサポート', 'WEBマスター', '-', '-'],
            ['メンバー', '22', '大竹 絵理香', 'おおたけ えりか', 'ライフサポート', 'ビジターホストサポート', '-', '-'],
            ['メンバー', '23', '山口 薫', 'やまぐち かおる', 'ライフサポート', '-', '-', '-'],
            ['メンバー', '24', '海沼 功', 'かいぬま いさお', '金融・保険・資金サポート', 'ビジターホストサポート', '-', '-'],
            ['メンバー', '25', '紀川 和弘', 'きかわ かずひろ', '金融・保険・資金サポート', 'メンバーシップ委員', '-', '-'],
            ['メンバー', '26', '竹内 駿太', 'たけうち しゅんた', '金融・保険・資金サポート', 'イベント担当サポート', '-', '-'],
            ['メンバー', '27', '梅澤 朗広', 'うめざわ あきひろ', '士業・コンサル', 'グローバルビジネスサポート', '-', '-'],
            ['メンバー', '28', '加藤 隆太', 'かとう りゅうた', '士業・コンサル', 'ビジターホストサポート', '-', '-'],
            ['メンバー', '29', '越賀 淑恵', 'こしが としえ', '士業・コンサル', 'メンバーシップ委員', '-', '-'],
            ['メンバー', '30', '山本 三那子', 'やまもと みなこ', '士業・コンサル', 'ビジターホストサポート、BODサポート', '-', '-'],
            ['メンバー', '31', '望月 雅幸', 'もちづき まさゆき', '士業・コンサル', '-', '-', '-'],
            ['メンバー', '32', '佐久間 康丞', 'さくま こうすけ', '士業・コンサル', 'BOD担当', '-', '-'],
            ['メンバー', '33', '斎藤 和貴', 'さいとう かずき', 'ＩＴ', 'WEBマスターサポート・OCCサポート', '-', '-'],
            ['メンバー', '34', '小中 貴晃', 'こなか たかあき', 'ＩＴ', 'バイスプレジデント', '-', '-'],
            ['メンバー', '35', '山本 洸太', 'やまもと こうた', 'ＩＴ', '-', '-', '-'],
            ['メンバー', '36', '吉田 俊之', 'よしだ としゆき', '食品・製造', 'ビジターホストサポート', '-', '-'],
            ['メンバー', '37', '里見 允二', 'さとみ まさつぐ', '食品・製造', '1to1サポート', '-', '-'],
            ['メンバー', '38', '畠山 憲之', 'はたけやま のりゆき', '食品・製造', 'BCP担当', '-', '-'],
            ['メンバー', '39', '今西 俊明', 'いまにし としあき', '食品・製造', 'メンバーシップ委員', '-', '-'],
            ['メンバー', '40', '廣田 誠悟', 'ひろた せいご', '食品・製造', 'メンバーシップ委員', '-', '-'],
            ['メンバー', '41', '田渕 恭平', 'たぶち きょうへい', '食品・製造', '-', '-', '-'],
            ['メンバー', '42', '木村 健悟', 'きむら けんご', 'ファッション・デザイン', 'メンターサポート/対面イベントサポート', '-', '-'],
            ['メンバー', '43', '立岡 海人', 'たつおか かいと', 'ファッション・デザイン', 'グローバルビジネスサポート', '-', '-'],
            ['メンバー', '44', '中村 啓吾', 'なかむら けいご', 'ファッション・デザイン', 'ビジターホストサポート・書記兼会計補佐', '-', '-'],
            ['メンバー', '45', '岩永 伸也', 'いわなが しんや', 'ファッション・デザイン', 'トレーニング担当', '-', '-'],
            ['メンバー', '46', '藤井 恵理子', 'ふじい えりこ', 'ファッション・デザイン', '対面イベント担当', '-', '-'],
            ['メンバー', '47', '今村 千絵', 'いまむら ちえ', '美容・健康・生活', 'グローバルビジネスサポート', '-', '-'],
            ['メンバー', '48', '清原 佳彩美', 'きよはら かさみ', '美容・健康・生活', 'グローバルビジネスコーディネーター', '-', '-'],
            ['メンバー', '49', '船津 麻理子', 'ふなつ まりこ', '美容・健康・生活', 'ビジターホストサポート、エデュケーションサポート', '-', '-'],
            ['メンバー', '50', '飯田 千帆', 'いいだ ちほ', '美容・健康・生活', 'OCCコーディネーター、WEBマスターサポート、エデュケーションサポート', '-', '-'],
            ['メンバー', '51', '飯田 香', 'いいだ かおり', '美容・健康・生活', '1to1サポート', '-', '-'],
            ['メンバー', '52', '藤田 磨紀', 'ふじた まき', '（リージョン）', 'ディレクターコンサルタント', '-', '-'],
            ['メンバー', '53', '山崎 勇一', 'やまざき ゆういち', '（リージョン）', 'グロースエリアディレクター', '-', '-'],
            ['メンバー', '54', '木下 馨', 'きのした かおる', '（リージョン）', 'エグゼクティブディレクター', '-', '-'],
            ['ビジター', '1', '米田 国生', 'よねだ くにお', '塗装・防水', '-', '増本 重孝', '佐久間 康丞'],
            ['ビジター', '2', '青山 侑樹', 'あおやま ゆうき', 'SNS×地域イベント事業', '-', '太田 一誠', '今西 俊明'],
            ['ビジター', '3', '次廣 淳', 'つぎひろ あつし', 'システムエンジニア', '-', '増本 重孝', '西浦 雅'],
            ['ビジター', '4', '森園 友喜', 'もりぞの ゆうき', 'BPO(事務代行)', '-', '平岡 国彦', '平岡 国彦'],
            ['ビジター', '5', '伊丹 己太郎', 'いたみ こうたろう', 'リゾート会員権販売', '-', '高野 和義', '渡邊 真大'],
            ['ゲスト', '1', 'みかわ てるみ', 'みかわ てるみ', '美容・健康専門マーケティング', '-', '紀川 和弘', '飯田 香'],
            ['ゲスト', '2', '今川 渡祥', 'いまがわ つよし', 'ライブ配信', '-', '平山 真由美', '飯田 千帆'],
            ['ゲスト', '3', '髙畑 健治', 'たかはた けんじ', '鉄コンドクター', '-', '佐藤 拓斗', '山本 三那子'],
            ['ゲスト', '4', '西村 麻弥', 'にしむら まや', 'ビジュアルブランディング撮影', '-', '藤井 恵理子', '山本 洸太'],
        ];
    }

    public function run(): void
    {
        $meeting = Meeting::firstOrCreate(
            ['number' => 199],
            [
                'held_on' => '2026-03-03',
                'name' => '第199回定例会',
            ]
        );

        if ($meeting->participants()->exists()) {
            $this->command?->info('第199回の参加者は既に登録済みです。スキップします。');
            return;
        }

        $nameToMemberId = [];
        $membersToUpdateIntroducerAttendant = [];

        foreach ($this->participantsData() as $row) {
            [$typeKana, $no, $name, $nameKana, $category, $roleNotes, $introducerName, $attendantName] = $row;
            $type = self::TYPE_MAP[$typeKana] ?? 'member';
            $displayNo = $this->displayNo($typeKana, $no);

            $member = Member::create([
                'name' => $name,
                'name_kana' => $nameKana,
                'category_id' => $this->resolveCategoryId($category),
                'type' => $type,
                'display_no' => $displayNo,
                'introducer_member_id' => null,
                'attendant_member_id' => null,
            ]);
            $this->syncCurrentRole($member, $roleNotes);

            $nameToMemberId[$name] = $member->id;

            if ($this->nullIfDash($introducerName) !== null || $this->nullIfDash($attendantName) !== null) {
                $membersToUpdateIntroducerAttendant[] = [
                    'member' => $member,
                    'introducer_name' => trim($introducerName),
                    'attendant_name' => trim($attendantName),
                ];
            }
        }

        foreach ($membersToUpdateIntroducerAttendant as $item) {
            $introducerId = $nameToMemberId[$item['introducer_name']] ?? null;
            $attendantId = $nameToMemberId[$item['attendant_name']] ?? null;
            $item['member']->update([
                'introducer_member_id' => $introducerId,
                'attendant_member_id' => $attendantId,
            ]);
        }

        foreach ($this->participantsData() as $row) {
            [$typeKana, $no, $name, , , , $introducerName, $attendantName] = $row;
            $type = self::TYPE_MAP[$typeKana] ?? 'member';
            $memberId = $nameToMemberId[$name];
            $introducerId = $this->nullIfDash($introducerName) !== null ? ($nameToMemberId[trim($introducerName)] ?? null) : null;
            $attendantId = $this->nullIfDash($attendantName) !== null ? ($nameToMemberId[trim($attendantName)] ?? null) : null;

            Participant::firstOrCreate(
                [
                    'meeting_id' => $meeting->id,
                    'member_id' => $memberId,
                ],
                [
                    'type' => $type,
                    'introducer_member_id' => $introducerId,
                    'attendant_member_id' => $attendantId,
                ]
            );
        }
    }

    private function displayNo(string $typeKana, string $no): string
    {
        return match ($typeKana) {
            'ビジター' => 'V' . $no,
            'ゲスト' => 'G' . $no,
            default => $no,
        };
    }

    private function nullIfDash(?string $value): ?string
    {
        if ($value === null || trim($value) === '' || trim($value) === '-') {
            return null;
        }
        return trim($value);
    }

    private function resolveCategoryId(?string $category): ?int
    {
        $v = $this->nullIfDash($category);
        if ($v === null) {
            return null;
        }
        $cat = Category::firstOrCreate(
            ['group_name' => $v, 'name' => $v],
            ['group_name' => $v, 'name' => $v]
        );

        return $cat->id;
    }

    private function syncCurrentRole(Member $member, ?string $roleNotes): void
    {
        $v = $this->nullIfDash($roleNotes);
        $today = now()->toDateString();
        if ($v === null) {
            return;
        }
        $role = Role::firstOrCreate(
            ['name' => $v],
            ['name' => $v, 'description' => null]
        );
        MemberRole::create([
            'member_id' => $member->id,
            'role_id' => $role->id,
            'term_start' => $today,
            'term_end' => null,
        ]);
    }
}
