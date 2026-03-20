# REPORT: ONETOONES-P5（導線設計）

## 1. 実施内容サマリ

Members 一覧（List/Card）・Member 詳細・1 to 1 作成フォームを **`GET /api/dragonfly/members/one-to-one-status`**（owner 文脈の実施ベースリード）と接続。Dashboard の Leads は **DASHBOARD-P7-1** で先行マージ済み。本取り込みで **F1〜F2 を UI 完了**（F3/F4 の一部は Dashboard 側で既存）。

## 2. 変更ファイル一覧（代表）

| 種別 | パス |
|------|------|
| 更新 | `www/resources/js/admin/pages/MembersList.jsx` |
| 更新 | `www/resources/js/admin/pages/MemberShow.jsx` |
| 更新 | `www/resources/js/admin/pages/OneToOnesCreate.jsx` |
| 更新 | `docs/SSOT/DATA_MODEL.md`（§4.12.1） |
| 更新 | `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` |
| 更新 | `docs/process/PHASE_REGISTRY.md` |
| 更新 | `docs/dragonfly_progress.md` |
| 更新 | 本 REPORT |

## 3. 実装内容（F1〜F4 / API）

| 要件 | 内容 |
|------|------|
| F1 | `OneToOnesCreate` が `?target_member_id=` で相手を初期選択。Members 行・カード・Show から **1to1作成** / **1 to 1 を記録（フォーム）** リンク |
| F2 | Members Datagrid に **1to1（実施ベース）** 列（Chip + 最終実施日短文）。カードに snippet |
| F3 | Dashboard「次の 1to1 候補」は **DASHBOARD-P7-1** 済 |
| F4 | want_1on1 優先・★ は **API（MemberOneToOneLeadService）**／Dashboard で既存 |
| API | `one-to-one-status` は **develop 上で DASHBOARD-P7-1 により先行追加済み**（本 Phase は主にフロント） |

## 4. テスト結果

| コマンド | 結果 |
|----------|------|
| `php artisan test` | **296 passed** |
| `npm run build` | 成功 |

## 5. 残課題

- `MembersList` の `OWNER_MEMBER_ID = 1` 固定箇所（メモ／Drawer 等）は **E-4 との全面統一は別タスク**。
- Dashboard のメモ Modal 直起動・Activity の BO/フラグは P7-2 以降。

## 6. Merge Evidence（develop 取り込み後）

| 項目 | 値 |
|------|-----|
| merge commit id | _本 merge 直後に `git log -1 --format=%H develop` で追記_ |
| source branch | `feature/onetoones-p5-p6-leads-merge` |
| target branch | `develop` |
| phase id | ONETOONES-P5（P6 同時完了 を REGISTRY 参照） |
| test command | `php artisan test` / `npm run build` |
| test result | 296 passed / build 成功 |
