# REPORT: WORKSPACE-SINGLE-CHAPTER-ASSUMPTION

| 項目 | 内容 |
|------|------|
| Phase ID | WORKSPACE-SINGLE-CHAPTER-ASSUMPTION |
| 種別 | docs（＋ PHP docblock のみ） |
| Related SSOT | `DATA_MODEL.md`、`WORKSPACE_RESOLUTION_POLICY.md`、`USER_ME_AND_ACTOR_RESOLUTION.md`、`BO_AUDIT_LOG_DESIGN.md`、`DASHBOARD_DATA_SSOT.md` |

---

## 1. 実施内容サマリ

BNI 前提の **1 user = 1 workspace（原則）** と **チャプター ≒ workspace** を DATA_MODEL に新設セクションで固定。`default_workspace_id` を **所属 workspace** と再定義し、[WORKSPACE_RESOLUTION_POLICY.md](../../SSOT/WORKSPACE_RESOLUTION_POLICY.md) で解決順を **所属 / legacy 補完 / システムフォールバック**として明文化。USER_ME・BO_AUDIT・DASHBOARD_DATA_SSOT を **「所属チャプター」** 表現で揃えた。実装ロジックは据え置き、`ReligoActorContext` / `UserController` / `BoAssignmentAuditLogWriter` の **docblock のみ**更新。

---

## 2. 変更ファイル一覧

| パス |
|------|
| `docs/SSOT/DATA_MODEL.md` |
| `docs/SSOT/WORKSPACE_RESOLUTION_POLICY.md` |
| `docs/SSOT/USER_ME_AND_ACTOR_RESOLUTION.md` |
| `docs/SSOT/BO_AUDIT_LOG_DESIGN.md` |
| `docs/SSOT/DASHBOARD_DATA_SSOT.md` |
| `docs/process/phases/PHASE_WORKSPACE_SINGLE_CHAPTER_ASSUMPTION_{PLAN,WORKLOG,REPORT}.md` |
| `docs/process/PHASE_REGISTRY.md` |
| `docs/INDEX.md` |
| `docs/dragonfly_progress.md` |
| `www/app/Services/Religo/ReligoActorContext.php`（コメントのみ） |
| `www/app/Http/Controllers/Religo/UserController.php`（コメントのみ） |
| `www/app/Services/Religo/BoAssignmentAuditLogWriter.php`（コメントのみ） |

---

## 3. BNI 前提の設計整理

- **1 ユーザーは 1 チャプターのみ**（プロダクト前提）。
- **1 チャプター = 1 workspace 行**。
- **多対多 user⇄workspace** は **スコープ外**（DATA_MODEL・WORKSPACE_RESOLUTION_POLICY に明記）。

---

## 4. SSOT 更新内容（要約）

- **DATA_MODEL:** 「Workspace と User の関係」追加、Entities / Relationships / users 表の記述更新。
- **WORKSPACE_RESOLUTION_POLICY:** 前提・解決順の意味論・命名方針・スコープ外セクション追加。
- **USER_ME:** `workspace_id` の意味（所属チャプター、`default_workspace_id` 基準）を冒頭に明示。
- **BO_AUDIT_LOG_DESIGN:** 監査 `workspace_id` の意味セクション追加、表の説明更新。
- **DASHBOARD_DATA_SSOT:** `workspace_id` / 所属の言葉を BO・SSOT と一致。

---

## 5. フィット＆ギャップ結果

**ギャップなし（ロジック変更不要）。** 既存の解決順は SSOT 上 **所属 → legacy → システム** と読み替え可能。過剰な別ルートは増やしていない。

---

## 6. 実装への影響

- **挙動変更なし。** コメントのみ。運用・Cursor は SSOT を **1 user = 1 workspace** で解釈する。

---

## 7. 未解決事項

- UI から **所属 workspace を明示的に設定**する専用画面は引き続き任意（API は PATCH 可能）。
- 認証必須化により acting user の曖昧さを減らす件は別 Phase。

---

## 8. 次 Phase 提案

- 管理画面に **所属チャプター（workspace）選択** UI と PATCH 導線。
- 認証ミドルウェア本番適用。

---

## 9. Merge Evidence

| 項目 | 値 |
|------|-----|
| 種別 | docs 中心・`develop` へ直接コミット（本 Phase は feature ブランチ未使用） |
| develop commit | `d9470a0` — `docs(ssot): BNI 1 user=1 workspace assumption (WORKSPACE-SINGLE-CHAPTER-ASSUMPTION)` |
| notes | SSOT 固定 + PHP docblock のみ。ロジック変更なし。 |

| scope / ssot / dod | OK |
