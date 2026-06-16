# AI 開発ツール SSOT（Cursor / Claude Code 共通）

**目的:** Cursor と Claude Code の両方が同じルールで開発できるよう、ツール非依存の手順・制約を1か所に集約する。  
**作成:** 2026-06-16  
**関連:** [PROJECT_NAMING.md](PROJECT_NAMING.md) · [process/README.md](process/README.md) · [git/PRLESS_MERGE_FLOW.md](git/PRLESS_MERGE_FLOW.md)

---

## 1. ツール入口（重複を避ける）

| ツール | 入口ファイル | 役割 |
|--------|-------------|------|
| **Cursor** | `.cursorrules` + `.cursor/rules/devos-v4.mdc` | IDE 統合・React UI・MCP ブラウザ |
| **Claude Code** | `CLAUDE.md` + `.claude/skills/` | ターミナル中心・横断リファクタ・長時間 implement |

**詳細ルールは本ファイル（`docs/AI_TOOLING.md`）を正とする。** 各入口ファイルは短く保ち、ここを参照する。

---

## 2. 命名（必須）

| 名称 | 意味 |
|------|------|
| **Religo** | プロダクト名 |
| **DragonFly** | BNI チャプター名（プロダクト名ではない） |
| **dragonfly** | リポジトリ・Docker・内部識別子 |

詳細: [PROJECT_NAMING.md](PROJECT_NAMING.md)

---

## 3. プロジェクト構成

- Laravel アプリ: **`www/`** 直下（`app/`, `routes/`, `config/` 等）
- Docker: **`infra/compose/docker-compose.yml`** + ルートの **`project.env`**
- ドキュメント: **`docs/`**
- Phase 詳細: **`docs/process/phases/`**

---

## 4. DevOS v4.3（全 AI ツール共通）

### 4.1 Phase 開始前（省略禁止）

1. [SSOT_REGISTRY.md](02_specifications/SSOT_REGISTRY.md) で関連仕様を特定
2. [PHASE_REGISTRY.md](process/PHASE_REGISTRY.md) で次 Phase 番号を取得
3. 種別（`docs` / `implement` / `refactor`）を決定
4. Scope と DoD を PLAN に明記
5. **PLAN 完成前は実装を開始しない**

### 4.2 Phase 成果物

```
docs/process/phases/PHASE_XXX_name_PLAN.md
docs/process/phases/PHASE_XXX_name_WORKLOG.md
docs/process/phases/PHASE_XXX_name_REPORT.md
```

- WORKLOG: 「いつ」より **「何を判断してどう実装したか」**
- WORKLOG に `tool: cursor | claude-code` を1行記載（推奨）
- REPORT: Merge Evidence 必須（[テンプレート](process/templates/PHASE_REPORT_TEMPLATE.md)）

### 4.3 Scope

| 種別 | 変更可能 |
|------|----------|
| docs | `docs/**`, `.cursor/**`, `.cursorrules`, `CLAUDE.md`, `.claude/**` |
| implement | `www/**`, `docs/**`, 上記 docs 系 |
| refactor | PLAN で明示したファイルのみ |

`package.json` / `composer.json` の変更は **人間の承認後のみ**。

### 4.4 安全装置（検出時は作業停止）

- Scope 違反 → REPORT に記録 → 人間に確認
- SSOT 不明 / DoD 未定義 / Phase ID 未確認 → 作業停止

---

## 5. Docker コマンド（このディレクトリで実行）

```bash
# コンテナ起動
docker compose -f infra/compose/docker-compose.yml --env-file project.env up -d

# マイグレーション
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan migrate

# テスト（implement Phase 完了前）
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test

# Composer（コンテナ内のみ）
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app composer require ...

# フロントビルド（React 変更後は必須）
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node npm run build
```

### Makefile（DB 同期など）

```bash
make doctor      # 環境診断
make db-export   # ローカル DB → www/database/sync/dragonfly.sql
make db-import   # sync SQL → ローカル DB
make db-pull TARGET=prod   # 本番 → ローカル（要 SSH）
make db-push TARGET=prod   # ローカル → 本番（要確認・自動バックアップ）
```

