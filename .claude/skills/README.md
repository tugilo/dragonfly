# Claude Code Skills（dragonfly / Religo）

リポジトリルートで `claude` を起動し、`/skill-name` で呼び出す。

## Phase ライフサイクル

| Skill | コマンド | 用途 |
|-------|----------|------|
| phase-start | `/phase-start` | Phase 開始・PLAN/WORKLOG/REPORT 作成 |
| ssot-lookup | `/ssot-lookup` | 実装前の SSOT 参照 |
| implement-checklist | `/implement-checklist` | implement 前後のチェックリスト |
| phase-finish | `/phase-finish` | Phase 完了・REPORT・registry 更新 |
| commit-phase | `/commit-phase` | コミット（明示依頼時のみ） |
| merge-develop | `/merge-develop` | develop への PRレス merge |
| docs-sync | `/docs-sync` | INDEX・進捗・日時更新 |

## 開発・インフラ

| Skill | コマンド | 用途 |
|-------|----------|------|
| docker-artisan | `/docker-artisan` | コンテナ内 artisan / compose |
| react-build | `/react-build` | React ビルド（JS 変更後必須） |
| mock-ui-verify | `/mock-ui-verify` | 管理画面とモックの比較 |

## データ・DB

| Skill | コマンド | 用途 |
|-------|----------|------|
| import-religo | `/import-religo` | 議事録・1to1・CSV → DB |
| db-sync | `/db-sync` | db-export/import/pull/push |

## 参照

- 共通 SSOT: `docs/AI_TOOLING.md`
- 入口: `CLAUDE.md`
