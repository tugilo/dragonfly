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

# 4. push（人間の明示指示がある場合のみ）
git push origin develop
```

## REPORT 取り込み証跡

merge 後に REPORT へ追記:

```
merge commit id: $(git log -1 --format=%H develop)
source branch: feature/phaseXXX-name
target branch: develop
test result: XX passed
changed files: $(git diff --name-only develop^1...develop)
```

## 禁止

- **PR 作成・PR 提案**
- `git push --force`
- `git reset --hard`
- develop への直接コミット（docs 軽微追記のみ例外）

## push について

`git push` は **人間が明示的に依頼した場合のみ** 実行する。
