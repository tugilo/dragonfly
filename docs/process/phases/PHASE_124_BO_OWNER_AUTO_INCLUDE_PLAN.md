# Phase 124 PLAN — Connections BO 保存時に Owner を未所属なら BO1 へ自動追加

- **Phase ID:** 124
- **種別:** implement
- **Related SSOT:** SPEC-002（CONTACT_LOGIC_ALIGNMENT）、DATA_MODEL §4.5–4.6、SPEC-007（参加者必須）
- **モック比較:** なし（API・データ整合の内部挙動）

## 背景

Dashboard 未接触が「BO を保存しているのに owner が `participant_breakout` に載らない」原因の一つは、**BO リストにグローバル Owner の member_id が含まれていない**こと。運用上は自分の卓にいる前提のため、保存時に **どの BO にも含まれない Owner は BO1 に自動追加**する。

## Scope

- `www/app/Services/Religo/MeetingBreakoutService.php` — マージ処理
- `www/app/Http/Controllers/Religo/MeetingBreakoutController.php` — PUT 前マージ
- `www/app/Http/Requests/Religo/UpdateMeetingBreakoutsRequest.php` — `owner_member_id` 検証（任意）
- `www/resources/js/admin/pages/DragonFlyBoard.jsx` — 保存ペイロードに `owner_member_id`
- `www/tests/Feature/Religo/MeetingBreakoutsTest.php`
- `docs/SSOT/CONTACT_LOGIC_ALIGNMENT.md`
- Phase レジストリ・INDEX・進捗

## 仕様

1. `PUT /api/meetings/{id}/breakouts` の JSON に任意キー **`owner_member_id`**（integer・`members.id` が存在すること）。
2. **`owner_member_id` が null／省略** → 従来どおり（後方互換）。
3. **`owner_member_id` が BO1 または BO2 のいずれかの `member_ids` に既に含まれる** → 変更なし。
4. **どちらにも含まれない** → **BO1** の `member_ids` に追加（重複なし）。その後既存の `updateBreakouts`・participant 必須チェックが走る（例会に participant が無ければ従来どおり 422）。
5. **`breakout-rounds` API** は本 Phase 対象外（Connections は `breakouts` のみ使用）。

## DoD

- 上記仕様の Feature テストが通る。
- `php artisan test` 成功、`npm run build` 成功。
- CONTACT_LOGIC_ALIGNMENT に 1 行追記済み。
