# feature/religo-product-name → develop をマージする手順

GitHub 上で PR を確実にマージし、origin/develop に Religo（30f2673）を入れるための手順です。

---

## Step A: 既存 PR の確認（約1分）

1. ブラウザで **https://github.com/tugilo/dragonfly/pulls** を開く
2. 検索欄または一覧で **"religo-product-name"** または **"establish Religo"** で探す
3. 該当 PR を開き、次を確認する：
   - **Base branch** が **develop** になっているか
   - **状態**: **Merged**（紫） / **Closed**（赤） / **Open**（緑）
   - 「Merged commit」や「Squash and merge」の履歴があるか

---

## Step B: マージ or 作り直し

### ケース1: 該当 PR が Open（緑）で Base=develop の場合
- **Merge pull request** をクリック
- **Squash and merge** 推奨（1 コミットなので Create a merge commit でも可）
- **Confirm merge**

### ケース2: 該当 PR が Closed（赤）で未マージ／Base が違う／見つからない場合
1. **New pull request** をクリック
2. **base: develop** にする
3. **compare: feature/religo-product-name** にする
4. タイトル: `docs: establish Religo as product name`
5. 本文（要点）:
   - docs/README のみ（コード変更なし）
   - Religo＝プロダクト / DragonFly＝チャプター / dragonfly＝内部名
   - SSOT: docs/PROJECT_NAMING.md
   - テスト不要
6. **Create pull request** → 続けて **Merge**（Squash and merge 推奨）

---

## Step C: マージ後のローカル確認

**PR をマージしたあと**、ローカルで以下を実行する：

```bash
cd /Users/tugi/docker/dragonfly   # リポジトリのパスに合わせて変更

git fetch --prune origin
git checkout develop
git pull origin develop

# 以下がすべて OK であることを確認
head -n 1 README.md
# → "# Religo" であること

test -f docs/PROJECT_NAMING.md && echo "OK"
# → OK と表示されること

git merge-base --is-ancestor origin/feature/religo-product-name origin/develop
echo $?
# → 0 であること（Religo が develop に含まれた状態）
```

---

## 確認できたら

- README 先頭が `# Religo`
- `docs/PROJECT_NAMING.md` が存在
- `merge-base --is-ancestor` が exit 0

の 3 つが満たされていれば、origin/develop に Religo（30f2673）が入った状態です。
