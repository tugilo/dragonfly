# Phase M7-P5: 手動マッチングUI — PLAN

**Phase:** M7-P5  
**Phase Type:** implement  
**作成日:** 2026-03-17

---

## 1. 背景

- M7-P4 で候補ごとに match_status（matched / new）と既存一致・新規作成件数を表示できるようになった。
- 照合は名前完全一致のみで、表記ゆれや別名の場合は「新規作成」になる。手動で既存 member を選び直す UI がなく、人が正しく既存 member に寄せられない。

## 2. 目的

候補ごとに既存 member を手動で選択・解除できるようにし、反映前に「新規作成」ではなく「既存 member に紐づける」判断を人が行えるようにする。

## 3. スコープ

**今回やること**

- candidate ごとに手動マッチング結果（matched_member_id, matched_member_name, match_source: manual）を extracted_result.candidates に保持する。
- PUT .../candidates で matched_member_id 等を保存対象に含める（A案）。
- member 検索 API（GET /api/members/search?q=...）を追加し、手動選択用に利用する。
- Drawer の候補編集モードで「照合」列を追加し、「member を選択」／選択済みなら member 名＋解除を表示する。選択時は検索 Dialog/Popover で member を検索して選ぶ。
- 表示モードでは auto matched / manual matched / new を Chip で区別する。
- 集計（matched_count / new_count）に手動マッチを反映する。
- apply 時に candidate.matched_member_id を優先して participant を作成する。

**今回やらないこと**

- 曖昧一致アルゴリズムの高度化、introducer/attendant、差分更新、OCR、一括自動照合。

## 4. 変更対象ファイル

- www/app/Http/Controllers/Religo/MemberSearchController.php（新規）
- www/app/Http/Requests/Religo/UpdateParticipantImportCandidatesRequest.php（matched_member_id / matched_member_name / match_source 追加）
- www/app/Http/Controllers/Religo/MeetingParticipantImportController.php（updateCandidates で手動マッチ保存）
- www/app/Services/Religo/CandidateMemberMatchService.php（manual 時は保存値を優先、match_source 付与）
- www/app/Services/Religo/ApplyParticipantCandidatesService.php（matched_member_id 優先で member 解決）
- www/routes/api.php（GET /members/search）
- www/resources/js/admin/pages/MeetingsList.jsx（照合列・member 選択 UI・Chip 区別）
- www/tests/Feature/Religo/MeetingControllerTest.php（match_source 等の断言）
- www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php（手動マッチ保存・apply 優先のテスト）
- www/tests/Feature/Religo/MemberSearchControllerTest.php（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_PLAN.md（本ファイル）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_REPORT.md
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md

## 5. 手動マッチング方針

- 手動選択時: matched_member_id = 選択した member id、matched_member_name = その name、match_status = matched、match_source = manual を candidate に保存。
- 解除時: matched_member_id / matched_member_name / match_source を null にし、表示時は CandidateMemberMatchService の auto 判定に戻す（match_source が manual でない候補のみ auto 実行）。
- extracted_result.meta は維持し、candidates のみ更新する。

## 6. apply 優先順位

1. candidate.matched_member_id がある → その member を participant に使用。
2. なければ name 完全一致で Member 検索。
3. 見つからなければ新規 Member 作成。

## 7. UI 方針

- 編集モード: 各行に「照合」列。自動一致時は「既存 member（自動）」表示＋「member を選択」で上書き可能。未一致時は「新規作成」＋「member を選択」。選択済みは member 名＋解除ボタン。「member を選択」クリックで検索用 Dialog を開き、q で GET /api/members/search を呼び、結果から選択。
- 表示モード: 既存の「照合」列を拡張。auto + matched → success Chip「既存 member（自動）」、manual + matched → primary Chip「既存 member（手動）」、new → warning Chip「新規作成」。

## 8. テスト観点

- PUT candidates で matched_member_id / matched_member_name / match_source を保存でき、show で manual matched として返ること。
- 集計に manual matched が matched_count に含まれること。
- apply 時に matched_member_id が優先され、その member で participant が作られること。
- 手動解除後は auto / new のルールに戻ること。
- GET /api/members/search が q で部分一致検索し上限件数を返すこと。

## 9. DoD

- [x] candidate ごとに手動で既存 member を選べる
- [x] 選択結果を保存できる
- [x] 解除できる
- [x] 集計に反映される
- [x] apply 時に手動指定が優先される
- [x] 既存 auto match を壊さない
- [x] php artisan test が通る
- [x] npm run build が通る
- [x] PLAN / WORKLOG / REPORT と INDEX・REGISTRY・progress を更新している
