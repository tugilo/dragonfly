# Phase Meetings 一覧に参加者PDF有無表示 — PLAN

**Phase:** M7-P1 一覧参加者PDFインジケータ  
**Phase ID:** M7-P1-LIST（一覧表示追加）  
**作成日:** 2026-03-17  
**フェーズ種別:** implement  
**Related SSOT:** [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md)、[FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md)

---

## 1. 背景

- M7-P1 で参加者PDFのアップロード・保存・ダウンロードが実装済み。Drawer では participant_import の有無を表示できる。
- 一覧では「どの Meeting に PDF が登録済みか」が分からず、ユーザーから一覧にも表示してほしいという要望がある。

---

## 2. 目的

- Meetings 一覧で「参加者PDFあり / なし」が一目で分かるようにする。
- PDF が登録済みの Meeting を一覧上ですぐ判別できる状態にする。
- 過剰な作り込みはせず、最小差分で UX を上げる。

---

## 3. スコープ

- **やること:** 一覧 API に PDF 有無を返す項目を追加。一覧に「参加者PDF」列を追加（Chip であり/なし）。既存の Drawer・アップロード・ダウンロードは変更しない。
- **やらないこと:** PDF 解析、participants 自動登録、一覧から直接ダウンロード、履歴表示、アップロード日時表示。

---

## 4. 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| www/app/Http/Controllers/Religo/MeetingController.php | index の addSelect に has_participant_pdf（exists サブクエリ）、map に has_participant_pdf 追加 |
| www/resources/js/admin/pages/MeetingsList.jsx | HasParticipantPdfField コンポーネント追加、Datagrid に「参加者PDF」列追加（メモの次、Actions の前） |
| www/tests/Feature/Religo/MeetingControllerTest.php | index のレスポンスに has_participant_pdf が含まれること、import ありで true になることのテスト追加 |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_*.md | PLAN / WORKLOG / REPORT |

---

## 5. 実装方針

### API

- GET /api/meetings の各要素に `has_participant_pdf: boolean` を追加。
- `meeting_participant_imports` の存在有無で判定（exists サブクエリ）。一覧用途のため original_filename は返さない。

### UI

- 既存の「メモ」列と揃え、Chip で「あり」（success）/「なし」（default outlined）を表示。
- 列順: 番号 / 開催日 / BO数 / メモ / 参加者PDF / Actions。

---

## 6. テスト観点

- GET /api/meetings に has_participant_pdf が含まれること。
- PDF あり Meeting は true、なしは false になること。
- 一覧に「参加者PDF」列が表示され、Chip が意図どおりであること。
- Drawer・アップロード・ダウンロードに影響がないこと。
- php artisan test の既存回帰がないこと。npm run build が通ること。

---

## 7. DoD（Definition of Done）

- [x] 一覧 API に has_participant_pdf が含まれる。
- [x] 一覧に「参加者PDF」列が表示され、あり/なしが Chip で判別できる。
- [x] 既存の Drawer・アップロード・ダウンロードに影響がない。
- [x] MeetingControllerTest で has_participant_pdf を検証している。
- [x] 全テスト・ビルドが通る。
- [x] PLAN / WORKLOG / REPORT が揃っている。
