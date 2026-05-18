# PLAN: Phase 119 — Dashboard プレゼン原稿タブ化

| 項目 | 内容 |
|------|------|
| **Phase ID** | **119** |
| **種別** | implement |
| **Related SSOT** | SPEC-004 — [DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md](../../SSOT/DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md) |
| **参照** | [DATA_MODEL.md](../../SSOT/DATA_MODEL.md), [ADMIN_GLOBAL_OWNER_SELECTION.md](../../SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md), [DASHBOARD_FIT_AND_GAP.md](../../SSOT/DASHBOARD_FIT_AND_GAP.md), [MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md) |
| **ブランチ（想定）** | `feature/phase119-dashboard-weekly-tabs` |
| **モック比較** | モック比較: [MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md) に従う。既存同様、Dashboard 原稿カードはモック未収録の補助ブロックとして [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) に差分を記録する。 |

---

## 1. 背景

2026-05-19 の DragonFly 定例会で、通常25秒のウィークリープレゼンに加え、入会間もないメンバー向けの **スタートダッシュプレゼン60秒** を行う。Religo Dashboard では現在 `members.weekly_presentation_body` の単一原稿のみを表示しているため、標準稿とスタートダッシュ稿を切り替えて確認できるようにする。

---

## 2. Scope

### 含む

- `members` に `start_dash_presentation_body`（nullable text）を追加する。
- `GET /api/dashboard/weekly-presentation` で標準稿とスタートダッシュ稿を同時に返す。
- Dashboard の原稿カードを **ウィークリープレゼン / スタートダッシュ** のタブ切り替えにする。
- 次廣のスタートダッシュ60秒稿をドキュメントとローカルDB/SQLダンプに反映する。
- SPEC-004 / DATA_MODEL / FIT_AND_GAP / 進捗 / INDEX / Phase Registry を更新する。
- Feature テストとフロントビルドを実行する。

### 含まない

- Dashboard 上での原稿編集 UI。
- 原稿履歴・承認・監査。
- 他メンバーへの公開範囲の再設計。

---

## 3. DoD

- [ ] Dashboard 原稿カードで、標準稿とスタートダッシュ稿をタブで切り替えられる。
- [ ] どちらのタブでも本文の改行保持・全文コピーができる。
- [ ] Owner 未設定・原稿未登録・API エラー時の既存挙動を壊さない。
- [ ] `GET /api/dashboard/weekly-presentation` の既存互換キー `weekly_presentation_body` を維持し、新キー `start_dash_presentation_body` を返す。
- [ ] `php artisan test` と `npm run build` が成功する。
- [ ] WORKLOG / REPORT / PHASE_REGISTRY / docs/INDEX.md / docs/dragonfly_progress.md を更新する。

---

## 4. 変更予定ファイル

| 種別 | パス |
|------|------|
| migration | `www/database/migrations/*_add_start_dash_presentation_body_to_members_table.php` |
| Model/API/Test | `www/app/Models/Member.php`, `www/app/Http/Controllers/Religo/DashboardController.php`, `www/tests/Feature/Religo/DashboardApiTest.php` |
| UI | `www/resources/js/admin/pages/Dashboard.jsx`, `www/resources/js/admin/pages/dashboard/DashboardWeeklyPresentationPanel.jsx` |
| docs | `docs/SSOT/DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md`, `docs/SSOT/DATA_MODEL.md`, `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md`, `docs/strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md` |
| project docs | `docs/process/PHASE_REGISTRY.md`, `docs/INDEX.md`, `docs/dragonfly_progress.md` |

---

## 5. 変更履歴

| 日時 (JST) | 内容 |
|------------|------|
| 2026-05-17 22:07 | PLAN 初版。 |
