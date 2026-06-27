# Phase 272 — 東京 NE リージョン・チャプターマスタと 1to1 相手選択

**Phase ID:** 272  
**Type:** implement  
**Status:** completed  
**Branch:** `feature/phase272-tokyo-ne-region-chapter-1to1`

## Purpose

SPEC-021 に基づき、東京 NE リージョン／チャプターマスタをシードし、1to1 相手選択を自チャプター／リージョン切替に改善する。既存クロスチャプター 121 履歴の編集時に相手が消えないよう対応する。

## Related SSOT

- SPEC-021 [REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md](../../SSOT/REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md)
- SPEC-006 [ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md](../../SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md)
- [FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md](../../SSOT/FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md)

## Scope

| 領域 | ファイル |
|------|----------|
| Seeder / Command | `TokyoNeRegionChapterSeedService.php`, `SeedTokyoNeRegionChapterCommand.php` |
| API | `RegionController`, `DragonFlyMemberController`, `WorkspaceController`, `IndexDragonFlyMembersRequest`, `routes/api.php` |
| UI | `OneToOnesFormParts.jsx` |
| Tests | `TokyoNeRegionChapterSeedTest`, `DragonFlyMembersWorkspaceRegionFilterTest`, `RegionApiTest`, `CrossChapterTargetResolveTest` |
| Docs | Phase 272 3ファイル、SSOT Fit&Gap 更新、INDEX、progress |

## DoD

- [x] `religo:seed-tokyo-ne-region` で Japan + 東京 NE 25チャプター（EduTech含む）+ 既存121由来のNE外チャプターが冪等シードされる
- [x] `GET /api/regions`、`members?workspace_id` / `members?region_id` が動作
- [x] 1to1 作成フォーム: 自チャプター / 東京 NE 全体の切替
- [x] 既存クロスチャプター 1to1 編集時に相手 ID がクリアされない
- [x] `php artisan test` 全通過、React build 成功

## Tasks

1. TokyoNeRegionChapterSeedService + artisan command
2. regions API + members/workspace フィルタ
3. ScopedTargetSelect UX + 履歴保持
4. Feature tests + build

## モック比較

1to1 作成フォームの相手選択にスコープ切替を追加。モックに該当画面なし — [MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md) §1to1 は一覧・Create 既存比較を維持。
