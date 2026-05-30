# PHASE_155_ONETOONE_PREP_AI_OPENAI WORKLOG

## Task1 - DB/Model
- 判断: AI キーは Zoom（OAuth 共有アプリ）と異なり**ユーザーの契約そのもの**のため user 単位で暗号化保存（`user_ai_credentials`）。添付は相手未確定でも保持できるよう `one_to_one_attachments` に extracted_text を持たせ、確定原稿は notes/メモへ。
- 実施: 2 migration＋`UserAiCredential`（encrypted/hidden・hasUsableKey）・`OneToOneAttachment`。
- 確認: migrate DONE。

## Task2 - AI サービス（OpenAI）
- 判断: provider 抽象（`AiTextGenerator`）＋ `AiClientFactory` で将来の Claude/Gemini をアダプタ追加で対応可能に。今回 OpenAI のみ実装し、未対応 provider は明示エラー。原稿は `_TEMPLATE.md` のセクション構成で日本語生成。ハルシネーション抑制（無い事実は断定しない・AI 下書き表記）。
- 実施: `OpenAiTextGenerator`（Chat Completions・401/429/失敗ハンドリング）・`OneToOnePrepService`（添付テキスト＋メンバー＋過去メモからプロンプト・上限切詰め）・`HtmlTextExtractor`。`config/services.ai`（base_url/default_model/timeout・キーは持たない）。
- 確認: php -l OK。

## Task3 - Controller/Route
- 判断: すべて `auth:sanctum`。1to1 操作は acting user の owner_member_id と一致が必要（R7・他人の事前準備に触れない）。AI キーは平文を返さず has_api_key のみ。api_key は空送信で既存維持。
- 実施: `UserAiCredentialController`（show/update）・`OneToOnePrepController`（attachments index/pdf/url/delete・generate save_to=notes/memo）。routes 追加。
- 確認: route:list に ai/credentials・attachments・prep/generate。

## Task4 - React UI
- 実施: ReligoSettings に AI 設定カード（ON/OFF・provider 選択〔未実装は disabled〕・model・APIキー）。OneToOnesEdit に事前準備パネル（PDF D&D・URL 取込・添付一覧/削除・原稿生成→下書き/notes/メモ保存）。`npm run build` 成功。

## Task5 - テスト
- 実施: `UserAiCredentialTest`（401・保存とマスク・暗号化・空キー非上書き）、`OneToOnePrepTest`（URL 抽出・AI 未設定 422・OpenAI Http::fake で notes/メモ保存・他人 403）。
- 確認: AI 8 件 green、全体 **418 passed**。

## Task6 - 同期
- 実施: SSOT_REGISTRY（SPEC-013 active）・SPEC-013 §12.5・DATA_MODEL §4.17/4.18・PHASE_REGISTRY(155)・INDEX・progress。
