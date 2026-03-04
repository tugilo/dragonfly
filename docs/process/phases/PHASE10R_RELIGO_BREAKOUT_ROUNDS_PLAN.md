# PHASE10R Religo Breakout Round 可変 — PLAN

**Phase:** Meeting ごとに Breakout Round（回）を可変で管理（Phase10 の BO1/BO2 固定はレガシー互換で維持）  
**作成日:** 2026-03-04  
**SSOT:** [docs/SSOT/DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.5, §4.6. Phase10 互換を維持。

---

## 1. 狙い

- Round を固定しない（2 回が多いが増える可能性あり）。Round → Rooms（複数）を持つ。
- 同一 Round 内で同一 member が複数 Room に所属するのは禁止（422）。absent/proxy は割当不可（422）— Phase10 規約踏襲。
- ルームメモは breakout_rooms.notes を利用（Phase10 で追加済み）。
- **Phase10 の /api/meetings/{id}/breakouts（BO1/BO2 固定）は互換のため残す。** 10R は新 API（/breakout-rounds）とする。
- 個別メモ導線は既存 POST /api/contact-memos（memo_type=meeting, meeting_id 固定）を流用。

## 2. DB

- **breakout_rounds:** id, meeting_id (FK), round_no (int), label (string nullable), timestamps。unique(meeting_id, round_no)。
- **breakout_rooms:** breakout_round_id (FK, nullable) を追加。index(breakout_round_id)。既存データはバックフィルで round_no=1 の round を生成し breakout_round_id を設定。unique は (breakout_round_id, room_label) に変更（同一 round 内で room_label 一意）。breakout_round_id は運用上 NULL 禁止（UI/API は NULL を作らない）とし、nullable のままでも可。

## 3. API（10R 専用・Phase10 は維持）

- **GET /api/meetings/{meetingId}/breakout-rounds** — meeting + rounds[]。各 round に round_no, label, rooms[]（room_id, room_label, notes, member_ids）。
- **PUT /api/meetings/{meetingId}/breakout-rounds** — rounds[] を upsert。rounds[].rooms を (breakout_round_id, room_label) で upsert。participant_breakout は対象 Round の rooms に限定して削除→入れ直し。同一 Round 内重複 member → 422。absent/proxy → 422。Round 削除は行わない（PUT に無い round は触らない）。

## 4. UI（DragonFlyBoard.jsx）

- Phase10 の BO1/BO2 固定 UI は残す。
- 「BO（Round）」セクションを新設（10R）：Round 一覧（アコーディオン or タブ）、「+ Round 追加」、各 Round に BO1/BO2 2 カラム（rooms 配列）、ルームメモ・割当・保存（PUT /breakout-rounds）。成功後 GET /breakout-rounds 再取得＋members 再 fetch。ルーム内メンバーに「メモ」ボタン（Phase06 モーダル流用、memo_type=meeting）。

## 5. DoD

- [ ] Round 可変で保存できる（2 回以上）
- [ ] GET で復元できる
- [ ] ルームメモ保存できる
- [ ] BO 内から meeting メモが書ける
- [ ] Feature テスト green（10R + Phase10 既存テストも green）
- [ ] docs 更新（PLAN/WORKLOG/REPORT + INDEX/progress）
- [ ] 1 commit push → develop へ --no-ff merge
- [ ] REPORT に merge commit id とテスト結果
