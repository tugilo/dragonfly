# Phase Meetings List Enhancement — PLAN

**Phase:** M1（Meetings 一覧改善）  
**作成日:** 2026-03-17  
**SSOT:** [FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md)、[FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §5

---

## 1. Phase Type

implement

---

## 2. Background

- Meetings 画面は現状「一覧のみ」で、モック（religo-admin-mock-v2.html#/meetings）にあるサブ説明・統計・BO数/メモ列・行アクション・右パネル等が未実装（FIT_AND_GAP_MEETINGS 参照）。
- 一覧 API は `id` / `number` / `held_on` のみ返却しており、「名前」列は API 未返却のため空。モックにも名前列は存在しない。
- 本 Phase は「一覧に必要な最小情報の拡張」と「一覧 UI の整理」に限定する。

---

## 3. Purpose

- Meetings 一覧 API を拡張し、一覧に必要な **breakout_count**（BO数）と **has_memo**（メモ有無）を返すようにする。
- 一覧 UI に **BO数列**・**メモ列**を追加し、**名前列を削除**する。
- ページタイトル下に **サブ説明**「例会管理 / BO割当 / メモ」を追加する。

---

## 4. Related SSOT

- docs/SSOT/FIT_AND_GAP_MEETINGS.md（Meetings モック vs 実装）
- docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md §5
- docs/SSOT/DATA_MODEL.md（meetings, breakout_rooms, contact_memos memo_type=meeting）

---

## 5. Scope

- **変更可能:**  
  - www/app/Http/Controllers/Religo/MeetingController.php  
  - www/resources/js/admin/pages/MeetingsList.jsx  
  - docs/process/phases/PHASE_MEETINGS_LIST_ENHANCEMENT_*.md  
  - 必要に応じて www/tests（Meetings API のテスト追加・更新）
- **変更しない:** Meeting モデル・breakouts/breakout-rounds API・他リソース・既存の dataProvider の resource 判定ロジック（返却キー追加は許容）

---

## 6. 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| www/app/Http/Controllers/Religo/MeetingController.php | 一覧で withCount('breakoutRooms') と has_memo 用の subSelect を追加し、breakout_count / has_memo を返却 |
| www/resources/js/admin/pages/MeetingsList.jsx | サブ説明追加、名前列削除、BO数列・メモ列追加 |
| www/tests/Feature/Religo/MeetingControllerTest.php | 新規または既存テストに breakout_count / has_memo の検証を追加（既存がなければ新規作成） |

---

## 7. 実装方針

### 7.1 API（MeetingController@index）

- `Meeting::query()->withCount('breakoutRooms')` で BO 数を取得。返却キーは **breakout_count**（Laravel の breakout_rooms_count を map で breakout_count に変換）。
- **has_memo:** `contact_memos` において `meeting_id = meetings.id` かつ `memo_type = 'meeting'` の存在有無。  
  - 実装: `addSelect(DB::raw("exists(select 1 from contact_memos where contact_memos.meeting_id = meetings.id and contact_memos.memo_type = 'meeting') as has_memo"))` の要領で subSelect を追加し、取得した値を bool に正規化して返す。
- 返却 JSON の各要素: `id`, `number`, `held_on`, `breakout_count`, `has_memo`。

### 7.2 フロント（MeetingsList.jsx）

- **タイトル:** `<List title="Meetings" />` のまま。React Admin の List でサブ説明を出すには `title` を要素にすることが多いため、`title={<><Typography variant="h5">Meetings</Typography><Typography variant="body2" color="textSecondary">例会管理 / BO割当 / メモ</Typography></>}` のようにする（または List のサブタイトル用の props があればそれを使用）。
- **Datagrid 列:** 回(number) → 開催日(held_on) → **BO数(breakout_count)** → **メモ(has_memo)**。名前(name)列は削除。
- **BO数表示:** 数値のみまたはチップ風。モックは「chip chip-p」で数値表示。
- **メモ列:** has_memo が true なら「あり」、false なら「なし」。Chip またはテキストで表現。

---

## 8. テスト観点

- GET /api/meetings のレスポンスに `breakout_count` と `has_memo` が含まれること。
- 既存の id / number / held_on が変わらないこと。
- breakout_rooms が 0 件の meeting は breakout_count = 0 であること。
- contact_memos に memo_type='meeting' 且つ当該 meeting_id が 1 件以上ある場合は has_memo = true となること（API 側で boolean で返す想定）。
- フロント: 一覧に BO数・メモ列が表示され、名前列が無いこと。サブ説明が表示されること。

---

## 9. DoD

- [x] GET /api/meetings が breakout_count と has_memo を返すこと。
- [x] MeetingsList にサブ説明「例会管理 / BO割当 / メモ」が表示されること。
- [x] 一覧に BO数列・メモ列が表示され、名前列が削除されていること。
- [x] 既存の php artisan test が通ること（MeetingControllerTest で 3 件追加）。
- [x] PLAN / WORKLOG / REPORT が揃っていること。

---

## 10. 参照

- モック: http://localhost/mock/religo-admin-mock-v2.html#/meetings  
- 実装: http://localhost/admin#/meetings  
