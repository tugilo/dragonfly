# PHASE10 Religo Meeting Breakout Room Builder（BO1/BO2）— PLAN

**Phase:** ミーティングごとに BO1/BO2 のメンバー割当・ルームメモ・メンバーへのメモ導線  
**作成日:** 2026-03-04  
**SSOT:** [docs/SSOT/DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.4 participants, §4.5 breakout_rooms, §4.6 participant_breakout, §4.8 contact_memos

---

## 1. 狙い

- Meeting 選択（または作成）→ **BO1/BO2 のメンバー割当**を保存できる。
- BO1/BO2 それぞれに**ルームメモ**を保存できる。
- BO に参加した各メンバーに**個別メモ（contact_memos, memo_type=meeting）**を書ける導線がある。
- 保存後、Religo の summary 系（同室回数など）が更新される前提データが整う。

## 2. スコープロック

- **変更対象:** breakout_rooms.notes 追加、Religo 用 API（meetings 一覧・breakouts 取得/保存）、DragonFlyBoard の BO ビルダー UI、Feature テスト。既存 Phase04〜09 の挙動は維持する。
- **既存を壊さない:** DragonFly 既存 API（dragonfly/meetings/{number}/…）はそのまま。Religo 用に `/api/meetings` と `/api/meetings/{meetingId}/breakouts` を新設。

## 3. UI 追加箇所

- **ファイル:** `www/resources/js/admin/pages/DragonFlyBoard.jsx`
- **内容:** Meeting 選択ドロップダウン、BO1/BO2 の 2 カラム（ルームメモ textarea、メンバー割当チェック）、保存ボタン、各メンバー行の「メモ」ボタン（Phase06 メモモーダルを meeting_id 固定で流用）。

## 4. API 追加

| メソッド | エンドポイント | 概要 |
|----------|----------------|------|
| GET | /api/meetings | 一覧。`[{ id, number, held_on }]`。直近順。 |
| GET | /api/meetings/{meetingId}/breakouts | 割当取得。`{ meeting, rooms: [{ id, room_label, notes, member_ids }] }`。 |
| PUT | /api/meetings/{meetingId}/breakouts | 割当・ルームメモ保存。`{ rooms: [{ room_label, notes, member_ids }] }`。 |

- **member_ids:** 同室算出規約に合わせ、participant の type が absent/proxy の場合は含めない。PUT で absent/proxy に該当する member_id が渡された場合は **422 で拒否**（事故防止）。

## 5. DB 変更（最小）

- **breakout_rooms:** `notes`（TEXT, nullable）を追加する migration のみ。既存カラムは変更しない。

## 6. PUT 保存仕様（超重要）

- meeting に紐づく breakout_rooms を **BO1/BO2 の 2 部屋分**確保（無ければ作成）。`room_label` は "BO1" / "BO2"。
- 各 room の `notes` を更新。
- `member_ids` を participants に変換: (meeting_id, member_id) が無ければ作成（type=regular）、既存はその participant を使用。**既存が type=absent または proxy の場合は 422**。
- **participant_breakout** は当該 meeting の 2 部屋分をいったん削除してから、新しい割当で入れ直す（越境禁止）。
- **同一 member が BO1/BO2 両方に含まれる場合は 422**。

## 7. DoD

- [ ] BO1/BO2 の割当を PUT で保存できる
- [ ] GET で現在の割当が復元できる
- [ ] breakout_rooms.notes でルームメモが保存される
- [ ] BO 内の各メンバーに meeting メモ（contact_memos）が書ける導線がある
- [ ] Feature テストが green
- [ ] PLAN / WORKLOG / REPORT ＋ INDEX / progress 更新
- [ ] 1 commit push → develop へ --no-ff merge → test → push
- [ ] REPORT に merge commit id とテスト結果を記録
