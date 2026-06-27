# Phase 268 REPORT — グローバル Owner セレクタ廃止（ログインユーザー固定）

**完了:** 2026-06-27 12:24 JST  
**Phase Type:** implement  
**Branch:** `feature/phase268-remove-global-owner-selector`  
**Related SSOT:** SPEC-020 §10 / §11.6 順位 7  
**Status:** completed  

---

## 成果

グローバルヘッダーの Owner プルダウン（admin 用 Select・member 用表示専用ラベル）を廃止し、Owner をログインユーザー（`/api/users/me`）に固定した。各画面のデータスコープは `ReligoOwnerContext` 経由で従来どおり動作する。

- `CustomAppBar`: Owner 切替 UI と関連 import / state / ハンドラを削除。
- `ReligoLayout`: owner 未設定時の案内を「メンバー紐付けが必要」へ更新（Owner 選択前提の文言を撤去）。

---

## DoD 達成

- [x] ヘッダーに Owner プルダウン・表示専用ラベルが出ない（ブラウザ確認済み）
- [x] Owner はログインユーザー固定・各画面スコープ従来どおり
- [x] `npm run build` 成功
- [x] `php artisan test` 全 pass（567 passed / 2086 assertions）

---

## Merge Evidence

merge commit id: 8982140df24a3e76603bcbf6f4f4f8fc01aeda62  
source branch: feature/phase268-remove-global-owner-selector  
target branch: develop  
phase id: 268  
phase type: implement  
related ssot: SPEC-020  

test command: php artisan test  
test result: 567 passed (2086 assertions)  

changed files:
- www/resources/js/admin/CustomAppBar.jsx
- www/resources/js/admin/ReligoLayout.jsx
- docs/process/phases/PHASE_268_*
- docs/process/PHASE_REGISTRY.md / docs/INDEX.md / docs/dragonfly_progress.md

scope check: OK  
ssot check: OK（ヘッダー Owner 切替廃止・ログインユーザー固定で SPEC-020 §10 と整合）  
dod check: OK  

### main 反映

main merge commit id: <fill-main>  
target branch: main  
備考: ユーザー指示によりリリース反映として develop → main を merge・push。
