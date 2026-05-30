# PHASE_154_ZOOM_PER_USER_ACCESS REPORT

## Changed Files
- www/routes/api.php（zoom グループ: religo.chapter_admin → auth:sanctum）
- www/tests/Feature/Zoom/ZoomImportAccessTest.php（新規）
- docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md / docs/SSOT/ZOOM_INTEGRATION_SETUP.md
- docs/process/phases/PHASE_154_ZOOM_PER_USER_ACCESS_{PLAN,WORKLOG,REPORT}.md
- docs/process/PHASE_REGISTRY.md / docs/dragonfly_progress.md

## Summary
Zoom 連携・取り込み API のゲートを `religo.chapter_admin` から **`auth:sanctum`** に変更。認証済みユーザー（member 含む）が各自で自分の Zoom を連携し、自分のミーティングのみ取り込めるようにした（データは actingUser スコープのまま）。callback（署名 state）・webhook（署名）は現状維持。アクセス制御テストを追加。

## DoD Check
- [x] 認証済みユーザーが自分の Zoom を連携/取り込み可能
- [x] 未認証 401・他ユーザー import 参照/編集不可（テスト）
- [x] 全テスト green（410 passed）
- [x] 本番反映（main マージ・自動デプロイ・キャッシュ再生成）

## Scope Check
OK（zoom グループの middleware とテスト・docs のみ）

## SSOT Check
OK（SPEC-012 を本変更に合わせ更新）

## Merge Evidence
merge commit id: b025d3efc8317fed6b80d60504a249a745d258c7
source branch: develop
target branch: main
phase id: 154
phase type: implement
related ssot: SPEC-012

test command: php artisan test
test result: 410 passed (1552 assertions)

changed files: 上記 Changed Files を参照

scope check: OK
ssot check: OK
dod check: OK
