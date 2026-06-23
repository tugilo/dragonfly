# Phase 238 PLAN — MeetingsList UI 種別対応（SPEC-018 Phase D）

**作成:** 2026-06-23 22:12 JST  
**Phase Type:** implement  
**Branch:** feature/phase238-meetings-list-ui  
**Related SSOT:** SPEC-018  
**Status:** completed

**モック比較:** docs/SSOT/MOCK_UI_VERIFICATION.md に従う

---

## Purpose

SPEC-018 Phase D: Meetings 一覧の種別/チームフィルタ、Drawer・議事録モーダルの種別出し分け。

---

## Scope

- `www/resources/js/admin/pages/MeetingsList.jsx`
- `www/resources/js/admin/utils/meetingTypeUi.js`（新規）
- `www/resources/js/admin/dataProvider.js`
- `www/resources/js/admin/referralSuggestionApi.js`
- `docs/SSOT/FIT_AND_GAP_MEETINGS.md`
- Phase 238 docs / PHASE_REGISTRY / progress / SPEC-018 Phase D

---

## DoD

- [x] 種別・チームフィルタ UI
- [x] Drawer タブ / アクション出し分け
- [x] 議事録モーダルヘルプ文言
- [x] npm run build
- [x] FIT_AND_GAP 記録
- [ ] develop merge + push
