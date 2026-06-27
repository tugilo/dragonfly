# Phase 272 REPORT — 東京 NE リージョン・チャプターマスタと 1to1 相手選択

**Phase ID:** 272  
**Type:** implement  
**Status:** completed

## Summary

東京 NE リージョンとチャプター workspace の冪等シード、regions/members API 拡張、1to1 相手選択 UI（自チャプター／他チャプターのリージョン・チャプター・名前指定）を実装。既存クロスチャプター 121 は、東京NE 25件（EduTech含む）と NE 外チャプター（大人なじみ=東京南、クリエーションズ=千葉セントラル、インフィニティ=静岡セントラル）へ正しく紐付けた。

同一 Phase 内で以下の UX 改善・データ整合も実施:

- **モーダル UX:** 他チャプター相手選択をステップ式（①リージョン→②チャプター→③名前・番号バッジ・確定後 success Alert）に再構成。Quick Create の Owner 表示を生 ID から「#番号 氏名」に変更。
- **他チャプター type 是正:** `CrossChapterTargetResolveService` の新規相手 type を `visitor`→`member` に修正（「BNI会員以外」誤バッジ解消）。既存誤登録 21 件を是正。
- **Members チャプター絞り込み:** Members 一覧・1to1 リードを DragonFly 在籍に限定（`ReligoDragonFlyWorkspace`・`dragonfly_chapter_only` フィルタ）。
- **退会済み機能:** `type=former` を追加し、Members 行/カードに「退会済みにする」導線を実装（削除せず一覧から除外・履歴保持・履歴 Chip は「退会済み」表示）。

## Related SSOT

- SPEC-021

## Test

- command: `php artisan test`
- result: 577 passed (2126 assertions)
- React build: 成功

## Changed files

```
docs/02_specifications/SSOT_REGISTRY.md
docs/INDEX.md
docs/SSOT/FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md
docs/SSOT/REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_272_tokyo_ne_region_chapter_1to1_PLAN.md
docs/process/phases/PHASE_272_tokyo_ne_region_chapter_1to1_REPORT.md
docs/process/phases/PHASE_272_tokyo_ne_region_chapter_1to1_WORKLOG.md
www/app/Console/Commands/SeedTokyoNeRegionChapterCommand.php
www/app/Http/Controllers/Api/CrossChapterTargetController.php
www/app/Http/Controllers/Api/DragonFlyMemberController.php
www/app/Http/Controllers/Api/RegionController.php
www/app/Http/Controllers/Api/WorkspaceController.php
www/app/Http/Requests/Api/IndexDragonFlyMembersRequest.php
www/app/Http/Requests/Api/ResolveCrossChapterTargetRequest.php
www/app/Services/Religo/CrossChapterTargetResolveService.php
www/app/Services/Religo/DashboardService.php
www/app/Services/Religo/MemberOneToOneLeadService.php
www/app/Services/Religo/TokyoNeRegionChapterSeedService.php
www/app/Support/MemberEnrollmentType.php
www/app/Support/ReligoDragonFlyWorkspace.php
www/config/religo.php
www/database/sync/dragonfly.sql
www/resources/js/admin/dataProvider.js
www/resources/js/admin/pages/MembersList.jsx
www/resources/js/admin/pages/OneToOneFormFields.jsx
www/resources/js/admin/pages/OneToOnesFormParts.jsx
www/resources/js/admin/pages/OneToOnesList.jsx
www/resources/js/admin/utils/memberEnrollmentType.js
www/resources/js/admin/utils/oneToOnesTransform.js
www/routes/api.php
www/tests/Feature/Api/CrossChapterTargetResolveTest.php
www/tests/Feature/Api/DragonFlyMembersIndexFilterSortTest.php
www/tests/Feature/Api/DragonFlyMembersWorkspaceRegionFilterTest.php
www/tests/Feature/Api/RegionApiTest.php
www/tests/Feature/Religo/TokyoNeRegionChapterSeedTest.php
```

## Merge Evidence

merge commit id: f1432e2380288f02ee7f91b4145ee7e5fc7f8a1a  
source branch: feature/phase272-tokyo-ne-region-chapter-1to1  
target branch: develop  
phase id: 272  
phase type: implement  
related ssot: SPEC-021  
test command: php artisan test  
test result: 577 passed  
scope check: OK  
ssot check: OK  
dod check: OK

### main リリース反映

main merge commit id: bdf69c268028f032f8ba12f65655680088e54881  
source branch: develop  
target branch: main
