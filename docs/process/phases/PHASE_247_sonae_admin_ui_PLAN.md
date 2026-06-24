# PHASE_247_sonae_admin_ui PLAN

**作成日時:** 2026-06-24 21:22 JST  
**最終更新日時:** 2026-06-24 21:22 JST  
**Phase Type:** implement  
**Branch:** feature/phase247-sonae-admin-ui  
**Related SSOT:** SPEC-017 §6.1 管理画面、SONAE_IMPLEMENTATION_PLAN Phase 247  
**Status:** completed

---

## 目的

Phase 244–246 の SONAE API を Religo 管理 SPA から操作できる React 画面（`/admin#/sonae/*`）を追加し、L1 運用可能にする。

---

## Scope

| 対象 | 内容 |
|------|------|
| API | `GET /api/sonae/chapters/resolve`、training index に `notification_id` 追加 |
| React | Dashboard / Members / LINE / Training 画面、メニュー、chapter context |
| Routes | `app.jsx` CustomRoutes `/sonae/*` |

---

## DoD

- [x] ダッシュボード（KPI + 直近訓練）
- [x] メンバー一覧（同期・CSV・未紐付け・招待）
- [x] LINE 設定フォーム
- [x] 訓練発報・履歴・集計ダイアログ
- [x] サイドメニュー SONAE セクション
- [x] workspace → chapter 解決（resolve API + context）
- [x] `npm run build` 成功
- [x] `php artisan test` — 527 passed

---

## モック比較

モック比較: `docs/SSOT/MOCK_UI_VERIFICATION.md` に従う。  
SONAE 専用モックは未整備のため、FIT_AND_GAP の「モック」列は Phase 247 REPORT に初回記録。

---

## Phase 248 以降に委譲

- Religo workspace 変更時の自動 bootstrap
- `sonae.chapter` middleware
- 発報条件・JMA 設定 UI
