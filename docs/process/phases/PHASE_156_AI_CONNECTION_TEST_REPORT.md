# PHASE_156_AI_CONNECTION_TEST REPORT

## Changed Files
- www/app/Http/Controllers/Ai/UserAiCredentialController.php（test 追加・AiClientFactory 注入）
- www/routes/api.php（POST /api/ai/credentials/test）
- www/resources/js/admin/pages/ReligoSettings.jsx（接続テストボタン）
- www/tests/Feature/Ai/UserAiCredentialTest.php
- docs: ONETOONE_PREP_PROFILE_REQUIREMENTS.md（§12.5・変更履歴）, PHASE_REGISTRY.md, dragonfly_progress.md
- docs: ONETOONE_PREP_PROFILE_REQUIREMENTS.md §12.6（SPEC-012 合流メモ・前ターン分を同梱）

## Summary
AI 設定画面に「接続テスト」ボタンを追加。`POST /api/ai/credentials/test` が保存済みの API キー・モデルで最小の AI 呼び出しを行い、成功（provider/model/サンプル応答）または失敗理由を返す。OpenAI は Http::fake でテスト。

## DoD Check
- [x] 接続テストで成功/失敗が判別できる
- [x] テスト 10 件 green / 全体 420 passed・build 成功
- [x] 本番反映

## Scope Check
OK（SPEC-013 補強・新規依存なし）

## SSOT Check
OK（SPEC-013 §12.5 更新）

## Merge Evidence
merge commit id: （develop→main 取り込み後に追記）
source branch: develop
target branch: main
phase id: 156
phase type: implement
related ssot: SPEC-013

test command: php artisan test
test result: 420 passed (1582 assertions)

changed files: 上記参照

scope check: OK
ssot check: OK
dod check: OK
