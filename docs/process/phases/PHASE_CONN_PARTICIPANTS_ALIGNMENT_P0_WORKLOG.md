# PHASE CONN-PARTICIPANTS-ALIGN-P0 — WORKLOG

## 判断・根拠

- **自動生成の単一ソースではない:** `MeetingBreakoutService::updateBreakouts` と `MeetingBreakoutRoundsService::updateBreakoutRounds` の**両方**で、`Participant::firstWhere` が空のとき `Participant::create(['type' => 'regular'])` する同一パターンを確認。Connections（`DragonFlyBoard.jsx`）は `PUT /api/meetings/{id}/breakouts` のみ使用（`getMeetingBreakouts` / `putMeetingBreakouts`）。Round 系 API は別経路だが挙動は同型。  
- **左ペイン:** `refetchMembers` が `GET /api/dragonfly/members?owner_member_id=&with_summary=1` のみ。`selectedMeetingId` に依存しない。  
- **absent/proxy:** GET では `BreakoutRoom::participants()` 経由で `whereNotIn('type', ['absent','proxy'])` により **member_ids から除外**。PUT では既存 participant が absent/proxy のとき **422**。未存在時は **create してしまう**（自動生成）。  
- **CSV CLI:** `members` は `resolveOrCreateMember` で **`type` + `name` で既存検索**、見つかれば `display_no` 等更新、なければ `create`。SSOT 3.3 の「(type, display_no)」表現と**不一致**（実装コメントで意図あり）。  
- **CSV Apply:** `MeetingCsvMemberResolver` で **resolution または name** 。新規は `ApplyMeetingCsvImportService::resolveOrCreateMember` が `Member::create`。  
- **参加者 API:** `GET /api/dragonfly/meetings/{number}/attendees` は `MeetingAttendeesService` が `participants.type` を `member` / `visitor` / `guest` のみ分類。CSV が作る **`regular` / `proxy` はいずれのバケットにも入らない**ため、**一覧から漏れる**設計バグに近い挙動。

## 実施日

- 2026-03-31 JST
