# PLAN: DASHBOARD-P7-3（Dashboard 仕上げ）

| 項目 | 内容 |
|------|------|
| Phase ID | DASHBOARD-P7-3 |
| 種別 | implement |
| Related SSOT | `DASHBOARD_FIT_AND_GAP.md`、`FIT_AND_GAP_MOCK_VS_UI.md`、`DATA_MODEL.md` |
| ブランチ | `feature/phase-dashboard-p7-3-finishing` |

## 目的

P7-1 / P7-2 後の Dashboard を **空状態・ローディング・SSOT の細部**まで運用で迷いにくくし、**BO 活動の扱いを要件化または実装で確定**したうえで、**develop merge + Merge Evidence** まで完了する。

## スコープ

| In | 内容 |
|----|------|
| F1 | 空状態（KPI / Tasks / Activity / Leads、オーナー未設定と 0 件の区別） |
| F2 | ローディング（MUI Skeleton、パネル間で統一感・凡例データを出さない） |
| F3 | `DASHBOARD_FIT_AND_GAP` / `FIT_AND_GAP_MOCK_VS_UI` / `DATA_MODEL` の Dashboard 関連整合 |
| F4 | `bo_assigned` — **実装見送り**、理由と実装条件を SSOT / REPORT に明記 |
| DoD | PLAN/WORKLOG/REPORT・REGISTRY・INDEX・progress・test/build・merge・Evidence |

## 対象外

大型機能、AI、API 全面再設計、Dashboard デザイン刷新、他画面の巻き込み。

## BO 判断（F4）

- **見送り:** Connections の BO 保存に対応する**永続イベント一本化**が無い。`MeetingCsvApplyLog` は CSV 反映専用で意味が異なる。
- **実装可能にする条件:** BO 保存の監査または正規化ログ、`occurred_at`・表示文言の SSOT 化。

## DoD

- [ ] 各パネルで空・ローディング・オーナー未設定が区別される
- [ ] SSOT の旧記述（静的前提・固定 subtext 等）が整理される
- [ ] BO 扱いが文書上確定
- [ ] `feature/phase-dashboard-p7-3-finishing` → `develop`（`--no-ff`）、push、REPORT Merge Evidence
