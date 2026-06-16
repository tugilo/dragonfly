---
name: commit-phase
description: Create a git commit for dragonfly phase work safely. Use when user asks to commit. Never commit unless explicitly requested. Follows project commit message style and safety rules.
---

# Phase コミット（明示依頼時のみ）

## 重要

- **ユーザーが明示的にコミットを依頼した場合のみ** 実行
- 依頼が曖昧なら確認してから進める
- `git push` は別途明示依頼がある場合のみ

## 事前確認（並列実行）

```bash
git status
git diff
git log -5 --oneline
```

## コミットメッセージ

- 1〜2 文、**why** を中心に
- Phase 単位なら `Phase XXX: 概要` 形式も可
- HEREDOC で渡す:

```bash
git add <relevant files>
git commit -m "$(cat <<'EOF'
Phase XXX: 変更の目的を1文で。

EOF
)"
git status
```

## 含めないもの

- `.env` / `project.env` / 秘密情報
- 意図しない untracked ファイル

## 禁止

- `git commit --amend`（例外: ユーザー明示 + 直前コミットが自分 + 未 push）
- `--no-verify` / `--no-gpg-sign`（ユーザー明示時のみ）
- `git push --force`（main/master では特に警告）

## Phase 完了との関係

コミット後も `/phase-finish` の手順（REPORT・merge evidence）を完了する。
