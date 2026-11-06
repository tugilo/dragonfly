# Phase 319 REPORT — デプロイ先のフロントビルド Node を nvm 22 系にする

**作成:** 2026-10-24 07:38 JST  
**Phase Type:** refactor  
**Status:** completed（develop merge 済み 2026-10-24 07:39 JST。main 反映は別途）

---

## 実施内容

- さくら VPS でのフロントビルドに使う Node を nvm の 20.19.5（EOL）から 22 系（22.23.4）へ切り替えた。
- 失敗を握りつぶしていた `|| true` を外し、22 が無ければデプロイを止めるようにした。
- アプリコードは変えていない。

## 変更ファイル一覧

- `.github/workflows/deploy.yml`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_319_deploy_node22_{PLAN,WORKLOG,REPORT}.md`

## テスト結果

アプリコード変更なしのため `php artisan test` と React ビルドはローカルでスキップ。develop デプロイの Actions で確認する。

- Actions: run 40034988234（Deploy Religo to Sakura VPS, develop, success, 1m35s）。VPS ログ `Now using node v22.23.4 (npm v10.9.9)`、`Node: v22.23.4 npm: 10.9.9`、vite `✓ built in 12.71s`（2026-10-24 07:41 JST 確認）

## DoDチェック

- [x] `nvm use 22`、無ければ exit 1
- [x] Actions ログに `Node: v22.23.4` とビルド成功（run 40034988234）
- [x] INDEX / 進捗 / PHASE_REGISTRY 同期

---

## Merge Evidence

merge commit id: 2274666540617d14119581ef4281e36beac6a4d5  
source branch: feature/phase319-deploy-node22  
target branch: develop  
phase id: 319  
phase type: refactor  
related ssot: Spec ID なし（運用）

test command: スキップ（アプリコード変更なし。VPS デプロイで確認）  
test result: develop デプロイ success。Node v22.23.4、vite ✓ built in 12.71s

scope check: OK  
ssot check: OK  
dod check: OK
