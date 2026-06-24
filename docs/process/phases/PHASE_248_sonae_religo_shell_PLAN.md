# PHASE_248_sonae_religo_shell PLAN

**作成日時:** 2026-06-24 21:28 JST  
**最終更新日時:** 2026-06-24 21:28 JST  
**Phase Type:** implement  
**Branch:** feature/phase248-sonae-religo-shell  
**Related SSOT:** SPEC-017 §2.2 Religo 統合、SONAE_IMPLEMENTATION_PLAN Phase 248  
**Status:** completed

---

## 目的

Religo workspace と SONAE chapter を Shell 層で解決し、API アクセスをユーザーの所属 workspace に限定する。管理 UI から bootstrap・Religo sync を実行可能にする。

---

## Scope

| 対象 | 内容 |
|------|------|
| Service | `SonaeChapterResolver` |
| Middleware | `sonae.chapter`（`EnsureSonaeChapterAccess`） |
| API | `GET /api/sonae/context`、`POST /api/sonae/chapters/bootstrap` |
| React | `SonaeChapterContext` を context API 化、bootstrap CTA、Dashboard 同期 |
| Tests | `SonaeReligoShellTest`、`SonaeChapterTestHelpers`、既存 Sonae テスト middleware 対応 |

---

## DoD

- [x] workspace → chapter 解決（`SonaeChapterResolver` + context API）
- [x] `sonae.chapter` middleware（他 chapter 403 / 未 bootstrap 404）
- [x] bootstrap API（Religo members sync 込み）
- [x] UI: 未 bootstrap 時セットアップ、Dashboard Religo 同期ボタン
- [x] `npm run build` 成功
- [x] `php artisan test` — 531 passed

---

## モック比較

対象外（Shell 統合）。SONAE 画面モック差分は Phase 247 REPORT 参照。
