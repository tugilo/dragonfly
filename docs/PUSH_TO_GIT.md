# Git へプッシュする手順

リモートリポジトリはまだ作成していない前提です。

## 1. リモートリポジトリを作成する

- **GitHub**: https://github.com/new で「tugilo-template」などで New repository 作成（README / .gitignore / license は追加しない）
- **GitLab**: 新規プロジェクト作成
- **Bitbucket**: 新規リポジトリ作成

## 2. リモートを追加してプッシュする

作成したリポジトリの URL を `YOUR_REPO_URL` に置き換えて実行してください。

```bash
cd /Users/tugi/docker/tugilo-template

# リモート追加（1回だけ）
git remote add origin YOUR_REPO_URL

# 例: GitHub
# git remote add origin https://github.com/あなたのユーザ名/tugilo-template.git
# または SSH
# git remote add origin git@github.com:あなたのユーザ名/tugilo-template.git

# プッシュ
git push -u origin main
```

## 3. 確認

- ブラウザでリモートのページを開き、`Makefile`, `bin/`, `infra/`, `docs/` などが反映されていることを確認する。

## 注意

- `project.env` と `.env` は `.gitignore` に入っているためプッシュされません（そのままで問題ありません）。
- 既に `origin` がある場合は `git remote set-url origin YOUR_REPO_URL` で変更できます。
