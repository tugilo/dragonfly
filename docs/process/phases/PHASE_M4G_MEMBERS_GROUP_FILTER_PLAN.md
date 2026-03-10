# Phase M4G Members 大カテゴリ単独フィルタ追加 — PLAN

**Phase:** M4G  
**作成日:** 2026-03-10  
**SSOT:** [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4.1, §4.2 M5

---

## Phase

M4G — Members の FilterBar に「大カテゴリ」単独フィルタを追加し、FIT_AND_GAP M5「フィルタバー 大カテゴリ単独は未」を解消する。

---

## Purpose

- Members の FilterBar に **大カテゴリ** 単独で絞り込むためのフィルタを追加する。
- FIT_AND_GAP §4.2 M5 の GAP「検索・大カテゴリ・カテゴリ・ロール… 大カテゴリ単独は未」を解消する。
- 既存 API・バックエンドは変更しない。List / Card の切替や既存フィルタ・並び順を壊さない。

---

## Background

- モック §4.1 の .fbar には「大カテゴリ select」「カテゴリ select」の両方がある。実装では「カテゴリ」のみで、大カテゴリで一括絞りができない（M5 Gap）。
- バックエンドの `GET /api/dragonfly/members` は既にクエリ `group_name` をサポートしている（IndexDragonFlyMembersRequest に group_name、DragonFlyMemberController で whereHas category group_name）。dataProvider（getList members）も既に `f.group_name` をクエリに載せている。**したがって API 変更は不要。フロントの FilterBar に UI を追加し、filterValues に group_name を渡せばよい。**
- 既存の「カテゴリ」フィルタは category_id で実カテゴリ 1 件を指定する。大カテゴリは group_name でそのグループに属する全カテゴリのメンバーをまとめて絞る。両方設定した場合は API が両条件を AND で適用する。競合はしない。

---

## Related SSOT

- docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md §4.1（.fbar の大カテゴリ select）、§4.2 M5（フィルタバー 大カテゴリ単独は未）

---

## Scope

- **変更可能:** www/resources/js/admin/pages/MembersList.jsx の FilterBar のみ。
- **変更しない:** API（バックエンド）、dataProvider（既に group_name 対応済みのため触らない）、他ページ、List/Card 表示ロジック。

---

## Target Files

- www/resources/js/admin/pages/MembersList.jsx

---

## Implementation Strategy

1. **既存 API の利用**
   - `GET /api/dragonfly/members` は既に `group_name` クエリをサポートしている。dataProvider の getList('members') も `params.filter.group_name` をそのままクエリに載せている。**新規 API ・バックエンド変更は不要。** FilterBar で setFilters に group_name を渡すだけでサーバー側で絞り込まれる。

2. **大カテゴリ候補の生成**
   - FilterBar では既に `useGetList('categories', …)` で categories を取得している。各 category は `group_name` を持つ。**大カテゴリ候補は、この categories から group_name を重複排除し、ソートしたリストとする。** 例: `[...new Set(categories.map(c => c?.group_name).filter(Boolean))].sort()`。新規 API や新規 state は不要。

3. **FilterBar への追加**
   - モックの並び「検索・大カテゴリ・カテゴリ・ロール…」に合わせ、**検索の次に「大カテゴリ」Select を追加**する。value は filterValues.group_name、選択時は handleFilter('group_name', value || undefined)。空の選択肢「—」で「すべて」とする。

4. **既存カテゴリフィルタとの関係**
   - 大カテゴリ（group_name）とカテゴリ（category_id）は独立。両方指定した場合は API が両方で絞る（AND）。大カテゴリを選んでもカテゴリの Select は既存のまま（全カテゴリのリスト）でよい。必要なら「大カテゴリ選択時にカテゴリをそのグループに限定」は将来の拡張とする。本 Phase では競合しないことのみ確認する。

5. **List / Card 両表示**
   - フィルタは useListContext の filterValues / setFilters に紐づいており、List も Card も同じ List コンテキストの data を参照するため、**大カテゴリを追加しても List / Card の両方に同じ絞り込み結果が反映される。** 追加対応は不要。

---

## Tasks

- [ ] Task1: SSOT と現行 FilterBar の差分確認（モックは大カテゴリ＋カテゴリ、実装はカテゴリのみ）
- [ ] Task2: 大カテゴリ候補の取得方法の決定（categories の group_name を重複排除・ソート）
- [ ] Task3: FilterBar に大カテゴリ Select を追加（検索の次、value=filterValues.group_name）
- [ ] Task4: List / Card 両表示で絞り込みが効くことを確認
- [ ] Task5: 既存カテゴリフィルタ・並び順・件数表示への影響確認

---

## DoD

- FilterBar に「大カテゴリ」Select が追加され、選択すると一覧がその大カテゴリで絞り込まれること。
- 大カテゴリ候補は既存の categories から group_name を重複排除して生成していること。
- 既存 API ・ dataProvider は変更していないこと（既存の group_name 対応を利用するのみ）。
- List 表示・Card 表示の両方で同じ絞り込み結果になること。
- 既存のカテゴリ・役職・Interested/Want 1on1・並び順・件数表示が壊れていないこと。
- php artisan test および npm run build が通ること。

---

## 参照

- モック .fbar: www/public/mock/religo-admin-mock-v2.html#/members
- API: App\Http\Controllers\Api\DragonFlyMemberController::index（group_name 対応済み）
- dataProvider: www/resources/js/admin/dataProvider.js getList members（f.group_name を q に追加済み）
