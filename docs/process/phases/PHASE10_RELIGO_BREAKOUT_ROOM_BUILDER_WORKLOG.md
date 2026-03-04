# PHASE10 Religo Meeting Breakout Room Builder — WORKLOG

**Phase:** BO1/BO2 割当・ルームメモ・メンバーへのメモ導線  
**作成日:** 2026-03-04

---

## Step 1: ブランチ・PLAN

- develop から `feature/phase10-breakout-room-builder-v1` を作成。
- PHASE10_RELIGO_BREAKOUT_ROOM_BUILDER_PLAN.md を作成（UI 箇所・API・DB・PUT 仕様・DoD）。

## Step 2: DB Migration

- `add_notes_to_breakout_rooms_table` で `notes` (text, nullable) を追加。BreakoutRoom の fillable に `notes` を追加。

## Step 3: API（Laravel）

- GET /api/meetings: MeetingController（Religo）または既存拡張。id, number, held_on を直近順で返す。
- MeetingBreakoutController: show(meetingId) → GET breakouts、update(meetingId) → PUT breakouts。
- MeetingBreakoutService: getBreakouts、updateBreakouts（トランザクション、BO1/BO2 確保、notes 更新、participant 解決、participant_breakout クリア→入れ直し、重複・absent/proxy は 422）。
- UpdateMeetingBreakoutsRequest: rooms[].room_label, notes, member_ids。バリデーションで重複 member は 422 にしても可（サービス側でも実施）。

## Step 4: UI（DragonFlyBoard.jsx）

- Meeting 選択（GET /api/meetings）。選択後 GET /api/meetings/{id}/breakouts で BO1/BO2 表示。
- BO1/BO2 各カラム: ルームメモ textarea、メンバー割当（members 一覧からチェック）。保存で PUT。成功後 breakouts 再取得 ＋ members 再 fetch。
- 各メンバー行に「メモ」ボタン。クリックでメモモーダルを開き、memo_type=meeting, meeting_id=選択中 meeting, target_member_id=そのメンバーで POST contact-memos。成功後 members 再 fetch。

## Step 5: Feature テスト

- MeetingBreakoutsTest: (1) PUT→GET で member_ids と notes 一致、(2) 同一 member が BO1/BO2 両方→422、(3) 別 meeting の breakout は壊れない、(4) participant が無い member_id でも participant 作成して割当可。

## Step 6: 手動スモーク（REPORT に記載）

- meeting 選択→BO1/BO2 表示、割当・メモ保存→再読込で維持、BO 内メンバーから個別メモ→members 一覧の last_memo 更新。

## Step 7: ドキュメント・merge

- INDEX / dragonfly_progress 更新。1 commit push → develop merge（--no-ff）→ test → push。REPORT に証跡追記。
