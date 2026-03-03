<?php

namespace Database\Seeders;

use App\Models\Meeting;
use App\Models\Member;
use App\Models\Participant;
use Illuminate\Database\Seeder;

/**
 * 第199回（2026-03-03）のメンバー・ビジター・ゲストを meetings / members / participants に投入する Seeder.
 *
 * データソース: docs/networking/bni/dragonfly/participants/BNI_DragonFly_All_Participants_20260303.md
 * breakout_rooms / participant_breakout / breakout_memos は投入しない。
 *
 * 実行手順:
 *   php artisan db:seed --class=DragonFlyMeeting199Seeder
 *
 * 実行後の期待件数:
 *   - meetings: 1件（number=199）
 *   - members: 54 + 5 + 4 = 63件
 *   - participants: 63件（meeting_id = 第199回）
 */
class DragonFlyMeeting199Seeder extends Seeder
{
    /** メンバー54名 [display_no, name, name_kana, category, role_notes] */
    private function membersData(): array
    {
        return [
            ['1', '平岡 国彦', 'ひらおか くにひこ', '建設・不動産', '-'],
            ['2', '増本 重孝', 'ますもと しげたか', '建設・不動産', 'BODコーディネーター/メンターサポート'],
            ['3', '長谷川 貴志', 'はせがわ たかし', '建設・不動産', 'BCP担当、対面イベントサポート'],
            ['4', '松倉 健治', 'まつくら けんじ', '建設・不動産', 'ビジターホストコーディネーター'],
            ['5', '福上 大輝', 'ふくがみ たいき', '建設・不動産', 'プレジデント'],
            ['6', '太田 一誠', 'おおた いっせい', '建設・不動産', '-'],
            ['7', '高野 和義', 'たかの かずよし', '建設・不動産', '-'],
            ['8', '福士 利明', 'ふくし としあき', '中小企業サポート', 'トレーニングサポート'],
            ['9', '後藤 岳久', 'ごとう たけひさ', '中小企業サポート', '対面イベントサポート'],
            ['10', '倉持 賢一', 'くらもち けんいち', '中小企業サポート', 'WEBマスター'],
            ['11', '岡元 智美', 'おかもと ともみ', '中小企業サポート', '1to1担当・書記兼会計補佐'],
            ['12', '西浦 雅', 'にしうら みやび', '中小企業サポート', 'エデュケーションコーディネーター・OCCサポート'],
            ['13', '芳賀 崇利', 'はが たかとし', '中小企業サポート', 'イベント担当（フォーラム）'],
            ['14', '西岡 優希', 'にしおか ゆうき', '中小企業サポート', '-'],
            ['15', '横山 尚武', 'よこやま なおむ', '中小企業サポート', '-'],
            ['16', 'Rii', 'りー', '中小企業サポート', '-'],
            ['17', '佐藤 拓斗', 'さとう たくと', '中小企業サポート', '-'],
            ['18', '平山 真由美', 'ひらやま まゆみ', 'ライフサポート', 'メンターコーディネイター'],
            ['19', '槇村 翔磨', 'まきむら しょうま', 'ライフサポート', 'ビジターホストサポート'],
            ['20', '舩杉 牧子', 'ふなすぎ まきこ', 'ライフサポート', '書記兼会計'],
            ['21', '渡邊 真大', 'わたなべ まお', 'ライフサポート', 'WEBマスター'],
            ['22', '大竹 絵理香', 'おおたけ えりか', 'ライフサポート', 'ビジターホストサポート'],
            ['23', '山口 薫', 'やまぐち かおる', 'ライフサポート', '-'],
            ['24', '海沼 功', 'かいぬま いさお', '金融・保険・資金サポート', 'ビジターホストサポート'],
            ['25', '紀川 和弘', 'きかわ かずひろ', '金融・保険・資金サポート', 'メンバーシップ委員'],
            ['26', '竹内 駿太', 'たけうち しゅんた', '金融・保険・資金サポート', 'イベント担当サポート'],
            ['27', '梅澤 朗広', 'うめざわ あきひろ', '士業・コンサル', 'グローバルビジネスサポート'],
            ['28', '加藤 隆太', 'かとう りゅうた', '士業・コンサル', 'ビジターホストサポート'],
            ['29', '越賀 淑恵', 'こしが としえ', '士業・コンサル', 'メンバーシップ委員'],
            ['30', '山本 三那子', 'やまもと みなこ', '士業・コンサル', 'ビジターホストサポート、BODサポート'],
            ['31', '望月 雅幸', 'もちづき まさゆき', '士業・コンサル', '-'],
            ['32', '佐久間 康丞', 'さくま こうすけ', '士業・コンサル', 'BOD担当'],
            ['33', '斎藤 和貴', 'さいとう かずき', 'ＩＴ', 'WEBマスターサポート・OCCサポート'],
            ['34', '小中 貴晃', 'こなか たかあき', 'ＩＴ', 'バイスプレジデント'],
            ['35', '山本 洸太', 'やまもと こうた', 'ＩＴ', '-'],
            ['36', '吉田 俊之', 'よしだ としゆき', '食品・製造', 'ビジターホストサポート'],
            ['37', '里見 允二', 'さとみ まさつぐ', '食品・製造', '1to1サポート'],
            ['38', '畠山 憲之', 'はたけやま のりゆき', '食品・製造', 'BCP担当'],
            ['39', '今西 俊明', 'いまにし としあき', '食品・製造', 'メンバーシップ委員'],
            ['40', '廣田 誠悟', 'ひろた せいご', '食品・製造', 'メンバーシップ委員'],
            ['41', '田渕 恭平', 'たぶち きょうへい', '食品・製造', '-'],
            ['42', '木村 健悟', 'きむら けんご', 'ファッション・デザイン', 'メンターサポート/対面イベントサポート'],
            ['43', '立岡 海人', 'たつおか かいと', 'ファッション・デザイン', 'グローバルビジネスサポート'],
            ['44', '中村 啓吾', 'なかむら けいご', 'ファッション・デザイン', 'ビジターホストサポート・書記兼会計補佐'],
            ['45', '岩永 伸也', 'いわなが しんや', 'ファッション・デザイン', 'トレーニング担当'],
            ['46', '藤井 恵理子', 'ふじい えりこ', 'ファッション・デザイン', '対面イベント担当'],
            ['47', '今村 千絵', 'いまむら ちえ', '美容・健康・生活', 'グローバルビジネスサポート'],
            ['48', '清原 佳彩美', 'きよはら かさみ', '美容・健康・生活', 'グローバルビジネスコーディネーター'],
            ['49', '船津 麻理子', 'ふなつ まりこ', '美容・健康・生活', 'ビジターホストサポート、エデュケーションサポート'],
            ['50', '飯田 千帆', 'いいだ ちほ', '美容・健康・生活', 'OCCコーディネーター、WEBマスターサポート、エデュケーションサポート'],
            ['51', '飯田 香', 'いいだ かおり', '美容・健康・生活', '1to1サポート'],
            ['52', '藤田 磨紀', 'ふじた まき', '（リージョン）', 'ディレクターコンサルタント'],
            ['53', '山崎 勇一', 'やまざき ゆういち', '（リージョン）', 'グロースエリアディレクター'],
            ['54', '木下 馨', 'きのした かおる', '（リージョン）', 'エグゼクティブディレクター'],
        ];
    }

