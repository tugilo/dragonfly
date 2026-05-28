# フィット＆ギャップ：メニュー・ヘッダー（モック v2 基準）

**目的:** メニュー（サイドバー）とヘッダー（AppBar）をモックに合わせるための調査結果。実装時の参照用。  
**SSOT モック:** `www/public/mock/religo-admin-mock-v2.html`  
**比較 URL:** モック http://localhost/mock/religo-admin-mock-v2.html ／ 実装 http://localhost/admin  

**更新（2026-04-06）:** §4・§5.2 を **現行実装**（カスタム AppBar・`ReligoOwnerProvider`・グローバル Owner）に合わせて追記・修正。[ADMIN_GLOBAL_OWNER_SELECTION.md](ADMIN_GLOBAL_OWNER_SELECTION.md)（SPEC-003）・Phase `ADMIN_GLOBAL_OWNER_SPEC003_DOCS` の記録に整合。

---

## 1. 参照情報

| 種別 | URL / パス |
|------|------------|
| モック（v2） | http://localhost/mock/religo-admin-mock-v2.html |
| モックファイル | `www/public/mock/religo-admin-mock-v2.html` |
| 実装（管理画面） | http://localhost/admin |
| 実装レイアウト | `www/resources/js/admin/ReligoLayout.jsx` |
| 実装メニュー | `www/resources/js/admin/ReligoMenu.jsx` |

---

## 2. モック v2 のサイドバー構造

### 2.1 全体

- **ID:** `#sidebar`
- **幅:** `--sbw: 240px`（固定）
- **背景:** `--sb: #1e2a3a`（ダーク）
- **構成:** 上から ロゴ → メインナビ → 区切り → SETTINGS → フッター（ユーザー）

### 2.2 ブロック別（モックの HTML / CSS クラス）

| 順 | ブロック | クラス / 要素 | 表示内容 |
|----|----------|----------------|----------|
| 1 | ロゴ | `.sb-logo` | マーク＋製品名＋チャプター名 |
| 1a | マーク | `.sb-mark` | 32×32px、角丸8px、グラデ背景。「R」1文字、白・太字 13px |
| 1b | 名前 | `.sb-name` | 「Religo」、白・15px・700 |
| 1c | サブ | `.sb-sub` | 「DragonFly Chapter」、rgba(255,255,255,.38)、10px |
| 2 | メインナビ | `.sb-sec` > `.nav`（button） | 6 項目（下記） |
| 2a | — | `.nav` data-href="#/dashboard" | 📊 Dashboard |
| 2b | — | `.nav` #/connections | 🗺 Connections |
| 2c | — | `.nav` #/members | 👥 Members |
| 2d | — | `.nav` #/meetings | 📋 Meetings |
| 2e | — | `.nav` #/one-to-ones | 🤝 1 to 1 |
| 2f | — | `.nav` #/role-history | 🏅 Role History |
| 3 | 区切り | `.sb-div` | 1px 線（rgba(255,255,255,.1)） |
| 4 | SETTINGS 見出し | `.sb-lbl` | 「Settings」、9px・大文字・letter-spacing 1px、色 rgba(255,255,255,.28) |
| 5 | SETTINGS サブ | `.sb-sec` > `.nav-sub` | 2 項目 |
| 5a | — | `.nav-sub` #/settings/categories | Categories（左インデント 44px 相当） |
| 5b | — | `.nav-sub` #/settings/roles | Roles |
| 6 | フッター | `.sb-foot` | ボーダー上＋ユーザー情報 |
| 6a | ユーザー | `.sb-user` | アバター＋名前＋メール |
| 6b | アバター | `.sb-av` | 30×30 円、「ME」、グラデ背景 |
| 6c | テキスト | （インライン） | 「メンバー管理者」、12px・500／「admin@dragonfly」、10px・.38 |

### 2.3 ナビのスタイル（モック）

- **通常:** `.nav` — padding 8px 18px、色 rgba(255,255,255,.62)、13px。アイコン `.ico` は 15px・幅 20px。
- **ホバー:** background rgba(255,255,255,.07)、color #fff。
- **アクティブ:** `.nav.active` — background rgba(25,118,210,.22)、color #fff・500。左に 3px の primary 縦線（border-radius 0 2px 2px 0）。
- **サブ:** `.nav-sub` — padding 6px 18px 6px 44px、色 .45、12px。ホバーで .85＋背景 .05。アクティブは .nav-sub.active（#90caf9、500）。

### 2.4 モックのルート（hash）

- `/dashboard`, `/connections`, `/members`, `/meetings`, `/one-to-ones`, `/role-history`
- `/settings/categories`, `/settings/roles`

---

## 3. モック v2 の AppBar（ヘッダー）構造

### 3.1 全体

- **ID:** `#appbar`
- **高さ:** `--abh: 56px`
- **背景:** 白（`--sur: #fff`）、下ボーダー 1px、薄いシャドウ、z-index 9
- **レイアウト:** flex、align-items center、padding 0 20px、gap 12px

### 3.2 ブロック別

