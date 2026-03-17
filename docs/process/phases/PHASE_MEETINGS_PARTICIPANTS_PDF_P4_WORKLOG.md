# Phase M7-P4: member 照合と反映前確認の強化 — WORKLOG

**Phase:** M7-P4  
**作成日:** 2026-03-17

---

## 完全一致を採用した理由

- 要件で「高度な曖昧一致はしない」と明記されており、ApplyParticipantCandidatesService の `Member::where('name', $name)->first()` と同一ルールにすることで、表示上の「既存 member / 新規作成」と実際の apply 結果が一致する。曖昧一致を入れると apply 時は別ロジックになるため、見た目と挙動の乖離を防ぐため完全一致に限定した。

## API 返却方式の判断

- A案（GET /api/meetings/{meetingId} の participant_import に match 情報を追加）を採用。専用 review API は不要と判断。show はすでに participant_import と candidates を返しており、ここに matched_count / new_count / total_count と各 candidate の match_status / matched_member_id / matched_member_name を足すだけで完結する。一覧 API は変更していない。

## UI 表示方法の判断

- 候補一覧（編集モードでないとき）に「照合」列を追加し、match_status === 'matched' のとき success Chip「既存 member」、それ以外は warning Chip「新規作成」を表示。既存一致時は title で matched_member_name を補助表示。
- 解析候補ブロックの「候補 N件」の横に「既存一致 M件 / 新規作成 K件 / 合計 T件」を表示（total_count が数値のときのみ）。
- 反映確認ダイアログの冒頭に「合計 N件（既存 member 一致 M件 / 新規作成 K件）」を追加し、続けて既存の注意文言を表示。

## 集計の扱い

- 名前が空の候補は apply と同様に total に含めない。CandidateMemberMatchService では、name が空の行は match_status: new のまま matched_count/new_count にカウントせず、total_count = matched_count + new_count で「名前あり」のみの件数にした。

## 実装内容

- **CandidateMemberMatchService:** enrichCandidates(candidates) で各候補の name を trim し、Member::where('name', $name)->first() で照合。見つかれば match_status: matched, matched_member_id, matched_member_name を付与、見つからなければ match_status: new, matched_member_id/null, matched_member_name/null。名前が空の候補は new のまま集計には含めない。戻り値は candidates / matched_count / new_count / total_count。
- **MeetingController::show:** parse_status === success かつ candidates ありのとき、CandidateMemberMatchService で enrich し、participant_import の candidates を enriched に差し替え、matched_count / new_count / total_count を追加。parse_success でない場合は従来どおり null。
- **MeetingsList.jsx:** participant_import から matched_count, new_count, total_count を参照。候補一覧に「照合」列と Chip を追加。候補件数表示に集計を追加。反映確認ダイアログに集計を表示。
- **MeetingControllerTest:** participant_import が has_pdf false のときの期待に matched_count / new_count / total_count: null を追加。parse_success 時の candidates に match_status / matched_member_id / matched_member_name および matched_count / new_count / total_count の存在を断言。新規テスト: 既存 Member 同名で matched になること、未登録名で new になること、混在で集計が正しいこと。

## テスト内容

- test_show_returns_meeting_detail_with_memo_body_and_rooms: participant_import に matched_count, new_count, total_count が null であることを追加。
- test_show_includes_participant_import_when_pdf_exists: parse_status pending 時も matched_count, new_count, total_count が null であることを追加。
- test_show_includes_candidates_when_parse_success: candidates に match_status, matched_member_id, matched_member_name および participant_import に matched_count, new_count, total_count が含まれることを追加。
- test_show_candidates_include_member_match_matched_when_member_exists: 既存 Member と名前完全一致で matched になり集計 1/0/1 であること。
- test_show_candidates_include_member_match_new_when_no_member: 未登録名で new になり集計 0/1/1 であること。
- test_show_match_counts_are_correct_for_mixed_candidates: 2 既存・1 新規で 2/1/3 であること。

## 結果

- php artisan test 126 passed。npm run build 成功。apply 関連テストはすべて通過し、participants 反映の既存機能に影響なし。
