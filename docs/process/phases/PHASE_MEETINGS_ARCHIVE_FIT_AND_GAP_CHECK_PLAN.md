# PHASE_MEETINGS_ARCHIVE_FIT_AND_GAP_CHECK — PLAN

**Phase ID:** MEETINGS_ARCHIVE_FIT_AND_GAP_CHECK  
**種別:** docs（**実装・マイグレーション・API・UI 変更なし**）  
**Related SSOT:** `DATA_MODEL.md` §4.6、`MEETINGS_DELETE_FIT_AND_GAP.md`、`MEETINGS_CREATE_FIT_AND_GAP.md`、`FIT_AND_GAP_MEETINGS.md`、`FIT_AND_GAP_MOCK_VS_UI.md`  
**作成日:** 2026-03-19

---

## 背景

Meetings について一覧・統計・詳細・POST・PATCH・管理 UI（新規・編集）および participants / breakout / memo / 参加者 PDF / CSV import・apply ログ等の子機能が実装済み。  
**DELETE** については `MEETINGS_DELETE_FIT_AND_GAP_CHECK` で **無条件物理削除の危険性**（cascade / nullOnDelete 混在・連鎖喪失）が整理され、**履歴保持の観点では Archive / 非表示 / 論理無効化の方が適する可能性**が示された。  
本 Phase では **Archive を実装せず**、Religo において **Archive が何を解決するか**、**Delete との関係**、**一覧・stats・Drawer・子データへの影響**、**設計案 A〜F** を比較し、**実装前の合意事項**を SSOT 化する。

## 調査目的

- Meetings に **Archive（非表示・論理無効化・履歴保持）** が必要か、**Delete の代替としてどこまで有効か**を整理する。  
- モック・SSOT・既存実装に **Archive / hidden / inactive** の概念があるか確認する。  
- **子データ**（participants / breakout / memo / PDF / CSV / resolutions / apply_logs / contact_memos 等）について、Archive 時に **残す・一覧に出す・Drawer で参照・stats に含める** を論点化する。  
- **設計案 A〜F** を比較し、**推奨方針**と **実装前に決めること**を明記する。  
- **コードは一切変更しない**。

## 調査対象

### SSOT / Phase 文書

- `docs/SSOT/DATA_MODEL.md` §4.6 meetings と関連節
- `docs/SSOT/FIT_AND_GAP_MEETINGS.md`
- `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md`
- `docs/SSOT/MEETINGS_CREATE_FIT_AND_GAP.md`
- `docs/SSOT/MEETINGS_DELETE_FIT_AND_GAP.md`
- `docs/process/phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_*`
- `docs/process/phases/PHASE_MEETINGS_CREATE_IMPLEMENT_*`
- `docs/process/phases/PHASE_MEETINGS_UPDATE_IMPLEMENT_*`
- `docs/process/phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_*`

### 実装（読取のみ）

- `www/app/Http/Controllers/Religo/MeetingController.php`（index / stats / show）
- `www/routes/api.php`（meetings 系）
- `www/resources/js/admin/pages/MeetingsList.jsx`
- `www/app/Models/Meeting.php`
- `meetings` および **`meeting_id` を参照する migrations / relations**（Delete Phase の整理と整合）
- `ImportParticipantsCsvCommand` 等の meeting 依存（`number` / `firstOrCreate`）

### モック

- `www/public/mock/religo-admin-mock-v2.html` — `#/meetings` の一覧・統計・Actions に Archive 余地があるか（`archive` / `hidden` / `inactive` の語・導線）

## Archive を検討する理由

- **一覧から「見えなくしたい」** ニーズと **DB からの物理削除** は分離できる。Delete 調査で **子データ連鎖喪失**が問題化したため、**履歴・監査・会の地図**を壊さず運用画面を薄くする手段として Archive が候補になる。  
- **誤登録**対応も「一覧から外す」で足りるケースでは Archive が有効。**完全な抹消**が法務・テスト等で必要なら **条件付き Delete** は別論点（排他ではない）。  
- **「現役の例会」と「履歴として保持する例会」** の分離は、stats の `next_meeting` 等の **意味**に直結し、**明示ルールが無いと不具合に見える**（例: アーカイブ済み未来日が「次回」に出る）。

## 確認する関連テーブル・関連機能

- participants / breakout_rooms / breakout_rounds / breakout_memos / participant_breakout  
- contact_memos（meeting_id）  
- meeting_participant_imports、meeting_csv_imports、meeting_csv_import_resolutions、meeting_csv_apply_logs  
- one_to_ones 等 meeting 参照（nullable 含む）

## 整理観点

- Archive は **何のためか**（誤登録・過去回の整理・現役/履歴分離）  
- 子データごとの **残す / 一覧 / Drawer / stats**  
- 一覧・検索・統計・Drawer への **クエリ・UX 影響**  
- 設計案 **A〜F**（boolean / archived_at / +archived_by / softDeletes / 別テーブル / Archive なしで Delete のみ）  
- **number** の再利用・欠番・アーカイブ行の占有  
- UI 導線（行 Actions / Drawer / フィルタ「アーカイブ表示」）・**復元の要否**  
- **未確定・要合意**の明示

## 成果物一覧

| 成果物 | パス |
|--------|------|
| SSOT 調査まとめ | `docs/SSOT/MEETINGS_ARCHIVE_FIT_AND_GAP.md` |
| PLAN | 本ファイル |
| WORKLOG | `PHASE_MEETINGS_ARCHIVE_FIT_AND_GAP_CHECK_WORKLOG.md` |
| REPORT | `PHASE_MEETINGS_ARCHIVE_FIT_AND_GAP_CHECK_REPORT.md` |
| レジストリ・INDEX・進捗 | `PHASE_REGISTRY.md`、`INDEX.md`、`dragonfly_progress.md` |

## DoD

- [x] `MEETINGS_ARCHIVE_FIT_AND_GAP.md` が §1〜10（調査目的・確認資料・Delete 代替理由・現状・子データ影響・一覧/統計/Drawer・案 A〜F・推奨・実装前決定・次 Phase）を含む  
- [x] PLAN / WORKLOG / REPORT が揃っている  
- [x] Archive の **必要性・適用範囲**、子データ・一覧/統計への影響が列挙されている  
- [x] 案 **A〜F** が比較され、**推奨方針**と **実装はまだやらない理由**が明記されている  
- [x] INDEX / PHASE_REGISTRY / dragonfly_progress を更新した  
- [x] **本 Phase で `www/` を編集していない**ことが WORKLOG / REPORT に明記されている  
