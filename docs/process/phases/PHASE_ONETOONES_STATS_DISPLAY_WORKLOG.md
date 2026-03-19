# WORKLOG: ONETOONES-P2（統計＋表示品質）

## Step 1: 現状・P1・モックの再確認

- **目的:** 差分とルーティング順の落とし穴を避ける。
- **実施:** `FIT_AND_GAP` §6、`OneToOnesList.jsx`、`routes/api.php`、flags テーブル定義を確認。
- **結果:** 統計は別 API が妥当。`stats` は `{id}` より先に登録する必要あり。
- **影響:** 設計固定。

## Step 2: 統計の定義整理

- **目的:** want_1on1・今月判定を曖昧にしない。
- **実施:** `OneToOneStatsService` に phpdoc で planned / completed 当月 / canceled 当月 / flags 件数を定義。`config('app.timezone')` 基準の月初末。
- **結果:** 実装とテストの基準が一致。
- **影響:** `www/app/Services/Religo/OneToOneStatsService.php`

## Step 3: 統計 API

- **目的:** Owner 文脈の集計を提供。
- **実施:** `OneToOneStatsRequest`、`OneToOneController::stats`、ルート `GET /api/one-to-ones/stats`。
- **結果:** JSON に counts + `period`。
- **影響:** Controller / Request / routes。

## Step 4: 一覧 meeting ラベル

- **目的:** 列を #番号 — 日付 に寄せる。
- **実施:** `OneToOneIndexService` で `meeting:id,number,held_on` を eager load。`formatMeetingLabel`。store 応答を `formatRecord` に統一。
- **結果:** `meeting_label` 等が index/show/patch/create で揃う。
- **影響:** `OneToOneIndexService.php`、`OneToOneController.php`（store）

## Step 5: テスト

- **目的:** 回帰と新仕様の固定。
- **実施:** `OneToOneStatsTest` 新規、`OneToOneIndexTest::test_index_includes_meeting_label_when_meeting_set`。
- **結果:** 280 tests passed。
- **影響:** `www/tests/Feature/Religo/**`

## Step 6: フロント（統計・サブタイトル・chip）

- **目的:** モック近似の一覧ヘッダと列表示。
- **実施:** `OneToOnesStatsCards`（owner 連動 fetch）、サブタイトル Typography、`OneToOneStatusChip`、`MeetingLabelChip`、Datagrid 列差し替え。
- **結果:** Dashboard と調和するカードグリッド。
- **影響:** `OneToOnesList.jsx`

## Step 7: build・ドキュメント

- **目的:** DoD 完了。
- **実施:** `npm run build`、PLAN/WORKLOG/REPORT、REGISTRY、INDEX、`FIT_AND_GAP` §6、進捗。
- **結果:** 記録完了。
- **影響:** `docs/**`
