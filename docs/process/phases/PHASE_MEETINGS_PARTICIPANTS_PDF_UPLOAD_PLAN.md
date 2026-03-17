# Phase Meetings Participants PDF Upload — PLAN

**Phase:** M7-P1（参加者PDFアップロード）  
**Phase ID:** M7-P1  
**作成日:** 2026-03-17  
**フェーズ種別:** implement  
**Related SSOT:** [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md)（P1: PDF を Meeting に紐づけて保存）

---

## 1. 背景

- M7 で「例会参加者PDF取込」の要件整理を完了。P1 は「PDF を Meeting に紐づけて保存・参照・ダウンロードできる」までを実装する。
- 参加者の登録や PDF 解析は行わない（P2 以降）。participants には一切触れない。
- 既存の Meetings 一覧・Drawer・メモ・BO・統計を壊さないこと。

---

## 2. 目的

- Meeting に対して「参加者PDF」をアップロードし、保存・参照できるようにする。
- Drawer から PDF の有無を確認し、登録済みならダウンロードできるようにする。
- 1 Meeting = 1 PDF（初期）。既存 PDF がある場合は上書き保存とする。

---

## 3. スコープ

- **変更可能:** マイグレーション、MeetingParticipantImport モデル、Meeting モデル（リレーション追加）、MeetingParticipantImportController（新規）、MeetingController@show（participant_import 追加）、routes/api.php、MeetingsList.jsx、Feature テスト、docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_*.md
- **変更しない:** participants / members テーブル・API。既存 GET /api/meetings、GET /api/meetings/{id} の既存キー（meeting, memo_body, rooms）の形。他 Meetings 機能。

---

## 4. データ設計

### 新規テーブル meeting_participant_imports

| カラム | 型 | 説明 |
|--------|-----|------|
| id | bigint PK | 主キー |
| meeting_id | FK meetings, unique | 紐づく例会。1 Meeting = 1 件 |
| file_path | string(512) | 保存先パス（storage 相対） |
| original_filename | string(255) | アップロード時のファイル名 |
| status | string(20), default 'uploaded' | ステータス（P1 では uploaded のみ） |
| created_at, updated_at | timestamps | 作成・更新日時 |

- 保存先: `storage/app/private`（local ディスク）の `meeting_participant_imports/{meeting_id}/{uuid}.pdf`。

---

## 5. API

| メソッド | パス | 説明 |
|----------|------|------|
| GET | /api/meetings/{id}/participants/import | 該当 Meeting の PDF メタ情報。{ has_pdf, original_filename } |
| POST | /api/meetings/{id}/participants/import | PDF アップロード。body: multipart, key: pdf。既存あれば上書き。201 + メタ |
| GET | /api/meetings/{id}/participants/import/download | PDF を attachment で返却。404 は未登録またはファイルなし |

- GET /api/meetings/{id} のレスポンスに `participant_import: { has_pdf, original_filename }` を追加（Drawer で 1 リクエストで取得するため）。

---

## 6. UI

- **導線:** Meeting 詳細 Drawer 内に「参加者PDF」ブロックを追加。
  - PDF あり: ファイル名 + 「ダウンロード」リンク（/api/meetings/{id}/participants/import/download）。
  - PDF なし: 「未登録」+「参加者PDF登録」ボタン。フッターにも「参加者PDF登録」を配置（PDF 未登録時のみ）。
- **アップロード:** 「参加者PDF登録」クリックでモーダルを表示。PDF 選択 → アップロード。成功時に Drawer の詳細を再取得し、ダウンロード表示に更新。
- **制約:** 既存 Meetings 機能を壊さない。participants には一切触れない。

---

## 7. 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| www/database/migrations/2026_03_17_100001_create_meeting_participant_imports_table.php | 新規 |
| www/app/Models/MeetingParticipantImport.php | 新規 |
| www/app/Models/Meeting.php | participantImport() HasOne 追加 |
| www/app/Http/Controllers/Religo/MeetingParticipantImportController.php | 新規。show / store / download |
| www/app/Http/Controllers/Religo/MeetingController.php | show に participant_import 追加、with('participantImport') |
| www/routes/api.php | GET/POST .../participants/import、GET .../participants/import/download 追加 |
| www/resources/js/admin/pages/MeetingsList.jsx | Drawer に参加者PDFブロック、PDF 登録モーダル、postParticipantImport、state |
| www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php | 新規 |
| www/tests/Feature/Religo/MeetingControllerTest.php | show に participant_import 含むテスト追加 |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_*.md | PLAN / WORKLOG / REPORT |

---

## 8. DoD（Definition of Done）

- [x] PDF アップロードできる（POST .../participants/import）。
- [x] DB に meeting_participant_imports として保存される。
- [x] Drawer から参加者PDFの有無を確認できる（participant_import 表示）。
- [x] ダウンロードできる（GET .../participants/import/download）。
- [x] 既存 Meetings 機能（一覧・Drawer・メモ・BO・統計）に影響なし。
- [x] Feature テストが通る。php artisan test で回帰なし。
- [x] React ビルドが通る（npm run build）。
- [x] PLAN / WORKLOG / REPORT が揃っている。

---

## 9. 参照

- 要件たたき台: [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md)
- 実装: http://localhost/admin#/meetings → 行クリックで Drawer → 参加者PDF登録 / ダウンロード
