# 接触ロジック整合（CONTACT）— SSOT

**目的:** `last_contact_at`・Dashboard の未接触表示・1to1 リード（completed ベース）について、**実装の正**と**利用者の感覚のギャップ**を明文化し、改善を **表示（A）→ 軽微仕様（B）→ モデル（C）** の三段階で追えるようにする。  
**関連:** [CONTACT_AND_LEAD_DATE_LOGIC_REVIEW.md](CONTACT_AND_LEAD_DATE_LOGIC_REVIEW.md)、[DASHBOARD_DATA_SSOT.md](DASHBOARD_DATA_SSOT.md)、[DATA_MODEL.md](DATA_MODEL.md) §4.12.1、`MemberSummaryQuery::batchLastContactAt`、`DashboardService::getTasks`、`MemberOneToOneLeadService`。

---

## 1. 現状仕様の明文化

### 1.1 `last_contact_at` の構成要素

`App\Queries\Religo\MemberSummaryQuery::batchLastContactAt` により、**次の候補日時の最大値**が各 target ごとの `last_contact_at` となる。

| ソース | 条件 |
|--------|------|
| **BO 同席** | `participant_breakout` により owner と target が **同一 breakout_room** で紐づいている場合、その例会の **`meetings.held_on`（開催日 00:00 として比較）** が候補になる。**一度でも同じ BO ルームになれば接触としてよい**（複数回あるときはそのうち最新開催日が効く）。同じ例会に「出席」していても **別ルーム** で DB に同席が無ければ候補に入らない。**Connections で BO を保存するとき**、`owner_member_id` を付けて送信し、かつ当該メンバーが **どの BO にも含まれない**場合はサーバが **BO1 に自動追加**する（Phase124・後方互換のためフィールド省略時は従来どおりペイロードのみ）。 |
| **接触メモ** | `contact_memos`・owner→target・`created_at` |
| **1 to 1** | `one_to_ones`・`status != canceled`・`started_at` / `scheduled_at` / `created_at` のうち存在するもの（**登録のみでも `created_at` が候補**） |

**いずれも成立しない場合:** `last_contact_at` は **null**。

### 1.2 Dashboard Tasks「○日間未接触」と **999**

`DashboardService::getTasks` の `stale_follow` 行で、`last_contact_at` が **null** のとき、表示用日数に **999** を代入し、`meta` を **`999日間未接触 — …`** 形式で組み立てている。

- **999 は「実際に 999 日空いている」ではない。**
- **「接触起点日時がシステム上まったく無い」** ことのプレースホルダに近い。

### 1.3 `one_to_one_status`（実施ベース・completed のみ）

`MemberOneToOneLeadService::indexForOwner` / `GET /api/dragonfly/members/one-to-one-status`。

| 値 | 意味 |
|----|------|
| **none** | 当該 owner→target に **`status = completed` の 1 to 1 が 0 件** |
| **needs_action** | completed が 1 件以上かつ、最終 completed が要対応閾値より前 |
| **ok** | 最終 completed が閾値以内 |

**`planned` / `canceled` は「実施」に含めない。**  
UI の「実施済記録なし」系文言は **「completed レコードが無い」** を指す。

### 1.4 Dashboard「未接触」分母（peer 集合）

`DashboardService::stalePeerMemberIds` は **owner と同一 `members.workspace_id`** かつ **`type` が guest / visitor 以外**のメンバー（自分除外）。**Members のリード一覧**（`MemberOneToOneLeadService`）と同じ type 除外であり、クロスチャプター用の最小 `visitor` 行は分母に含めない。

---

## 2. ユーザーとのギャップ（最低限）

| ギャップ | 利用者の感覚 | システム上の正 |
|----------|----------------|----------------|
| 例会参加 | 例会に出たので「接触した」に近い | **同一 BO ルームで同席が DB にあるなら接触に含まれる。** 同じ例会でも別ルームのみ・または breakout 未登録なら含まれないことがある。 |
| KPI の「／◯人」 | チャプターが約50名なのに70超など | **分母は同一 `workspace_id` の在籍のみ（guest・visitor 除外）**。`visitor` は他チャプター1to1用の最小行で混ざりやすい。 |
| 1to1 記録 | 予定を入れた＝実施したに近い | リードの「実施」は **completed のみ**。 |
| 999 表示 | 異常に長い未接触 | **日数不明（記録なし）** の内部表現に近い |

---

## 3. 改善方針（三段階）

### A: 表示改善（仕様・DB・API スキーマは変えない）

- **999 を画面に出さない:** `meta` の先頭を **「接触記録なし」** 等に読み替え（UI 層）。
- **補助文言:** Dashboard / Members に「**同一 BO ルームで同席すれば接触に含まれる**」「別ルームのみの出席や breakout 未登録では含まれないことがある」「1to1 は完了（completed）のみ実施扱い」等の **短い説明**。
- 1to1 補助文: **「実施済記録なし」→「1to1完了記録なし」** 等、**completed の意味が伝わる表現**へ。
- 一覧の最終接触が **null** のときは **「—」** ではなく **「接触記録なし」** 等に寄せる（UI のみ）。

**本 SSOT の結論（今回の範囲）:**  
- **`last_contact_at` の計算式は変更しない。**  
- **999 の数値は API 内部のまま残し、画面では解釈表示を変える（A）。**

### B: 軽微仕様改善（次 Phase 候補）

- planned の扱い・文言・導線の整理（DATA_MODEL と整合）。
- Dashboard / Members の表示ロジックの微調整（仕様レビュー後）。

### C: モデル変更（将来）

- participant 連携・「初参加日」など、**別設計・別 Phase**。

---

## 4. 参照実装一覧

| 領域 | 主なクラス / ファイル |
|------|-------------------------|
| last_contact | `MemberSummaryQuery::batchLastContactAt` |
| Dashboard stale / 999 | `DashboardService::getTasks` |
| 1to1 リード | `MemberOneToOneLeadService`、`religoOneToOneLeadLabels.js` |
| メンバー表示共通化 | `www/resources/js/admin/utils/memberDisplay.js` |

---

## 5. 改訂履歴

| 日付 | 内容 |
|------|------|
| 2026-03-24 | 初版（CONTACT_LOGIC_ALIGNMENT_ANALYSIS Phase） |
