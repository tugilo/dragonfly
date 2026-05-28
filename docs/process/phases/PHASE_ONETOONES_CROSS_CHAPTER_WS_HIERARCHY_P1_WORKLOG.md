# WORKLOG — ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1

## 判断

- **階層:** `workspaces` に JSON で region/country を埋める案より、`countries` / `regions` / `workspaces.region_id` を採用。将来の検索・一意制約・管理 UI に耐える。
- **1 to 1 の workspace_id:** バリデーションは変更せず（作成時 `workspace_id` 必須のまま）、**意味**を SSOT と API コメントで固定。target の所属とは **強制一致させない**。
- **is_cross_chapter:** `one_to_ones.workspace_id` と `members.workspace_id`（target）を比較。いずれか null のときは `false`（誤検知防止）。
- **Members API:** ネストした `workspace` オブジェクトをそのまま返すとフロントの期待とズレるため、`unset($arr['workspace'])` 後に **フラットキー**（`workspace_name`, `region_name`, …）をマージ。

## 実装順序

1. Migration + `Country` / `Region` / `Workspace.region_id`
2. `MemberWorkspaceAttributes` + `OneToOneIndexService` + `OneToOne::workspace()`
3. `DragonFlyMemberController` + `WorkspaceController`
4. `memberDisplay.js` + OneToOnes 一覧・フォーム
5. Feature test `OneToOneCrossChapterHierarchyTest`
6. SSOT / registry / INDEX / progress

## 詰まりポイント

- なし（テスト全通過後に migration ファイル名を `2026_04_08_*` に整理し、実行順を `2026_04_07` 週プレゼン migration より後に固定）
