# PLAN: DASHBOARD-P7-2（Dashboard データ・導線改善）

| 項目 | 内容 |
|------|------|
| Phase ID | DASHBOARD-P7-2 |
| 種別 | implement |
| Related SSOT | `docs/SSOT/DASHBOARD_FIT_AND_GAP.md`、`docs/SSOT/DASHBOARD_DATA_SSOT.md`、`docs/SSOT/DATA_MODEL.md` |
| ブランチ | `feature/phase-dashboard-p7-2-data-actions` |

## 目的

P7-1 で整えた Dashboard UI に対し、**P1 Gap（§5）** のデータ・導線を埋める。完了時点で **develop への `--no-ff` merge・REPORT の Merge Evidence 追記・push** まで含める。

## スコープ

| In | 内容 |
|----|------|
| F1 | KPI `subtexts` の動的化（既存集計＋前月比較・説明可能な文案） |
| F2 | 次回例会 Tasks の meta：`meetings.held_on` と当日の**暦日差**（本日 / あとN日 / 次回未登録・直近終了済み） |
| F3 | Tasks 2 件目 stale「メモ追加」→ **Member Show への deep link**（`/members/:id/show`） |
| F4 | Activity：`dragonfly_contact_flags` の更新を `flag_changed` で統合。紹介メモは `memo_introduction` で区別 |
| DoD | PLAN/WORKLOG/REPORT・REGISTRY・INDEX・`dragonfly_progress.md`・必要 SSOT 更新、test/build、merge、Evidence、push |

## 対象外

- Dashboard 全面デザイン変更、Leads 再配置、AI 要約、権限本格化、BO 割当イベント（監査ログ無しのため今回見送り）

## 判定・採用案

- **タイムゾーン:** `config('app.timezone')` 相当（`now()`・暦日 `startOfDay`）に合わせる。
- **メモ導線:** Dashboard 完結モーダルより **既存 Member Show**（メモ・1to1 との住み分けを壊さない）を優先。
- **活動:** BO はデータソースが明確でないため **未実装のまま**。フラグは `updated_at` で十分「最近の更新」として意味が通る。

## DoD

- [ ] `DashboardService`：subtext / 例会 meta / Tasks href / activity 拡張が反映されている
- [ ] `DashboardApiTest` および回帰テストが通過
- [ ] `npm run build` 成功
- [ ] 本 PLAN / WORKLOG / REPORT 完成、PHASE_REGISTRY・INDEX・進捗更新
- [ ] `feature/phase-dashboard-p7-2-data-actions` → `develop` を `--no-ff` merge、`origin/develop` push
- [ ] REPORT § Merge Evidence 追記コミット済み

## モック比較

- 要点は `docs/SSOT/DASHBOARD_FIT_AND_GAP.md`・`FIT_AND_GAP_MOCK_VS_UI.md` §2 を更新して記録する。
