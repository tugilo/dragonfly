# PLAN: BO-AUDIT-P2（レガシー BO 監査・workspace・actor）

| 項目 | 内容 |
|------|------|
| Phase ID | BO-AUDIT-P2 |
| 種別 | implement |
| Related SSOT | `BO_AUDIT_LOG_DESIGN.md`、`DATA_MODEL.md`、`DASHBOARD_DATA_SSOT.md` |
| ブランチ | `feature/phase-bo-audit-p2` |

---

## 1. 目的

P1 の監査基盤を **説明可能な運用**に近づける：`PUT .../breakout-assignments` の扱い確定、`workspace_id` 方針、`User::find(1)` からの離脱（auth 優先＋フォールバック）。

---

## 2. レガシー経路（F1）

- **利用:** `www/resources/views/dragonfly/mvp.blade.php` が `PUT .../breakout-assignments` / DELETE を呼ぶ。
- **意味:** `BreakoutAssignmentService` は participant ベースだが、永続は `breakout_rooms` / `participant_breakout` で **例会の BO 状態**を更新。主線と Dashboard 上の「BO 割当保存」**意味は一致**。
- **採用:** PUT 成功後に `BoAssignmentAuditLogWriter::logFromDragonFlyBreakoutAssignment`。`source = dragonfly_breakout_assignments`。
- **DELETE:** 割当解除のみ → **監査見送り**（イベント意味が「保存」と異なる）。
- **二重記録:** 同一ハンドラで Writer を複数回呼ばない。別 API の連続呼び出しは別イベントで正しい。

---

## 3. workspace_id（F2）

- **採用:** `Workspace::query()->orderBy('id')->value('id')`（単一チャプター既定）。0 件なら null。
- **Dashboard:** 活動フィルタは引き続き `actor_owner_member_id` のみ（P2 では workspace 絞り込みなし）。

---

## 4. actor（F3）

- **採用:** `auth()->user()` が `App\Models\User` なら使用。否则 **id 昇順先頭 User**（無認証 API の暫定）。
- **注入:** Writer に `?User $actor` を内部で統合（Controller からの明示渡しは不要）。

---

## 5. DoD

- [x] レガシー PUT 監査 or 見送り理由が SSOT/REPORT にある
- [x] `workspace_id`・actor 方針が実装・テストされている
- [x] `php artisan test` / `npm run build` 通過
- [x] feature → develop `--no-ff` merge・Merge Evidence・push

---

## 6. 対象外

BO 以外の監査、Dashboard UI 再設計、認証基盤の全面改修。
