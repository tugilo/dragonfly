# Phase M7-P2-IMPLEMENT-2: PDF解析候補表示UI — WORKLOG

**Phase:** M7-P2-IMPLEMENT-2  
**作成日:** 2026-03-17

---

## show API の返し方の判断

- participant_import に `candidates` を追加する形にした。parse_status === success かつ extracted_result['candidates'] が配列のときのみ、その配列をそのまま返す。success 以外または候補なしのときは `candidates: null` とし、フロントで常に participant_import.candidates を参照できるようにした。extracted_result 全体ではなく candidates だけをトップレベルに出すことで、フロントが「候補一覧」だけ扱えばよく、meta は今回使わないため省略した。

---

## 候補表示 UI の選定理由

- 列が「名前・種別推定・抽出元行」の 3 つで固定かつ読み取り専用のため、MUI Table（TableContainer + TableHead + TableBody）を採用した。候補数が多い場合に備え TableContainer に maxHeight: 220 と overflow を指定し、スクロールで確認できるようにした。編集は行わないため、行クリックやインライン編集は追加していない。

---

## parse_status ごとの表示ルール

- **has_pdf = false:** 従来どおり「未登録」＋参加者PDF登録ボタンのみ。候補ブロックは出さない。
- **has_pdf = true, parse_status = pending（または未設定）:** 「解析待ち」を表示し、既存の「PDF解析」ボタンをそのまま表示。
- **has_pdf = true, parse_status = failed:** 「解析失敗」を error 色で表示。PDF解析ボタンで再解析可能。
- **has_pdf = true, parse_status = success:** 「候補 N件」＋候補一覧テーブル。candidates が空配列のときは「候補なし」と表示。N は candidate_count と一致させ、表示行数も candidates.length で整合させた。

---

## 実装内容

- **MeetingController@show:** participant_import に `candidates` を追加。success 時は extracted_result['candidates'] をそのまま返し、それ以外は null。candidate_count は既存どおり candidates の件数で算出。
- **MeetingsList.jsx:** typeHintLabel(typeHint) で regular→メンバー候補、guest→ゲスト候補、visitor→ビジター候補、proxy→代理候補、その他→不明に変換。Drawer の参加者PDFブロックで、parsePending / parseFailed / parseSuccess を分岐し、解析待ち・解析失敗・候補 N件＋テーブルを表示。テーブルは名前・種別推定（Chip）・抽出元行（24 文字で省略、title で全文）。
- **MeetingControllerTest:** test_show_returns_meeting_detail と test_show_includes_participant_import_when_pdf_exists の participant_import 期待値に `candidates: null` を追加。test_show_includes_candidates_when_parse_success を新規追加（success 時のみ candidates と candidate_count が返り、件数・中身が一致することを検証）。
- **MeetingParticipantImportControllerTest:** test_show_returns_parse_status_and_candidate_count_in_meeting_detail に candidates 配列と先頭要素の name のアサートを追加。

---

## テスト内容

- show で has_pdf false のとき participant_import に candidates: null が含まれること。
- show で has_pdf true, parse_status pending のとき candidate_count と candidates が null であること。
- show で parse_status success のとき candidate_count と candidates の件数が一致し、candidates 各要素に name, raw_line, type_hint が含まれること。
- 既存の Meeting 詳細・一覧・parse API のテストが回帰しないこと。

---

## 判断理由

- participants には一切触れず、候補は「確認用表示」に限定する方針のため、API は show の participant_import 拡張のみとし、一覧 API は変更していない。候補の編集・削除・登録は次 Phase に分離した。
