# PHASE_246_sonae_training_response PLAN

**作成日時:** 2026-06-24 21:19 JST  
**最終更新日時:** 2026-06-24 21:19 JST  
**Phase Type:** implement  
**Branch:** feature/phase246-sonae-training-response  
**Related SSOT:** SPEC-017 §6–§8 訓練・回答・集計（L1）  
**Status:** completed

---

## 目的

手動訓練発報 → LINE Push（回答 URL 付き）→ メンバー安否回答 → 集計 API までを SONAE Core として実装し **L1 達成**とする。

---

## Scope

| 対象 | 内容 |
|------|------|
| Services | `SonaeTrainingDispatchService`, `SonaeResponseTokenService`, `SonaeSafetyResponseService`, `SonaeAggregationService` |
| Controllers | `SonaeTrainingController`, `SonaeResponseController` |
| Routes | API `/api/sonae/chapters/{chapter}/training-events/*`, 公開 `/sonae/respond/{token}` |
| View | `resources/views/sonae/respond.blade.php` |
| Tests | `SonaeTrainingResponseTest` |

---

## DoD

- [x] 手動訓練発報 API（`POST .../training-events/dispatch`）
- [x] 回答トークン URL 生成・公開回答フォーム（GET/POST `/sonae/respond/{token}`）
- [x] 集計 API（`GET .../notifications/{id}/summary`）
- [x] 訓練履歴 + 前回比（`GET .../training-events`）
- [x] Feature test 2 cases
- [x] `php artisan test` — 525 passed

---

## 設計判断

1. **`created_by_user_id`:** PoC では Religo Sanctum `users` と `sonae_users` 未連携のため `null`（Phase 242 PLAN 準拠）。
2. **通知対象:** Phase 244 `SonaeNotificationTargetResolver`（LINE 紐付け済み active のみ）を再利用。
3. **回答 UI:** Phase 247 React 管理画面の前段として Blade 公開フォーム（セッション不要）。

---

## モック比較

対象外（管理画面 UI は Phase 247）。
