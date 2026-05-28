# PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION — PLAN

| 項目 | 内容 |
|------|------|
| Phase ID | AXIOS-SC-2026-03（呼称: `PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION`） |
| 種別 | docs（調査・記録のみ。アプリケーションコード変更なし） |
| 調査日 | 2026-04-01 |
| Related SSOT | 該当なし（npm 依存とインフラ記述の事実確認。製品仕様 SSOT 外） |

## 1. 調査目的

2026 年 3 月に報じられた **axios 系サプライチェーン侵害**（悪性 `postinstall`・`plain-crypto-js` 等を前提知識とする）に関し、**本リポジトリ（dragonfly / Religo 管理画面フロント）** が以下の観点で影響を受けていないかを、証拠ベースで洗い出す。

- ロックファイルおよび実インストール済みツリー上の **axios バージョン**
- **危険バージョン**（調査プロンプト指定: `axios@1.14.1`, `axios@0.30.4`）の有無
- **悪性パッケージ名**（`plain-crypto-js`）の痕跡
- **package.json / ロックファイル** における不審な `postinstall` 関連記述の有無（リポジトリ範囲）
- **IOC 文字列**（`sfrclak.com`、`:8000` を過度に規定しない範囲でのソース検索）
- **CI/CD**（GitHub Actions、Docker ビルドでの `npm install` / `npm ci`）

## 2. 対象範囲

| 範囲 | パス・備考 |
|------|------------|
| Node 定義 | `www/package.json`, `www/package-lock.json` |
| 他ロックファイル | リポジトリ内に `yarn.lock` / `pnpm-lock.yaml` **なし**（glob 確認） |
| ソース | リポジトリルート以下（`node_modules` はコンテナ内 `/var/www/node_modules` で別途確認） |
| インフラ | `infra/compose/docker-compose.yml`, `infra/docker/node/Dockerfile` |
| CI | `.github/workflows` — **本リポジトリには該当ディレクトリなし**（glob 確認） |

## 3. チェック項目一覧（DoD 対応）

1. `npm ls axios`（再現可能な実行環境: `dragonfly-node` コンテ、`/var/www`）
2. `package-lock.json` における `axios` の `resolved` / `version`
3. `axios@1.14.1` / `axios@0.30.4` の有無（ロック・ツリー）
4. `plain-crypto-js` の全文検索（リポジトリ + コンテナ内 `node_modules` のサンプル grep）
5. `www/package.json` の `scripts`（`postinstall` 等）
6. `package-lock.json` 内の `postinstall` 文字列の有無
7. `sfrclak.com` / `plain-crypto-js` のリポジトリ grep
8. Docker: Node イメージの起動コマンド・PHP イメージに npm の有無（この PLAN では compose / Dockerfile のみ）
9. GitHub Actions の有無
10. PLAN → WORKLOG → REPORT の完成、`docs/INDEX.md` / `PHASE_REGISTRY.md` 更新

## 4. 制約

- **コード変更禁止**（調査・ドキュメントのみ）
- 事実とログに基づき記載し、推測は書かない
- ローカルに存在しないログ（本番・外部 CI の実行履歴など）は **未確認** と明記

## 5. 完了条件（DoD）

- axios の影響有無が **SAFE / CAUTION / RISK** のいずれかで、根拠付きで結論できる
- 調査手順が WORKLOG により **再現可能**
- REPORT で意思決定（追加対応の要否）ができる
- tugilo 式ドキュメント（本 PLAN / WORKLOG / REPORT）と INDEX・REGISTRY が揃う
