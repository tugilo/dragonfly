# PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION — REPORT

| 項目 | 内容 |
|------|------|
| Phase ID | AXIOS-SC-2026-03 |
| 種別 | docs（調査のみ） |
| 調査日 | 2026-04-01 |
| 結論レベル | **SAFE** |

---

## 1. 結論

**SAFE** — 調査時点で、リポジトリの npm ロックおよび `dragonfly-node` コンテナ内のインストールツリーにおいて、対象とされた危険バージョン **`axios@1.14.1` / `axios@0.30.4` は使用されていない**。`axios` は **1.13.6** に固定されている。リポジトリおよびコンテナ内 `node_modules` のサンプル検索で **`plain-crypto-js` / `sfrclak.com` の痕跡は見つからない**。

---

## 2. 根拠（証拠ベース）

### 2.1 axios バージョン

| 証拠源 | 値 |
|--------|-----|
| `www/package-lock.json` → `node_modules/axios` | version **1.13.6**, resolved `axios-1.13.6.tgz` |
| `npm ls axios`（コンテナ `/var/www`） | `axios@1.13.6`（直接依存） |
| `require('.../node_modules/axios/package.json').version` | **1.13.6** |

### 2.2 依存経路

- **直接依存**: `www/package.json` の `devDependencies` に `axios: ^1.11.0`
- **ロック解決**: 上記レンジの結果として **1.13.6** が選択されている
- **間接依存**: `npm ls axios` 上、子依存としての別バージョン axios は表示されず

### 2.3 危険バージョン

- `axios@1.14.1`, `axios@0.30.4`: ロックファイルおよび `npm ls` に **存在しない**

### 2.4 悪性パッケージ / IOC（リポジトリ + node_modules grep）

| 検索対象 | 結果 |
|----------|------|
| `plain-crypto-js` | **ヒットなし**（リポ全体 + コンテナ `node_modules`） |
| `sfrclak.com` | **ヒットなし** |
| `:8000` | ドキュメント内の localhost 例 **1 件のみ**（別文脈） |

### 2.5 postinstall（リポジトリ範囲）

- `www/package.json`: **`postinstall` スクリプトなし**
- `www/package-lock.json`: 文字列 `postinstall` **0 件**

---

## 3. リスク評価

| 環境 | 評価 | コメント |
|------|------|----------|
| 開発（ロック + 現行コンテナツリー） | **低** | axios **1.13.6**。危険版・悪性パッケージ名の痕跡なし（上記調査範囲） |
| CI（GitHub Actions） | **未確認** | リポジトリに `.github/workflows` **なし**。別ホストの CI があれば当 REPORT の外 |
| 本番 | **未確認** | デプロイ手順・本番イメージの npm 層は本リポジトリだけでは追跡不可。ロックを本番ビルドにコミット利用しているなら **1.13.6 想定** |

---

## 4. 必要対応（現時点）

- **バージョンダウン**: 不要（危険版は未使用）。将来 `npm update` で **1.14.1 へ上がらないよう**、`package-lock.json` を維持し、公式アドバイザリに従って pin / 除外を検討する程度。
- **トークンローテーション / 再デプロイ**: 本調査だけでは「侵害発生」を示さないため **必須とは言えない**。組織ポリシーでサプライチェーン週知時に実施するなら那是運用判断。
- **追加推奨（オプション）**: `npm audit` の定期実行、`npm ci` と lockfile の厳格運用（既に lock あり）。

---

## 5. 再発防止

| 策 | 備考 |
|----|------|
| lockfile 固定 | 既に `package-lock.json` をコミット。`npm install` より **`npm ci`** を CI（導入時）で使うと再現性が上がる |
| npm audit | 定期・PR 前の実行を推奨（本リポジトリに GH Actions 未設定） |
| CI 検証 | ワークフロー追加時に **`npm ci` + audit** を検討 |
| 依存の直接宣言の棚卸し | `axios` は devDependency かつ Laravel 標準の `bootstrap.js` で利用。将来メジャー更新時は **解決バージョンを lock で確認** |

---

## 6. 制約・未確認事項

- **本番・外部 CI の実行ログ・npm キャッシュ**: 未確認
- **過去に危険版を一時的に入れた履歴**: git 履歴の npm-lock 差分は本 REPORT では未スキャン（必要なら `git log -p www/package-lock.json` で別途確認可能）
- **全 node_modules パッケージの各 package.json scripts の人手監査**: 未実施（ロック構造上、リスク版 axios が無いことは確認済み）

---

## 7. Merge Evidence（取り込み）

本 Phase は **ドキュメント調査のみ**（アプリコード変更なし）。feature → develop の merge は **対象外**。必要であれば docs のみのコミットで完結する。

| 項目 | 値 |
|------|-----|
| merge commit id | （該当なし） |
| source branch | （該当なし・または docs 直コミット方針はプロジェクトルールに従う） |
| test command | （実施対象外） |
| test result | スキップ（調査のみ） |
| changed files | `docs/process/phases/PHASE_AXIOS_SUPPLY_CHAIN_*.{md}`, `docs/INDEX.md`, `docs/process/PHASE_REGISTRY.md`, `docs/dragonfly_progress.md` |
| scope check | OK（docs のみ） |
| ssot check | OK（製品 SSOT 変更なし） |
| dod check | OK |

---

## 8. 参照

- PLAN: [PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_PLAN.md](./PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_PLAN.md)
- WORKLOG: [PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_WORKLOG.md](./PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_WORKLOG.md)
