# Dashboard「今日やること（Tasks）」データ取得元トレース

**Phase:** DASHBOARD-TASK-SOURCE-TRACE（調査のみ）  
**目的:** UI → API → Service → DB をコードベースで固定し、モック/実データと SSOT 整合を説明する。  
**SSOT（定義）:** [DASHBOARD_DATA_SSOT.md](DASHBOARD_DATA_SSOT.md) §3 tasks

---

## 1. 概要

| 項目 | 結論 |
|------|------|
| データ取得元 | **実データ**（DB 参照）。フロントにハードコードされた仮タスクは **ない**。 |
| API | **`GET /api/dashboard/tasks`**（JSON 配列） |
| バックエンド | `DashboardController::tasks` → `DashboardService::getTasks` |
| workspace | **`getSummaryLiteBatch` 第 3 引数は `null`**（`stale_follow`・**KPI の stale_contacts_count** も同様）。owner 以外の **全メンバーを peer**。 |

### 1.1 stale / KPI と workspace（DASHBOARD-STALE-WORKSPACE-SCOPE-P1）

| 項目 | 内容 |
|------|------|
| **決定** | Dashboard の stale（Tasks `stale_follow`・`getStats` の `stale_contacts_count`）は **`getSummaryLiteBatch(..., null)` のまま**。 |
| **`workspaceId` 非 null のとき Query で起きること** | `batchOneToOneCount` / `batchLastMemo` / `batchLastContactAt`（memos・o2o 部分）/ `batchFlags` が **`workspace_id` 厳密一致**。**`workspace_id IS NULL` の行は集計に入らない**。**同席例会日は引き続きフィルタなし**。 |
| **案B を見送り理由（要約）** | `members` に workspace が無く peer をチャプター限定できない／NULL 行除外と DATA_MODEL の単一 WS 扱いがずれる／last_contact の説明が混線。詳細は [DASHBOARD_DATA_SSOT §0](DASHBOARD_DATA_SSOT.md)。 |
| **再検討** | `MemberSummaryQuery` の NULL 許容 OR 化 + peer のチャプター限定が揃った **別 Phase** で `ReligoActorContext::resolveWorkspaceIdForUser` を渡す案をレビュー。 |

---

## 2. フロント構造

### Front: Tasks 描画

| 項目 | 内容 |
|------|------|
| **コンポーネント** | `DashboardTasksPanel`（`www/resources/js/admin/pages/dashboard/DashboardTasksPanel.jsx`） |
| **親** | `Dashboard.jsx` が `tasks` を props で渡す |
| **state 名** | `tasks`（`useState([])`） |
| **データ構造** | API の JSON 配列をそのまま利用。要素は `id`, `kind`, `title`, `meta`, `action`（`label`, `href`, `disabled`）, `badge` 等 |
| **呼び出し関数** | `loadDashboard` 内で `dashboardRequest('tasks')` → 成功時 `setTasks(Array.isArray(t) ? t : [])` |
| **API 失敗時** | `dashboardRequest('tasks').catch(() => null)` のため `t` が `null` → **`setTasks([])`**（空表示。モックにフォールバックしない） |
| **オーナー未設定時** | `loadDashboard` を呼ばず `setTasks([])`（パネルは `ownerConfigured === false` で別メッセージ） |

**キーワード対応:** `tasks` は上記。`todo` / `today` は UI 文言・コメントのみ（別ロジック名なし）。

---

## 3. API 構造

### API

| 項目 | 内容 |
|------|------|
| **エンドポイント** | **`GET /api/dashboard/tasks`** |
| **クエリ** | 任意 `owner_member_id`（未指定時は acting user の `users.owner_member_id`） |
| **定義** | `routes/api.php` — `Route::get('/dashboard/tasks', [DashboardController::class, 'tasks']);` |
| **呼び出し箇所** | `Dashboard.jsx` の `dashboardRequest('tasks')`（`owner_member_id` は現状クエリに付けない） |
| **レスポンス** | **200**: `DashboardService::getTasks` が返す **配列**（オブジェクトのリスト） |
| **422** | owner 解決不能（`ReligoActorContext` + `owner_member_id` どちらも無い） |
| **404** | owner id が `members` に存在しない |

