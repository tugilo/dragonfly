# PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK — WORKLOG

**種別:** docs（実装なし）  
**日付:** 2026-03-19

---

## 確認したモック / 実装 / ドキュメント

- **モック v2 `#/meetings`（`#pg-meetings`）:** ヘッダ右は「Connectionsで編集」のみ。例会の「＋ 新規」や作成フォームは**なし**。`#/one-to-ones` には「＋ 1to1を追加」があり、対比で例会マスタ作成導線の欠如が明確。
- **`FIT_AND_GAP_MEETINGS.md` / `FIT_AND_GAP_MOCK_VS_UI.md` §5:** M1〜M6 由来の一覧・Drawer・メモ・統計・PDF 列等。**例会エンティティの新規作成・編集・削除は要件として記載なし**。
- **`MOCK_UI_VERIFICATION.md` §4.3:** Meetings の検証項目はタイトル・統計・Drawer・メモ等。**作成ボタンは検証対象に含まれない**。
- **`DATA_MODEL.md` §4.6:** `meetings` の目的・カラム・`number` UNIQUE。**管理画面からのライフサイクル（作成フロー）は未記述**。
- **Phase M1〜M6 / FIT_AND_GAP_FINAL_UPDATE:** スコープは一覧・行アクション・Drawer・メモ・ツールバー・統計・SSOT 反映。**Meeting の store/update/destroy は対象外**（明示的拒否より**未着手**に近い）。
- **`MeetingController`:** `index` / `stats` / `show` のみ。
- **`routes/api.php`:** meetings の GET と、既存 `meeting_id` 前提のサブリソースのみ。**POST/PUT/PATCH/DELETE meetings なし**。
- **react-admin:** `<Resource name="meetings" list={MeetingsList} />` のみ（create/edit なし）。
- **`MeetingsList.jsx`:** 例会行の新規作成 UI なし。「新規」は CSV 未解決・PDF 候補の member 文脈に限定。
- **マイグレーション `create_meetings_table`:** `number` UNIQUE、`held_on` NOT NULL、`name` nullable。
- **投入経路:** `DragonFlyMeeting199Seeder`、`BniDragonFly199ParticipantsSeeder` で `Meeting::updateOrCreate` / 関連処理。`ImportParticipantsCsvCommand::resolveMeeting` で `firstOrCreate(['number' => ...], ['held_on', 'name' => 第N回定例会])`。

## 作成機能が現状あるかないか

- **管理画面・REST としての例会新規作成・編集・削除: ない。**
- **代替:** Seeder、参加者 CSV CLI の `firstOrCreate`、手動 DB。

## 既存運用前提の整理

- 取込・メモ・BO・統計はすべて **`meetings.id` が既にある**前提で一貫している。
- 週次の「次の回」をシステムに載せる責務が、**コード上は開発者/バッチ寄り**に倒れている。

## 比較した案

- **案A:** 一覧から新規作成（number / held_on / name）→ 以降 CSV/PDF。**運用自然性・SaaS 期待に最も合う。** 実装・削除ポリシー設計のコストあり。
- **案B:** 取込時に meeting が無ければ作成。**CLI と思想は近い**が、管理画面 API と二系統になり得る。誤紐づけリスクの設計が要る。
- **案C:** Seeder/CLI/DB のみ。**現状に近い**が本番の週次運用でボトルネックになりやすい。

## 判断理由

- モック・FIT_AND_GAP に作成 UI が無いのは、**当該画面のスコープが「既存例会の運用」に留まっていた**ためと解釈するのが合理的。**「不要」とは結論しにくい**（BNI 定例会は継続的に新しい回が生じる）。
- 既存実装は**読取＋子リソース**に最適化されており、**Gap は意図的な省略というより未実装領域**。

## まとめ

詳細は `docs/SSOT/MEETINGS_CREATE_FIT_AND_GAP.md` に集約。推奨は**中長期では案A を主軸**、実装は**POST＋最小 UI から段階的**、編集・削除は**子データとの整合を決めたうえで別 Phase**。
