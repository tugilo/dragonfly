---
name: phase-finish
description: Finish a DevOS Phase in dragonfly. Use when completing work, writing REPORT, merge evidence, or updating PHASE_REGISTRY and progress. Runs test for implement phases.
---

# Phase 完了（DevOS v4.3）

## 前提

- PLAN の DoD をすべて満たしていること
- 詳細: `docs/AI_TOOLING.md` · `docs/git/PRLESS_MERGE_FLOW.md`

## 手順

1. `/implement-checklist` で未完了項目がないか確認
2. **WORKLOG** に判断理由を追記（「いつ」より「なぜ・どう」）
3. **implement/refactor:** `/docker-artisan` でテスト実行
   ```bash
   docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test
   ```
3. **React 変更あり:** `/react-build`
4. **docs 変更あり:** `/docs-sync`
5. **REPORT** 作成（Merge Evidence 含む）
6. **更新:**
   - `docs/process/PHASE_REGISTRY.md`（Status: completed）
7. **merge（人間確認後）:** `/merge-develop` を参照
8. **REPORT に取り込み証跡**（merge commit id 等）を追記

## Merge Evidence（REPORT 必須）

```
merge commit id:
source branch: feature/phaseXXX-name
target branch: develop
phase id: XXX
phase type: docs / implement / refactor
related ssot: SPEC-XXX
test command: php artisan test
test result: XX passed / スキップ（docsフェーズ）
changed files: [git diff --name-only の出力]
scope check: OK
ssot check: OK
dod check: OK
```

## 注意

- `git push` は人間の明示指示がある場合のみ実行
- PR は作成しない
