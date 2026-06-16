---
name: implement-checklist
description: Pre and post implementation checklist for dragonfly implement/refactor phases. Use before coding, during review, and before marking phase complete. Ensures SSOT, tests, and build steps.
---

# implement Phase チェックリスト

## 開始前（実装禁止ゲート）

- [ ] `/ssot-lookup` — 関連 Spec を読んだ
- [ ] `/phase-start` — PLAN 完成（Scope / DoD / Related SSOT）
- [ ] feature ブランチ: `feature/phaseXXX-name`
- [ ] WORKLOG: `tool: claude-code`

## 実装中

- [ ] Scope 内のみ変更（`www/**`, `docs/**`）
- [ ] `package.json` / `composer.json` 変更 → 人間承認
- [ ] 命名: Religo / DragonFly / dragonfly を正しく使う
- [ ] 指示外の変更をしない

## 完了前

- [ ] `php artisan test` — コンテナ内、全 pass
- [ ] `www/resources/js` 変更あり → `/react-build`
- [ ] UI 変更あり → `/mock-ui-verify`（差分を FIT_AND_GAP に記録）
- [ ] docs 変更 → `/docs-sync`
- [ ] WORKLOG に判断理由を記録

## 完了

- [ ] REPORT 作成（Merge Evidence 欄含む）
- [ ] PHASE_REGISTRY 更新
- [ ] 人間依頼時: `/commit-phase` → `/merge-develop`

## 停止条件

Scope 違反 / SSOT 不明 / DoD 未達 → 作業停止、人間に確認
