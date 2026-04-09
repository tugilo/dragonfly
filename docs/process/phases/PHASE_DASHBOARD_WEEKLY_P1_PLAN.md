# PLAN: DASHBOARD-WEEKLY-P1 — Dashboard ウィークリープレゼン原稿表示（SPEC-004 最小実装）

| 項目 | 内容 |
|------|------|
| **Phase ID** | **DASHBOARD-WEEKLY-P1** |
| **種別** | implement |
| **Related SSOT** | SPEC-004 — [DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md](../../SSOT/DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md) |
| **参照** | [DASHBOARD_DATA_SSOT.md](../../SSOT/DASHBOARD_DATA_SSOT.md), [ADMIN_GLOBAL_OWNER_SELECTION.md](../../SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md), [DATA_MODEL.md](../../SSOT/DATA_MODEL.md), [DASHBOARD_FIT_AND_GAP.md](../../SSOT/DASHBOARD_FIT_AND_GAP.md) |
| **ブランチ（想定）** | `feature/phase-dashboard-weekly-p1` |
| **モック比較** | モックに当該ブロックなし。**[FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §2 Dashboard** に意図的 Gap（新規補助カード）として追記する。 |

---

## 1. 背景と目的

### 1.1 SPEC-004 の要点

- Religo **Dashboard（`/`）** に、BNI **ウィークリープレゼン（例: 25秒）の原稿**を表示する。
- 表示対象は **グローバル Owner に対応する `members` 行**のデータ。**製品上の正は DB**（オフライン Markdown は参考のみ）。
- 本機能は **KPI / Tasks / Activity / Leads を置き換えない** **補助ブロック**（[DASHBOARD_DATA_SSOT §0](../../SSOT/DASHBOARD_DATA_SSOT.md)）。

### 1.2 本 Phase のゴール

- **最小構成**で「閲覧 + 全文コピー」を成立させる。
- **Owner 文脈**・**他人原稿の誤表示防止**を既存 Dashboard API と同型に保つ。

---

## 2. 今回のスコープ

### 2.1 含む

- `members` に **nullable text** `weekly_presentation_body` を追加する **マイグレーション**。
- **GET** API（Dashboard 配下）で、解決済み Owner のメンバーから原稿を返す。
- Dashboard 左列 **Shortcuts の直下**に **カード 1 枚**（本文・固定高スクロール・全文コピー）。
- **[DATA_MODEL.md](../../SSOT/DATA_MODEL.md)** の `members` 説明への追記。
- **Feature テスト**（Owner あり/なし・member 不在・原稿あり/なし）。
- **FIT_AND_GAP** への1行追記。

### 2.2 含まない（明示的スコープ外）

- **編集 UI**（Members 含む一切）
- **標準稿 / 別稿**の切替・複数カラム
- **リッチテキスト**・履歴・監査
- **他者閲覧権限**の細分化（本 API は既存 Dashboard と同様、`owner_member_id` で指定されたメンバーの行を返すのみ）

---

## 3. 表示の正

### 3.1 Owner 文脈

- **クエリ `owner_member_id` → なければ acting user の `owner_member_id`** の順で解決（既存 `DashboardController::resolveOwnerMemberId` と**同一**）。
- Dashboard UI は `ReligoOwnerContext` の `ownerMemberId` をクエリに付与（既存 `dashboardRequest` と同型）。

### 3.2 挙動一覧

| 状態 | API | UI |
|------|-----|-----|
| Owner **未解決**（422） | 他 Dashboard エンドポイントと同様のメッセージ | **カード非表示**（`ownerMemberId == null` のときは fetch しない／他パネルと整合） |
| Owner ID はあるが **member 不存在**（404） | `Owner member not found.` | エラー扱いでカード内に短いエラー文（または非表示）。テストで期待を固定 |
| member 存在・**原稿 null または空文字** | `weekly_presentation_body: null` | **「原稿が未登録です。」** |
| member 存在・**原稿あり** | 本文を返す | 改行保持・スクロール領域内に表示・コピー可 |

**他人の原稿:** Owner が **ユーザーが選んだメンバー**を指すのは既存仕様。誤って **別メンバーの本文を混在表示しない**よう、**常に解決した 1 つの `owner_member_id` の行のみ**を読む。

---

## 4. データ方針

### 4.1 カラム

| カラム | 型 | 備考 |
|--------|-----|------|
| `weekly_presentation_body` | `text`, **nullable** | プレーンテキスト。改行可。 |

### 4.2 将来拡張（本 Phase では実装しない）

- `weekly_presentation_alt_body` や JSON による複数稿は **SPEC-004 §7** の未決に委ねる。

### 4.3 マイグレーション

- `Schema::table('members', function (Blueprint $table) { $table->text('weekly_presentation_body')->nullable(); });`

### 4.4 モデル

- `Member::$fillable` に追加（**今回編集 UI はないが**、シード・将来 PATCH・テストでの代入に備える）。

---

## 5. API / 取得方針

### 5.1 選定: **`GET /api/dashboard/weekly-presentation`**

**理由:**

- Owner 解決・422/404 の挙動を **stats/tasks/activity と完全に揃えられる**（同一コントローラ・同一 `resolveOwnerMemberId`）。
- Dashboard 専用の読み取りで、**1 エンドポイント 1 責務**が明確。
- フロントは既存 `dashboardRequest('weekly-presentation')` を **stats と並列** `Promise.all` に追加するだけでよい（[SPEC-004 §6 非機能](../../SSOT/DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md)）。

### 5.2 レスポンス形（案）

```json
{ "weekly_presentation_body": null }
```

または

```json
{ "weekly_presentation_body": "1行目\n2行目" }
```

- DB が **null または空文字**のときは JSON では **`null`** を返す（「未登録」判定を UI で統一）。

### 5.3 専用 Member API に分けない理由（今回）

- 一覧・詳細の Member リソースに載せると **Dashboard 以外にも露出**し、フィールド選択・権限の議論が広がる。初回は Dashboard 集約で十分。

---

## 6. UI 方針

| 項目 | 方針 |
|------|------|
| **配置** | 左列: `DashboardTasksPanel` → `DashboardShortcutsPanel` → **`DashboardWeeklyPresentationPanel`（新規）** → `DashboardActivityPanel` |
| **タイトル** | **ウィークリープレゼン原稿** |
| **本文** | `white-space: pre-wrap`、**maxHeight 約 240px** + `overflow: auto`（長文はスクロール） |
| **コピー** | **全文コピー**ボタン（`navigator.clipboard.writeText`、失敗時はスナックバーまたは `alert` 最小） |
| **Owner 未設定** | カード**非表示**（KPI 等の Owner 案内と**文言の重複を避ける**） |
| **空状態** | 「原稿が未登録です。」（コピーは disabled または非表示） |
| **モバイル** | `minWidth: 0`、カードは既存 `DASHBOARD_CARD_SX` に合わせる |

---

## 7. テスト観点

| # | 内容 |
|---|------|
| 1 | `owner_member_id` 指定・原稿あり → 200・本文一致 |
| 2 | 原稿 null → 200・`weekly_presentation_body` null |
| 3 | Owner 未設定（クエリなし・user に owner なし）→ 422 |
| 4 | 存在しない `owner_member_id` → 404 |
| 5 | 既存 stats 等のテストが **退行しない** |

---

## 8. DoD（SPEC-004 を本 Phase 用に具体化）

- [ ] Dashboard に **ウィークリープレゼン原稿**カードがあり、**Owner に紐づくメンバー**の `weekly_presentation_body` が表示される（DB 経由）。
- [ ] Owner 未設定時は **誤表示がなく**、カードは出さない、または既存フローと矛盾しない。
- [ ] `npm run build` 成功、`php artisan test` 全通過（本 Phase のテスト追加含む）。
- [ ] [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §2 に **本ブロックの Gap（新規）** を記載した。
- [ ] WORKLOG・REPORT・PHASE_REGISTRY・INDEX・dragonfly_progress を更新した。

---

## 9. 変更予定ファイル（予測）

| 種別 | パス |
|------|------|
| migration | `www/database/migrations/2026_04_07_*_add_weekly_presentation_body_to_members_table.php` |
| API | `www/routes/api.php`, `www/app/Http/Controllers/Religo/DashboardController.php` |
| Model | `www/app/Models/Member.php` |
| UI | `www/resources/js/admin/pages/Dashboard.jsx`, `www/resources/js/admin/pages/dashboard/DashboardWeeklyPresentationPanel.jsx`（新規） |
| テスト | `www/tests/Feature/Religo/DashboardApiTest.php` |
| SSOT | `docs/SSOT/DATA_MODEL.md`, `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` |

---

## 10. 変更履歴

| 日時 (JST) | 内容 |
|------------|------|
| 2026-04-07 | PLAN 初版（実装開始前に完成） |
| 2026-04-07 | 実装完了（REPORT・WORKLOG 締め） |
