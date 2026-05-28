# Phase M4I Members デフォルト表示を Card に変更 — PLAN

**Phase:** M4I  
**作成日:** 2026-03-10  
**SSOT:** [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4（Members 一覧形式）

---

## Phase

M4I — Members ページを開いたときの**初期表示を List ではなく Card** にし、「人をパッと見て把握しやすい」体験を優先する。

---

## Purpose

- Members の**初回表示を Card にする**。
- List / Card の切替機能は維持する。ユーザーが List に切り替えた場合は従来どおり Datagrid が表示される。
- 既存 FilterBar・Datagrid・Card 表示は一切壊さない。

---

## Background

- FIT_AND_GAP §4 ではモックはカードグリッド、実装は List/Card 切替可能（M4D）。現状は**初期表示が List（Datagrid）**のため、開いた瞬間は表形式になる。「人をパッと見て把握する」にはカード形式を初期にした方がよいという要望に対応する。

---

## Related SSOT

- docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md §4.1（.mcard / .cgrid）、§4.2（一覧形式の比較）

---

## Scope

- **変更可能:** www/resources/js/admin/pages/MembersList.jsx の **viewMode 初期値**のみ。
- **変更しない:** API、FilterBar、Datagrid、MemberCard、切替 UI、他ファイル。

---

## Target Files

- www/resources/js/admin/pages/MembersList.jsx

---

## Implementation Strategy

1. **viewMode の初期値を card に変更**
   - MembersListInner 内の `useState('list')` を `useState('card')` に変更する。これのみで、ページ初回表示が Card になり、List/Card ボタンでの切替は従来どおり動作する。

2. **ViewModeContext のデフォルト値**
   - createContext のデフォルトは `viewMode: 'list'` のままでもよい（Provider 内では useState が効くため）。必要であれば 'card' に揃えてもよい。本 Phase では useState の初期値のみ変更する。

3. **List / Card 切替 UI**
   - FilterBar 内の List / Card ボタンは変更しない。表示・切替動作は維持する。

---

## Tasks

- [ ] Task1: viewMode 初期値の現在値確認（list）
- [ ] Task2: useState('list') を useState('card') に変更
- [ ] Task3: List に切り替えたとき Datagrid が表示されることを確認（既存動作維持）

---

## DoD

- Members ページを開いたとき、初期表示が Card であること。
- List / Card 切替ボタンで List に切り替えると Datagrid が表示されること。
- Card に切り替えると Card グリッドが表示されること。
- FilterBar・Datagrid・Card の表示・動作に変更がないこと。
- MembersList.jsx 以外は変更しないこと。API 変更なし。
- php artisan test および npm run build が通ること。

---

## 参照

- MembersList.jsx: MembersListInner の useState('list')（約 918 行目）
