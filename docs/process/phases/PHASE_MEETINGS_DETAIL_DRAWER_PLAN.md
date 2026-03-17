# Phase Meetings Detail Drawer — PLAN

**Phase:** M3（例会詳細 Drawer）  
**作成日:** 2026-03-17  
**SSOT:** [FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md)、[PHASE_MEETINGS_ROW_ACTIONS_REPORT.md](PHASE_MEETINGS_ROW_ACTIONS_REPORT.md)

---

## 1. 背景

- Phase M1/M2 により Meetings 一覧にサブ説明・BO数/メモ列・行アクション（📝メモ・🗺BO編集）が実装済み。右パネル／Drawer は未実装で、FIT_AND_GAP_MEETINGS の M13/M14 が Gap のまま。
- モックでは行選択で右パネルに「番号・日付・BO数・メモ有無・メモ本文・BO割当一覧・メモ編集/Connectionsへ」を表示している。M3 は「Meeting を理解できる一覧」にするため、行選択で詳細を表示する UX を実装する。

---

## 2. 目的

- Drawer（または右パネル）で例会詳細を表示できるようにする。
- 詳細に最低限、**番号・日付・BO数・メモ本文・BO割当一覧**を表示する。
- 一覧の行クリックで詳細が開く UX を実装する。MUI / React Admin に自然な Drawer でよい。
- 一覧 API はそのまま使い、詳細表示用データは別取得とする。

---

## 3. スコープ

- **変更可能:** MeetingController（show メソッド追加）、routes/api.php、MeetingsList.jsx、docs/process/phases/PHASE_MEETINGS_DETAIL_DRAWER_*.md、必要ならテスト追加
- **変更しない:** 一覧 API の返却形、M2 の Actions 列・handleMeetingMemoClick、他リソース。M4 のメモ保存処理は行わない。

---

## 4. 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| www/app/Http/Controllers/Religo/MeetingController.php | show(meetingId) を追加。詳細用に meeting・memo_body・rooms（BO割当＋メンバー名）を返す |
| www/routes/api.php | GET /meetings/{meetingId} を追加 |
| www/resources/js/admin/pages/MeetingsList.jsx | Drawer 用 state、rowClick、詳細取得、MeetingDetailDrawer コンポーネント |
| www/tests/Feature/Religo/MeetingControllerTest.php | show のテストを追加（任意・推奨） |
| docs/process/phases/PHASE_MEETINGS_DETAIL_DRAWER_*.md | PLAN / WORKLOG / REPORT |

---

## 5. 実装方針

### 5.1 データ取得

- **一覧:** 既存 GET /api/meetings をそのまま利用。
- **詳細:** 新規 GET /api/meetings/{meetingId} を追加。
  - meeting: id, number, held_on, breakout_count, has_memo（一覧と同定義）。
  - memo_body: contact_memos のうち meeting_id 一致かつ memo_type='meeting' の 1 件の body（複数ある場合は先頭 1 件）。無ければ null。
  - rooms: 既存 MeetingBreakoutService::getBreakouts の返却に、各 room の member_ids に対応する member の name を付与（member_names または members 配列）。BO割当一覧表示に必要。

### 5.2 バックエンド

- MeetingController::show(int $meetingId): Meeting を取得、存在しなければ 404。withCount と has_memo は index と同様。memo_body は ContactMemo::where('meeting_id', $id)->where('memo_type', 'meeting')->orderByDesc('created_at')->value('body')。rooms は MeetingBreakoutService::getBreakouts を呼び、各 room の member_ids から Member::whereIn('id', ...)->get(['id','name']) で名前を取得し付与。

### 5.3 フロント

- **State:** selectedMeeting（一覧行の record または null）、detailOpen（boolean）、detailLoading（boolean）、detailData（null または { meeting, memo_body, rooms }）。
- **行クリック:** Datagrid の rowClick を「詳細を開く」関数に変更。クリック時に selectedMeeting をセットし detailOpen を true に。Drawer が open になったタイミングで selectedMeeting.id を使って GET /api/meetings/{id} を発行し、detailData をセット。Actions 列のボタンクリックでは行クリックが発火しないよう、既存ボタンに stopPropagation を追加する。
- **Drawer:** MUI Drawer anchor="right"、open={detailOpen}、onClose で detailOpen を false。幅は 380～400px 程度。中身は「📋 例会詳細」タイトル、番号・日付・BO数・メモ有無／メモ本文、BO割当一覧（room_label ＋ メンバー名）、「📝 メモ編集」「🗺 Connectionsへ」ボタン。loading 中はスピナーまたはスケルトン。
- **詳細コンポーネント:** 同一ファイル内で MeetingDetailDrawer として切り出し、props で open / onClose / data / loading / onMemoClick / meetingFromList を渡す。M4 でメモ編集 Dialog と接続しやすいよう onMemoClick(record) は維持。

---

## 6. テスト観点

- 行クリックで Drawer が開くこと。Actions 列のボタンクリックでは Drawer が開かないこと（イベント伝播止め）。
- 番号・日付・BO数が表示されること。
- メモ本文がある場合に表示されること。無い場合は「なし」または表示しない。
- BO割当一覧（BO1/BO2 とメンバー名）が表示されること。
- 「📝 メモ編集」「🗺 Connectionsへ」が表示され、Connections へ遷移できること。
- 既存の一覧表示・Actions 列に影響がないこと。
- php artisan test の既存回帰がないこと。

---

## 7. DoD

- [x] GET /api/meetings/{meetingId} が存在し、meeting・memo_body・rooms（メンバー名付き）を返すこと。
- [x] 一覧の行クリックで Drawer が開き、詳細が表示されること。
- [x] 詳細に番号・日付・BO数・メモ本文・BO割当一覧が表示されること。
- [x] 「📝 メモ編集」「🗺 Connectionsへ」の導線があること。
- [x] M2 の Actions 列・行アクションがそのまま動作すること。
- [x] PLAN / WORKLOG / REPORT が揃っていること。

---

## 8. 参照

- モック: http://localhost/mock/religo-admin-mock-v2.html#/meetings  
- 実装: http://localhost/admin#/meetings  
- 既存: GET /api/meetings/{meetingId}/breakouts（MeetingBreakoutService）
