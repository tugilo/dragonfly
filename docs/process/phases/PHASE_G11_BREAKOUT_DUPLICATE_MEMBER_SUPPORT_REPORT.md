# Phase G11: DragonFly breakout duplicate member support — REPORT

| Phase ID | G11 |
|----------|-----|
| Status | completed (feature push 済み。develop 未 merge) |
| 完了日 | 2026-03-11 |

---

## Changed Files

- www/resources/js/admin/pages/DragonFlyBoard.jsx
- www/app/Services/Religo/MeetingBreakoutService.php
- www/tests/Feature/Religo/MeetingBreakoutsTest.php
- docs/process/phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_PLAN.md
- docs/process/phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_WORKLOG.md
- docs/process/phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_REPORT.md
- docs/process/PHASE_REGISTRY.md
- docs/INDEX.md

---

## DoD チェック

- [x] 同じ member を BO1 と BO2 の両方に入れられる
- [x] 同じ BO 内では重複登録を防ぐ（候補を「その BO に未割当」に限定、payload で dedupe）
- [x] 「BO1→BO2 コピー」ボタン追加（BO2 を BO1 で完全上書き）
- [x] 保存後も BO1/BO2 の内容が崩れない
- [x] php artisan test が通る（79 passed）
- [x] npm run build が通る

---

## Merge readiness

- feature/phase13-remove-round-v2 上で push まで。develop への merge は未実施。