    /** ビジター5名 [display_no, name, name_kana, category, introducer_name, attendant_name] */
    private function visitorsData(): array
    {
        return [
            ['V1', '米田 国生', 'よねだ くにお', '塗装・防水', '増本 重孝', '佐久間 康丞'],
            ['V2', '青山 侑樹', 'あおやま ゆうき', 'SNS×地域イベント事業', '太田 一誠', '今西 俊明'],
            ['V3', '次廣 淳', 'つぎひろ あつし', 'システムエンジニア', '増本 重孝', '西浦 雅'],
            ['V4', '森園 友喜', 'もりぞの ゆうき', 'BPO(事務代行)', '平岡 国彦', '平岡 国彦'],
            ['V5', '伊丹 己太郎', 'いたみ こうたろう', 'リゾート会員権販売', '高野 和義', '渡邊 真大'],
        ];
    }

    /** ゲスト4名 [display_no, name, name_kana, category, introducer_name, attendant_name] */
    private function guestsData(): array
    {
        return [
            ['G1', 'みかわ てるみ', 'みかわ てるみ', '美容・健康専門マーケティング', '紀川 和弘', '飯田 香'],
            ['G2', '今川 渡祥', 'いまがわ つよし', 'ライブ配信', '平山 真由美', '飯田 千帆'],
            ['G3', '髙畑 健治', 'たかはた けんじ', '鉄コンドクター', '佐藤 拓斗', '山本 三那子'],
            ['G4', '西村 麻弥', 'にしむら まや', 'ビジュアルブランディング撮影', '藤井 恵理子', '山本 洸太'],
        ];
    }

