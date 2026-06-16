# PHASE_221 Claude Code セットアップ PLAN

## Phase Type
docs

## Purpose
Cursor だけでなく Claude Code も同じ DevOS・SSOT・Git ルールで使えるよう、ツール非依存の AI 開発 SSOT と Claude Code 用入口（`CLAUDE.md` / `.claude/`）を整備する。

## Background
- 現状: `.cursorrules` + `.cursor/rules/devos-v4.mdc` は Cursor 向けのみ。`CLAUDE.md` / `.claude/` は未整備。
- 小中氏 1to1 等で Claude Code 活用の話題あり。二重管理を避け、SSOT を1か所に集約する方針。

## Related SSOT
- （新規）`docs/AI_TOOLING.md` — ツール非依存 AI 開発 SSOT
- `docs/PROJECT_NAMING.md` — 命名
- `docs/process/README.md` — Phase / 進捗ルール
- `docs/git/PRLESS_MERGE_FLOW.md` — PRレス merge
- `.cursor/rules/devos-v4.mdc` — DevOS v4.3（内容は AI_TOOLING から参照）

## Scope
- `docs/AI_TOOLING.md`（新規）
- `CLAUDE.md`（新規）
- `.claude/settings.json`（新規）
- `.claude/skills/`（phase-start / phase-finish / docker-artisan）
- `.gitignore`（Claude Code ローカル設定）
- `.cursorrules`（AI_TOOLING への参照1行追加）
- `docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md`
- Phase 221 PLAN / WORKLOG / REPORT

## Target Files
- 上記 Scope 内のみ

## Implementation Strategy
1. `docs/AI_TOOLING.md` に DevOS・Docker・Git・命名・禁止事項・ツール使い分けを集約（`.cursorrules` の重複を避け、相互参照）
2. `CLAUDE.md` は 100 行以内の薄い入口 + `@docs/...` 参照
3. `.claude/skills/` で Phase 開始・完了・Docker コマンドを Skill 化
4. `.claude/settings.json` で docker 許可・破壊的 git 禁止を `.cursorrules` と整合

## Tasks
- [x] PLAN 作成
- [ ] `docs/AI_TOOLING.md` 作成
- [ ] `CLAUDE.md` 作成
- [ ] `.claude/settings.json` + skills 作成
- [ ] `.gitignore` 更新
- [ ] `.cursorrules` に参照追加
- [ ] INDEX / progress / PHASE_REGISTRY 更新
- [ ] WORKLOG / REPORT 作成

## DoD
- [ ] `docs/AI_TOOLING.md` が DevOS・Docker・Git・命名をカバーしている
- [ ] `CLAUDE.md` が存在し、主要 SSOT へ `@` 参照している
- [ ] `.claude/skills/` に phase-start / phase-finish / docker-artisan がある
- [ ] `.claude/settings.json` で docker 許可・git push/reset 等を制御している
- [ ] `docs/INDEX.md` と `dragonfly_progress.md` を更新した
- [ ] Phase 221 PLAN / WORKLOG / REPORT が揃っている
