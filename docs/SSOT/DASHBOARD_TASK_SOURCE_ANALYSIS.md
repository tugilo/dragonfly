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
| workspace | **Tasks 生成では `workspace_id` は渡さない**（`MemberSummaryQuery` に `null`）。owner のみで全ピア対象。 |

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

3. **meeting_follow_up（0〜1 件・常に push しうる）**（旧: `meeting_memo_pending`）  
   - **次回例会:** `meetings.held_on >= today` を昇順で先頭。なければ **直近終了**の `meetings` を `orderByDesc('held_on')->first()`。  
   - **メモ有無の DB 判定は行っていない**。文言・kind は **次回/直近例会へのフォロー（Meetings への導線）** に揃えた（DASHBOARD-TASKS-ALIGNMENT-P1）。

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
| `meetings` | まず `held_on >= today` 昇順 1 件、なければ `held_on` 降順 1 件 |

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
  - meeting 行: **次回例会または直近例会**へのフォロー（**メモ未整理の有無は未判定**）。

### owner / workspace 整合

- **owner:** 全タスク **owner_member_id 軸**で一致（SSOT の Dashboard owner と整合）。  
- **workspace:** **Tasks では workspace を使っていない**（`getSummaryLiteBatch(..., null)`）。SSOT の「Dashboard 3 API はクエリに workspace を付けない」と矛盾はしないが、**summary-lite 側は将来 workspace 絞りを入れる余地**がある（現状 null）。

### SSOT との細部

- **DASHBOARD_DATA_SSOT §3** の kind 順・件数上限はコードと **一致**（`meeting_follow_up` に改名済み）。  
- **2 件目 stale の「メモ追加」:** **P1 で SSOT を実装に寄せ、`disabled: false`・Member Show deep link を正**とした。  
- **meeting_follow_up:** **kind・タイトル・SSOT** を「次回/直近例会のフォロー」に統一（メモ未整理の自動判定は未実装のまま）。

### 問題点（調査メモ）

1. ~~**「今日」ヘッダと中身の温度差**~~ → **P1 で見出しを「優先アクション」に変更し SSOT で定義**。  
2. **所属チャプター workspace と Tasks のデータ境界**は **P1 で「Tasks は workspace 未使用（owner 軸）」と固定**（将来の拡張は別フェーズ）。  
3. **例会行とメモ未整理の連動**は **未実装**（文言はフォロー誘導に整合。memo 突合は別案・別 Phase）。

---

## 9. 改善提案

### 案A（最小）— **P1 で実施済みの一部**

- **disabled:** SSOT を **有効 deep link** に寄せて統一。  
- **DASHBOARD_DATA_SSOT** に Dashboard 役割・Tasks 意味を追記。kind **`meeting_follow_up`** へ改名。

### 案B（現実的）

- **meeting_follow_up 行:** `contact_memos`（`memo_type = meeting`, `meeting_id` 等）と突合し、**未記載のときだけ**タスク表示するなど、文言にさらに寄せる（別 Phase）。  
- **getSummaryLiteBatch** に **解決済み workspace_id**（`ReligoActorContext` と同式）を渡し、**チャプター単位**の stale と揃える（SSOT の 1 user = 1 workspace と整合）。

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
