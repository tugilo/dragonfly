# Phase M4K Members Card向け並び順の強化 — PLAN

**Phase:** M4K  
**作成日:** 2026-03-10  
**SSOT:** [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4.1, §4.2

---

## Phase

M4K — Members の Card 表示で「誰を先に見るべきか」が分かる並び順を強化する。既存 List / Card 切替は維持し、Card 向けに有効な並び順を追加・整理する。

---

## Purpose

- 並び順候補を見直し、Card 向けに「今見るべき人」が前に来る選択肢を追加する。
- 既存 API は変更しない。List 表示では Datagrid の自然さを壊さない。
- 既存フィルタと併用しても分かりやすい並び順体験にする。

---

## Background

- FIT_AND_GAP §4.1 の .fbar には「並び順 select」がある。現行実装は「番号昇順・番号降順・名前昇順・名前降順」の 4 種のみ。
- API（IndexDragonFlyMembersRequest）の SORT_FIELDS は **id, display_no, name** のみ。最終接触・Relationship Score・interested・want_1on1 でのソートは API にない。
- Card は「人を把握して次の一手を決める」用途のため、**最終接触が古い順**（未接触優先）・**関係温度が高い順**・**Interested 優先**・**Want 1on1 優先**が有効。これらは **Card 表示時のみフロント側で data を並び替えて実現**する。API は変更しない。

---

## Related SSOT

- docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md §4.1（.fbar 並び順）、§4.2（実装比較）

---

## Scope

- **変更可能:** www/resources/js/admin/pages/MembersList.jsx のみ。
- **変更しない:** API、dataProvider、バックエンド、他ページ。

---

## Target Files

- www/resources/js/admin/pages/MembersList.jsx

---

## Implementation Strategy

1. **API で対応可能な並び順**
   - 現状どおり sort / order で **display_no**, **name** の昇順・降順。FilterBar の setSort で API に渡り、List / Card ともに API 返却順で表示。

2. **Card 専用（フロントソート）の並び順**
   - **最終接触が古い順** — summary_lite.last_contact_at 昇順（null は末尾）。
   - **関係温度が高い順** — relationshipScoreFromSummaryLite 降順（同点は display_no 等で安定化）。
   - **Interested 優先** — interested が true を前に、同順は display_no 昇順。
   - **Want 1on1 優先** — want_1on1 が true を前に、同順は display_no 昇順。
   - これらを選択したときは **API には sort=display_no, order=asc を渡し**（dataProvider 変更なし）、**Card 表示時だけ MembersCardGrid 内で data をコピーしてソート**してから表示。List 表示では API 返却順（display_no 昇順）のままとする。

3. **並び順の状態の持ち方**
   - React Admin の List は sort / setSort をコンテキストで持つ。**「表示用の並び順キー」を別 state（displaySortKey）で持ち**、FilterBar の Select の value とする。API 対応キー（display_no_asc 等）のときは setSort も同期し、Card 専用キーのときは setSort(display_no, ASC) にし、displaySortKey だけそのキーにしておく。ViewModeContext を拡張し、**displaySortKey / setDisplaySortKey** を追加する。

4. **FilterBar**
   - 並び順 Select の選択肢を追加。「番号昇順・番号降順・名前昇順・名前降順」に加え、「最終接触が古い順」「関係温度が高い順」「Interested 優先」「Want 1on1 優先」を追加。value は displaySortKey。onChange で displaySortKey を更新し、API 対応なら setSort も呼ぶ。

5. **MembersCardGrid**
   - useListContext() の data を取得。ViewModeContext から displaySortKey を取得。displaySortKey が Card 専用のとき、data を useMemo でソートした配列を描画に使う。それ以外は data をそのまま使用。

6. **List 表示**
   - Datagrid は List コンテキストの data をそのまま表示。displaySortKey が Card 専用でも、API には display_no asc で取得しているため、List は番号順で表示される。Datagrid の既存ソート挙動は変更しない。

---

## Tasks

- [ ] Task1: 現行 sort UI / API SORT_FIELDS の確認
- [ ] Task2: Card 向け並び順候補の整理（API 対応とフロントソートの切り分け）
- [ ] Task3: displaySortKey の導入と FilterBar での同期
- [ ] Task4: 並び順 Select の選択肢追加
- [ ] Task5: MembersCardGrid でのフロントソート実装
- [ ] Task6: List 表示・既存フィルタとの整合確認

---

## DoD

- 並び順 Select に「最終接触が古い順」「関係温度が高い順」「Interested 優先」「Want 1on1 優先」が追加され、選択できること。
- Card 表示でそれらを選んだとき、一覧がその順で表示されること。
- List 表示では Datagrid の挙動を崩さず、API 返却順（display_no 昇順等）で表示されること。
- 既存の番号・名前の昇降順は従来どおり API でソートされ、List / Card 両方で効くこと。
- 既存フィルタと併用して破綻しないこと。
- MembersList.jsx 以外・API 変更なし。
- php artisan test および npm run build が通ること。

---

## 参照

- IndexDragonFlyMembersRequest::SORT_FIELDS = ['id', 'display_no', 'name']
- MembersList.jsx: relationshipScoreFromSummaryLite（M4H で追加）、MembersFilterBar の並び順 Select、MembersCardGrid
