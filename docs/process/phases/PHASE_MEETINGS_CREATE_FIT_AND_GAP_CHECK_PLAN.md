# PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK — PLAN

**Phase ID:** MEETINGS_CREATE_FIT_AND_GAP_CHECK  
**種別:** docs（調査・整理のみ、**実装なし**）  
**Related SSOT:** SPEC は未採番。参照: `FIT_AND_GAP_MEETINGS.md`、`FIT_AND_GAP_MOCK_VS_UI.md`、`DATA_MODEL.md` §4.6、`MEETINGS_CREATE_FIT_AND_GAP.md`（本調査の成果物）  
**作成日:** 2026-03-19

---

## 背景

Meetings は一覧・詳細 Drawer・メモ・CSV/PDF 取込・participants / members / roles 同期まで実装が進んでいるが、**`meetings` 行そのものを管理画面で新規登録する導線**が見当たらない。データは Seeder、CLI（`ImportParticipantsCsvCommand` の `firstOrCreate`）、手動 DB 投入に依存している可能性がある。要件・SSOT・モック・過去 Phase が「作成不要」と言っているのか「未検討」なのかを切り分ける必要がある。

## 目的

- Meetings に**新規作成・編集・削除**が本来必要かを、要件・仕様・既存実装から確認する。
- 必要な場合、**現状の Gap**（API/UI/バリデーション/採番ルール等）を列挙する。
- 既存 Meetings 機能全体の中で、**作成・編集・削除のあるべき姿**を業務フロー観点で整理する。

## 調査対象

- **SSOT / Fit&Gap:** `docs/SSOT/FIT_AND_GAP_MEETINGS.md`、`FIT_AND_GAP_MOCK_VS_UI.md` §5、`MOCK_UI_VERIFICATION.md` §4.3、`DATA_MODEL.md` §4.6
- **モック:** `www/public/mock/religo-admin-mock-v2.html` — `#/meetings`
- **Phase 文書:** `PHASE_MEETINGS_LIST_ENHANCEMENT_*`、`ROW_ACTIONS_*`、`DETAIL_DRAWER_*`、`MEMO_MODAL_*`、`TOOLBAR_FILTERS_*`、`STATS_CARDS_*`、`FIT_AND_GAP_FINAL_UPDATE_*`、必要に応じて CSV/PDF 系 Phase
- **実装:** `MeetingController`、`Meeting` モデル、`routes/api.php`、`MeetingsList.jsx`、react-admin `Resource` 定義、`create_meetings_table` マイグレーション、Seeder / `ImportParticipantsCsvCommand`

## 整理観点

1. 要件: モック・SSOT・過去 Phase に例会 CRUD の記述があるか、スコープ外か未検討か。
2. 実装: REST の POST/PUT/DELETE、UI の Create 導線、代替投入経路（Seeder/CLI）。
3. Fit / Gap、業務フロー、案 A/B/C 比較、推奨方針、次アクション。

## 成果物

| 成果物 | パス |
|--------|------|
| SSOT 調査まとめ | `docs/SSOT/MEETINGS_CREATE_FIT_AND_GAP.md` |
| PLAN | 本ファイル |
| WORKLOG | `PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_WORKLOG.md` |
| REPORT | `PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_REPORT.md` |
| レジストリ・INDEX・進捗 | `PHASE_REGISTRY.md`、`INDEX.md`、`dragonfly_progress.md` を更新 |

## DoD（完了の定義）

- [x] 上記成果物が作成され、Fit/Gap・案 A/B/C・推奨方針・次ステップが記載されている。
- [x] **アプリケーションコード・マイグレーション・テストの変更は行っていない**（調査のみ）。
- [x] `PHASE_REGISTRY.md` に本 Phase を記録し、`INDEX.md` から辿れる。
