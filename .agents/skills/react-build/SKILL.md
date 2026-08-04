---
name: react-build
description: Build React frontend after changing www/resources/js in dragonfly. Use after any JSX/JS/CSS admin UI changes. Required before phase completion.
---

# React ビルド（必須）

## いつ実行するか

`www/resources/js/` 以下を変更した **すべての implement Phase** の完了前。

## コマンド

```bash
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node npm run build
```

## 失敗時

- エラーを解消してから Phase 完了とする
- REPORT に build 成功を記録

## 関連

- モック SSOT: `http://localhost/mock/religo-admin-mock.html`
- UI Phase: `/mock-ui-verify` Skill も参照
- 実体: `www/public/mock/religo-admin-mock.html`

## PLAN 記載

UI を触る Phase の PLAN に以下を含める:

```
モック比較: docs/SSOT/MOCK_UI_VERIFICATION.md に従う
```
