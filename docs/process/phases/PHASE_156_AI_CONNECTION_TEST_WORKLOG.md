# PHASE_156_AI_CONNECTION_TEST WORKLOG

## Task1 - 接続テスト
- 判断: 保存済みの credential を使って最小プロンプトで 1 回 generate し、成否を返す。フォーム未保存の値ではなく DB の保存値で実行（UI に注記）。失敗は AiGenerationException を 422 で返し、原因（キー無効/レート/通信）をユーザーに表示。
- 実施: `UserAiCredentialController::test`＋`POST /api/ai/credentials/test`。ReligoSettings に「接続テスト」ボタン（AI 有効時のみ）。
- 確認: `UserAiCredentialTest` に test_test_endpoint_requires_setup / ok_with_openai_fake を追加。AI 10 件・全体 420 passed。`npm run build` 成功。
