# PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1 — PLAN

| 項目 | 内容 |
|------|------|
| **Phase ID** | DASHBOARD-ONETOONES-SUMMARY-EXPANSION-P1 |
| **種別** | implement |
| **Related SSOT** | DASHBOARD_DATA_SSOT.md §2・§6、DASHBOARD_FIT_AND_GAP.md |
| **ブランチ** | `feature/phase-dashboard-onetoones-summary-expansion-p1` |

## 背景

`monthly_one_to_one_count` は「今月・completed・started_at 当月」のみ。予定・キャンセルのみの登録は 0 になり得るが、**登録件数が 0 に見える**違和感がある。

## 採用方針（案B）

- **主指標:** 今月実施数（`monthly_one_to_one_count`）— **定義は変更しない**
- **補助:** 総登録・予定・キャンセル（owner スコープ・全期間）を API と KPI カード 2 行目で表示

## 追加 API フィールド

| キー | 定義 |
|------|------|
| `one_to_one_total_count` | `owner_member_id` 一致の全行数 |
| `one_to_one_planned_count` | `status = planned` |
| `one_to_one_canceled_count` | `status = canceled` |
| `subtexts.one_to_one_inventory` | 上記 3 つを1行で表示する文言 |

## UI

- KPI カード「今月の1to1（実施）」: 主数値は従来どおり、**2 行目**に `one_to_one_inventory`

## 検証

- `DashboardSummaryVerificationService` / `dashboard:verify-summary` に新指標の db_raw / diff を追加

## DoD

- [ ] `getStats` が新フィールドを返す
- [ ] verify-summary が全 diff 0 で一致
- [ ] SSOT / Fit&Gap 更新
- [ ] Feature テスト追加
- [ ] `php artisan test` / `npm run build` 通過
- [ ] develop へ `--no-ff` merge、REPORT に Merge Evidence

## 対象外

Tasks / Leads / 1to1 作成フロー / Dashboard 全面 redesign
