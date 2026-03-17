# PHASE Religo Sidebar Mock Align — WORKLOG

**Phase:** Phase 1 — Sidebar モック準拠化  
**作成日:** 2026-03-17  
**SSOT:** docs/SSOT/FIT_AND_GAP_MENU_HEADER.md、モック `religo-admin-mock-v2.html` #sidebar

---

## 着手日時

2026-03-17

---

## 参照ドキュメント

- docs/SSOT/FIT_AND_GAP_MENU_HEADER.md §2 サイドバー構造
- www/public/mock/religo-admin-mock-v2.html 行 26–45（#sidebar, .sb-logo, .sb-foot, .sb-user）
- react-admin Layout API（sidebar に children として Menu が渡る）

---

## 実施ステップ

### Step 1: CustomSidebar.jsx 新規作成

- useSidebarState で open/setOpen を取得。MUI Drawer を variant temporary（xs/sm）／permanent（md+）で使用。
- 幅 240px（theme.sidebar.width は既存 240 のためそのまま）、Paper の backgroundColor を #1e2a3a に。
- 子要素構成: ロゴブロック → スクロール可能な Box（children）→ ユーザーブロック（marginTop: auto）。

### Step 2: ロゴブロック

- .sb-logo 相当: padding 16px 18px 12px、flex、alignItems center、gap 10px、borderBottom 1px solid rgba(255,255,255,.08)。
- .sb-mark: 32x32、borderRadius 8px、background linear-gradient(135deg, #1976d2, #42a5f5)、フォント 13px 700 白「R」。
- .sb-name: 「Religo」、白、15px、700。
- .sb-sub: 「DragonFly Chapter」、rgba(255,255,255,.38)、10px、marginTop 1px。

### Step 3: ユーザーブロック

- .sb-foot 相当: padding 12px 18px、borderTop 1px solid rgba(255,255,255,.08)、marginTop auto。
- .sb-user: flex、alignItems center、gap 9px。
- .sb-av: 30x30 円、グラデ背景、「ME」、11px 700。
- テキスト: 「メンバー管理者」12px 500 白、「admin@dragonfly」10px rgba(255,255,255,.38)。仮固定。

### Step 4: ReligoLayout.jsx 変更

- CustomSidebar を import。Layout に sidebar={CustomSidebar} を追加。menu={ReligoMenu} はそのまま。

---

## 変更ファイル

- www/resources/js/admin/CustomSidebar.jsx（新規）
- www/resources/js/admin/ReligoLayout.jsx（sidebar プロップ追加）

---

## テスト結果

- メニュー順・SETTINGS 階層・リンク遷移・アクティブ表示: 確認予定
- 上部ロゴ・下部ユーザー表示: 確認予定
- レイアウト・狭幅: 確認予定

---

## 気づき

- ra-ui-materialui の Sidebar は Drawer の Paper 幅を theme.sidebar.width (240) で参照。CustomSidebar で同様に 240px を指定。
- モックの .sb-sec / .nav は既存 ReligoMenu が担当するため、CustomSidebar はあくまで外枠のみ。

---

## 保留事項

- なし
