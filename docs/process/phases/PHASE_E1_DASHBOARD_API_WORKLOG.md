# PHASE E-1 Dashboard API — WORKLOG（E-1b 実装）

**Phase:** E-1（Dashboard API 動的化）  
**SSOT:** docs/SSOT/DASHBOARD_REQUIREMENTS.md §5（GET /api/dashboard/stats, tasks, activity）

---

## Step0: 既存パターン棚卸し（重複防止）

### A) 既存 API の例
- **ルーティング:** `www/routes/api.php` — プレフィックスなしで GET/POST/PUT を定義。middleware は Laravel デフォルト（api の stateless）。
- **Controller 配置:** `App\Http\Controllers\Religo\*`（MeetingController, OneToOneController, ContactMemoController）、`App\Http\Controllers\Api\*`（DragonFlyContactSummaryController, WorkspaceController）。
- **FormRequest:** `App\Http\Requests\Religo\IndexContactMemosRequest`（owner_member_id required）、`App\Http\Requests\DragonFly\GetContactSummaryRequest`（owner_member_id required）。不要な場合は使わない（MeetingController は FormRequest なし）。
- **Service:** `App\Services\Religo\OneToOneIndexService`、`App\Services\DragonFly\ContactSummaryService`。集計・複数ソース結合は Service に配置。

### B) 認可・スコープ
- 現行 API は **認証 middleware なし**（bootstrap/app.php に api 用の追加 middleware なし）。401 は未使用。workspace はクエリで optional（IndexOneToOnesRequest: workspace_id nullable）。
- Dashboard も認証なしで統一。owner_member_id はクエリで optional（省略時は全件集計または暫定 1 固定）。

### C) レスポンス形式
- **成功:** `response()->json($data)` で **data を直返し**（envelope なし）。配列 or 連想配列。
- **404:** `response()->json(['message' => '...'], 404)`。
- **422:** FormRequest の validation 失敗で自動 422（message + errors）。

### D) テストの正
- **配置:** `tests/Feature/Religo/*`、`tests/Feature/Api/*`。命名 `*Test.php`。
- **認証:** 未使用（actingAs なし）。RefreshDatabase、setUp で DB::table()->insertGetId または Model::create。
- **workspace/members:** OneToOneIndexTest で workspaces, members を insertGetId、OneToOne を Model::create。ContactMemosIndexTest で members を insertGetId、ContactMemo::create。

---

## Step1–8: E-1b 実装結果（要約）

- Step2: routes/api.php に GET /api/dashboard/stats, tasks, activity を追加。
- Step3: DashboardController（Religo）に stats(), tasks(), activity() を実装。
- Step4: DashboardService（Religo）で集計ロジック。既存 MemberSummaryQuery / ContactMemo / OneToOne / Meeting を利用。
- Step5: Feature Test 追加（DashboardStatsTest, DashboardTasksTest, DashboardActivityTest）。
- Step6: Dashboard.jsx から既存 API 呼び出し口（fetch/axios 等）で GET し表示を動的化。
- Step7: php artisan test — 61 passed。npm run build — 成功。
- Step8: 1 コミット push。
