# ブランチ整理と運用メモ（G13 作成）

**前提:** tugilo AI DevOS、PR レス merge。main / develop 以外の feature ブランチの整理方針と推奨運用をまとめる。

---

## 1. Phase ごとの feature 運用

- Phase 開始時に `docs/process/PHASE_REGISTRY.md` で次番号を確認する。
- 作業は **develop から** `feature/phaseXXX-name` を切り、そのブランチ上で実装する。
- PLAN → 実装 → WORKLOG → REPORT の順で進める。
- 実装後に **動作確認**（必要なら手動確認）し、`php artisan test` と `npm run build` を通す。
- develop に **merge** する（`git merge --no-ff feature/phaseXXX-name`）。PR は使わない。
- **REPORT / PHASE_REGISTRY / INDEX** に Merge Evidence と status を更新する。
- merge 済みの **feature ブランチは削除してよい**（ローカル・リモートとも）。履歴は develop の merge commit に残る。

---

## 2. ブランチ削除のルール

- **削除してよい:** develop（または origin/develop）に **merge 済み** と確認できた feature / hotfix / fix 等。
- **削除しない:** main / develop。また、**未 merge** のブランチ、**参照用に残す**と明示したブランチ、**判断が曖昧**なブランチは削除しない。
- 削除前に必ず `git branch --merged develop`（ローカル）、`git branch -r --merged origin/develop`（リモート）で merge 済みか確認する。
- ローカル削除: `git branch -d <branch>`
- リモート削除: `git push origin --delete <branch>`
- いきなりまとめて削除せず、削除候補を一覧化してから実行する。

---

## 3. 参照用ブランチ

- 未 merge のまま残すブランチ（例: 旧 `feature/phase13-remove-round`）は、**参照用**である理由を docs または REPORT に明記する。
- 参照用と判断したブランチは、safe to delete と明確に判断できない限り削除しない。

---

## 4. 推奨する流れ（1 Phase あたり）

1. develop を最新化し、feature ブランチを切る。
2. 実装し、test / build を通す。
3. develop に merge し、REPORT / REGISTRY / INDEX を更新する。
4. push 後、merge 済み feature ブランチを削除する（任意だが推奨）。
5. 次の Phase では再度 develop から新しい feature ブランチを切る。

---

## 関連

- [BRANCH_STRATEGY.md](BRANCH_STRATEGY.md) — ブランチ構成・命名・merge ルール
- [PRLESS_MERGE_FLOW.md](PRLESS_MERGE_FLOW.md) — 取り込み手順・証跡の残し方
- [../process/PHASE_REGISTRY.md](../process/PHASE_REGISTRY.md) — Phase 一覧・次番号
