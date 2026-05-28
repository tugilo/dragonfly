# Phase M7-P2-PREP: PDF解析のための基盤準備 — PLAN

**Phase:** M7-P2-PREP  
**Phase ID:** M7-P2-PREP  
**作成日:** 2026-03-17  
**フェーズ種別:** implement  
**Related:** [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md)

---

## 1. 背景

- M7-P1 で参加者PDFのアップロード・一覧表示・フィルタまで完了。次の P2（PDF解析・参加者抽出）に備え、解析状態を保持する DB/Model/API を追加する。

---

## 2. 目的

- meeting_participant_imports に「解析完了日時」と「解析状態」を保持できるようにする。
- 既存のアップロード・一覧・Drawer 表示を壊さない。

---

## 3. スコープ

- **変更対象:** migration（meeting_participant_imports）、MeetingParticipantImport モデル、MeetingController@show の participant_import レスポンス、MeetingControllerTest。
- **変更しない:** 一覧 API、Drawer UI、MeetingParticipantImportController、participants テーブル。

---

## 4. 変更内容

### DB（migration）

- meeting_participant_imports に追加:
  - `parsed_at` (nullable timestamp)
  - `parse_status` (string 20, default 'pending') — 値: pending / success / failed
- 既存の `status`（アップロード状態）はそのまま。

### Model

- fillable に parsed_at, parse_status を追加。
- casts で parsed_at を datetime に。
- 定数 PARSE_STATUS_PENDING / SUCCESS / FAILED を定義し enum 的に利用可能にする。

### API

- GET /api/meetings/{id} の participant_import に parse_status と parsed_at を含める。
  - あり: parse_status（文字列）, parsed_at（ISO8601 または null）
  - なし: parse_status: null, parsed_at: null

### テスト

- test_show_returns_meeting_detail_with_memo_body_and_rooms の participant_import 期待値に parse_status, parsed_at を追加。
- test_show_includes_participant_import_when_pdf_exists で parse_status と parsed_at を検証。

---

## 5. DoD（Definition of Done）

- [x] migration が適用され、parsed_at / parse_status が存在する。
- [x] Model で定数と casts が定義されている。
- [x] show の participant_import に parse_status / parsed_at が含まれる。
- [x] 既存テストが通る（期待値更新含む）。php artisan test / npm run build 成功。
- [x] PLAN / WORKLOG / REPORT 作成、INDEX・PHASE_REGISTRY・dragonfly_progress 更新。
