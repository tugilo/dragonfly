# Phase G11: DragonFly breakout duplicate member support — PLAN

| Phase ID | G11 |
|----------|-----|
| Name | DragonFly breakout duplicate member support |
| Type | implement |

---

## Purpose

DragonFly の実運用に合わせて、同じ member を BO1 / BO2 の両方に割り当て可能にし、BO1 の内容を BO2 にコピーできるようにする。

---

## Background

現状は member が BO 全体で一意扱いとなっており、DragonFly の実際の breakout room 運用（同一メンバーが BO1 と BO2 の両方に入る）と一致しない。G10 の続きとして feature/phase13-remove-round-v2 上で実装する。

---

## Scope

- **DragonFlyBoard.jsx** を主対象（候補の絞り込みを「同一 BO 内のみ」に変更、コピーボタン追加、保存前の cross-BO エラー削除）
- **MeetingBreakoutService.php** の cross-BO 重複エラー削除と、同一 BO 内重複の正規化
- 必要なら最小限の docs 更新（PHASE_G11_*, REGISTRY, INDEX）

---

## Out of Scope

- unrelated backend refactor
- Round 廃止以外の仕様変更
- 他画面の変更

---

## Target Files

| 種別 | パス |
|------|------|
| 主対象 | www/resources/js/admin/pages/DragonFlyBoard.jsx |
| 補助 | www/app/Services/Religo/MeetingBreakoutService.php |
| Phase docs | docs/process/phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_*.md |
| 必要時 | docs/process/PHASE_REGISTRY.md, docs/INDEX.md |

---

## Tasks

| # | Task | 内容 |
|---|------|------|
| 1 | 同一 member を別 BO に入れられない制御の洗い出し | UI の assignedInRound、saveRounds の allIds チェック、backend の updateBreakouts チェックを特定。 |
| 2 | BO ごとに独立して member を入れられるよう修正 | UI: 候補を「その BO に未割当」に変更。保存時 cross-BO エラーを削除。Backend: cross-BO 重複エラーを削除。同一 BO 内は重複を防ぐ（UI で防ぎ、payload は per-room で dedupe）。 |
| 3 | 「BO1 を BO2 にコピー」ボタン追加 | BO2 を BO1 の内容で完全上書き（仕様 A）。 |
| 4 | 保存時の payload / backend 整合確認 | room_label 単位で member_ids を送る形を維持。backend は per-room で受け取り重複チェックを外す。 |
| 5 | 手動確認 | 同一 member を BO1/BO2 に入れられる、同一 BO 内重複防止、コピー、保存・再表示。 |
| 6 | test/build | php artisan test、npm run build。 |
| 7 | REPORT 作成 | 変更ファイル・DoD・merge 準備。 |

---

## Risks

- duplicate 制御を外した結果、同一 BO 内にも重複登録できてしまう → 候補を「その BO に未割当」にし、payload で per-room dedupe する。
- payload 仕様と UI のズレ → 既存の rooms[].member_ids 構造を維持。
- コピー時に既存 BO2 データの扱いが曖昧 → 仕様 A（完全上書き）で明確化。

---

## DoD

- [ ] 同じ member を BO1 と BO2 の両方に入れられる
- [ ] 同じ BO 内では不必要な重複登録を防げる
- [ ] 「BO1 を BO2 にコピー」ボタンが追加され、BO2 が BO1 で完全上書きされる
- [ ] 保存後も BO1 / BO2 の内容が崩れない
- [ ] php artisan test が通る
- [ ] npm run build が通る
