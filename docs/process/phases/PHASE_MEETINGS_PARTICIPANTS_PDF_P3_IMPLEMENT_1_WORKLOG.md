# Phase M7-P3-IMPLEMENT-1: 候補確認・修正UI — WORKLOG

**Phase:** M7-P3-IMPLEMENT-1  
**作成日:** 2026-03-17

---

## candidates 更新方式の判断

- extracted_result は JSON で candidates と meta を持つ。candidates のみ上書きし、meta は既存をそのまま保持する形にした。update 時に `extracted_result` を `['candidates' => $candidates, 'meta' => $existing['meta']]` で保存。parse_status は success のまま、parsed_at は変更しない。

---

## meta の保持方針

- 既存の extracted_result から meta を取得し、candidates 更新後も同じ meta を merged して保存。meta は parser_version / line_count 等の参照用のため、人が候補を編集しても更新しない。

---

## 空行や不正値の扱い

- リクエストの candidates のうち、name を trim した結果が空の行は保存時に除外した。raw_line は空文字可。type_hint は regular / guest / visitor / proxy 以外は null に正規化。Form Request では candidates を required array、各要素の name を nullable string、type_hint を nullable + in:regular,guest,visitor,proxy にし、空 name の除外は Controller 側で実施した。

---

## UI 構成の判断理由

- 「候補を編集」ボタンで編集モードに入り、編集モード中は既存の読み取り専用テーブルを「各行が TextField + Select + 削除ボタン」のテーブルに差し替えた。候補 0 件で編集開始時は 1 行の空行を追加。候補追加は「候補追加」で 1 行追加。保存・キャンセルは編集モードのフッターに配置。Drawer を閉じたときに編集モードをリセットするため、useEffect で open が false になったら candidateEditMode と editingCandidates をクリアした。

---

## 実装内容

- **UpdateParticipantImportCandidatesRequest:** candidates 必須配列、各要素 name nullable、raw_line nullable、type_hint nullable + in。
- **MeetingParticipantImportController::updateCandidates:** Meeting / import 存在・parse_status === success を確認。candidates から name が空の行を除外し、type_hint を正規化。meta を保持して extracted_result を更新。レスポンスで candidate_count と candidates を返す。
- **Route:** PUT /api/meetings/{meetingId}/participants/import/candidates を追加。
- **MeetingsList.jsx:** putParticipantImportCandidates、candidateEditMode / editingCandidates / candidatesSaving 状態、「候補を編集」ボタン、編集モード時のテーブル（名前 TextField・種別 Select・抽出元行読取・削除ボタン）、候補追加、保存・キャンセル。保存後は onDetailRefresh で再取得し編集モードを終了。
- **Tests:** update_candidates 成功・meta 保持・空 name 除外・import なし 422・parse_status が success でないとき 422・保存後 show で候補が更新されていることを検証。

---

## テスト内容

- test_update_candidates_success_updates_extracted_result_and_preserves_meta
- test_update_candidates_excludes_empty_name_rows
- test_update_candidates_returns_422_when_no_import
- test_update_candidates_returns_422_when_parse_status_not_success
- test_show_meeting_returns_updated_candidates_after_update_candidates

---

## 結果

- php artisan test 117 passed。npm run build 成功。participants には一切触れていない。
