# PHASE_301_participants_pdf_csv_cursor_skill PLAN

| 項目 | 内容 |
|------|------|
| **Phase ID** | 301 |
| **Name** | 参加者PDF→CSV→ローカル取込（Cursorスキル） |
| **Phase Type** | **docs** |
| **Status** | completed |
| **Branch** | develop 直コミット（docs 軽微追記例外） |
| **作成** | 2026-08-17 21:44 JST |

## Purpose

定例会参加者 PDF から full CSV を作成し、既存 CLI でローカル DB に取り込むまでの手順を **Cursor スキル**として固定する。Religo 製品に LLM / 新 Artisan は載せない。

## Related SSOT

| ID / 文書 | 内容 |
|-----------|------|
| （新 SPEC なし） | Religo 製品機能ではない |
| CSV 要件 | [MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md) §13 運用 |
| PDF 要件 | [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md) |
| SPEC-007 | [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](../../SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md) |

## Scope

| パス | 内容 |
|------|------|
| `.claude/skills/participants-pdf-csv/SKILL.md` | 新規スキル |
| `.claude/skills/import-religo/SKILL.md` | PDF→CSV 導線追記 |
| `.claude/skills/README.md` | スキル一覧 |
| `docs/SSOT/MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md` | §13 運用節 |
| `docs/process/phases/PHASE_301_*` | PLAN / WORKLOG / REPORT |
| `docs/process/PHASE_REGISTRY.md` | Phase 301 |
| `docs/INDEX.md` / `docs/dragonfly_progress.md` | 索引・進捗 |
| `CLAUDE.md` / `AGENTS.md` | スキル1行 |

**変更しない:** `www/**`（第218回 CSV 取込は既存 CLI のみ。コード変更なし）

## DoD

- [x] `/participants-pdf-csv` スキルで第218回と同品質の手順が再現可能
- [x] SSOT に「PDF=候補 / CSV=正 / 確定=人 / 取込=CLI」と明記
- [x] 第218回をローカル取込済み（75名・meeting id=34）
- [x] PHASE_REGISTRY / INDEX / 進捗更新

## モック比較

対象外（管理画面 UI 変更なし）
