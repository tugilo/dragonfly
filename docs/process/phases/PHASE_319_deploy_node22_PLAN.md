# Phase 319 PLAN — デプロイ先のフロントビルド Node を nvm 22 系にする

**作成:** 2026-10-24 07:38 JST  
**Phase Type:** refactor（`.github/workflows/deploy.yml` のみ。アプリコード変更なし）  
**Branch:** `feature/phase319-deploy-node22`  
**Related SSOT:** Spec ID なし（運用）。Tugilo OS `docs/operations/nodejs-security-20261021-REPORT.md`（TASK-20261024-001）

---

## Purpose

Node.js 公式のセキュリティリリース（2026-10-21。修正版 22.23.4 / 24.22.1 / 26.12.1。20 系は EOL で修正が来ない）を受け、さくら VPS（religo_dev / religo_app）でのフロントビルド（vite 7）に使う Node を nvm の 20.19.5 から **22 系（22.23.4 以上）** にする。

## 背景

deploy.yml は `nvm use 20 2>/dev/null || true` で 20 を選び、失敗しても黙って続ける。VPS の nvm には 2026-10-24 00:46 JST に 22.23.4 を追加済み（default 22）。同一 VPS の stamp / tugilo_site / protectlab は本日 22 へ切り替え済み。

---

## Scope

変更可能範囲は次のファイルのみ。

- `.github/workflows/deploy.yml`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_319_deploy_node22_{PLAN,WORKLOG,REPORT}.md`

対象外: `www/` 全体（`package.json`、`vite.config.js` を含む）、ローカル Docker の `versions.env`（NODE_VERSION=20。別 Phase）、VPS の nvm 20 / apt nodejs、main への反映（develop デプロイ成功を見てから別判断）。

---

## DoD

- deploy.yml の `nvm use` が 22 で、22 が無ければ exit 1 で止まる。
- develop デプロイ（Actions）のログに `Node: v22.23.4` があり、`npm run build` が成功している。
- INDEX / 進捗 / PHASE_REGISTRY を同期する。
- アプリコード変更なしのため Laravel テスト・React ビルドはローカルで実行しない（VPS のビルドで確認）。

---

## Tasks

1. deploy.yml を変更する。
2. INDEX・進捗・PHASE_REGISTRY・REPORT を更新する。
3. develop へ merge → 1 push。Actions の結果を REPORT に記録する。

## 事前確認（VPS、2026-10-24 00:47 JST）

`religo_dev` で `nvm use 22`（22.23.4）、`NODE_OPTIONS=--max-old-space-size=4096 npx vite build --outDir /tmp/...` が 12.51 秒で成功（Tugilo OS EVD-20261024-003）。
