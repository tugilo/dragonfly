# PHASE_245_sonae_line_integration PLAN

**作成日時:** 2026-06-24 21:18 JST  
**最終更新日時:** 2026-06-24 21:17 JST  
**Phase Type:** implement  
**Branch:** feature/phase245-sonae-line-integration  
**Related SSOT:** SPEC-017 §10 LINE 連携  
**Status:** completed

---

## DoD

- [x] LINE 設定 API（GET/PUT）
- [x] Webhook 署名検証 + follow/unfollow/message
- [x] 招待トークン + `SONAE-LINK:{token}` 紐付け
- [x] 管理者直接紐付け + Push テスト API
- [x] Feature test 4 cases
- [x] `php artisan test` — 523 passed
