# Phase G10: phase13 remove round rework — PLAN

| Phase ID | G10 |
|----------|-----|
| Name | phase13 remove round rework |
| Type | implement |

---

## Purpose

Round 概念削除のうち develop に未反映な部分を、現行実装に合わせて安全に rework する。特に DragonFlyBoard.jsx の Round 由来 UI / state の整理を主対象とする。

---

## Background

旧 feature/phase13-remove-round は目的自体は有効だが、ベースが古くそのまま merge すると高確率で競合・regress が起きる。G9 の結論に従い、旧ブランチは merge せず、develop から feature/phase13-remove-round-v2 を切り、必要最小限のみ rework する。

---

## Scope

- **DragonFlyBoard.jsx** を主対象（Round 由来の表示・コメント・内部 label を BO 前提に整理）
- 必要なら最小限の docs 更新（PHASE_G10_*, REGISTRY, INDEX）
- develop に不足がある場合のみ補助的なコード修正（本 Phase では Board のみ想定）

---

## Out of Scope

- 旧 feature/phase13-remove-round のそのままの merge
- 不要な migration の持ち込み
- 既に develop に入っている backend 差分の再投入
- MeetingBreakoutService / api.php / Model の変更（develop がすでに round なし前提なら触らない）

---

## Target Files

| 種別 | パス |
|------|------|
| 主対象 | www/resources/js/admin/pages/DragonFlyBoard.jsx |
| Phase docs | docs/process/phases/PHASE_G10_PHASE13_REMOVE_ROUND_REWORK_*.md |
| 必要時 | docs/process/PHASE_REGISTRY.md, docs/INDEX.md |

---

## Tasks

| # | Task | 内容 |
|---|------|------|
| 1 | DragonFlyBoard の round 由来 state/UI の洗い出し | round_no, roundsEdit, "Round 1" 表示、memoContextRoundLabel 等を確認。 |
| 2 | Round なし UI への整理 | 表示を "BO" / "BO1" / "BO2" に統一。内部は roundsEdit[0] のみ使用し label を 'BO' に。 |
| 3 | 必要なら docs の最小更新 | G10 REPORT、REGISTRY/INDEX。 |
| 4 | test/build | php artisan test、npm run build。 |
| 5 | REPORT 作成 | 変更ファイル・DoD・merge 準備状況。 |

---

## Risks

- Board UI regress（BO 表示・保存が壊れる）
- round 由来 state の消し漏れ（memo ダイアログ等で "Round" が残る）
- 既存の Relationship Summary / Score / Introduction Hint への影響 → 触らない方針で回避

---

## DoD

- [ ] Board に round 依存の**表示**が残らない（"Round 1" → "BO" 等に変更）
- [ ] BO1/BO2 の表示と操作が維持される
- [ ] php artisan test が通る
- [ ] npm run build が通る
- [ ] feature/phase13-remove-round-v2 として push 済み（develop への merge は別判断）
