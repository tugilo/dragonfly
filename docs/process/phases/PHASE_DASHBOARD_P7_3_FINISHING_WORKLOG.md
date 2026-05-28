# WORKLOG: DASHBOARD-P7-3

## 空状態（F1）

- **根本原因:** 従来 `loadDashboard` が `t.length > 0` / `a.length > 0` のときだけ `setState` し、API が `[]` を返しても **TASKS_FALLBACK / ACTIVITY_FALLBACK** のまま残る不具合があった。
- **対応:** `stats` 初期 `null`、`tasks` / `activity` 初期 `[]`。API 結果は **常に** `Array.isArray` ならセット。フェールバック凡例は表示しない。
- **文言:** `dashboardConstants.js` の `DASHBOARD_MSG` に集約。KPI はオーナー未設定 / API 失敗 / 正常を `InfoOutlined` + 短文で分離。
- **Leads:** `RELIGO_DASHBOARD_LEADS_EMPTY` を短文化（P6 の意味は維持しつつ長さ削減）。

## ローディング（F2）

- **`bootLoading`:** 初回 `loadMe` ＋ダッシュボード一式の間 `true`。
- **`panelsRefreshing`:** オーナー保存直後の `loadDashboard` / leads 再取得のみ `true`。
- **`panelsBusy`:** 上記の OR。KPI / Tasks / Activity / Leads（オーナー済み時）に **MUI Skeleton** を適用。先に空メッセージが出てからデータが載るフラッシュを防止。
- **全画面上部の「読込中…」テキストは削除**（パネル側に寄せた）。

## ドキュメント（F3）

- **DASHBOARD_FIT_AND_GAP:** §3 の旧固定 subtext / 固定5日 / activity 未含有など **P7-2 以前の記述を整理**。§4 にローディング・空状態（P7-3）。§7 P7-3 完了メモ。§8 に BO 判断を追記。
- **FIT_AND_GAP_MOCK_VS_UI §2:** Dashboard のローディング・空状態・BO Gap を現状に合わせて補足。
- **DATA_MODEL §4.12.2:** 活動フィード kind 一覧と **bo_assigned 未実装理由**。
- **ONETOONES_P1_P4_SUMMARY:** Dashboard リード（§4.12.1）へのリンクを関連リンクに追加。

## BO イベント（F4）

- **実装しない。** CSV apply ログは「名簿反映」であり、モックの「Connections での BO 割当保存」と同一視できない。BO 用の単一 `occurred_at` ソースが無い。
- **不足物:** BO 保存の正規イベントストア（または既存テーブルへの正規投影）、Dashboard 用タイトル・会議番号の取り方の SSOT。

## merge

- **競合:** なし（記載時点）。
