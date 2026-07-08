# Phase 279 REPORT: リファーラル提案 — 再生成 force

## Summary

2026-07-08 20:06 JST — リファーラル提案モーダルの **再生成** で `force=true` を送り、議事録 digest が前回 run と同一でも新 run を作成できるようにした。初回生成は COMMON §3 の digest 重複抑制（既存 run 再利用）を維持。

## Changes

- API: `POST .../referral-suggestions/generate` に `force`（boolean）追加（121 / 定例会）
- Service: digest キャッシュ lookup を `if (! $force)` で囲む
- UI: 既存 run 表示中の生成 → `force=true`、通知を初回/再生成/再利用で分岐
- Meeting Controller: 不正 `context_mode` を relationship に正規化（121 と同型）

## Current Status

completed（develop merge 済み 2026-07-08 20:12 JST）

## DoD Check

| Item | Result |
|------|--------|
| force=false で digest 再利用 | OK |
| force=true で新 run 作成 | OK |
| 121 / 定例会 UI | OK |
| php artisan test | OK — 592 passed |
| npm run build | OK |
| docs 同期 | OK |

## Test Results

```
php artisan test — 592 passed (2173 assertions)
npm run build — OK
```

## Merge Evidence

```
merge commit id: 7093b2aef5fcc44e3a3dabd83cf07e073573303d
source branch: feature/phase279-referral-suggestion-force-regenerate
target branch: develop
phase id: 279
phase type: implement
related ssot: SPEC-015, SPEC-016
test command: php artisan test
test result: 592 passed (2173 assertions)
changed files:
www/app/Http/Controllers/Religo/MeetingReferralSuggestionController.php
www/app/Http/Controllers/Religo/OneToOneReferralSuggestionController.php
www/app/Services/Religo/MeetingReferralSuggestionService.php
www/app/Services/Religo/OneToOneReferralSuggestionService.php
www/resources/js/admin/components/ReferralSuggestionDialogCore.jsx
www/resources/js/admin/pages/MeetingReferralSuggestionDialog.jsx
www/resources/js/admin/pages/OneToOneReferralSuggestionDialog.jsx
www/resources/js/admin/referralSuggestionApi.js
www/tests/Feature/Religo/MeetingReferralSuggestionTest.php
www/tests/Feature/Religo/OneToOneReferralSuggestionTest.php
docs/INDEX.md
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_279_referral_suggestion_force_regenerate_PLAN.md
docs/process/phases/PHASE_279_referral_suggestion_force_regenerate_WORKLOG.md
docs/process/phases/PHASE_279_referral_suggestion_force_regenerate_REPORT.md
scope check: OK
ssot check: OK
dod check: OK
```
