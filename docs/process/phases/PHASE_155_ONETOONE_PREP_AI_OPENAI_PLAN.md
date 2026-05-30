# PHASE_155_ONETOONE_PREP_AI_OPENAI PLAN

## Phase Type
implement

## Purpose
SPEC-013（1to1 事前準備）を **OpenAI から** 実装する。相手プロフィール（PDF / NCAS URL）を 1to1 に添付・テキスト化し、ユーザーごとの AI 設定（BYO key）で 1to1 原稿を生成して notes / メモに保存できるようにする（P1+P2）。

## Background
Cursor 上でローカル md として作っている 1to1 事前準備ドキュメントを Religo サーバ上で再現する。AI はユーザー任意・プロバイダ選択（まず OpenAI）。

## Related SSOT
- SPEC-013 ONETOONE_PREP_PROFILE_REQUIREMENTS
- DATA_MODEL §4.12（one_to_ones）・§4.17/4.18（新規）
- 認証は SPEC-012/Phase 154 の `auth:sanctum` と整合

## Scope
implement。migrations・app/Models・app/Services/Ai・app/Http/Controllers（Ai/Religo）・routes/api.php・config/services.php・resources/js/admin・tests・docs。新規 composer/npm 依存なし。

## Target Files
- migrations: user_ai_credentials / one_to_one_attachments
- Models: UserAiCredential, OneToOneAttachment
- Services/Ai: AiTextGenerator(IF), OpenAiTextGenerator, AiClientFactory, OneToOnePrepService, HtmlTextExtractor, AiGenerationException
- Controllers: Ai\UserAiCredentialController, Religo\OneToOnePrepController
- routes/api.php（auth:sanctum）, config/services.php（ai）
- resources/js/admin/pages/ReligoSettings.jsx, OneToOnesEdit.jsx
- tests/Feature/Ai/*

## Implementation Strategy
provider 抽象（AiTextGenerator）＋ OpenAI アダプタ。AI キーはユーザーごと暗号化（user_ai_credentials）。PDF は既存 PdfParticipantParseService、URL は Http+HtmlTextExtractor。原稿は _TEMPLATE 構成で生成し下書き→校正保存。所有者（owner 一致）スコープ。OpenAI は Http::fake でテスト。

## Tasks
- [ ] DB/Model
- [ ] AI サービス（OpenAI）
- [ ] Controller/Route
- [ ] React UI + build
- [ ] テスト + 全体 green
- [ ] SSOT/Registry/Phase/INDEX/progress 同期・develop→main

## DoD
- AI 設定（BYO key・暗号化・平文非返却）が動く。
- PDF/URL 添付→テキスト抽出→OpenAI で原稿生成→notes/メモ保存ができる。
- 認証・owner スコープを担保。全テスト green。本番反映。
