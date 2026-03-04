# PR を介さない取り込みフロー（PRレス運用）— SSOT

**目的:** GitHub の PR 画面を介さず、ローカルで安全に feature → develop を取り込み、tugilo 標準の履歴・証跡を残す。  
**前提:** [GIT_WORKFLOW.md](../GIT_WORKFLOW.md) のブランチ種別・1push 原則・スコープロックに従う。  
**作成日:** 2026-03-04

---

## 1. 目的

- **PR を使わない:** feature ブランチの取り込みは「ローカルで merge → テスト → push」で完結する。
- **証跡を docs に残す:** PR の代替として、Phase の REPORT に「merge commit id / 対象ブランチ / 変更ファイル一覧 / テスト結果」を記録する。
- **安全な履歴:** merge commit を残すことで、いつ・どの feature が develop に入ったかを一意に追えるようにする。

---

## 2. 前提

- **feature ブランチ運用:** 作業は必ず develop から `feature/xxx` を切り、Phase 単位（または 1 テーマ）で 1 ブランチ。
- **1push 原則:** 1 目的 = 1 コミットで push。Phase の PLAN / WORKLOG / REPORT を締めたうえで push する。
- **Phase docs:** 各 Phase で `docs/process/phases/` に PLAN / WORKLOG / REPORT を必ず作成する。
- **テスト:** 取り込み前後にテストを実行し、REPORT に結果を記録する。

---

## 3. 基本フロー（feature → develop）

1. feature ブランチで作業・コミット・push まで完了していること。
2. ローカルで develop に切り替え、リモート最新を取り込む。
3. feature を **merge（--no-ff）** し、merge commit を 1 つ作る。
4. テストを実行し、問題なければ develop を push する。
5. REPORT に「取り込み証跡」を追記する（merge commit id、変更ファイル一覧、テスト結果）。

コマンド例（日本語コメント付き）:

```bash
# develop を最新化してから取り込みを行う
git checkout develop
git pull origin develop

# feature を merge（PR の代替として merge commit を残す）
git merge --no-ff feature/phaseXX-yyy -m "Merge feature/phaseXX-yyy into develop"

# 取り込み後に必ずテスト（最低限の安全装置）
# ※ プロジェクトルートで実行。Laravel の場合は app コンテナ内で php artisan test
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test

# 問題なければ push
git push origin develop
```

merge 後、該当 Phase の REPORT に以下を追記する（[REPORT 取り込み証跡のテンプレート](../process/templates/PHASE_REPORT_TEMPLATE.md) 参照）:

- merge commit id（`git log -1 --format=%H` で取得）
- merge 元ブランチ名
- `git diff --name-only develop^1...develop` の結果（変更ファイル一覧）
- テスト結果（コマンドと pass 数）
- （任意）compare URL

---

## 4. リリースフロー（develop → main）

- **必要時のみ** 実施する。通常の開発は develop までで完結。
- 手順: develop を最新にしたうえで、ローカルで main に切り替え、`git merge --no-ff develop -m "Release: ..."` で merge。テスト後に `git push origin main`。
- PR は使わない。ローカル merge + push でよい。

```bash
# develop を最新化
git checkout develop
git pull origin develop

# main に切り替え・最新化
git checkout main
git pull origin main

# develop を main に merge（リリース）
git merge --no-ff develop -m "Release: develop 取り込み YYYY-MM-DD"

# 必要に応じてテスト後、push
git push origin main
```

---

## 5. 禁止事項

- **develop への直接コミット禁止:** 新規の機能・修正は必ず feature ブランチで行い、merge で取り込む。例外: 進捗ファイルや INDEX の軽微な追記のみ、develop 直コミットを許容する場合は [.cursorrules](../../.cursorrules) の例外条件に従う。
- **main の直作業禁止:** main には develop（または hotfix）の merge 以外でコミットしない。
- **未テストで取り込み禁止:** feature を develop に merge する前に、少なくとも `php artisan test`（またはプロジェクトの標準テストコマンド）を実行し、失敗している場合は merge しない。
- **PR の必須化をしない:** 本運用では GitHub の PR は使わない。PR を作成してもよいが、取り込みは「ローカル merge → push」を正とする。

---

## 6. 証跡（REPORT に書く内容）

feature を develop に取り込んだあと、その Phase の REPORT に「取り込み証跡」セクションを追加する。PR の代替として以下を記録する。

| 項目 | 内容 |
|------|------|
| **merge commit id** | develop にできた merge commit のハッシュ（`git log -1 --format=%H develop`）。 |
| **merge 元ブランチ名** | 例: `feature/phase1-summary-api-v1`。 |
| **変更ファイル一覧** | `git diff --name-only develop^1...develop` の結果（または merge 直前の `git diff --name-only develop...feature/xxx`）。 |
| **テスト結果** | 実行したコマンドと、pass 数・失敗の有無。 |
| **手動確認** | 必要なら「〇〇を手動で確認した」を簡潔に。 |
| **compare URL** | （任意）GitHub の compare 例: `https://github.com/owner/repo/compare/develop...feature/xxx`。 |

---

## 7. merge commit message の規約

- **feature → develop:** `Merge feature/<ブランチ名> into develop` 形式を推奨。例: `Merge feature/phase1-summary-api-v1 into develop`。
- **develop → main:** `Release: develop 取り込み YYYY-MM-DD` または `Release: 〇〇` のようにリリースであることが分かる文言にする。

---

## 8. トラブル時（コンフリクト・テスト失敗時の戻し方）

### コンフリクトが発生した場合

- merge 途中でコンフリクトが出たら、該当ファイルを編集して解消し、`git add` → `git commit` で merge commit を完了させる。
- 解消が難しい場合は `git merge --abort` で merge をやめ、feature 側で develop を merge してコンフリクトを解消してから、あらためて develop 側で feature を merge する。

```bash
# merge を中止する場合
git merge --abort
```

### テスト失敗時

- merge 後にテストが失敗した場合は、修正を feature ブランチで行い、再度 develop を最新化してから merge し直すか、develop 上で修正コミットを入れる（推奨は feature で修正してから再度 merge）。
- すでに push してしまった場合は、`git revert -m 1 <merge_commit_id>` で merge を打ち消し、修正後に再度 merge する。

```bash
# merge を打ち消す（develop に push 済みの場合）
git checkout develop
git pull origin develop
git revert -m 1 <merge_commit_id>
git push origin develop
```

---

## 関連ドキュメント

- [GIT_WORKFLOW.md](../GIT_WORKFLOW.md) — ブランチ種別・原則
- [docs/process/templates/PHASE_REPORT_TEMPLATE.md](../process/templates/PHASE_REPORT_TEMPLATE.md) — REPORT の証跡欄テンプレート
- [.cursorrules](../../.cursorrules) — Cursor 向け取り込み手順