---

## 4. Controller 構造

### Controller

| 項目 | 内容 |
|------|------|
| **クラス** | `App\Http\Controllers\Religo\DashboardController` |
| **メソッド** | `tasks(Request $request)` |
| **owner 解決** | `resolveOwnerMemberId`: クエリ `owner_member_id` 優先 → なければ `ReligoActorContext::actingUser()` の `owner_member_id` |
| **呼び出している Service** | `DashboardService::getTasks($ownerMemberId)` |

---

## 5. Service 構造

### Service

| 項目 | 内容 |
|------|------|
| **クラス** | `App\Services\Religo\DashboardService` |
| **メソッド** | `getTasks(int $ownerMemberId): array` |
| **ロジック概要** | 最大 **3 ブロック**を **この順で**配列に push（§6 参照）。すべて DB クエリベース。 |

**日付・owner 条件（コード準拠）**

1. **stale_follow（最大 2 件）**  
   - `members` から **自分以外**の id 一覧。  
   - `MemberSummaryQuery::getSummaryLiteBatch($ownerMemberId, $memberIds, null)` で各 target の `last_contact_at` を取得。  
   - **未接触:** `last_contact_at === null` または `last_contact_at < now() - 30 days`（`STALE_DAYS = 30`）。  
   - 該当 target を先頭から **最大 2 件**（`array_slice(..., 0, 2)`）。  
   - 1 件目アクション: `1to1予定` → `/one-to-ones/create`、2 件目: `メモ追加` → `/members/{id}/show`（現行コードでは両方 `disabled: false`）。

2. **one_to_one_planned（0〜1 件）**  
   - `one_to_ones`: `owner_member_id` 一致、`status = planned`、`scheduled_at` が **今日以降の日付**または **null**。  
   - `orderBy('scheduled_at')->first()` で 1 件のみ。  
   - `targetMember` を eager load。

3. **meeting_follow_up（0〜1 件・条件付き）**（旧: `meeting_memo_pending`） — **DASHBOARD-TASKS-ALIGNMENT-P2**  
   - **対象例会:** `meetings` で **`whereDate(held_on, '<=', now())`**（暦日・サーバー TZ）に合致する行のうち **`held_on` 降順、`id` 降順で先頭 1 件**（**直近開催済み＝今日含む過去の最終例会**）。該当なし（例会が無い／暦上すべて未来）なら **タスクに含めない**。  
   - **表示条件:** 上記例会 id に対し **`contact_memos` に `meeting_id` 一致・`memo_type = 'meeting'`・本文あり**の行が **存在しない**ときのみ push。  
   - **owner_member_id は突合に使わない**（例会メモは `MeetingMemoController` / 一覧 has_memo と同じ **会議単位**判定）。

---

## 6. DB 構造（参照テーブル）

### stale_follow（MemberSummaryQuery）

`getSummaryLiteBatch` の第 3 引数が **`null`** のため、クエリ内の **workspace 条件は付かない**（`contact_memos` / `one_to_ones` / `dragonfly_contact_flags` の workspace 列はフィルタに使われない）。

| 用途 | 主テーブル | 備考 |
|------|------------|------|
| 同室回数 | `participant_breakout`, `participants`, `breakout_rooms` | owner/target の同室 |
| last_contact_at 候補 | 同上 + `meetings.held_on`（例会日） |  |
| last_contact_at 候補 | `contact_memos` | owner→target、created_at |
| last_contact_at 候補 | `one_to_ones` | started_at / scheduled_at（canceled 除外） |
| フラグ表示用 | `dragonfly_contact_flags` | stale 判定自体は last_contact_at ベース |

**members:** 名前表示用に `Member::whereIn('id', $memberIds)` でロード。

### one_to_one_planned

| テーブル | 条件 |
|----------|------|
| `one_to_ones` | `owner_member_id`, `status = planned`, `scheduled_at >= today` OR `scheduled_at` null |
| `members`（relation） | `targetMember` |

### meeting_follow_up

