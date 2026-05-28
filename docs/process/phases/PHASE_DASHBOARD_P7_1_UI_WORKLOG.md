# WORKLOG: DASHBOARD-P7-1（Dashboard UI 再構成）

## 採用したモック構造

- `religo-admin-mock-v2.html` の **上段 4 統計（`.stats`）＋ 下段 2 カラム** の意味を踏襲。
- モックでは右列が「最近の活動」だが、**P7-1 仕様**により **主役（Tasks / Shortcuts / Activity）を左列に縦積み**、**Leads を右列の補助パネル**にした（`DASHBOARD_FIT_AND_GAP` の案 B/C と整合。主判断優先）。

## Leads の再配置

- **変更前:** 左列の最上段（Tasks の上）に全面幅で配置され、主タスク領域の上に来ていた。
- **変更後:** **右列 340px（`md` 以上）** にのみ配置。`position: sticky; top: 16px` で長い左列スクロール時も参照しやすくした。一覧は `maxHeight` + `overflowY: auto` で補助パネルとして収まりを制御。
- オーナー未設定時: 同じ右列カード内で「オーナーを設定すると…」の短文を表示（レイアウト欠損を避ける）。候補 0 件時は **P6 の `RELIGO_DASHBOARD_LEADS_EMPTY` をそのまま**使用。

## コンポーネント分割

| ファイル | 責務 |
|----------|------|
| `Dashboard.jsx` | 状態、`loadMe` / `loadDashboard` / `loadOneToOneLeads` / `saveOwner`、子へ props のみ |
| `dashboardConstants.js` | フォールバック KPI/Tasks/Activity・`DASHBOARD_CARD_SX`（P7-2 で subtext 差し替えの単一箇所） |
| `DashboardHeader.jsx` | タイトル・補助文・Owner・Connections/1to1 CTA |
| `DashboardKpiGrid.jsx` | 4 KPI（`stats` 受け取り、`subtexts` はオブジェクト内で表示） |
| `DashboardTasksPanel.jsx` | Tasks リスト。メモ追加 disabled に **Tooltip**（Connections 経由・P7-2 予定） |
| `DashboardShortcutsPanel.jsx` | 4 ボタン（遷移先不変） |
| `DashboardActivityPanel.jsx` | 活動リスト（`items` のみ） |
| `DashboardLeadsPanel.jsx` | 1to1 候補（ラベル・API 形状は P5/P6 のまま） |

API 呼び出しは **Dashboard.jsx に集約**（ロジックの過剰分散を避ける）。

## Tasks / Shortcuts / Activity の責務整理

- **Tasks:** 「今日手を付けるべきこと」＝見出し直下に**1 行説明**を追加し、主役ブロックとして認知しやすくした。
- **Shortcuts:** 「すぐ移動」＝説明 1 行を追加。ボタンラベル・`to` は変更なし。
- **Activity:** 「メモと 1 to 1 の新しい順」＝説明 1 行を追加。データソースは親の state のまま（API 未変更）。

## あえてやらなかったこと（P7-2 へ）

- KPI subtext の動的化（先月比・例会番号）
- Tasks の「次回例会まであとN日」の実日数
- Dashboard からのメモ追加有効化
- Activity の `bo_assigned` / `flag_changed` など kind 拡張
- `FIT_AND_GAP_MOCK_VS_UI.md` §2 の全文更新（REPORT の残課題に記載）
