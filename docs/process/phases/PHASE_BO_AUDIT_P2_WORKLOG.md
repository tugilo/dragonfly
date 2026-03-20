# WORKLOG: BO-AUDIT-P2

## 判断

### レガシー breakout-assignments の責務評価

- **PUT:** `DragonFlyBreakoutAssignmentController::store` → `BreakoutAssignmentService::saveAssignment`。Session（1/2）＋ participant 同室者。主線の member_ids 一括 PUT とは **ペイロックが異なる**が、永続先は同じ BO 関連テーブル。**「例会の BO 割当が更新された」**という Dashboard 意味で主線と整合するため、`bo_assigned` のまま `source` のみ分離した。
- **DELETE:** 「保存」ではないため監査に含めない。

### 接続したか

- **接続した**（PUT のみ）。`BoAssignmentAuditLog::SOURCE_DRAGONFLY_BREAKOUT_ASSIGNMENTS`。

### actor をどう取得したか

- `BoAssignmentAuditLogWriter::resolveActorUser()`：`auth()->user()` が `User` なら採用。テストでは `actingAs` で検証。無認証では **`User::orderBy('id')->first()`** にフォールバック（旧 `find(1)` を一般化）。

### workspace をどう決めたか

- `resolveWorkspaceIdForAudit()`：**workspaces の最小 id**。DragonFly 単一チャプター前提で flags/memos と同様「章の既定」を置ける。未シード環境では null。

### writer をどう変えたか

- `createLog` に集約。各 `logFrom*` は payload と source のみ差分。オプション `?User $actor` は拡張用（Controller は未変更でも可）。

### Dashboard との整合

- `formatBoAssignmentActivityMeta` にレガシー分岐を追加。`kind`・owner フィルタ・ソートは P1 のまま。`workspace_id` は Activity クエリに未使用。

### merge 時の競合

- **なし**（`develop` に `feature/phase-bo-audit-p2` を `--no-ff` merge）。
