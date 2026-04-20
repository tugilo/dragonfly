# PHASE CONN-BO-UX-GUARDS-P1 — PLAN

## Phase ID

**CONN-BO-UX-GUARDS-P1**

## Type

implement

## Related SSOT

- **SPEC-007:** [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](../../SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md)

## Scope

- `www/resources/js/admin/pages/DragonFlyBoard.jsx`
- `www/resources/js/admin/utils/boAssignmentGuards.js`（新規）
- `docs/SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md`（UX 節の追記）
- `docs/process/phases/*`（本 Phase の PLAN/WORKLOG/REPORT）
- `docs/INDEX.md` / `docs/dragonfly_progress.md` / `docs/process/PHASE_REGISTRY.md`

## Goal

BO 保存前に、**participant なし（一覧にいない member_id）・`bo_assignable: false`（代理等）** をクライアントで防ぎ、万一ペイロードに残った場合は **既存 API 422** をユーザーが理解できる文言で表示する。BO1→BO2 コピーで不正 ID が混ざらないようフィルタする。

## DoD

1. `toggleRoundMember` / `assignMemberToRoom` で割当不可の **追加** を拒否し、Snackbar で理由を表示。
2. `saveRounds` 前に全 `member_ids` を検証し、問題があれば **保存 API を呼ばない**。
3. `putMeetingBreakouts` の 422 応答に **接頭辞** を付けて `roundsError` に表示。
4. BO ルーム内チップで、**不正・割当不可** が視覚的に分かる（警告色＋文言）。
5. BO1→BO2 コピーは **`filterBoAssignableMemberIds`** でのみ反映、除外時は Snackbar。
6. `npm run build` 成功、`php artisan test` 回帰緑。

## Out of scope

- `MeetingBreakoutService` のバリデーション文言変更（サーバは最終防衛線として現状維持）。
- proxy を BO 対象にする仕様変更（将来は SSOT・API・UI の三方見直しが必要 — REPORT に記載）。
