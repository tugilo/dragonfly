---
name: merge-develop
description: Merge feature branch into develop using PR-less flow in dragonfly. Use when completing a phase, integrating feature work, or before pushing to origin/develop. Never create PRs.
---

# develop への merge（PRレス）

## 前提

- Phase REPORT の DoD 完了
- implement/refactor: `php artisan test` 成功済み
- React 変更: `npm run build` 成功済み
- 詳細: `docs/git/PRLESS_MERGE_FLOW.md`

## 手順

```bash
# 1. develop を最新化
git checkout develop
git pull origin develop

# 2. feature を merge（merge commit を残す）
git merge --no-ff feature/phaseXXX-name -m "Merge feature/phaseXXX-name into develop"

# 3. テスト（implement/refactor）
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test

# 4. Merge Evidence を REPORT / PHASE_REGISTRY に追記してコミット（push 前）
#    merge commit id: git log -1 --format=%H develop  ※ merge 直後の SHA
git add docs/process/phases/PHASE_XXX_*_REPORT.md docs/process/PHASE_REGISTRY.md
git commit -m "docs: Phase XXX merge evidence を REPORT に記録する。"

# 5. develop へ push は Phase あたり 1 回だけ（merge + evidence をまとめて送る）
git push origin develop
```

## REPORT 取り込み証跡

merge 後・**push 前**に REPORT へ追記:

```
merge commit id: $(git rev-parse HEAD^)   # evidence コミットの 1 つ前 = merge commit
source branch: feature/phaseXXX-name
target branch: develop
test result: XX passed
changed files: $(git diff --name-only develop^2...develop^)
```

## 禁止

- **PR 作成・PR 提案**
- **`git push origin develop` を Phase 内で 2 回以上**（merge 直後と evidence 後で分けない → Actions 渋滞）
- `git push --force`
- `git reset --hard`
- develop への直接コミット（docs 軽微追記のみ例外）

## push について

- `git push origin develop` は **Phase 完了ごとに 1 回**
- merge commit と merge evidence 記録は **同一 push に含める**（ローカルで merge → evidence コミット → 1 push）
- 人間の明示指示がある場合のみ push する
