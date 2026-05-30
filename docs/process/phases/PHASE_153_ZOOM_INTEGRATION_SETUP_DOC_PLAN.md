# PHASE_153_ZOOM_INTEGRATION_SETUP_DOC PLAN

## Phase Type
docs

## Purpose
Phase 152 で実装した Zoom 連携（SPEC-012）を **実運用で動かすための手順書（Runbook）** を作成する。コードは実装済みのため、本 Phase は **コード外の設定・操作手順**を文書化する。

## Background
SPEC-012 の実装（Phase 152）は develop に merge 済み。残課題は「Zoom Marketplace アプリ作成・`.env` 設定・HTTPS トンネル・連携/取り込み/要約/Webhook の操作・運用注意」というコード外の運用手順。これを 1 つの Runbook にまとめる。

## Related SSOT
- SPEC-012 ZOOM_ONETOONE_SYNC_REQUIREMENTS（要件・実装）
- ZOOM_INTEGRATION_SETUP.md（本 Phase で新規作成・Runbook）

## Scope
docs のみ。docs/SSOT/ZOOM_INTEGRATION_SETUP.md 新規、docs/INDEX.md・docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md・docs/dragonfly_progress.md・docs/process/PHASE_REGISTRY.md・本 Phase 三点セット。コード変更なし。

## Target Files
- docs/SSOT/ZOOM_INTEGRATION_SETUP.md（新規）
- docs/INDEX.md・docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md・docs/dragonfly_progress.md・docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_153_ZOOM_INTEGRATION_SETUP_DOC_{PLAN,WORKLOG,REPORT}.md

## Implementation Strategy
既存の `.env` 安全書き換えパターン（bin/setup.sh の `php -r` + `preg_replace`、sed 禁止）を踏襲した手順を記載。Zoom 公式の OAuth/Webhook 仕様（SPEC-012 §6.1）に沿ってスコープ・Redirect/Webhook・HTTPS トンネル・操作・トラブルシュートを整理。

## Tasks
- [ ] ZOOM_INTEGRATION_SETUP.md を作成
- [ ] INDEX・SPEC-012・progress・PHASE_REGISTRY を同期

## DoD
- Zoom アプリ作成 → `.env` → 連携 → 取り込み → 要約 → Webhook の手順が再現可能な形で記載されている。
- 登録簿・INDEX・進捗が同期。docs フェーズのためテストは対象外。
