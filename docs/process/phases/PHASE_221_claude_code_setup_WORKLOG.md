# PHASE_221 Claude Code セットアップ WORKLOG

tool: cursor

## 判断

### SSOT の単一化
- `.cursorrules` 全文を `CLAUDE.md` に複製せず、`docs/AI_TOOLING.md` を共通 SSOT にした。
- Cursor 入口（`.cursorrules`）と Claude Code 入口（`CLAUDE.md`）は短く保ち、詳細は AI_TOOLING を `@` 参照。

### Claude Code 設定
- `.claude/settings.json`: docker / make を allow、git push・reset --hard・ホスト composer・sed を deny/ask。`.cursorrules` 禁止事項と整合。
- Skills 3 本: phase-start（PLAN 前ゲート）、phase-finish（REPORT・merge 手順）、docker-artisan（コンテナコマンド定型）。

### gitignore
- `.claude/settings.local.json` を除外（個人 API キー・権限上書き用）。

## 実施内容

- `docs/AI_TOOLING.md` 新規
- `CLAUDE.md` 新規（100 行以内）
- `.claude/settings.json` + skills 3 本
- `.gitignore` / `.cursorrules` 更新
- INDEX / PHASE_REGISTRY / progress 更新

### 追補（2026-06-16 17:39 JST）

- Skills 9 本追加 + `.claude/skills/README.md`
- 既存 phase-start / phase-finish を他 Skill 参照に更新
- `CLAUDE.md` / `AI_TOOLING.md` に Skills 一覧追記