---

## 6. 禁止事項

- ホスト側での `composer` 実行
- `sed` の使用（Mac/Linux 差異防止）
- `.env` の手動編集（必要時は PHP スクリプト）
- バージョン番号の直書き（`versions.env` に定義）
- **PR 作成の提案**（PRレス運用）

---

## 7. Git（PRレス運用）

- feature ブランチ: `feature/phaseXXX-name`
- **develop への直接コミット禁止**（docs の軽微追記のみ例外可）
- 取り込み: ローカル merge（`--no-ff`）→ test → `git push origin develop`
- merge 後 REPORT に取り込み証跡を記録

```bash
git checkout develop && git pull origin develop
git merge --no-ff feature/phaseXXX-name -m "Merge feature/phaseXXX-name into develop"
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test
git push origin develop
```

詳細: [git/PRLESS_MERGE_FLOW.md](git/PRLESS_MERGE_FLOW.md)

---

## 8. ドキュメント・進捗

- 進捗: **`docs/dragonfly_progress.md`**
- INDEX: **`docs/INDEX.md`**（docs 追加・変更時は必ず更新）
- 日時: **JST・時刻まで**（`TZ=Asia/Tokyo date '+%Y-%m-%d %H:%M JST'`）

---

## 9. UI 実装時（Cursor 推奨）

- モック SSOT: `http://localhost/mock/religo-admin-mock.html`
- UI Phase の PLAN に「モック比較: [MOCK_UI_VERIFICATION.md](SSOT/MOCK_UI_VERIFICATION.md)」を記載
- 実装後: [FIT_AND_GAP_MOCK_VS_UI.md](SSOT/FIT_AND_GAP_MOCK_VS_UI.md) に差分記録

---

## 10. ツール使い分け（推奨）

| 用途 | 推奨ツール |
|------|-----------|
| React 管理画面・モック比較 | Cursor |
| 大規模リファクタ・横断変更・import 整備 | Claude Code |
| Phase PLAN / docs 整備 | どちらでも |
| merge / push | 人間確認（または Skill 手順に従う） |

**原則:** 1 Phase = 1 ツール（または PLAN=Cursor → implement=Claude Code → UI 仕上げ=Cursor）

---

## 11. Claude Code 固有

- 入口: リポジトリルートの **`CLAUDE.md`**
- Skills: **`.claude/skills/`** — `/skill-name` で呼び出し（一覧: `.claude/skills/README.md`）
- 権限: **`.claude/settings.json`**（チーム共有）/ **`.claude/settings.local.json`**（個人・gitignore）
- 実装前: **Plan モード**で方針提示 → DevOS の PLAN と整合させる

### Skills 一覧

| カテゴリ | Skill | 用途 |
|----------|-------|------|
| Phase | `phase-start` | PLAN/WORKLOG/REPORT 作成 |
| Phase | `ssot-lookup` | SSOT 参照 |
| Phase | `implement-checklist` | implement 前後チェック |
| Phase | `phase-finish` | 完了・REPORT |
| Phase | `commit-phase` | コミット（明示依頼時） |
| Phase | `merge-develop` | PRレス merge |
| Phase | `docs-sync` | INDEX・進捗 |
| 開発 | `docker-artisan` | コンテナコマンド |
| 開発 | `react-build` | フロントビルド |
| 開発 | `mock-ui-verify` | モック比較 |
| データ | `import-religo` | 議事録・CSV 取込 |
| データ | `db-sync` | DB 同期 |

---

## 変更履歴

| 日時 (JST) | 内容 |
|------------|------|
| 2026-06-16 17:39 JST | Claude Code Skills 拡充（ssot-lookup, merge-develop, docs-sync, import-religo, db-sync, react-build, commit-phase, implement-checklist, mock-ui-verify）。 |
| 2026-06-16 17:36 JST | 初版（Phase 221） |
