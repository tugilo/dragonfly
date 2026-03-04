# PHASE10R Religo Breakout Round 可変 — WORKLOG

**Phase:** Round 可変 BO ビルダー（Phase10 互換維持）  
**作成日:** 2026-03-04

---

## Step 1: ブランチ・PLAN

- develop から `feature/phase10r-breakout-rounds-v1` を作成。
- PHASE10R_RELIGO_BREAKOUT_ROUNDS_PLAN.md を作成。

## Step 2: DB

- breakout_rounds テーブル作成（meeting_id, round_no, label）。unique(meeting_id, round_no)。
- breakout_rooms に breakout_round_id (nullable, FK) 追加。バックフィルで既存 meeting ごとに round_no=1 を作成し、該当 rooms に breakout_round_id を設定。unique(meeting_id, room_label) を削除し、unique(breakout_round_id, room_label) を追加。
- BreakoutRound モデル追加。Meeting hasMany BreakoutRound、BreakoutRound hasMany BreakoutRoom。BreakoutRoom belongsTo BreakoutRound。

## Step 3: Phase10 互換

- MeetingBreakoutService を round_no=1 前提に変更：getBreakouts は round_no=1 の BreakoutRound を取得（無ければ作成）、その round の rooms を返す。updateBreakouts は同様に round 1 の rooms のみ更新。既存 MeetingBreakoutsTest が green のままであることを確認。

## Step 4: 10R API

- MeetingBreakoutRoundsController、UpdateMeetingBreakoutRoundsRequest、MeetingBreakoutRoundsService。GET/PUT /api/meetings/{id}/breakout-rounds。PUT は DB::transaction、rounds upsert、rooms upsert、participant_breakout は対象 round の room のみ削除→入れ直し。

## Step 5: UI

- DragonFlyBoard に「BO（Round）」セクション追加。Meeting 選択は既存流用。Round 一覧＋「+ Round 追加」、各 Round に BO1/BO2 カラム、保存・メモボタン。

## Step 6: テスト・手動スモーク

- MeetingBreakoutRoundsTest で 5 ケース実装・green。全体テストで Phase10 の MeetingBreakoutsTest も green。
- **手動スモーク（必須）:** meeting 選択 → Round1 表示；Round2 追加 → 保存 → 再読込で維持；Round1/2 で割当・ルームメモ保存 → 維持；ルーム内メンバーから個別メモ → last_memo 更新（members 再 fetch で反映）。実施後に本節に「実施済み YYYY-MM-DD」と追記すること。

## Step 7: docs・merge

- INDEX / dragonfly_progress 更新。1 commit push → develop merge（--no-ff）→ test → push。REPORT に証跡。