| 順 | ブロック | クラス | 表示内容 |
|----|----------|--------|----------|
| 1 | パンくず | `.ab-bc` | 「Religo › Dashboard」など。クリックで hash 遷移。最後だけ .cur（現在ページ） |
| 1a | リンク | span onclick | Religo → #/dashboard |
| 1b | 区切り | `.sep` | 「›」、色 dis |
| 1c | 現在 | `.cur` | 現在ページ名、txt・500、cursor default |
| 2 | 検索 | `.ab-search` | 幅 210px、角丸 20px、背景 #f5f5f5、ボーダー。🔍＋input placeholder「検索…」 |
| 3 | 通知 | `.ab-ico` | 34×34 円ボタン、🔔、ホバーで背景 .06 |
| 4 | アバター | `.av` | 32×32 円、「ME」、グラデ背景、cursor pointer |

---

## 4. 実装の現状

### 4.1 レイアウト（ReligoLayout.jsx）

- **react-admin の `<Layout>`** に **`menu={ReligoMenu}`**、**`sidebar={CustomSidebar}`**、**`appBar={CustomAppBar}`** を渡している（デフォルト AppBar ではない）。
- **`ReligoOwnerProvider`:** `www/resources/js/admin/app.jsx` で **`<Admin>` 全体をラップ**。`GET /api/users/me`・`GET /api/dragonfly/members`（Owner 選択肢）・所属チャプター表示用の workspace 解決を Context に集約。
- **初期ロード（`loading === true`）:** メイン領域は **全画面スピナー**（`CircularProgress`）。この間は Sidebar / AppBar は出さない。
- **`owner_member_id` 未設定（`loading === false` かつ `ownerMemberId == null`）:** **原則**メインコンテンツは「Ownerを選択してください」に差し替え。**例外:** **`pathname === '/settings'`** のときは **ReligoSettings** を表示。**AppBar・Sidebar は表示**され、ヘッダーの Owner `Select` で選択可能（[ADMIN_GLOBAL_OWNER_SELECTION.md](ADMIN_GLOBAL_OWNER_SELECTION.md) §4.4）。

### 4.2 メニュー（ReligoMenu.jsx）

- **コンポーネント:** react-admin の `<Menu>` ＋ MUI `MenuItem` / `ListSubheader` / `Divider`。
- **並び:** Dashboard → Connections → Members → Meetings → 1 to 1 → Role History → Divider → "SETTINGS" → Categories → Roles。
- **アイコン:** 各項目に emoji（📊 🗺 👥 📋 🤝 🏅）。Settings 配下の Categories / Roles はアイコンなし。
- **アクティブ:** `path === href || path.startsWith(href)` で selected、左 3px primary ボーダー。
- **リンク先:** `/`, `/connections`, `/members`, `/meetings`, `/one-to-ones`, `/role-history`, `/categories`, `/roles`（**Settings はパスに含まない**）。チャプター設定は **`/settings`**（`CustomRoutes`）。

### 4.3 AppBar（CustomAppBar.jsx）

- **カスタム実装**（react-admin 標準ではない）。
- **パンくず:** 「Religo」リンク（`/`）› 現在ページラベル（pathname から変換）。
- **検索:** モック同様の **見た目のボックス**（`InputBase`、**disabled**・ダミー）。
- **Owner（SPEC-003）:** MUI **`Select`**（ラベル「Owner」）。選択肢は `GET /api/dragonfly/members`。変更時 **`PATCH /api/users/me`**。未選択時はプレースホルダ行。
- **所属チャプター:** `resolvedWorkspaceId` があるとき **「所属: {名}」** を表示し **`/settings` へリンク**（Context の解決名）。
- **通知:** 🔔 の **IconButton**（ダミー）。
- **アバター:** 32px 円・「ME」・グラデ（モックの `.av` に近い）。

### 4.4 データ取得と React Admin（補足）

- **React Admin の `dataProvider`**（`dragonflyDataProvider`）は、owner 依存リソースで **`assertOwnerResolved()`**（`religoOwnerStore` と同期）を用いる。未解決・ロード中はエラー。
- **CustomRoutes** や **コンポーネント内 `fetch`** は dataProvider 外のため、**`useReligoOwner().ownerMemberId`** で同一の解決済み ID を参照する方針（詳細は SPEC-003 §5.1・実装棚卸し）。

---

## 5. フィット＆ギャップ一覧（メニュー・ヘッダー）

### 5.1 サイドバー（メニュー）

