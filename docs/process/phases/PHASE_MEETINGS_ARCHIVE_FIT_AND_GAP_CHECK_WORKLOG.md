# PHASE_MEETINGS_ARCHIVE_FIT_AND_GAP_CHECK — WORKLOG

**Phase ID:** MEETINGS_ARCHIVE_FIT_AND_GAP_CHECK  
**種別:** docs

---

## 実際に確認したファイル

### SSOT / Docs

- `docs/SSOT/DATA_MODEL.md` — §4.6 meetings（archive 用カラムの記載なし）  
- `docs/SSOT/MEETINGS_DELETE_FIT_AND_GAP.md` — 物理削除リスク、**案 D（アーカイブ/非表示）** の言及  
- `docs/SSOT/MEETINGS_CREATE_FIT_AND_GAP.md` — 作成・更新後の文脈（削除・アーカイブは別整理）  
- `docs/SSOT/FIT_AND_GAP_MEETINGS.md`、`FIT_AND_GAP_MOCK_VS_UI.md` — 一覧・統計・Drawer 文脈（**Archive 用語なし** を前提に照合）  
- `docs/process/phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_PLAN.md` — 本調査の **直前 Phase** のスコープ確認  

### 実装（読取・要点メモ）

- `www/app/Http/Controllers/Religo/MeetingController.php` — `index`: `Meeting::query()` + `q` / `has_memo` / `has_participant_pdf` のみ。**archive フィルタなし**。`stats`: `Meeting::count()`、`next_meeting` = 今日以降の `held_on` 最小、`BreakoutRoom::count()` は **グローバル**、`meetings_with_memo` は distinct meeting_id。**いずれもアーカイブ除外なし**。  
- `www/public/mock/religo-admin-mock-v2.html` — `archive` 文字列 grep：**製品意味のアーカイブ導線はなし**（スタイルの `hidden` のみ）。  

### 未読だが SSOT 本文・Delete Phase で既にカバーされるもの

- `meetings` migration、`Meeting` モデル、`MeetingsList.jsx` の詳細行数、`routes/api.php` の meetings ルート — **Delete Fit & Gap** およびユーザー提示の「既存実装」前提と整合。本 WORKLOG では **MeetingController / stats 挙動**と **モック**を新規に突合。  
- `ImportParticipantsCsvCommand` — **number で firstOrCreate** である限り、アーカイブ行が残ると **番号は占有**（物理削除との差分として SSOT に記載）。

## Delete 調査結果との関係

- `MEETINGS_DELETE_FIT_AND_GAP.md` が **無条件 DELETE 非推奨**とした理由（子データ・FK）は、Archive では **行削除をしない**前提で **緩和**される。  
- Delete の **案 D** を、本 Phase で **一覧/stats/show/子データの見せ方**まで含めて具体化したドキュメントが `MEETINGS_ARCHIVE_FIT_AND_GAP.md`。

## モック / SSOT / 実装上の archive の扱い

- **モック:** Archive 導線・用語 **なし**。将来追加は **FIT_AND_GAP 更新が必要（要合意）**。  
- **SSOT（DATA_MODEL）:** meetings の状態フラグ **未定義**。  
- **実装:** index/stats は **全件ベース**。Archive 導入時は **一貫した scope** が必要。

## meetings と子データの「残す/隠す/集計に含める」論点

- **DB に残す:** Archive は原則 **行削除なし** → 子 FK は **原則維持**（Delete Phase の cascade 問題を避ける方向）。  
- **一覧:** 既定は **未アーカイブのみ**が自然だが **`include_archived` 等は要合意**。  
- **Drawer:** 一覧に出ないと **開けない**問題 → **「アーカイブを表示」フィルタ**等が **推奨論点**として SSOT に記載。  
- **stats:** `next_meeting` は **アーカイブ除外が必須に近い**。`total_meetings` / `total_breakouts` / `meetings_with_memo` は **定義の要合意**。

## 案 A〜F の比較メモ

- **A** `is_archived`: 単純、監査弱い。  
- **B** `archived_at` nullable: **推奨候補の第一**（時刻あり）。  
- **C** B + `archived_by`: 運用・説明責任向き。  
- **D** softDeletes: **「削除」語と混同**、global scope 波及。**Archive と別概念として要合意**。  
- **E** 別テーブル: **過剰になりやすい**。  
- **F** Archive なし・条件付き Delete のみ: **「一覧から消す」だけは満たしにくい**。

## 採用した推奨方針の理由（調査時点）

- **履歴保持 + 運用 UI の簡素化**が目的なら **B または C** が最小で説明しやすい。  
- **next_meeting** 等の **意味の破綻**を防ぐため、stats・一覧に **明示的除外ルール**が必要。  
- Delete は **Archive と併存し得る**（完全抹消が要る場合のみ別ポリシー）。

## 実装していないことの確認

以下は **本 Phase で一切実施していない**。

- `is_archived` / `archived_at` / `archived_by` の **カラム追加**  
- Laravel **softDeletes** の追加  
- `PATCH /api/meetings/{id}/archive` 等 **API**  
- 一覧 **フィルタ・トグル UI**  
- **stats** の archived 対応コード  
- **migrate / backfill**  
- **policy / restore** 実装  

**本 Phase で新規に編集したのは `docs/` のみ**（`www/` への追加・変更は行っていない）。リポジトリの作業ツリーに他 Phase 由来の `www/` 変更が残っている場合は本 Phase の範囲外。

---

## 補足追記（2026-03-19・SSOT のみ）

`MEETINGS_ARCHIVE_FIT_AND_GAP.md` に **補足前提**を追加した。

- **スキーマ:** 第一候補は **`archived_at` のみ**（初回は `archived_by` なし）。  
- **`show`:** **壊さない**（アーカイブ済みも存在すれば **200**、404 隠蔽なし）。  
- **`stats.next_meeting`:** **`archived_at` IS NULL** のみ対象。  
- **restore:** **初回実装では必須にしない**（片道で可、復元は後続 Phase）。

実装・マイグレーションは行っていない。
