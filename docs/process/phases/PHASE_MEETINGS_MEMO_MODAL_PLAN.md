# Phase Meetings Memo Modal — PLAN

**Phase:** M4（例会メモ編集モーダル）  
**作成日:** 2026-03-17  
**SSOT:** [FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md)、[PHASE_MEETINGS_DETAIL_DRAWER_REPORT.md](PHASE_MEETINGS_DETAIL_DRAWER_REPORT.md)

---

## 1. 背景

- Phase M1〜M3 により一覧・行アクション・詳細 Drawer が実装済み。handleMeetingMemoClick はプレースホルダのまま。Drawer 内「📝 メモ編集」も onMemoClick で接続可能な状態。
- モックの「📝 例会メモ編集 — #247」モーダルに相当する UI と保存処理が未実装。M4 で例会メモ編集 Dialog を実装し、一覧と Drawer の両方から開き、保存後に has_memo / memo_body が反映されるようにする。

---

## 2. 目的

- 例会メモ編集 Dialog を実装する。
- 一覧の「📝 メモ」と Drawer 内「📝 メモ編集」の両方から同じ Dialog を開けるようにする。
- 対象 meeting の既存メモ本文を Dialog の初期値として表示する。
- 保存処理を実装し、保存後に一覧の has_memo と Drawer の memo_body を反映する。
- M3 までの既存 UX を壊さないこと。

---

## 3. スコープ

- **変更可能:** MeetingMemoController（新規または既存 routes 用に実体作成）、routes/api.php、MeetingsList.jsx、必要なら Request/テスト、docs/process/phases/PHASE_MEETINGS_MEMO_MODAL_*.md
- **変更しない:** GET /api/meetings、GET /api/meetings/{id} の既存返却形。複数履歴・履歴管理は行わない。

---

## 4. 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| www/app/Http/Controllers/Religo/MeetingMemoController.php | 新規。show(meetingId)、update(meetingId)、index()（既存 route 用の最小実装） |
| www/app/Http/Requests/Religo/UpdateMeetingMemoRequest.php | 新規。body を nullable string、max 長など |
| www/routes/api.php | GET/PUT /meetings/{meetingId}/memo を追加。既存 GET /meeting-memos は MeetingMemoController@index のまま |
| www/resources/js/admin/pages/MeetingsList.jsx | memoDialogOpen, memoTargetMeeting, memoValue, memoSaving、handleMeetingMemoClick 実装、Dialog、保存後 refresh と detailData 更新 |
| www/tests/Feature/Religo/MeetingMemoControllerTest.php | 新規。show/update のテスト |
| docs/process/phases/PHASE_MEETINGS_MEMO_MODAL_*.md | PLAN / WORKLOG / REPORT |

---

## 5. 実装方針

### 5.1 メモ保存の設計

- 「1 meeting = 1 現在メモ」として扱う。meeting_id 一致かつ memo_type='meeting' の最新 1 件を更新対象。無ければ新規作成。複数履歴は今回やらない。
- **空文字保存:** メモなし扱い。既存行があれば削除し、has_memo を false に戻す。
- 新規作成時は owner_member_id / target_member_id が必要。既定は先頭 member（id=1 等）を用いる。

### 5.2 API

- **GET /api/meetings/{meetingId}/memo:** Meeting 存在確認後、contact_memos の meeting_id + memo_type='meeting' の最新 1 件の body を返す。無ければ { body: null }。Meeting が無ければ 404。
- **PUT /api/meetings/{meetingId}/memo:** Request body: { body: string }。空文字または未送信なら「メモなし」扱いで既存行を削除。それ以外なら firstOrCreate で 1 件に更新。レスポンスは { body: string | null, has_memo: bool }。
- **GET /meeting-memos:** 既存 route のため MeetingMemoController@index を実装。最小で空配列または一覧を返す。

### 5.3 フロント

- State: memoDialogOpen, memoTargetMeeting（{ id, number, ... }）, memoValue（textarea の値）, memoSaving。
- handleMeetingMemoClick(record): memoTargetMeeting をセット。Drawer の detailData で同じ meeting の memo_body があればそれを memoValue に、無ければ GET /api/meetings/{id}/memo で取得して memoValue にセット。memoDialogOpen = true。
- Dialog: タイトル「📝 例会メモ編集 — #{number}」、textarea（memoValue 制御）、「BO割当の詳細は Connectionsで編集」案内、キャンセル／保存。保存時は memoSaving=true、PUT /api/meetings/{id}/memo、成功後に useRefresh() で一覧再取得、selectedMeeting.id が同じなら detailData を setDetailData(prev => ({ ...prev, memo_body: res.body, meeting: { ...prev.meeting, has_memo: res.has_memo } })) で更新。memoDialogOpen=false、state リセット。
- Dialog を閉じるときは memoDialogOpen=false、memoTargetMeeting=null、memoValue=''、memoSaving=false にリセット。

---

## 6. テスト観点

- 一覧の「📝 メモ」で Dialog が開くこと。
- Drawer 内「📝 メモ編集」で同じ Dialog が開くこと。
- 既存メモがある場合、初期表示されること。
- 保存後、一覧の has_memo が反映されること（refresh で再取得）。
- Drawer が同じ meeting を表示している場合、memo_body が更新されること。
- 空文字保存でメモが削除され、has_memo が false になること。
- php artisan test の既存回帰がないこと。

---

## 7. DoD

- [x] GET /api/meetings/{meetingId}/memo が実装され、body を返すこと。
- [x] PUT /api/meetings/{meetingId}/memo が実装され、空文字で削除・非空で保存できること。
- [x] 一覧と Drawer の両方から Dialog が開き、保存後に一覧と Drawer に反映されること。
- [x] M3 までの UX（行クリック、Actions、Drawer）が維持されていること。
- [x] PLAN / WORKLOG / REPORT が揃っていること。

---

## 8. 参照

- モック: http://localhost/mock/religo-admin-mock-v2.html#/meetings（例会メモ編集モーダル）
- 実装: http://localhost/admin#/meetings
