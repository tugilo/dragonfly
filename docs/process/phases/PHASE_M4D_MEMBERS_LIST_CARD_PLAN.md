# Phase M4D Members List/Card 表示切替 — PLAN

**Phase:** M4D（Members 一覧のリスト／カード切替）  
**作成日:** 2026-03-10  
**SSOT:** [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4.1

---

## 1. Phase Type

implement

---

## 2. Purpose

- Members ページで**リスト形式（表）**と**カード形式**をスイッチで切替可能にする。
- モック（religo-admin-mock-v2.html#/members）のカード形式（.cgrid + .mcard）を実装し、FIT_AND_GAP §4.3 の推奨「リスト／カード切替」を満たす。

---

## 3. Background

- M4 でブロック順・統計・フィルタバーをモックに合わせたが、一覧は Datagrid のまま。GAP「カードグリッド未対応」が残っていた。
- FIT_AND_GAP §4.1 にモックの .mcard 構造（mc-hdr / mc-body / mc-act / mc-logs）が定義されている。
- 既存 API は変更しない。useListContext().data をそのまま利用する。

---

## 4. Related SSOT

- docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md §4.1（モックの Members ページ要素・mcard 構造）

---

## 5. Scope

- **変更可能:** www/resources/js/admin/pages/MembersList.jsx
- **変更しない:** API、他のページ、FIT_AND_GAP の更新は REPORT 時のみ

---

## 6. Target Files

- www/resources/js/admin/pages/MembersList.jsx

---

## 7. Implementation Strategy

1. **viewMode state:** `'list' | 'card'` を保持。Context で FilterBar と一覧に共有。
2. **フィルタバー右:** [List] [Card] の切替ボタンを追加。
3. **list:** 既存 Datagrid をそのまま表示（変更なし）。
4. **card:** MembersCardGrid を表示。useListContext().data を map し、各件を MemberCard で描画。
5. **MemberCard:** §4.1 の mcard 構造に従う。mc-hdr（番号・役職・名前・かな）、mc-body（カテゴリ・同室・最終接触・メモ・flags）、mc-act（メモ・1to1・1to1メモ・詳細）、mc-logs（関係ログ（最近）— API にない場合は「詳細で確認」等で代替）。

---

## 8. Tasks

- [x] viewMode state と ViewModeContext の追加
- [x] MembersFilterBar 右に [List] [Card] 切替
- [x] viewMode === 'list' のとき Datagrid、'card' のとき MembersCardGrid を表示
- [x] MembersCardGrid（useListContext().data を map → MemberCard）
- [x] MemberCard（mc-hdr / mc-body / mc-act / mc-logs 構造）

---

## 9. DoD

- List / Card 切替がフィルタバー右で動作すること。
- 既存 Datagrid は変更なし（列・挙動そのまま）であること。
- Card 表示が mcard 構造（§4.1）に沿っていること。
- 既存の php artisan test / フロントビルドが通ること。

---

## 10. 参照

- モック: www/public/mock/religo-admin-mock-v2.html#/members
- FIT_AND_GAP §4.1 1 枚の .mcard 内の要素
