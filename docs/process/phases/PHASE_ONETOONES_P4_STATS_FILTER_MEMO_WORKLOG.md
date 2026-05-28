# WORKLOG: ONETOONES-P4

## Step 1: filter 共通化

- **目的:** Index と Stats で WHERE を一字一句揃える。
- **実施:** `OneToOneIndexService::applyIndexFilters(Builder, array)` に抽出。`getIndex` から呼び出し。
- **結果:** q / status / target / from / to / workspace / owner を一箇所で管理。

## Step 2: stats 修正

- **目的:** 一覧の filter query を stats にそのまま渡す。
- **実施:** `OneToOneStatsRequest` に index 同等の任意項目。`OneToOneStatsService` は `getStats($validated)` とし、各指標で `applyIndexFilters` 後に status / 当月条件を付与。want は distinct target × flags。
- **結果:** フロントは `filterValues` から query を組み立て。

## Step 3: メモ API

- **目的:** 1to1 専用の履歴取得・追加（既存 `contact_memos` 拡張）。
- **実施:** migration は新設なし（`one_to_one_id` 既存）。`memosIndex` / `memosStore`、`StoreOneToOneMemoRequest`。`ContactMemo::oneToOne()`。
- **結果:** POST で owner/target/workspace を 1to1 から複製。

## Step 4: UI

- **目的:** 一覧統計の同期、編集で履歴メモ。
- **実施:** `OneToOnesList` の stats fetch を `buildOneToOneStatsQuery` に。`OneToOnesEdit` に `OneToOneMemosPanel`。

## Step 5: /api/users/me

- **実施:** `id`・`member_id`・`owner_member_id` を返す。PATCH も同形。

## Step 6: 検証

- Feature 追加・既存回帰、`php artisan test` 286 passed、`npm run build` 通過。
