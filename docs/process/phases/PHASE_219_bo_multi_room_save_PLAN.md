# Phase 219: BO 3枠以上の保存 — PLAN

| Phase ID | 219 |
|----------|-----|
| Type | implement |
| Status | completed |
| Branch | feature/phase219-bo-multi-room-save |
| Related SSOT | DATA_MODEL §4.5/§4.6, [FIT_AND_GAP_BO_COPY_FROM_PREVIOUS.md](../../SSOT/FIT_AND_GAP_BO_COPY_FROM_PREVIOUS.md), MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY §5.5 |

## 背景

Connections UI は「＋ 同室枠を追加」で BO3 以降を編集できるが、`PUT /api/meetings/{id}/breakouts` が BO1/BO2 固定のため保存後に消失していた。

## Scope

- `www/app/Services/Religo/MeetingBreakoutService.php`
- `www/app/Http/Requests/Religo/UpdateMeetingBreakoutsRequest.php`
- `www/app/Http/Controllers/Religo/MeetingBreakoutController.php`（コメント）
- `www/resources/js/admin/pages/DragonFlyBoard.jsx`（直前 BO コピー一般化）
- `www/tests/Feature/Religo/MeetingBreakoutsTest.php`
- `docs/SSOT/FIT_AND_GAP_BO_COPY_FROM_PREVIOUS.md`
- Phase 219 ドキュメント、`PHASE_REGISTRY.md`

## DoD

- [x] BO1..BOn（最大20）を PUT/GET で永続化
- [x] payload に無い BO* ルームは削除（BO 以外の room_label は不変更）
- [x] BO1 から連番必須のバリデーション
- [x] BO2 以降に「直前 BO→現在 BO コピー」ボタン
- [x] php artisan test 全件 pass
- [x] npm run build 成功

## モック比較

対象外（API + Connections 中央ペインの挙動修正。モック差分記録は FIT_AND_GAP_BO_COPY_FROM_PREVIOUS 更新で代替）。