| テーブル | 条件 |
|----------|------|
| `meetings` | `whereDate(held_on, <= today)`、`orderByDesc(held_on)`、`orderByDesc(id)` で 1 件 |
| `contact_memos` | 記録済み判定: `meeting_id` = 上記・`memo_type = meeting`・`body` が null/空でない行が存在 |

---

## 7. 実装判定

### 判定

| 項目 | 結果 |
|------|------|
| **実装状態** | **実データ**（DB 参照） |
| **モック** | **否**（フロント・バックエンドともハードコードされたタスクリストはない） |
| **未実装（仮表示）** | **否**（API が中核。取得失敗時は空配列） |
| **理由** | `DashboardService::getTasks` が Eloquent / Query Builder で取得し、配列を組み立てている。 |

---

## 8. フィット＆ギャップ

### 現状の意味

- **UI ラベル:** **「優先アクション（Tasks）」**に変更（DASHBOARD-TASKS-ALIGNMENT-P1）。中身は **「今日」限定ではない**。  
  - stale: **30 日超未接触**（今日に限定しない）。  
  - planned 1to1: 今日以降の予定 or 日付未設定。  
  - meeting 行（**P2）:** **直近開催済み例会**に **例会メモが無い**ときのみ（`contact_memos` 突合）。

### owner / workspace 整合

- **owner:** 全タスク **owner_member_id 軸**で一致（SSOT の Dashboard owner と整合）。  
- **workspace:** **Tasks では workspace を使っていない**（`getSummaryLiteBatch(..., null)`）。SSOT の「Dashboard 3 API はクエリに workspace を付けない」と矛盾はしないが、**summary-lite 側は将来 workspace 絞りを入れる余地**がある（現状 null）。

### SSOT との細部

- **DASHBOARD_DATA_SSOT §3** の kind 順・件数上限はコードと **一致**（`meeting_follow_up` に改名済み）。  
- **2 件目 stale の「メモ追加」:** **P1 で SSOT を実装に寄せ、`disabled: false`・Member Show deep link を正**とした。  
- **meeting_follow_up:** **P2** で **contact_memos** 突合済み（未記録時のみ）。`whereDate` で **日付境界の取りこぼし**を防止。

### 問題点（調査メモ）

1. ~~**「今日」ヘッダと中身の温度差**~~ → **P1 で見出しを「優先アクション」に変更し SSOT で定義**。  
2. **所属チャプター workspace と Tasks のデータ境界**は **P1 で「Tasks は workspace 未使用（owner 軸）」と固定**（将来の拡張は別フェーズ）。  
3. ~~**例会行とメモ未整理の連動**~~ → **P2 で実装**（会議単位・`memo_type = meeting`）。

---

## 9. 改善提案

### 案A（最小）— **P1 で実施済みの一部**

- **disabled:** SSOT を **有効 deep link** に寄せて統一。  
- **DASHBOARD_DATA_SSOT** に Dashboard 役割・Tasks 意味を追記。kind **`meeting_follow_up`** へ改名。

### 案B（現実的）— **meeting 突合は P2 で実施済み**

- **getSummaryLiteBatch** に **解決済み workspace_id** を渡す案は **未着手**（別 Phase）。

### 案C（理想）

- **タスクエンジン**を明示的ドメイン（ルールテーブル or 設定）に切り出し、「今日」「今週」など期間と kind を設定可能にする。  
- KPI・Tasks・AI 提案で **同一の「次アクション」モデル**を参照する（別 Phase）。

---

## 10. 参照コード一覧（迅速トレース用）

| 層 | パス |
|----|------|
| UI | `www/resources/js/admin/pages/Dashboard.jsx`, `dashboard/DashboardTasksPanel.jsx` |
| ルート | `www/routes/api.php` |
| Controller | `www/app/Http/Controllers/Religo/DashboardController.php` |
| Service | `www/app/Services/Religo/DashboardService.php`（`getTasks`） |
| Query | `www/app/Queries/Religo/MemberSummaryQuery.php`（`getSummaryLiteBatch`, `batchLastContactAt` 等） |

---

*本ドキュメントはコード参照に基づき、推測で補っていない。*
