# PHASE_301_participants_pdf_csv_cursor_skill REPORT

| 項目 | 内容 |
|------|------|
| **Phase ID** | 301 |
| **完了日** | 2026-08-17 21:44 JST |
| **Type** | docs |

## 実施内容

- Cursor スキル `.claude/skills/participants-pdf-csv/SKILL.md` を新規作成（Grok/Composer で PDF→CSV、CLI で取込）
- `import-religo` スキル・README・CLAUDE.md / AGENTS.md から導線追加
- [MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md) §13 運用節を追加
- 第218回 CSV をローカル DB に取込（meeting id=34・75 participants）
- PHASE_REGISTRY / INDEX / dragonfly_progress 更新

## 第218回 取込証跡

| 項目 | 内容 |
|------|------|
| CSV | `docs/pdf/260817/religo_218_20260818_full.csv` |
| CLI | `dragonfly:import-participants-csv 218 ... --held_on=2026-08-18` |
| meeting id | 34 |
| participants | 75（メンバー57・ビジター13・ゲスト5） |
| guest→member 二重 | 横山　大樹・福島　和也・佐藤　久（各2行・SPEC-007 想定内） |
| 本番 push | 実施済み（2026-08-20 15:04 JST・`db-push TARGET=prod`。backup `backups/prod_20260820_150420.sql`） |

## テスト

- docs Phase のため `php artisan test` スキップ

## DoD

| 項目 | 結果 |
|------|------|
| スキルで手順再現可能 | OK |
| SSOT 運用節 | OK |
| Religo コード変更なし | OK |
| 第218回ローカル取込 | OK |

## scope / ssot / dod check

- scope check: OK
- ssot check: OK（新 SPEC なし・既存 CSV/PDF 要件に運用節追加）
- dod check: OK

## Merge Evidence

（develop merge 後に追記）
