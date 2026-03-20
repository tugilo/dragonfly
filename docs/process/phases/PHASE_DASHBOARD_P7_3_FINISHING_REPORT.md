# REPORT: DASHBOARD-P7-3（Dashboard 仕上げ）

| 項目 | 内容 |
|------|------|
| Phase ID | DASHBOARD-P7-3 |
| 種別 | implement |
| Related SSOT | `DASHBOARD_FIT_AND_GAP.md`、`FIT_AND_GAP_MOCK_VS_UI.md`、`DATA_MODEL.md` |
| ブランチ | `feature/phase-dashboard-p7-3-finishing` |

---

## 1. 実施内容サマリ

Dashboard の **空状態・ローディング**をパネル単位で整理（Skeleton、オーナー未設定と 0 件と API 失敗の区別、空配列 API の取りこぼし修正）。関連 **SSOT を現行実装に同期**。**`bo_assigned` は実装せず**、理由と実装条件を `DATA_MODEL` / 本 REPORT に記載。

---

## 2. 変更ファイル一覧

| 種別 | パス |
|------|------|
| 更新 | `www/resources/js/admin/pages/Dashboard.jsx` |
| 更新 | `www/resources/js/admin/pages/dashboard/DashboardKpiGrid.jsx` |
| 更新 | `www/resources/js/admin/pages/dashboard/DashboardTasksPanel.jsx` |
| 更新 | `www/resources/js/admin/pages/dashboard/DashboardActivityPanel.jsx` |
| 更新 | `www/resources/js/admin/pages/dashboard/DashboardLeadsPanel.jsx` |
| 更新 | `www/resources/js/admin/pages/dashboard/dashboardConstants.js` |
| 更新 | `www/resources/js/admin/religoOneToOneLeadLabels.js` |
| 新規 | `docs/process/phases/PHASE_DASHBOARD_P7_3_FINISHING_PLAN.md` |
| 新規 | `docs/process/phases/PHASE_DASHBOARD_P7_3_FINISHING_WORKLOG.md` |
| 新規 | 本 REPORT |
| 更新 | `docs/process/PHASE_REGISTRY.md` |
| 更新 | `docs/INDEX.md` |
| 更新 | `docs/dragonfly_progress.md` |
| 更新 | `docs/SSOT/DASHBOARD_FIT_AND_GAP.md` |
| 更新 | `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` |
| 更新 | `docs/SSOT/DATA_MODEL.md` |
| 更新 | `docs/process/ONETOONES_P1_P4_SUMMARY.md` |

---

## 3. 空状態整理内容

- `DASHBOARD_MSG` に KPI / Tasks / Activity の短文を集約。
- Leads 0 件は `RELIGO_DASHBOARD_LEADS_EMPTY` を短文化。
- オーナー未設定時は KPI / Tasks / Activity を数値ゼロと誤解しない文言に統一。

---

## 4. ローディング整理内容

- 初回・オーナー変更後の再取得で `panelsBusy` を共有。
- KPI 4 枚・Tasks・Activity・Leads（オーナー済み）に Skeleton。全幅の「読込中…」のみは廃止。

---

## 5. ドキュメント整合内容

- `DASHBOARD_FIT_AND_GAP` §3〜§4・§7・§8 を P7-2/3 実装に合わせ更新。
- `FIT_AND_GAP_MOCK_VS_UI` §2 にローディング/空状態と BO の位置づけを追記。
- `DATA_MODEL` §4.12.2 に activity kind と `bo_assigned` 見送りを追加。
- `ONETOONES_P1_P4_SUMMARY` に Dashboard リード SSOT へのリンクを追加。

---

## 6. BO イベント対応内容

- **実装しない（P7-3 確定）。**
- **理由:** Connections の BO 割当保存に紐づく **単一の活動イベントストリーム**が無い。`meeting_csv_apply_logs` は参加者 CSV 反映であり別用途。
- **実装に必要:** BO 保存の監査または正規ログ、Dashboard 表示のタイトル・`occurred_at` 規約の SSOT。

---

## 7. テスト結果

| コマンド | 結果 |
|----------|------|
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` | **302 passed**（merge 前ローカル） |
| `docker compose ... exec node npm run build` | 成功 |

---

## 8. 残課題

- BO 活動: 上記「必要物」が揃ったら別 Phase で `bo_assigned` を設計。
- KPI の「読込失敗」と「422 オーナー未設定」は UI 上は別経路で担保（未設定は先にカード表示）。

---

## 9. 次 Phase 提案

- CSV / Meetings 連携や Connections の保存フローに **監査ログ** を導入する Phase があれば、そこで Dashboard activity に横展開。

---

## 10. Merge Evidence

**（develop へ merge・push 後に追記し、`docs: add merge evidence for DASHBOARD P7-3` コミットで確定する）**

| 項目 | 値 |
|------|-----|
| merge method | `git merge --no-ff feature/phase-dashboard-p7-3-finishing` |
| merged branch | `feature/phase-dashboard-p7-3-finishing` |
| merge commit id | *（追記）* |
| feature last commit id | *（追記）* |
| test result | `302 passed`（参照 §7） |
| notes | BO: 実装見送り。競合: *（追記）* |
