# PHASE_152_ZOOM_ONETOONE_SYNC_IMPLEMENT WORKLOG

## Phase A - OAuth 連携基盤
- 状態: 完了
- 判断: 認証はユーザー OAuth。資格情報は `config/services.zoom`（.env）で管理しハードコード禁止。トークンはユーザーごとに動的のため `.env` でなく `zoom_accounts` に Eloquent `encrypted` キャストで暗号化保存。callback は Bearer を持てないため署名付き state（Crypt + exp）で user を解決。connect/status/disconnect は `religo.chapter_admin` ゲート。
- 実施: services.php zoom ブロック・.env.example・`zoom_accounts` migration・`ZoomAccount`・`ZoomTokenService`（code 交換/refresh/ensureFresh/authorizeUrl）・`ZoomApiClient`（ページネーション・429 バックオフ・UUID 二重エンコード）・`ZoomOAuthController`・ルート。
- 確認: `php -l` OK、migrate DONE、route:list に zoom/connect・callback・status 反映。

## Phase B - 読取取り込み + 複数選択 UI
- 状態: 完了
- 判断: 相手未確定は one_to_ones に書かずステージング `zoom_meeting_imports` に保留（target_member_id NOT NULL 維持・データ汚染回避）。二重登録防止は past=zoom_meeting_uuid、scheduled=(user,meeting_id,kind)。UTC→JST 変換。1to1 判定は人数＋件名で候補・自信度を出し、BNI 以外（定例/チーム/社内）は除外して UI 既定未選択。
- 実施: `zoom_meeting_imports` / `one_to_ones` zoom_* / `zoom_import_apply_logs` migration、`OneToOne` fillable と `OneToOneService::store` に zoom_* 追加、`ZoomOneToOneDetector`・`ZoomMeetingSyncService`・`ZoomImportApplyService`、`ZoomImportController`（sync/index/update/apply）＋ FormRequests、ルート、`ZoomImport.jsx`（複数選択・相手 Autocomplete・全選択/候補のみ/全解除・一括登録・既登録グレーアウト）、app.jsx・ReligoMenu 登録、`npm run build`。
- 確認: migrate DONE、route:list 反映、`ZoomImportApplyServiceTest`（completed/planned/held/dedupe）green、build 成功。

## Phase C - 要約・文字起こし取得
- 状態: 完了
- 判断: R2 はプラン依存（AI Companion / クラウド録画＋文字起こし）。取得不可なら null で返し手動継続にフォールバック。取得時は取り込み済み 1to1 の notes に下書きとして追記（自動上書きしない）。
- 実施: `ZoomSummaryService`（meeting_summary → summary_overview/details/next_steps、無ければ recording の TRANSCRIPT .vtt をパース）、`ZoomImportController::summary` ＋ ルート、UI に「要約取得」ボタン（past かつ取り込み済み）。
- 確認: `php -l` OK、build 成功。実アカウントでの取得可否検証は運用課題として REPORT に記載。

## Phase D - Webhook 自動化
- 状態: 完了
- 判断: 署名は `v0=HMAC-SHA256(secret, "v0:{ts}:{body}")` を専用ミドルウェアで検証。secret 未設定時は 503（誤公開防止）。url_validation は plainToken に HMAC を返す。meeting.ended は自動で one_to_ones に書かず候補（ステージング）を生成（人の確認は維持）。要約系イベントは取り込み済みのみ notes 反映。
- 実施: `VerifyZoomWebhookSignature`＋alias `zoom.webhook`、`ZoomWebhookController`、`ProcessZoomMeetingEndedJob`・`FetchZoomSummaryJob`、`ZoomMeetingSyncService::ingestEndedMeeting`、webhook ルート。
- 確認: `ZoomWebhookTest`（url_validation・不正署名 401・meeting.ended dispatch）green。全体 `php artisan test` 406 passed。

## ドキュメント同期
- 状態: 完了
- 実施: DATA_MODEL §4.12（zoom_* カラム）・§4.15/4.16（zoom_accounts / zoom_meeting_imports）追記、SPEC-012 を active・§12.5 実装節、SSOT_REGISTRY・PHASE_REGISTRY（152）・INDEX・progress 同期。
