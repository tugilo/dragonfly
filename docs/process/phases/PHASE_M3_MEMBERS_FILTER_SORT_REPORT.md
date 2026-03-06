# Phase M-3 Members 検索/フィルタ/ソート — REPORT

**Phase:** M-3（M-3a / M-3c / M-3b）  
**完了日:** （各 Phase 完了時点で記入）

---

## M-3a 実施内容

- PHASE_M3_MEMBERS_FILTER_SORT_PLAN.md を作成（目的・実現方式・既存 API 判定表・DoD・成果物・Git）。
- PHASE_M3_MEMBERS_FILTER_SORT_WORKLOG.md を作成（Step0 棚卸し: MembersList/dataProvider/Backend の対応状況）。
- PHASE_M3_MEMBERS_FILTER_SORT_REPORT.md を作成（本ファイル）。
- docs/INDEX.md に M-3 の 3 点セットを追加。

---

## 変更ファイル一覧（M-3 全体）

**M-3a（Docs）**
- docs/process/phases/PHASE_M3_MEMBERS_FILTER_SORT_PLAN.md
- docs/process/phases/PHASE_M3_MEMBERS_FILTER_SORT_WORKLOG.md
- docs/process/phases/PHASE_M3_MEMBERS_FILTER_SORT_REPORT.md
- docs/INDEX.md

**M-3c（API）**
- www/app/Http/Requests/Api/IndexDragonFlyMembersRequest.php
- www/app/Http/Controllers/Api/DragonFlyMemberController.php
- www/tests/Feature/Api/DragonFlyMembersIndexFilterSortTest.php

**M-3b（UI）**
- www/resources/js/admin/dataProvider.js
- www/resources/js/admin/pages/MembersList.jsx

---

## テスト結果・ビルド結果

- **php artisan test:** 69 passed（262 assertions）。M-3c で 3 本追加。
- **npm run build:** 成功（exit 0）。

---

## できた条件 / できない条件（GAP）

- **API で実現（M-3c）:** q（name / display_no / name_kana の部分一致）、category_id、group_name、role_id、interested、want_1on1 によるフィルタ。sort=id|display_no|name、order=asc|desc。UI で指定した条件が URL に反映され、一覧に反映される。
- **UI で実現（M-3b）:** 検索（SearchInput q）、カテゴリ・役職（ReferenceInput）、Interested / Want 1on1（BooleanInput）、ソート（デフォルト display_no 昇順、番号・名前列クリックでソート変更）。dataProvider が filter/sort を API に渡すため「効いてないフィルタ」はない。
- **未対応（GAP）:** sort=last_contact_at / same_room_count / one_to_one_count は API では未対応（summary_lite 由来のため DB 側ソートは未実装）。必要ならクライアント側ソートまたは将来 Phase で対応。

---

## テスト結果・取り込み証跡

- **M-3a:** docs のみのため php artisan test は既存通り。merge 後に証跡を追記。
- **M-3c:** FeatureTest 追加。merge 後に証跡を追記。
- **M-3b:** 既存テスト＋npm run build。merge 後に証跡を追記。

---

## 取り込み証跡（develop への merge 後）

| Phase | merge commit id | merge 元ブランチ | 変更ファイル |
|-------|-----------------|------------------|--------------|
| M-3a | （追記） | feature/m3a-members-filter-sort-docs | 上記 4 ファイル |
| M-3c | （追記） | feature/m3c-members-filter-sort-api | （Backend ファイル一覧） |
| M-3b | （追記） | feature/m3b-members-filter-sort-ui | （Front ファイル一覧） |
