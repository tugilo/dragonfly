# PLAN: OneToOnes 一覧のモック寄せ改善 Phase 1（フィルタ強化＋行アクション）

| 項目 | 内容 |
|------|------|
| Phase ID | **ONETOONES-P1** |
| 種別 | implement |
| Related SSOT | `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` §6、`docs/SSOT/DATA_MODEL.md`（one_to_ones 概念）、Phase11B 1 to 1 一覧 |
| ブランチ（想定） | `feature/phase-onetoones-p1-list-filter-actions` |

## 1. 背景

- モック `religo-admin-mock-v2.html#/one-to-ones` と実装の差は `FIT_AND_GAP_MOCK_VS_UI.md` §6.1〜6.3 に整理済み。
- 一覧のデータ・新規作成の土台はある一方、**フィルタ不足・行からの導線なし**が実運用上のボトルネック。
- 本 Phase は **一覧の使い勝手** を優先。**統計カード・サブタイトル・chip/日本語ステータス・Meeting リッチ表示・Create モーダル化**は後続とする。

## 2. 対象範囲

**対象**

1. 一覧フィルタ強化: `target_member_id`（相手選択）、フリーテキスト `q`（相手名・メモ）、既存 `status` / `from` / `to` / `owner_member_id` の維持、`dataProvider` のクエリ受け渡し整理。
2. 件数表示: 一覧上部に `total` ベースの件数表示＋ react-admin 標準 `Pagination`。
3. 行アクション: メモ全文確認（ダイアログ）、編集（`Resource` の `edit`＋`PATCH`）。

**対象外**

- 統計4枚、サブタイトル、ステータス chip/日本語化、Meeting 列の `#番号 — 日付` 化、Create のモーダル化、API の大規模再設計、一覧以外の全面改修。

## 3. 現状整理

- `OneToOneIndexService` は `owner_member_id` / `target_member_id` / `status` / `from` / `to` に対応済み。`q` は未対応 → **最小追加**。
- UI / `dataProvider` は `target_member_id`・`q` 未接続。相手プルダウンは Owner に連動して `GET /api/dragonfly/members?owner_member_id=` で取得。
- `Resource` に **edit なし** → 一覧から更新不可。

## 4. 実装方針

- バックエンド: `IndexOneToOnesRequest` に `q`（max 200）を追加。`OneToOneIndexService` で `notes` LIKE と `targetMember.name` LIKE を **OR**（他フィルタは **AND**）。`formatRecord()` で一覧行 JSON を共通化。
- `GET/PATCH /api/one-to-ones/{id}` を追加。`UpdateOneToOneRequest`＋`OneToOneService::update()` で編集。
- フロント: `dataProvider` の `getList`（`q`・`target_member_id`）、`getOne` / `update`。`OneToOnesList.jsx` に Filter 拡張・件数・操作列・メモ Dialog。`OneToOnesEdit.jsx` を新設し `app.jsx` に `edit` を登録。
- Owner の明示フィルタは既存運用を壊さない（空なら owner クエリを付けない）。

## 5. テスト観点

- `q`・`target_member_id`・既存フィルタ単体・複合で一覧が期待どおり。
- `GET/PATCH` 1 件で 200・JSON 形式が一覧行と整合。
- フロントビルド成功。既存 OneToOne 系テスト回帰。

## 6. DoD

- [x] 一覧から相手（`target_member_id`）指定ができる
- [x] フリーテキスト検索（`q`）ができる
- [x] 件数が確認できる（上部表示＋ページネーション）
- [x] 行からメモ確認・編集画面へ進める
- [x] 既存一覧取得の互換を壊さない
- [x] PLAN / WORKLOG / REPORT 作成、`PHASE_REGISTRY`・進捗更新