| # | 観点 | モック v2 | 実装 | Fit / Gap |
|---|------|-----------|------|-----------|
| S1 | 幅 | 240px | react-admin デフォルト（要確認） | **Gap:** 明示 240px 未指定の可能性 |
| S2 | ロゴブロック | sb-logo: R マーク＋Religo＋DragonFly Chapter | なし（Layout のデフォルトはタイトル等） | **Gap:** ロゴ・製品名・チャプター名なし |
| S3 | メニュー項目順 | Dashboard → Connections → Members → Meetings → 1 to 1 → Role History | 同一順 | **Fit** |
| S4 | メニューアイコン | 📊 🗺 👥 📋 🤝 🏅 | 同一 | **Fit** |
| S5 | 区切り線 | SETTINGS 直前に 1px 線 | Divider あり | **Fit** |
| S6 | SETTINGS ラベル | 「Settings」大文字・小さい字 | 「SETTINGS」ListSubheader | **Fit**（表記「Settings」vs「SETTINGS」は要確認） |
| S7 | Settings サブ項目 | Categories, Roles（インデント） | Categories, Roles（pl: 3） | **Fit** |
| S8 | Settings サブのアイコン | モックはなし | 実装もなし | **Fit** |
| S9 | フッター（ユーザー） | アバター ME＋「メンバー管理者」＋admin@dragonfly | なし（サイドバー内にはユーザー表示なし） | **Gap:** サイドバー下部のユーザー情報なし |
| S10 | ルート（URL） | #/settings/categories, #/settings/roles | /categories, /roles | **Gap:** モックは /settings/categories、実装は /categories。導線は同等 |

### 5.2 AppBar（ヘッダー）

| # | 観点 | モック v2 | 実装（CustomAppBar.jsx） | Fit / Gap |
|---|------|-----------|---------------------------|-----------|
| A1 | パンくず | Religo › [現在ページ]。Religo クリックで Dashboard | 「Religo」リンク（`/`）› 現在ページ名（`PATH_TO_LABEL` 等） | **Fit**（表記はモックと同等の意図） |
| A2 | 検索ボックス | 角丸・placeholder「検索…」・幅 210px | 同形状の **ダミー**（disabled） | **Partial:** 見た目は近いが機能なし |
| A3 | 通知アイコン | 🔔 円ボタン | 🔔 `IconButton`（ダミー） | **Fit**（機能はダミー） |
| A4 | アバター | 32px 円「ME」、グラデ | 32px 円「ME」グラデ | **Fit** |
| A5 | **Owner Select**（SPEC-003） | （モック v2 には明示なし・本プロダクト要件） | ラベル「Owner」・`PATCH /api/users/me` で保存 | **Fit**（要件は [ADMIN_GLOBAL_OWNER_SELECTION](ADMIN_GLOBAL_OWNER_SELECTION.md)） |
| A6 | 所属チャプター | （モックは別要素で表現可） | 「所属: …」リンク `/settings` | **Fit**（BO-AUDIT 系の既存導線と整合） |

---

## 6. まとめ

### 6.1 Fit（揃っているところ）

- メニュー項目の**順序**と**アイコン**（Dashboard 〜 Role History）。
- SETTINGS の**階層**（見出し＋Categories / Roles）と**インデント**。
- **アクティブ状態**の左ボーダー（3px primary）。
- **AppBar（CustomAppBar）:** パンくず風の **Religo › 現在ページ**、検索欄の**枠**（ダミー）、通知・ME アバター、**グローバル Owner Select**（[ADMIN_GLOBAL_OWNER_SELECTION](ADMIN_GLOBAL_OWNER_SELECTION.md)）、**所属チャプター**リンク。

### 6.2 Gap（モックに合わせるなら対応したいところ）

| 優先度 | 項目 | 内容 |
|--------|------|------|
| 高 | サイドバー上部 | **ロゴブロック**（R マーク＋「Religo」＋「DragonFly Chapter」）を追加 |
| 高 | サイドバー下部 | **ユーザー表示**（アバター＋「メンバー管理者」＋メール）を追加 |
| ~~高~~ | ~~AppBar パンくず~~ | **2026-04 実装済み**（§4.3・§5.2 A1）。残タスクから除外してよい。 |
| 中 | AppBar 検索 | **検索を有効化**するかは別要件（現状はダミー・§5.2 A2） |
| ~~中~~ | ~~AppBar 通知・アバター~~ | **ダミー通知・ME アバターは実装済み**（§5.2 A3・A4）。装飾・挙動のモック完全一致は未 |
| 低 | ルート | /categories → /settings/categories 等、モックと URL を揃えるかは要件次第 |
| 低 | サイドバー幅 | 240px を明示 |

### 6.3 実装時の参照

- **モックの見た目:** http://localhost/mock/religo-admin-mock-v2.html を開き、サイドバー・AppBar の構造とスタイルを確認。
- **CSS 変数・クラス:** 本ドキュメント §2・§3 および `religo-admin-mock-v2.html` の `<style>` 内の `#sidebar`, `#appbar`, `.sb-*`, `.ab-*`, `.nav`, `.nav-sub` を参照。
- **React Admin のカスタム:** 実装では `ReligoLayout` が **`Layout` に `appBar={CustomAppBar}` / `sidebar={CustomSidebar}`** を渡している（§4.1）。追加改修時は `www/resources/js/admin/ReligoLayout.jsx`・`CustomAppBar.jsx`・`CustomSidebar.jsx` を参照。

---

## 7. 関連ドキュメント

- [FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) — 全体のフィット＆ギャップ（§1 シェルは本ドキュメントで詳細化）
- [MOCK_UI_VERIFICATION.md](MOCK_UI_VERIFICATION.md) — モック比較の手順・ルール
