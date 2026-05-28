# PHASE CONN-PARTICIPANTS-ALIGN-P0 — PLAN

| 項目 | 内容 |
|------|------|
| **Phase ID** | CONN-PARTICIPANTS-ALIGN-P0 |
| **種別** | docs（調査のみ・**コード変更なし**） |
| **Related SSOT** | SPEC-007 — [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](../../SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md) |
| **目的** | Connections / BO / participants / members 周りの**現状実装をコード根拠付きで固定**し、ユーザー提示の**推奨実装順**（保存締め → UI）と**変更最小単位**を REPORT に明文化する。 |
| **DoD** | PLAN / WORKLOG / REPORT 作成済み。`PHASE_REGISTRY.md`・`docs/INDEX.md`・`dragonfly_progress.md` 更新。実装コミットなし。 |

## Scope

- **含む:** `www/` 内の該当 Controller / Service / Command / Model / `DragonFlyBoard.jsx` / Feature テストの**読取と引用**。
- **含まない:** プロダクションコードの変更、マイグレーション、新 API の追加。

## 調査項目（必須）

1. BO 保存時に `participant` が無い `member_id` を送った場合の自動生成箇所  
2. Connections 左ペインが「全 members」由来になる箇所  
3. BO 保存時の `absent` / `proxy` の扱い  
4. CSV インポート（CLI / Meetings Apply）における `members` の解決・upsert キー  

## 読むファイル（最低限）

- `MeetingBreakoutService.php`、`MeetingBreakoutRoundsService.php`
- `MeetingBreakoutController.php`、`MeetingBreakoutRoundsController.php`（ルート確認）
- `UpdateMeetingBreakoutsRequest.php`（バリデーション）
- `DragonFlyBoard.jsx`（`refetchMembers`・`putMeetingBreakouts`）
- `DragonFlyMemberController.php`（`index`）
- `ImportParticipantsCsvCommand.php`
- `ApplyMeetingCsvImportService.php`、`MeetingCsvMemberResolver.php`
- `MeetingAttendeesService.php`、`DragonFlyMeetingController.php`（参加者 API）
- `Participant.php`、`Member.php`、`BreakoutRoom.php`
- `MeetingBreakoutsTest.php`、`MeetingBreakoutRoundsTest.php`

## 成果物

- `PHASE_CONN_PARTICIPANTS_ALIGNMENT_P0_WORKLOG.md`
- `PHASE_CONN_PARTICIPANTS_ALIGNMENT_P0_REPORT.md`（REPORT 必須項目を満たす）

## 推奨実装順（ユーザー提示・本 Phase では実装しない）

1. 現状調査と SSOT 整合確認（本 Phase）  
2. BO 保存時の participant 自動生成を禁止  
3. Connections 左ペインを参加者限定  
4. 未参加者を BO 保存時に拒否（2 と重複し得るため REPORT で整理）  
5. members 重複統合ルールの運用・仕様整備  
6. マージ補助・調査レポート化（必要なら）

**理由:** 先に保存側を締め、次に UI を合わせる方がデータ不整合が起きにくい。
