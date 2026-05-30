# PHASE_156_AI_CONNECTION_TEST PLAN

## Phase Type
implement

## Purpose
AI 設定画面で、登録した API キー・モデルが実際に使えるかを確認できる「接続テスト」を追加する（SPEC-013 補強）。

## Background
Phase 155 で AI 設定（BYO key）を実装したが、保存しても実際に呼べるか確認手段が無かった。ユーザー要望により疎通確認ボタンを追加する。

## Related SSOT
- SPEC-013 ONETOONE_PREP_PROFILE_REQUIREMENTS

## Scope
implement。UserAiCredentialController（test 追加）・routes/api.php・ReligoSettings.jsx・tests・docs。新規依存なし。

## Target Files
- www/app/Http/Controllers/Ai/UserAiCredentialController.php（test）
- www/routes/api.php（POST /api/ai/credentials/test）
- www/resources/js/admin/pages/ReligoSettings.jsx（接続テストボタン）
- www/tests/Feature/Ai/UserAiCredentialTest.php

## Implementation Strategy
保存済み credential を AiClientFactory で生成器化し、最小プロンプトで 1 回呼んで成否を返す。失敗は AiGenerationException を 422 で返却。OpenAI は Http::fake でテスト。

## Tasks
- [ ] test エンドポイント＋ルート
- [ ] UI ボタン
- [ ] テスト・build・develop→main

## DoD
- 設定画面の「接続テスト」で成功/失敗が分かる。全テスト green。本番反映。
