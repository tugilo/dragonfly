# Phase 319 REPORT — デプロイ先のフロントビルド Node を nvm 22 系にする

**作成:** 2026-10-24 07:38 JST  
**Phase Type:** refactor  
**Status:** in_progress

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

- Actions: （実行後に記録）

## DoDチェック

- [x] `nvm use 22`、無ければ exit 1
- [ ] Actions ログに `Node: v22.23.4` とビルド成功（実行後に記録）
- [x] INDEX / 進捗 / PHASE_REGISTRY 同期

---

## Merge Evidence

merge commit id: （develop merge 後に記録）  
source branch: feature/phase319-deploy-node22  
target branch: develop  
phase id: 319  
phase type: refactor  
related ssot: Spec ID なし（運用）

test command: スキップ（アプリコード変更なし。VPS デプロイで確認）  
test result: （Actions 実行後に記録）

scope check: OK  
ssot check: OK  
dod check: （Actions 確認後に記録）
