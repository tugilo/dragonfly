# WORKLOG: ONETOONES-P1（1 to 1 一覧フィルタ＋行アクション）

## Step 1: 現状コード確認

- **目的:** API・UI の接続ギャップを確定する。
- **実施:** `OneToOneIndexService`、`IndexOneToOnesRequest`、`dataProvider` `one-to-ones`、`OneToOnesList.jsx`、`routes/api.php` を確認。
- **結果:** `target_member_id` はサービス対応済みだが UI/dataProvider 未接続。`q`・show/update ルートなし。
- **影響:** 設計方針確定（最小バックエンド拡張＋RA edit）。

## Step 2: バックエンド（q・formatRecord・GET/PATCH）

- **目的:** 一覧検索と編集 API を追加する。
- **実施:** `q` バリデーション、`OneToOneIndexService` に LIKE 条件（notes OR target name）と `formatRecord()`。`UpdateOneToOneRequest`、`OneToOneService::update`、`OneToOneController::show/update`、ルート登録。
- **結果:** 既存 index のレスポンス形は維持しつつ行配列の生成を共通化。
- **影響:** `www/app/**`（Service / Controller / Request / routes）。

## Step 3: テスト追加

- **目的:** 回帰と新仕様の固定。
- **実施:** `OneToOneIndexTest` に `q` の notes / target 名ケース。`OneToOneShowUpdateTest` 新規（show / patch）。
- **結果:** 9 tests passed（OneToOne 系フィルタ実行時）。
- **影響:** `www/tests/Feature/Religo/**`。

## Step 4: dataProvider 整理

- **目的:** フィルタをクエリに確実に反映する。
- **実施:** `getList` で `q`・`target_member_id`・空でない `owner_member_id` のみ付与。`getOne` / `update`（PATCH ボディは編集可能フィールドに限定）を追加。
- **結果:** react-admin の filter state と API が一致。
- **影響:** `www/resources/js/admin/dataProvider.js`。

## Step 5: OneToOnesList（フィルタ・件数・操作列・メモ Dialog）

- **目的:** モックの「絞り込み」「件数」「行からメモ」の最低限を満たす。
- **実施:** `TargetMemberFilterSelect`（`useListContext`＋owner 連動で members 取得）、`q` TextInput、操作列（メモ Dialog・編集 Link）。件数は `useListContext().total`。Dialog は `List` の外に配置しデフォルト Pagination と干渉させない。
- **結果:** 一覧上部に「N 件」、下部に RA 標準ページネーション。
- **影響:** `www/resources/js/admin/pages/OneToOnesList.jsx`。

## Step 6: OneToOnesEdit ＋ Resource 登録

- **目的:** 編集導線の実体を用意する。
- **実施:** `OneToOnesEdit.jsx`（Create と同型の SimpleForm）、`app.jsx` に `edit={OneToOnesEdit}`。
- **結果:** `#/one-to-ones/:id` で編集可能。
- **影響:** 新規 `OneToOnesEdit.jsx`、`app.jsx`。

## Step 7: 動作確認

- **目的:** DoD の技術的確認。
- **実施:** `php artisan test --filter=OneToOne`、`npm run build`（node コンテナ）。
- **結果:** ともに成功。
- **影響:** なし。

## Step 8: ドキュメント

- **目的:** tugilo 追跡可能性。
- **実施:** 本 WORKLOG、PLAN、REPORT、`PHASE_REGISTRY`、`dragonfly_progress`、`FIT_AND_GAP` §6 追記。
- **結果:** Phase 完了記録。
- **影響:** `docs/**`。
