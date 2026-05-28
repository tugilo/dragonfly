# REPORT: ONETOONES-P1（1 to 1 一覧フィルタ＋行アクション）

## 1. 実施内容サマリ

1 to 1 一覧に **相手（target_member_id）フィルタ** と **フリーテキスト検索（q：相手名・メモ）** を追加し、`dataProvider` のクエリ組み立てを整理した。一覧上部に **件数（total）** を表示し、react-admin 既定の **Pagination** を利用する。**行操作**としてメモ全文の閲覧ダイアログと、**PATCH 対応の編集画面**（`OneToOnesEdit`）への導線を追加した。モック完全一致（統計・chip 等）は行わない。

## 2. 変更ファイル一覧

| 種別 | パス |
|------|------|
| 新規 | `www/app/Http/Requests/Religo/UpdateOneToOneRequest.php` |
| 新規 | `www/tests/Feature/Religo/OneToOneShowUpdateTest.php` |
| 新規 | `www/resources/js/admin/pages/OneToOnesEdit.jsx` |
| 新規 | `docs/process/phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_PLAN.md` |
| 新規 | `docs/process/phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_WORKLOG.md` |
| 新規 | 本 `PHASE_ONETOONES_LIST_FILTER_ACTIONS_REPORT.md` |
| 更新 | `www/app/Http/Requests/Religo/IndexOneToOnesRequest.php` |
| 更新 | `www/app/Services/Religo/OneToOneIndexService.php` |
| 更新 | `www/app/Services/Religo/OneToOneService.php` |
| 更新 | `www/app/Http/Controllers/Religo/OneToOneController.php` |
| 更新 | `www/routes/api.php` |
| 更新 | `www/tests/Feature/Religo/OneToOneIndexTest.php` |
| 更新 | `www/resources/js/admin/dataProvider.js` |
| 更新 | `www/resources/js/admin/pages/OneToOnesList.jsx` |
| 更新 | `www/resources/js/admin/app.jsx` |
| 更新 | `docs/process/PHASE_REGISTRY.md` |
| 更新 | `docs/dragonfly_progress.md` |
| 更新 | `docs/INDEX.md` |
| 更新 | `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` |
| 非変更（参照のみ） | `docs/02_specifications/SSOT_REGISTRY.md`（本 Phase の起点確認に使用） |

## 3. 実装内容

### フィルタ（UI）

- `owner_member_id`（従来どおり alwaysOn）、`q`、`target_member_id`（Owner に同期して members を再取得）、`status`、`from`/`to`（YYYY-MM-DD テキスト）。
- 相手「すべて」は `target_member_id` をクエリに含めない。

### dataProvider

- `getList`: `owner_member_id` は空文字を送らない。`q`・`target_member_id` を追加。
- `getOne` / `update`: `GET/PATCH /api/one-to-ones/:id`。PATCH ボディは編集対象フィールドに限定。

### バックエンド

- `GET /api/one-to-ones/{id}`：`formatRecord` 済み JSON。
- `PATCH /api/one-to-ones/{id}`：`UpdateOneToOneRequest` 検証後 `OneToOneService::update`。
- `q`: `notes` と `targetMember.name` に対する部分一致（エスケープ付き LIKE）。他条件と AND。

### アクション導線

- **メモ:** MUI Dialog で全文表示。「編集画面で変更」で `#/one-to-ones/:id` へ。
- **編集:** react-admin `Edit`（`OneToOnesEdit`）。

## 4. 確認結果

| 項目 | 結果 |
|------|------|
| target_member_id 指定 | API・テストで確認（既存 `test_limit_applied` 等） |
| q 検索 | notes / target 名の Feature テスト追加済み |
| status / from / to 併用 | 既存ロジック維持・回帰テスト通過 |
| 件数表示 | `useListContext().total`＋下部 Pagination |
| action 動作 | 編集ルート登録・PATCH テスト通過 |
| 既存一覧 | `GET /api/one-to-ones` 配列形式は不変 |
| テストコマンド | `php artisan test --filter=OneToOne` → **9 passed** |
| フロントビルド | `npm run build` → **成功** |

## 5. 残課題（今回見送り）

- 統計4枚カード、サブタイトル、ステータス chip／日本語ラベル、Meeting 列のリッチ表示、Create のモーダル化、contact_memos 連携による「メモ」の別 API 実装。

## 6. 次 Phase 提案

- 統計カード（集計 API ＋ UI 帯）。
- ステータス表示の改善（chip・日本語）。
- Meeting 列を例会 number / held_on でリッチ化（N+1 回避の eager load 等）。
- Create/Edit の UX（モーダル化・Owner 既定値の運用設計）。

## 7. Merge Evidence

| 項目 | 値 |
|------|-----|
| merge commit id | **未実施**（ローカル実装・ドキュメント作成まで。develop への merge は別手順） |
| source branch | `feature/phase-onetoones-p1-list-filter-actions`（想定） |
| target branch | develop |
| test command | `php artisan test --filter=OneToOne` |
| test result | 9 passed |

---

scope check: OK  
ssot check: OK（FIT_AND_GAP 追記で UI 差分を更新）  
dod check: OK
