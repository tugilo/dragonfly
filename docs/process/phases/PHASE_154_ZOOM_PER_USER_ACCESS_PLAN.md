# PHASE_154_ZOOM_PER_USER_ACCESS PLAN

## Phase Type
implement

## Purpose
Zoom 連携・取り込み（SPEC-012）を **chapter_admin 限定から「認証済みユーザー単位」へ**開放する。各ユーザーが自分の Zoom を連携し、自分のミーティングのみ取り込めるようにする。

## Background
データモデルは既にユーザー単位（`zoom_accounts.user_id` / 取込は actingUser スコープ）。唯一の制約が API ゲートの `religo.chapter_admin` だった。各メンバーが自分用に使えるようにするため、ゲートを `auth:sanctum` に変更する。

## Related SSOT
- SPEC-012 ZOOM_ONETOONE_SYNC_REQUIREMENTS（§認証/署名・本変更を反映）

## Scope
implement。`www/routes/api.php`（zoom グループの middleware）・`www/tests/Feature/Zoom/*`・docs。callback（署名 state）/ webhook（署名）は現状維持。

## Target Files
- www/routes/api.php（zoom group: religo.chapter_admin → auth:sanctum）
- www/tests/Feature/Zoom/ZoomImportAccessTest.php（新規）
- docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md / ZOOM_INTEGRATION_SETUP.md（記述更新）

## Implementation Strategy
zoom プレフィックスグループの middleware を `auth:sanctum` に変更。コントローラは `ReligoActorContext::actingUser()` で認証ユーザーを解決済みのため、スコープ（自分のデータのみ）はそのまま機能。アクセス制御テストで未認証 401・認証済み 200・他ユーザー import 不可を担保。

## Tasks
- [ ] routes/api.php の zoom グループを auth:sanctum に変更
- [ ] ZoomImportAccessTest 追加
- [ ] SPEC-012 / SETUP 記述更新
- [ ] テスト・develop→main 反映

## DoD
- 認証済みユーザー（member 含む）が自分の Zoom を連携・取り込みできる。
- 未認証は 401、他ユーザーの取込候補は参照/編集不可。
- 全テスト green、本番反映。
