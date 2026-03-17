# Phase M7-P3-IMPLEMENT-1: 候補確認・修正UI — PLAN

**Phase:** M7-P3-IMPLEMENT-1  
**Phase ID:** M7-P3-IMPLEMENT-1  
**作成日:** 2026-03-17  
**フェーズ種別:** implement  
**Related:** [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md), [MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md](../../design/MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md), [PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_REPORT.md](PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_REPORT.md)

---

## 1. 背景

- M7-P2-IMPLEMENT-2 で Drawer に解析候補一覧（name / type_hint / raw_line）を表示済み。候補の編集はまだできない。

---

## 2. 目的

- 抽出候補を人が画面上で確認・修正できるようにする。name / type_hint の変更、行削除、行追加、保存で extracted_result.candidates を更新する。participants への反映は行わない。

---

## 3. スコープ

### やること

1. PUT /api/meetings/{meetingId}/participants/import/candidates で候補を保存
2. 各候補の name / type_hint を編集可能にする UI
3. 不要候補の削除、必要に応じた候補追加
4. 保存時に extracted_result の candidates を更新、meta は維持
5. 保存後 Drawer に反映（再取得またはローカル更新）
6. Feature テスト（保存成功、meta 保持、空 name 除外、show で取得）

### やらないこと

- participants への反映
- members 照合・introducer/attendant 設定
- 高度な一括編集

---

## 4. 変更対象ファイル

- www/app/Http/Requests/Religo/UpdateParticipantImportCandidatesRequest.php（新規）
- www/app/Http/Controllers/Religo/MeetingParticipantImportController.php（updateCandidates）
- www/routes/api.php
- www/resources/js/admin/pages/MeetingsList.jsx（編集モード・保存・キャンセル）
- www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_*.md
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md

---

## 5. API 保存方針

- リクエスト: `{ "candidates": [ { "name", "raw_line", "type_hint" } ] }`。candidates は配列必須。
- 保存時: name が空（trim 後）の行は除外。raw_line は空可。type_hint は regular / guest / visitor / proxy または null に正規化。
- extracted_result の meta は既存を維持。candidates のみ上書き。parse_status は success のまま、parsed_at は変更しない。
- レスポンス: candidate_count と candidates を返す。

---

## 6. UI 編集方針

- 通常時: 既存の候補一覧表示＋「候補を編集」ボタン。
- 編集モード: 各行をフォーム表示（名前 TextField、種別 Select、抽出元行は読み取り専用、削除ボタン）。下部に「候補追加」、フッターに「保存」「キャンセル」。保存で PUT API を呼び、成功後に詳細再取得で Drawer を更新。解析未実行 / failed 時は編集 UI を出さない。

---

## 7. テスト観点

- PUT candidates が成功し、extracted_result.candidates が更新されること。
- extracted_result.meta が保持されること。
- 空 name の行が除外されて保存されること。
- 保存後 GET /api/meetings/{id} で candidates が更新内容で取得できること。
- Meeting なし・import なし・parse_status が success でない場合は 404/422 になること。

---

## 8. DoD

- [x] success 時の候補を編集モードで修正できる
- [x] name / type_hint を変更できる
- [x] 行削除・行追加できる
- [x] 保存で extracted_result.candidates が更新され、candidate_count が整合する
- [x] participants に影響しない
- [x] php artisan test / npm run build が通る
- [x] PLAN / WORKLOG / REPORT と INDEX・REGISTRY・progress を更新している
