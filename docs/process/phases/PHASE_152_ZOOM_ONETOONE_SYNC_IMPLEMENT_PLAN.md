# PHASE_152_ZOOM_ONETOONE_SYNC_IMPLEMENT PLAN

## Phase Type
implement

## Purpose
SPEC-012（Zoom 連携による 1 to 1 取り込み）をユーザー OAuth で実装する。Zoom の予定起票・実績反映・要約取得・相手正規化（複数選択取り込み UI）・Webhook 自動化を段階 A〜D で実装する。

## Background
Phase 151 で要件 SSOT（SPEC-012）を作成。1 to 1 は Zoom 実施が主で、要約手貼り・時刻 TODO・DB 手入力の二重作業が課題。プラン `.cursor/plans/zoom_1to1_連携実装` に基づき実装する。

## Related SSOT
- SPEC-012 ZOOM_ONETOONE_SYNC_REQUIREMENTS（本実装の根拠）
- SPEC-006 クロスチャプター 1to1 / SPEC-007 visitor/guest / SPEC-008 重複統合
- DATA_MODEL.md §4.12 one_to_ones, §4.15/4.16（新規 zoom_accounts / zoom_meeting_imports）

## Scope
implement。app/**, routes/**, database/migrations/**, config/services.php, .env.example, resources/js/admin/**, tests/**, docs/**。composer/npm への新規依存追加なし。

## Target Files
- config/services.php, .env.example
- database/migrations/2026_05_30_06*（zoom_accounts / zoom_meeting_imports / one_to_ones zoom_* / zoom_import_apply_logs）
- app/Models/Zoom*（ZoomAccount, ZoomMeetingImport, ZoomImportApplyLog）, app/Models/OneToOne.php
- app/Services/Zoom/*（ApiClient, TokenService, MeetingSyncService, OneToOneDetector, ImportApplyService, SummaryService）
- app/Http/Controllers/Zoom/*（OAuth, Import, Webhook）, app/Http/Requests/Zoom/*
- app/Http/Middleware/VerifyZoomWebhookSignature.php, bootstrap/app.php, routes/api.php
- app/Jobs/Zoom/*（ProcessZoomMeetingEndedJob, FetchZoomSummaryJob）
- resources/js/admin/pages/ZoomImport.jsx, app.jsx, ReligoMenu.jsx
- tests/Unit/Zoom/*, tests/Feature/Zoom/*

## Implementation Strategy
段階 A（OAuth 基盤）→ B（読取取り込み＋複数選択 UI）→ C（要約）→ D（Webhook）。相手正規化・監査は M7/M8 の考え方を踏襲。相手未確定はステージングに保留し one_to_ones.target_member_id の NOT NULL を維持。二重登録は zoom_meeting_uuid / zoom_meeting_id で防止。

## Tasks
- [ ] Phase A: config/services・zoom_accounts・ZoomApiClient/TokenService・ZoomOAuthController
- [ ] Phase B: staging migration・one_to_ones zoom_*・Sync/Detector/ApplyService・sync/imports/apply API・React UI・build
- [ ] Phase C: ZoomSummaryService・summary API・UI 要約取得
- [ ] Phase D: Webhook 署名検証・controller・ジョブ
- [ ] DATA_MODEL / SPEC-012 / Registry / INDEX / progress 同期

## DoD
- 主要コードが実装され、Zoom 関連テストと全体テストが green。
- フロントが `npm run build` 成功。
- SSOT・登録簿が同期。運用前提（Zoom アプリ作成・HTTPS・プラン依存）を REPORT に明記。
