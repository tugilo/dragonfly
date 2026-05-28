# Phase Meetings 一覧に参加者PDF有無表示 — WORKLOG

**Phase:** M7-P1 一覧参加者PDFインジケータ  
**作成日:** 2026-03-17

---

## 既存 API / UI の確認

- **GET /api/meetings:** MeetingController@index で id, number, held_on, breakout_count, has_memo を返している。has_memo は addSelect で exists サブクエリを使用。
- **MeetingsList.jsx:** Datagrid に番号・開催日・BO数・メモ・Actions。HasMemoField は record.has_memo で Chip「あり」(success) / 「なし」(default) を表示。
- **詳細（show）:** participant_import: { has_pdf, original_filename } はそのまま。一覧用には boolean のみ追加する方針で、一覧は軽く保つ。

---

## 一覧表示用項目の追加方針

- 一覧用途のため `has_participant_pdf: boolean` のみ追加。participant_import オブジェクトは show 用に残す。
- meeting_participant_imports の存在有無で判定。addSelect に `DB::raw("exists(select 1 from meeting_participant_imports where meeting_participant_imports.meeting_id = meetings.id) as has_participant_pdf")` を追加し、map で `'has_participant_pdf' => (bool) $m->has_participant_pdf` を返す。

---

## UI 表示方法の判断理由

- 既存の「メモ」列が Chip で「あり」「なし」であり、同じパターンに揃えると一覧の視認性が良い。
- 列順は「メモ」の次に「参加者PDF」を置き、その後に Actions。番号・開催日・BO数・メモ・参加者PDF・Actions の順で自然。

---

## 実装内容

1. **MeetingController.php:** withCount / addSelect の直後に has_participant_pdf の exists を addSelect。map 内に has_participant_pdf を追加。
2. **MeetingsList.jsx:** HasParticipantPdfField を HasMemoField と同様の実装で追加（record.has_participant_pdf で Chip）。Datagrid に FunctionField「参加者PDF」をメモと Actions の間に追加。
3. **MeetingControllerTest.php:** test_index_returns_meetings_with_breakout_count_and_has_memo に has_participant_pdf のキー存在と false のアサートを追加。test_index_includes_has_participant_pdf_true_when_import_exists を新規追加（import ありで true になること）。

---

## テスト内容・結果

- MeetingControllerTest: test_index_returns_meetings_with_breakout_count_and_has_memo で has_participant_pdf が含まれ false であることを確認。test_index_includes_has_participant_pdf_true_when_import_exists で import 登録時に true になることを確認。
- php artisan test: 105 passed（既存 104 + 新規アサート含む）。
- npm run build: 成功。