    public function run(): void
    {
        $meeting = Meeting::updateOrCreate(
            ['number' => 199],
            [
                'held_on' => '2026-03-03',
                'name' => '第199回定例会',
            ]
        );

        $memberIdByKey = [];

        foreach ($this->membersData() as $row) {
            [$displayNo, $name, $nameKana, $category, $roleNotes] = $row;
            $member = Member::updateOrCreate(
                $this->memberUniqueKey($displayNo, 'member', $name),
                [
                    'name' => $name,
                    'name_kana' => $nameKana,
                    'category' => $this->nullDash($category),
                    'role_notes' => $this->nullDash($roleNotes),
                    'type' => 'member',
                    'display_no' => $displayNo,
                    'introducer_member_id' => null,
                    'attendant_member_id' => null,
                ]
            );
            $memberIdByKey['member:' . $displayNo] = $member->id;
            $memberIdByKey['name:' . $name] = $member->id;
        }

        foreach ($this->visitorsData() as $row) {
            [$displayNo, $name, $nameKana, $category, $introducerName, $attendantName] = $row;
            $introducerId = $memberIdByKey['name:' . $introducerName] ?? null;
            $attendantId = $memberIdByKey['name:' . $attendantName] ?? null;
            $member = Member::updateOrCreate(
                $this->memberUniqueKey($displayNo, 'visitor', $name),
                [
                    'name' => $name,
                    'name_kana' => $nameKana,
                    'category' => $this->nullDash($category),
                    'role_notes' => null,
                    'type' => 'visitor',
                    'display_no' => $displayNo,
                    'introducer_member_id' => $introducerId,
                    'attendant_member_id' => $attendantId,
                ]
            );
            $memberIdByKey['visitor:' . $displayNo] = $member->id;
        }

        foreach ($this->guestsData() as $row) {
            [$displayNo, $name, $nameKana, $category, $introducerName, $attendantName] = $row;
            $introducerId = $memberIdByKey['name:' . $introducerName] ?? null;
            $attendantId = $memberIdByKey['name:' . $attendantName] ?? null;
            $member = Member::updateOrCreate(
                $this->memberUniqueKey($displayNo, 'guest', $name),
                [
                    'name' => $name,
                    'name_kana' => $nameKana,
                    'category' => $this->nullDash($category),
                    'role_notes' => null,
                    'type' => 'guest',
                    'display_no' => $displayNo,
                    'introducer_member_id' => $introducerId,
                    'attendant_member_id' => $attendantId,
                ]
            );
            $memberIdByKey['guest:' . $displayNo] = $member->id;
        }

        $allParticipantRows = array_merge(
            array_map(fn ($row) => ['member', $row[0], $row[1], null, null], $this->membersData()),
            array_map(fn ($row) => ['visitor', $row[0], $row[1], $row[4], $row[5]], $this->visitorsData()),
            array_map(fn ($row) => ['guest', $row[0], $row[1], $row[4], $row[5]], $this->guestsData())
        );

        foreach ($allParticipantRows as [$type, $displayNo, $name, $introducerName, $attendantName]) {
            $key = $type === 'member' ? 'member:' . $displayNo : $type . ':' . $displayNo;
            $memberId = $memberIdByKey[$key] ?? $memberIdByKey['name:' . $name] ?? null;
            if ($memberId === null) {
                continue;
            }
            $introducerId = $introducerName !== null ? ($memberIdByKey['name:' . $introducerName] ?? null) : null;
            $attendantId = $attendantName !== null ? ($memberIdByKey['name:' . $attendantName] ?? null) : null;

            Participant::updateOrCreate(
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

    /** 一意判定: display_no を優先（今回データはすべて display_no あり）。無い場合は (type + name) で代替する想定。 */
    private function memberUniqueKey(string $displayNo, string $type, string $name): array
    {
        if ($displayNo !== '') {
            return ['type' => $type, 'display_no' => $displayNo];
        }
        return ['type' => $type, 'name' => $name];
    }

    private function nullDash(?string $value): ?string
    {
        if ($value === null || trim((string) $value) === '' || trim((string) $value) === '-') {
            return null;
        }
        return trim($value);
    }
}
