# PHASE_221 Claude Code セットアップ REPORT

**完了日:** 2026-06-16 17:55 JST  
**Phase Type:** docs  
**Related SSOT:** `docs/AI_TOOLING.md`（新規）

## 実施内容

- **AI 開発 SSOT:** `docs/AI_TOOLING.md` — Cursor / Claude Code 共通の DevOS・Docker・Git・命名・禁止事項・Skills 一覧
- **Claude Code 入口:** リポジトリルート `CLAUDE.md`（薄い参照 + コマンド + Skills 一覧）
- **Claude Code 設定:** `.claude/settings.json`（権限）、`.claude/skills/`（12 Skill + README）
- **Cursor 連携:** `.cursorrules` に AI_TOOLING 参照を追加
- **gitignore:** `.claude/settings.local.json` 等を除外

### Skills（12 本）

| Skill | 用途 |
|-------|------|
| phase-start | Phase 開始・PLAN 作成 |
| ssot-lookup | SSOT 参照 |
| implement-checklist | implement 前後チェック |
| phase-finish | Phase 完了 |
| commit-phase | コミット（明示依頼時） |
| merge-develop | PRレス merge |
| docs-sync | INDEX・進捗更新 |
| docker-artisan | コンテナコマンド |
| react-build | フロントビルド |
| mock-ui-verify | モック比較 |
| import-religo | 議事録・CSV 取込 |
| db-sync | DB 同期 |

## 変更ファイル一覧

```
.claude/settings.json
.claude/skills/README.md
.claude/skills/commit-phase/SKILL.md
.claude/skills/db-sync/SKILL.md
.claude/skills/docker-artisan/SKILL.md
.claude/skills/docs-sync/SKILL.md
.claude/skills/implement-checklist/SKILL.md
.claude/skills/import-religo/SKILL.md
.claude/skills/merge-develop/SKILL.md
.claude/skills/mock-ui-verify/SKILL.md
.claude/skills/phase-finish/SKILL.md
.claude/skills/phase-start/SKILL.md
.claude/skills/react-build/SKILL.md
.claude/skills/ssot-lookup/SKILL.md
.cursorrules
.gitignore
CLAUDE.md
docs/AI_TOOLING.md
docs/INDEX.md
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_221_claude_code_setup_PLAN.md
docs/process/phases/PHASE_221_claude_code_setup_WORKLOG.md
docs/process/phases/PHASE_221_claude_code_setup_REPORT.md
```

## テスト結果

docs フェーズのためスキップ

## DoD チェック

- [x] `docs/AI_TOOLING.md` が DevOS・Docker・Git・命名をカバー
- [x] `CLAUDE.md` が存在し SSOT へ参照
- [x] `.claude/skills/` に 12 Skill + README
- [x] `.claude/settings.json` で権限制御
- [x] INDEX / progress / PHASE_REGISTRY 更新
- [x] PLAN / WORKLOG / REPORT 完備

## 取り込み証跡（develop への反映後）

| 項目 | 内容 |
|------|------|
| **commit id** | `23f590f` |
| **ブランチ** | develop（docs Phase・直接コミット） |
| **phase id** | 221 |
| **phase type** | docs |
| **related ssot** | docs/AI_TOOLING.md（新規） |
| **test result** | スキップ（docs） |
| **scope check** | OK |
| **ssot check** | OK |
| **dod check** | OK |

## 次ステップ（Step 2: パイロット）

1. リポジトリルートで `claude` を起動し `/phase-start` で Phase 開始を確認
2. 小さな implement Phase を Claude Code 単独で実行
3. WORKLOG に `tool: claude-code` を記録
