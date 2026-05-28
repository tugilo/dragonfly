# PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION — WORKLOG

調査実施日: **2026-04-01**  
環境: ホスト macOS、Docker Compose（`infra/compose/docker-compose.yml`, `project.env`）

## 判断・方針

- ロックファイル（`package-lock.json`）を **単一の真実** とし、`npm ls` でツリーと突合した。
- `yarn.lock` / `pnpm-lock.yaml` はリポジトリに存在しないため **調査対象外（該当なし）**。
- `node_modules` は git 管理外のため、**コンテナ内**で `axios` の `package.json` と `plain-crypto-js` grep を実施した。
- 本番・GitHub 上の CI 実行ログは **この WORKLOG では取得していない**（未確認）。

---

## STEP1 — 依存関係の完全調査

### 1.1 ロックファイルの所在

- リポジトリ検索結果: `www/package-lock.json` **のみ**（ルートに他 npm ロックなし）
- `yarn.lock`, `pnpm-lock.yaml`: **リポジトリ内にファイルなし**（glob 検索）

### 1.2 package.json（宣言）

ファイル: `www/package.json`

- `devDependencies["axios"]`: `^1.11.0`
- `scripts`: `build`, `dev` のみ（`postinstall` なし）

### 1.3 package-lock.json（固定解決）

`www/package-lock.json` 抜粋（証拠）:

- `packages["node_modules/axios"].version`: **1.13.6**
- `resolved`: `https://registry.npmjs.org/axios/-/axios-1.13.6.tgz`
- `integrity`: `sha512-ChTCHMouEe2kn713WHbQGcuYrr6fXTBiu460OTwWrWob16g1bXn4vtz07Ope7ewMozJAnEquLk5lWQWtBig9DQ==`

依存経路: **ルートパッケージ `www@` の直接 devDependency**（他パッケージ経由のネストした axios は `npm ls` 出力上明示なし）。

### 1.4 実行コマンド: `npm ls axios`

実行（`dragonfly-node` コンテナ内、`/var/www`）:

```bash
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node sh -c 'cd /var/www && npm ls axios'
```

出力（原文）:

```text
www@ /var/www
`-- axios@1.13.6
```

---

## STEP2 — 危険バージョンの検出

対象: `axios@1.14.1`, `axios@0.30.4`

- `package-lock.json` 内で `axios-1.14.1` / `axios-0.30.4` の **resolved 行**: **なし**（パターン grep）
- `npm ls axios`: **1.13.6 のみ**

**判定**: 当該「感染リスクあり」とされる 2 バージョンは **ロックおよびインストールツリーに存在しない**。

---

## STEP3 — 悪性パッケージ痕跡（plain-crypto-js）

### 3.1 リポジトリ（ソース・docs 含む）

```bash
# ツール相当: workspace 全体 grep
pattern: plain-crypto-js
```

結果: **マッチなし**

### 3.2 コンテナ内 node_modules

```bash
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node sh -c 'grep -r "plain-crypto-js" /var/www/node_modules 2>/dev/null | head -5'
```

結果: **出力なし**（ヒットなし）

---

## STEP4 — postinstall 関連

- `www/package.json` の `scripts`: **`postinstall` なし**（`build`, `dev` のみ）
- `www/package-lock.json` 全体に **`postinstall` 文字列なし**（grep 結果 0 件）

※ npm のライフサイクルスクリプトは各パッケージの `package.json` にも存在しうるが、本調査では **ロックファイルに script セクションを保持していない形式** のため、ロック上の集約検索は上記に限る。実体として `node_modules` 内の全パッケージを人力走査はしていない（**ロック + 直接インストール axios の version 確認**でリスク版を否定）。

---

## STEP5 — 通信先・IOC（リポジトリ範囲）

| 検索 | 結果 |
|------|------|
| `sfrclak.com` | **マッチなし** |
| `:8000` | `docs/process/PHASE_TEMPLATE_STANDARDIZE_ALL_PROJECTS_REPORT.md` に **Laravel 例としての** `http://localhost:8000` の記述 **1 件**（IOC とは無関係なドキュメント例と判断） |

**アプリログ / CI ログ / サーバーログ**: 本 Phase では **未収集（未確認）**。

---

## STEP6 — CI/CD

| 項目 | 結果 |
|------|------|
| `.github/**/*.yml` | **0 件**（GitHub Actions ワークフローなし） |
| `infra/docker/node/Dockerfile` | `FROM node:…-alpine`, `WORKDIR /var/www` のみ。**npm install を Dockerfile 内で実行していない** |
| `infra/compose/docker-compose.yml`（`node` サービス） | `command: ["tail", "-f", "/dev/null"]`。ビルドは開発者がコンテナ内で `npm run build` 等を実行する運用 |
| `infra/` に `npm ci` / `npm install` の記述 | **grep ヒットなし** |

**解釈（事実のみ）**: リポジトリに同梱された CI 定義はなく、Dockerfile も npm install を自動実行しない。実際の `npm install` 実行日時（3/31 前後）は **このリポジトリからは断定不可（未確認）**。

---

## STEP7 — 実体 axios の確認（node_modules）

```bash
docker compose … exec node sh -c 'node -p "require(\"/var/www/node_modules/axios/package.json\").version"'
```

出力: `1.13.6`

`node_modules/axios/package.json` の mtime（コンテナ表示）: **Mar 17 10:52**（参考情報。感染判定には使わず、ツリーの陳腐化目安）

---

## ステータス

- WORKLOG 記録完了 → REPORT に結論（SAFE と根拠）を集約する。
