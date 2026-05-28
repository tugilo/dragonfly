# Phase M7-P2-IMPLEMENT-2: PDF解析候補表示UI — PLAN

**Phase:** M7-P2-IMPLEMENT-2  
**Phase ID:** M7-P2-IMPLEMENT-2  
**作成日:** 2026-03-17  
**フェーズ種別:** implement  
**Related:** [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md), [MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md](../../design/MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md), [PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_REPORT.md](PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_REPORT.md)

---

## 1. 背景

- M7-P2-IMPLEMENT-1 で PDF 解析結果（extracted_result.candidates）が DB に保存され、Drawer に「候補 N件」表示と「PDF解析」ボタンがある。候補の中身はまだ画面で見えない。

---

## 2. 目的

- Drawer から解析された候補（name / raw_line / type_hint）を確認できるようにする。表示のみで、編集・削除・participants 反映は行わない。

---

## 3. スコープ

### やること

1. show API の participant_import に candidates を追加し、フロントが扱いやすい形で返す
2. Drawer 内に「解析候補」表示エリアを追加（parse_status ごとの表示ルール）
3. success 時に name / type_hint / raw_line を一覧表示（表またはリスト）
4. candidate_count と表示件数を整合させる
5. pending / failed 時の表示を整理（解析待ち・解析失敗）
6. Feature テスト: show に candidates が含まれること（success 時）、構造・件数整合

### やらないこと

- 候補の編集・削除
- participants への反映
- members との自動照合
- 一覧 API の変更
- 高度なテーブル UI

---

## 4. 変更対象ファイル

- www/app/Http/Controllers/Religo/MeetingController.php（participant_import に candidates 追加）
- www/resources/js/admin/pages/MeetingsList.jsx（候補一覧・状態表示）
- www/tests/Feature/Religo/MeetingControllerTest.php（candidates 含むテスト追加・期待値更新）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_*.md
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md

---

## 5. API 表示方針

- GET /api/meetings/{id} の participant_import に `candidates` を追加する。
- parse_status === success かつ extracted_result['candidates'] が配列のとき、`candidates` をそのまま配列で返す（各要素は name, raw_line, type_hint）。success 以外または候補なしのときは `candidates: null` とする。
- 一覧 API は変更しない。

---

## 6. UI 表示方針

- **has_pdf = false:** 従来どおり（候補表示なし）
- **has_pdf = true, parse_status = pending:** 「解析待ち」表示。「PDF解析」ボタンは既存のまま
- **has_pdf = true, parse_status = failed:** 「解析失敗」表示
- **has_pdf = true, parse_status = success:** 「候補 N件」＋候補一覧（名前・種別推定・抽出元行）。MUI Table で表示。type_hint は regular→メンバー候補、guest→ゲスト候補、visitor→ビジター候補、proxy→代理候補、null/その他→不明。候補 0 件のときは「候補なし」

---

## 7. テスト観点

- show で participant_import に candidates が含まれること（parse_status success 時）
- parse_status が pending / failed / success のとき participant_import の構造が想定どおり（candidates の有無）
- candidate_count と candidates の件数が一致すること
- 既存の show テスト（has_pdf false / pending）の期待値に candidates: null を追加

---

## 8. DoD

- [x] success 時に候補一覧が画面表示される
- [x] pending / failed の状態表示がある
- [x] candidate_count と表示件数が整合する
- [x] participants には影響しない
- [x] php artisan test が通る
- [x] npm run build が通る
- [x] PLAN / WORKLOG / REPORT が揃い、INDEX・PHASE_REGISTRY・dragonfly_progress を更新している
