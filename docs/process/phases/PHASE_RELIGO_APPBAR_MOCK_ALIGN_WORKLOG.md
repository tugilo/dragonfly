# PHASE Religo AppBar Mock Align — WORKLOG

**Phase:** Phase 2 — AppBar モック準拠化  
**作成日:** 2026-03-17  
**SSOT:** docs/SSOT/FIT_AND_GAP_MENU_HEADER.md、モック `religo-admin-mock-v2.html` #appbar

---

## 着手日時

2026-03-17

---

## 参照ドキュメント

- docs/SSOT/FIT_AND_GAP_MENU_HEADER.md §3 AppBar 構造
- モック .ab-bc, .ab-search, .ab-ico, .av
- react-admin AppBar / SidebarToggleButton

---

## 実施ステップ

- CustomAppBar: MUI AppBar、height 56px、背景白、borderBottom 1px、boxShadow 薄く。左から SidebarToggleButton、パンくず（Link to / + 区切り + 現在ページ名）、検索 Box、通知 IconButton、ME アバター。
- パンくず: useLocation().pathname をマップしてラベル表示。'/'→Dashboard, '/connections'→Connections, '/members'→Members 等。
- ReligoLayout: appBar={CustomAppBar} 追加。

---

## 変更ファイル

- www/resources/js/admin/CustomAppBar.jsx（新規）
- www/resources/js/admin/ReligoLayout.jsx（appBar プロップ追加）

---

## テスト結果

- パンくず・検索・通知・ME 表示: 確認予定
- 既存遷移・狭幅: 確認予定

---

## 気づき・保留

- なし
