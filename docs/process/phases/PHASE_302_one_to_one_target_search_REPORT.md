# Phase 302 REPORT — 1to1 相手検索（他チャプター登録済み相手）

**Phase ID:** 302  
**Type:** implement  
**Status:** completed  
**完了:** 2026-09-02 09:55 JST

## Summary

1to1 作成／編集フォームの「他のチャプター」モードに **登録済みの相手を検索** を追加した。氏名・かな・No・**チャプター名**・**カテゴリ（大/実）** のいずれでもサーバー検索でき、候補を選ぶだけで相手が確定する（従来は登録済みの相手でも毎回 リージョン→チャプター→氏名→確定 が必要だった）。見つからない場合は従来の①〜③手動登録フローをそのまま使える。

- **API:** `GET /api/dragonfly/members` に `q_extended`（`q` をチャプター名・カテゴリへ拡張・opt-in）、`exclude_workspace_id`（自チャプター除外・`workspace_id` NULL は残す）、`limit`（1–200）を追加。既存 `q` の挙動は不変。
- **UI:** `RegisteredTargetSearch`（MUI Autocomplete・debounce 250ms・30 件・キーワード未入力時は候補なし）。選択後は既存の `targetId` effect が所属・氏名・サマリを復元し success Alert 表示。確定中は検索を disabled、「変更」で再検索。
- **自分のチャプター** モードは変更なし（既に氏名・カテゴリで client 絞込可）。

## Related SSOT

- SPEC-021 [REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md](../../SSOT/REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md) — T6 / A5 追加、T2 備考補正
- [FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md](../../SSOT/FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md) — G13 追加（Fit）

## Test

- command: `php artisan test`（app コンテナ）
- result: **605 passed (2218 assertions)**
- 追加テスト: `tests/Feature/Api/DragonFlyMembersExtendedSearchTest.php` 9 件（q_extended チャプター名／カテゴリ名／大カテゴリ／氏名・かな、`q` 単独では非ヒット、exclude_workspace_id と NULL 保持、limit、バリデーション 422）
- React build: `npm run build` 成功（node コンテナ）
- UI 確認: ローカル `#/one-to-ones/create` → 他のチャプター → 「Diana」入力で DIANA 3 名が候補 → 選択で リージョン／チャプター／氏名復元・success Alert・サマリカード表示

## モック比較

1to1 相手選択フォームはモックに該当画面なし（Phase 272 と同様）。差分は SPEC-021 Fit&Gap G13 に記録。

## Changed files

```
docs/02_specifications/SSOT_REGISTRY.md
docs/INDEX.md
docs/SSOT/FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md
docs/SSOT/REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_302_one_to_one_target_search_PLAN.md
docs/process/phases/PHASE_302_one_to_one_target_search_REPORT.md
docs/process/phases/PHASE_302_one_to_one_target_search_WORKLOG.md
www/app/Http/Controllers/Api/DragonFlyMemberController.php
www/app/Http/Requests/Api/IndexDragonFlyMembersRequest.php
www/resources/js/admin/pages/OneToOnesFormParts.jsx
www/tests/Feature/Api/DragonFlyMembersExtendedSearchTest.php
```

## Merge Evidence

merge commit id: 44a78d8b2703827b753aa943ccc36f4add129323  
feature commit id: b80a486  
merged at: 2026-09-02 09:58 JST  
test on develop after merge: 605 passed (2218 assertions)  
source branch: feature/phase302-one-to-one-target-search  
target branch: develop  
phase id: 302  
phase type: implement  
related ssot: SPEC-021  
test command: php artisan test  
test result: 605 passed  
scope check: OK（API / UI / Tests / Docs のみ。package.json / composer.json 変更なし）  
ssot check: UPDATED（SPEC-021 T6 / A5 追加・T2 備考補正・Fit&Gap G13）  
dod check: OK
