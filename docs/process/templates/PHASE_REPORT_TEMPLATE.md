# Phase REPORT テンプレート（証跡欄付き）

**用途:** Phase 完了時および **develop への取り込み後** に REPORT に記録する項目のひな形。  
**参照:** [PRLESS_MERGE_FLOW.md](../../git/PRLESS_MERGE_FLOW.md)（PR を介さない取り込みフロー）。

---

## 基本構成（Phase 完了時）

- **Phase 名・完了日**
- **実施内容**（箇条書き）
- **変更ファイル一覧**（`git diff --cached --name-only` または `git diff --name-only develop...feature/xxx`）
- **テスト結果**（コマンドと pass 数）
- **DoD チェック**
- **実行した git コマンド（コピペ用）**

---

## 取り込み証跡欄（develop に merge した後に追記）

PR を介さない運用では、**feature を develop に取り込んだあと**、このセクションを REPORT に追加する。PR の代替となる証跡として必須とする。

```markdown
## 取り込み証跡（develop への merge 後）

| 項目 | 内容 |
|------|------|
| **merge commit id** | （例: `a1b2c3d...`。`git log -1 --format=%H develop` で取得） |
| **merge 元ブランチ名** | （例: `feature/phase01-summary-api-v1`） |
| **変更ファイル一覧** | `git diff --name-only develop^1...develop` の結果を貼る |
| **テスト結果** | （例: `php artisan test` — 8 passed） |
| **手動確認** | （必要なら記述。不要なら「特になし」） |
| **compare URL** | （任意。例: https://github.com/owner/repo/compare/develop...feature/xxx） |
```

### 記入例

| 項目 | 内容 |
|------|------|
| **merge commit id** | `38480ea...` |
| **merge 元ブランチ名** | `feature/phase1-summary-api-v1` |
| **変更ファイル一覧** | docs/INDEX.md, docs/process/phases/PHASE01_*.md, www/app/Http/Controllers/Religo/..., www/routes/api.php, www/tests/Feature/Religo/MemberSummaryTest.php |
| **テスト結果** | `docker compose ... exec app php artisan test` — Tests: 8 passed (32 assertions) |
| **手動確認** | 特になし |
| **compare URL** | （省略可） |

---

## 運用上の注意

- **merge 前に REPORT を「完了時点」で一度締める**（変更ファイル・テスト結果・DoD まで）。
- **merge 後に REPORT を更新**し、「取り込み証跡」セクションを追加して merge commit id 等を記録する。
- 証跡欄は **PR を作らない代わりに「何がいつ develop に入ったか」を残す**ためのもの。Cursor が取り込み手順を実行する際は [.cursorrules](../../../.cursorrules) の「取り込み用固定手順」に従う。
