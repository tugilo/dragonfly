# PHASE_155_ONETOONE_PREP_AI_OPENAI REPORT

## Changed Files
- www/database/migrations/2026_05_30_103000_create_user_ai_credentials_table.php
- www/database/migrations/2026_05_30_103100_create_one_to_one_attachments_table.php
- www/app/Models/UserAiCredential.php, OneToOneAttachment.php
- www/app/Services/Ai/{AiTextGenerator,OpenAiTextGenerator,AiClientFactory,OneToOnePrepService,HtmlTextExtractor,AiGenerationException}.php
- www/app/Http/Controllers/Ai/UserAiCredentialController.php
- www/app/Http/Controllers/Religo/OneToOnePrepController.php
- www/routes/api.php, www/config/services.php
- www/resources/js/admin/pages/ReligoSettings.jsx, OneToOnesEdit.jsx
- www/tests/Feature/Ai/UserAiCredentialTest.php, OneToOnePrepTest.php
- docs: ONETOONE_PREP_PROFILE_REQUIREMENTS.md（active・§12.5）, DATA_MODEL.md（§4.17/4.18）, SSOT_REGISTRY.md, PHASE_REGISTRY.md, INDEX.md, dragonfly_progress.md

## Summary
SPEC-013 を OpenAI から実装（P1+P2）。1to1 詳細で相手プロフィールを **PDF ドラッグ&ドロップ / NCAS URL 取込**→テキスト抽出し、**ユーザーごとの AI 設定（BYO key・暗号化）**で 1to1 原稿（基本プロフィール/サマリー/共通点/リファーラル戦略/台本・質問/次アクション/メモ）を生成して **notes / 履歴メモに保存**できるようにした。provider は抽象化し OpenAI を実装（Claude/Gemini は将来アダプタ追加）。すべて `auth:sanctum`＋owner 一致でスコープ。新規 composer/npm 依存なし。

## DoD Check
- [x] ユーザー AI 設定（BYO key・暗号化・平文非返却・空送信非上書き）
- [x] PDF/URL 添付→テキスト抽出→OpenAI 原稿生成→notes/メモ保存
- [x] 認証・owner スコープ（他人の事前準備に触れない）
- [x] テスト 8 green / 全体 418 passed・npm build 成功
- [x] SSOT/Registry/DATA_MODEL/INDEX/progress 同期
- [ ] （任意）Claude/Gemini アダプタ追加
- [ ] 実運用での OpenAI 実キーによる生成確認（ユーザーがキー登録後）

## Scope Check
OK（SPEC-013 範囲・新規依存なし）

## SSOT Check
OK（SPEC-013 active 化・DATA_MODEL §4.17/4.18 追記）

## Merge Evidence
merge commit id: b17eade613a28fac18da14309a242b7620683b14
source branch: develop
target branch: main
phase id: 155
phase type: implement
related ssot: SPEC-013

test command: php artisan test
test result: 418 passed (1578 assertions)（うち AI 8 件）

changed files: 上記 Changed Files を参照

scope check: OK
ssot check: OK
dod check: OK（コード充足。実キーでの生成確認・他プロバイダは運用/将来）
