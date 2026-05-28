# PHASE CONN-BO-PARTICIPANT-REQUIRED-P1 — PLAN

| 項目 | 内容 |
|------|------|
| **Phase ID** | CONN-BO-PARTICIPANT-REQUIRED-P1 |
| **種別** | implement |
| **Related SSOT** | SPEC-007 — [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](../../SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md) |
| **前提調査** | [PHASE_CONN_PARTICIPANTS_ALIGNMENT_P0_REPORT.md](PHASE_CONN_PARTICIPANTS_ALIGNMENT_P0_REPORT.md) |
| **目的** | `PUT .../breakouts` / `PUT .../breakout-rounds` で、`participant` 不在の `member_id` を **自動作成せず 422 で拒否**する。 |
| **DoD** | サービス改修・テスト更新・`DragonFlyBoard` 422 表示・SSOT 5.2 更新・REPORT・レジストリ・INDEX・進捗・`npm run build`・`php artisan test` 通過。 |

## Scope

- `MeetingBreakoutService::updateBreakouts`
- `MeetingBreakoutRoundsService::updateBreakoutRounds`
- Feature テスト（`MeetingBreakoutsTest` / `MeetingBreakoutRoundsTest` / `DashboardApiTest` 該当）
- `DragonFlyBoard.jsx` — `putMeetingBreakouts` のエラー本文

## 非スコープ（次 Phase）

- Connections 左ペインの参加者限定表示
- `MeetingAttendeesService` の `regular`/`proxy` 分類修正
