# PHASE: DASHBOARD-TASKS-ALIGNMENT-P1 — PLAN

| 項目 | 内容 |
|------|------|
| **Phase ID** | DASHBOARD-TASKS-ALIGNMENT-P1 |
| **種別** | implement |
| **Branch** | `feature/phase-dashboard-tasks-alignment-p1` |
| **Related SSOT** | `docs/SSOT/DASHBOARD_DATA_SSOT.md`、`DASHBOARD_FIT_AND_GAP.md`、`DASHBOARD_TASK_SOURCE_ANALYSIS.md`、`FIT_AND_GAP_MOCK_VS_UI.md`（参照）。Registry SPEC 追番は未登録のためファイルパスを起点とする。 |

---

## 目的

- **目的A:** Dashboard の役割をドキュメント上で明文化する。  
- **目的B:** その整理に基づき Tasks セクションの表示定義・API・UI を揃える。

---

## スコープ

**対象:** Dashboard 役割 SSOT、Tasks 再定義、`DashboardService::getTasks` と Tasks パネル文言、SSOT / 分析書 / Fit&Gap 更新、develop 取り込みと Merge Evidence。

**対象外:** Dashboard 全面 UI 再設計、AI 提案、KPI 全面見直し、workspace 本格利用、無関係画面、大規模スキーマ変更。

---

## 判断（比較と採用）

### Tasks 見出し: 案A vs 案B

| 案 | 内容 | 採否 |
|----|------|------|
| **A** | 見出し・説明を実装の意味に寄せる（**優先アクション**。「今日」限定と誤解しない） | **採用** |
| **B** | 実装を「今日」だけに絞る（stale や将来日の予定を落とす） | **不採用** — Dashboard の「次に動くべきこと」を弱め、既存ロジックを大きく壊す。 |

### meeting 行: 名前 vs ロジック

| 選択 | 内容 | 採否 |
|------|------|------|
| **kind 改名 + 文言整合** | `meeting_follow_up`、タイトルは「次回・直近のフォロー」。**メモ DB 判定は入れない**（スコープ・複雑度抑制） | **採用** |
| **contact_memos 突合** | 「未整理のときだけ表示」 | **将来 Phase**（案B として分析書に残す） |

### stale 2 件目「メモ追加」disabled

| 選択 | 採否 |
|------|------|
| **有効リンク（Member Show）を正** | **採用** — P7-2 以降 deep link が有効。誤誘導よりメリットが大きい。 |
| SSOT どおり disabled | **不採用** |

### workspace

| 選択 | 採否 |
|------|------|
| **Tasks では workspace を使わない（owner 軸・`getSummaryLiteBatch(..., null)`）** | **採用**（本 Phase で固定。将来使う場合は API+SSOT 同時更新） |
| `workspace_id` を batch に渡す | **不採用**（別フェーズ） |

---

## DoD（完了条件）

1. `DASHBOARD_DATA_SSOT.md` に Dashboard 役割（§0）と Tasks 定義の更新がある。  
2. Tasks の kind / 見出し / 文言 / disabled が SSOT と一致。  
3. `meeting_follow_up` への改名とテスト更新。  
4. PLAN / WORKLOG / REPORT 完成、`PHASE_REGISTRY`・`INDEX`・`dragonfly_progress` 更新。  
5. `feature/phase-dashboard-tasks-alignment-p1` を develop に `--no-ff` merge、REPORT に Merge Evidence、**`origin/develop` push**。  
6. `php artisan test` と `npm run build` 通過。

---

## タスク分解

1. 現状コード・SSOT 確認  
2. 本 PLAN 承認前提で SSOT 更新  
3. `DashboardService` / `DashboardTasksPanel` / `DashboardHeader` / 定数 / テスト  
4. ドキュメント（分析・Fit&Gap）整合  
5. テスト・ビルド  
6. merge・Evidence 追記・push  
