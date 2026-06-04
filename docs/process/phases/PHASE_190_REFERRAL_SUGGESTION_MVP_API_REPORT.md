# REPORT: Phase 190 — REFERRAL-SUGGESTION-MVP-API

**Phase:** リファーラル提案 MVP API（121＋定例会）  
**完了日:** 2026-06-04 13:49 JST  
**ブランチ:** `feature/phase190-referral-suggest-mvp-api` → `develop`（merge 前）

---

## 1. 実施内容サマリ

- **migration:** `one_to_one_referral_suggestion_*` / `meeting_referral_suggestion_*`（§4.19–§4.20）
- **共有:** Digest・MemberRoster・PayloadNormalizer・ReferralSuggestionAiService
- **API（auth:sanctum）:**
  - `POST/GET /api/one-to-ones/{id}/referral-suggestions/...`
  - `PATCH /api/one-to-one-referral-suggestions/{id}`
  - `POST/GET /api/meetings/{id}/referral-suggestions/...`
  - `PATCH /api/meeting-referral-suggestions/{id}`
- **テスト:** Feature 11 件

---

## 2. 変更ファイル一覧

| 種別 | ファイル |
|------|----------|
| migration | `www/database/migrations/2026_06_04_140000_create_referral_suggestion_tables.php` |
| Models | `OneToOneReferralSuggestionRun.php`, `OneToOneReferralSuggestion.php`, `MeetingReferralSuggestionRun.php`, `MeetingReferralSuggestion.php` |
| Services | `ReferralSuggestionDigest.php`, `ReferralSuggestionMemberRoster.php`, `ReferralSuggestionPayloadNormalizer.php`, `ReferralSuggestionAiService.php`, `OneToOneReferralSuggestionService.php`, `MeetingReferralSuggestionService.php` |
| API | `OneToOneReferralSuggestionController.php`, `MeetingReferralSuggestionController.php`, `PatchReferralSuggestionRequest.php`, `routes/api.php` |
| テスト | `OneToOneReferralSuggestionTest.php`, `MeetingReferralSuggestionTest.php` |
| SSOT | `docs/SSOT/DATA_MODEL.md` §4.19–§4.20 実装注記 |
| process | `PHASE_190_*`, `PHASE_REGISTRY`（merge 後 completed） |

---

## 3. テスト結果

| コマンド | 結果 |
|----------|------|
| `php artisan test --filter=ReferralSuggestion` | **11 passed** (28 assertions) |
| `php artisan test` | 455 passed / **1 failed** (`ImportOneToOneNotesCommandTest` — 本 Phase スコープ外) |

---

## 4. DoD チェック

- [x] migration 適用可
- [x] 121 generate / digest 抑制 / owner 拒否
- [x] 定例会 generate / minutes なし 422
- [x] AI 未設定 422
- [x] PATCH dismissed / deferred
- [x] WORKLOG 記録
- [ ] develop merge + Merge Evidence（人間 merge 待ち）

---

## 5. Merge Evidence

| 項目 | 内容 |
|------|------|
| merge commit id | （merge 後） |
| source branch | `feature/phase190-referral-suggest-mvp-api` |
| target branch | `develop` |
| phase id | 190 |
| phase type | implement |
| related ssot | SPEC-015, SPEC-016, REFERRAL_SUGGESTION_COMMON |
| test command | `php artisan test --filter=ReferralSuggestion` |
| test result | 11 passed |
| scope check | OK |
| ssot check | OK（DATA_MODEL 実装注記更新済） |
| dod check | OK（merge 除く） |

---

## 6. 次 Phase

**Phase 191:** 1to1 / Meetings UI・提案モーダル・`npm run build`。→ [PLAN](PHASE_191_REFERRAL_SUGGESTION_MVP_UI_PLAN.md)

---

## 7. 運用注意

- ローカル DB で migration 試行時に **db:wipe** を実行したため、開発 DB は空状態から migrate 済み。**本番データの再 import**（`make db-import` / seeder 等）が必要な場合あり。
