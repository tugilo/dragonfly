# PHASE: DASHBOARD-STALE-WORKSPACE-SCOPE-P1 — PLAN

| 項目 | 内容 |
|------|------|
| **Phase ID** | DASHBOARD-STALE-WORKSPACE-SCOPE-P1 |
| **種別** | docs（**実装変更なし**・設計確定のみ） |
| **Branch** | `feature/phase-dashboard-stale-workspace-scope-p1` |
| **Related SSOT** | `DASHBOARD_DATA_SSOT.md`, `DASHBOARD_TASK_SOURCE_ANALYSIS.md`, `DASHBOARD_FIT_AND_GAP.md`, `DATA_MODEL.md`, `WORKSPACE_RESOLUTION_POLICY.md`, `USER_ME_AND_ACTOR_RESOLUTION.md` |

---

## 目的

- stale（KPI `stale_contacts_count`・Tasks `stale_follow`）に **workspace を渡すべきか** を技術根拠付きで決める。  
- **`MemberSummaryQuery::getSummaryLiteBatch(..., workspaceId)` の挙動**をダッシュ文脈で評価する。  
- **実装しない場合**も理由・再検討条件を SSOT に残す（方針D）。

---

## 比較

| 案 | 内容 | 本 Phase の結論 |
|----|------|----------------|
| **A** | owner ＋ **全 peer**・`getSummaryLiteBatch(..., null)` | **採用（現状維持）** |
| **B** | 所属 workspace 文脈の stale（引数に解決済み `workspace_id`） | **不採用（今回）** |
| **C** | 部分絞り込み | **不採用**（説明可能性が低い） |

**比較メモ（案B）:** BNI 1 user = 1 workspace 下でも、**peer に `members.workspace_id` が無い**・**Query が `workspace_id IS NULL` を弾く**・**同席日は非スコープ**のため、「チャプター内未接触」と **定義できない**。案B は **Query＋データモデル整備後**に再検討。

---

## 実装

- **なし。** `DashboardService`・`MemberSummaryQuery`・テストに変更を加えない。

---

## DoD

1. stale の意味・owner / workspace 関係が `DASHBOARD_DATA_SSOT` に明記されている。  
2. `getSummaryLiteBatch` 第 3 引数を Dashboard で **null のままにする判断**と理由が記載されている。  
3. 分析書・Fit&Gap が整合。  
4. PLAN / WORKLOG / REPORT・REGISTRY・INDEX・progress 更新。  
5. feature → develop `--no-ff` merge、REPORT Merge Evidence、`origin/develop` push。  
6. `php artisan test` / `npm run build` 通過（回帰確認）。
