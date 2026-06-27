# Phase 264 WORKLOG — Admin API Role Enforcement

**Branch:** `feature/phase264-admin-role-enforcement`

---

## 判断ログ

### 編集系の集約方法
- `routes/api.php` の `auth:sanctum` group 内に **`religo.chapter_admin` ネスト group** を追加し、編集系（書き込み）API をそこへ移動。
- GET（閲覧）は member のまま残す（SPEC-014: 例会データ閲覧は自由・編集は admin）。

### member のまま残す書き込み
- owner スコープの本人データ（contact-memos / one-to-ones / introductions / internal-referrals / dragonfly flags / users/me / zoom・ai credentials）は Phase 263 で owner 固定済みのため member 継続。
- これらは「自分のデータ操作」であり管理操作ではない。

### admin 限定にした書き込み
- Member マスタ PUT、Categories/Roles の POST/PUT/DELETE、Meetings の POST/PATCH・memo PUT・CSV import 系・participants import 系・breakouts/breakout-rounds PUT。

### テスト調整
- 編集系 Feature test の acting user を `chapter_admin` に変更（CategoryApiTest, RoleApiTest, DragonFlyMemberEmail/Ncast, MeetingController, MeetingCsvImport, MeetingParticipantImport, MeetingBreakouts, MeetingBreakoutRounds, MeetingMemo）。
- `actingAs($user)` で差し替える箇所（MeetingBreakouts P3/P4・MeetingMemo factory・Dashboard breakout）は当該 user の `religo_role` を chapter_admin に設定。
- 新規 `AdminRoleEnforcementTest` で member 403・admin 許可・閲覧継続を検証。

### テスト結果
- `php artisan test`: **567 passed (2086 assertions)**。
- React 変更なしのため npm build スキップ。
