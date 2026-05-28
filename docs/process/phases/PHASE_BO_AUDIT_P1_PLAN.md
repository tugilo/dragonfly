# PLAN: BO-AUDIT-P1（BO保存の監査ログ設計・Dashboard activity 接続前提）

| 項目 | 内容 |
|------|------|
| Phase ID | BO-AUDIT-P1 |
| 種別 | implement |
| Related SSOT | `DATA_MODEL.md`、`DASHBOARD_FIT_AND_GAP.md`、`FIT_AND_GAP_MOCK_VS_UI.md`、`DASHBOARD_DATA_SSOT.md`、`DASHBOARD_P7_3_FINISHING_REPORT`（BO 見送り理由） |
| ブランチ | `feature/phase-bo-audit-p1` |
| モック比較 | 本 Phase は設計・最小実装が主。Activity 文言は `docs/SSOT/MOCK_UI_VERIFICATION.md` の Dashboard 操作で確認可能なら実施。 |

---

## 1. 背景

- DASHBOARD-P7-3 で **`bo_assigned` はイベント源が無いため未実装**と整理済み。
- 本 Phase で **BO 保存の発生源・監査責務・最小データモデル**を固定し、曖昧なまま Activity に載せない。

---

## 2. 調査タスク（F1）

- `PUT .../breakouts`、`PUT .../breakout-rounds`、レガシー DragonFly、CSV apply の各経路を整理。
- `meeting_csv_apply_logs` の責務（参加者/members/roles 反映）と BO 割当の非一致を確認。

**出力:** イベント発生箇所・呼ばれる処理・永続イベントの有無・Dashboard 源としての可否。

---

## 3. 設計タスク（F2〜F4）

- **F2:** 監査ログを Meetings / Connections（クライアント概念のみ）/ 専用 に振り分け比較。**採用: Meetings ドメイン**（`meeting_id` 主軸、breakout 保存 API 成功直後に 1 行）。
- **F3:** 保存項目: `meeting_id`, `actor_user_id`, `actor_owner_member_id`, `source`, `payload`, `occurred_at`（before/after は P1 では持たない）。
- **F4:** Activity `kind=bo_assigned`、title/meta 規約、`getActivity` でのマージ・ソート（`occurred_at` 降順）。

---

## 4. 実装方針（最小）

- マイグレーション `bo_assignment_audit_logs`、Model、`BoAssignmentAuditLogWriter`。
- `MeetingBreakoutController`、`MeetingBreakoutRoundsController` の保存成功後に Writer 呼び出し。
- `DashboardService::getActivity` に統合。
- Feature テスト: breakouts 保存後に activity に `bo_assigned` が含まれること。
- **スコープ外:** `PUT /api/dragonfly/meetings/{number}/breakout-assignments`（別 Phase で source 追加可）。

---

## 5. DoD

- [x] BO 保存イベント源がドキュメントで説明できる。
- [x] 監査責務が固定されている（SSOT: `BO_AUDIT_LOG_DESIGN.md`）。
- [x] 保存項目・Activity 接続方針が `DATA_MODEL` / `DASHBOARD_*` に反映されている。
- [x] 最小実装が動き、`php artisan test` / `npm run build` 通過。
- [x] `feature/phase-bo-audit-p1` を `develop` に `--no-ff` merge、REPORT に Merge Evidence、registry / progress / INDEX 更新。

---

## 6. 対象外

- BO 全面再設計、Connections 業務フロー改修、Dashboard 大型 UI 変更、権限の本格見直し。
