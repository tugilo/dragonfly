---
name: phase-start
description: Start a DevOS Phase in dragonfly. Use when beginning new work, creating a phase, or before implementation. Reads PHASE_REGISTRY, creates PLAN/WORKLOG/REPORT stubs, confirms SSOT and Scope.
---

# Phase 開始（DevOS v4.3）

## 前提

- 詳細: `docs/AI_TOOLING.md`
- **PLAN 完成前は実装を開始しない**

## 手順

1. `/ssot-lookup` または SSOT_REGISTRY で関連 Spec を確認
2. **Phase 番号:** `docs/process/PHASE_REGISTRY.md` の最新 +1 を使用
3. **種別決定:** `docs` / `implement` / `refactor`
4. **Scope / DoD** を PLAN に明記
5. **3ファイル作成:**
   - `docs/process/phases/PHASE_XXX_<name>_PLAN.md`
   - `docs/process/phases/PHASE_XXX_<name>_WORKLOG.md`
   - `docs/process/phases/PHASE_XXX_<name>_REPORT.md`
6. **feature ブランチ:** `feature/phaseXXX-<name>`（develop から切る）
7. WORKLOG 先頭行: `tool: claude-code`

## PLAN 必須項目

- Phase Type / Purpose / Related SSOT / Scope / DoD / Tasks

## implement の追加確認

- UI 変更: PLAN に「モック比較: docs/SSOT/MOCK_UI_VERIFICATION.md」
- React 変更後: `npm run build`（コンテナ内）

## 停止条件

- SSOT 不明 / DoD 未定義 / Scope 不明 → 人間に確認してから再開
