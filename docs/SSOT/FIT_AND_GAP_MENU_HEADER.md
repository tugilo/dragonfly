# フィット＆ギャップ：メニュー・ヘッダー（モック v2 基準）

**目的:** メニュー（サイドバー）とヘッダー（AppBar）をモックに合わせるための調査結果。実装時の参照用。  
**SSOT モック:** `www/public/mock/religo-admin-mock-v2.html`  
**比較 URL:** モック http://localhost/mock/religo-admin-mock-v2.html ／ 実装 http://localhost/admin

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

### 4.1 レイアウト

- **ReligoLayout.jsx:** react-admin の `<Layout menu={ReligoMenu} />` をそのまま使用。カスタム AppBar / Sidebar は渡していない。
- **react-admin Layout:** デフォルトで Sidebar（メニュー）＋ AppBar ＋ Content。AppBar の内容は react-admin 標準（メニュー開閉・タイトル・ユーザーメニュー等）。

### 4.2 メニュー（ReligoMenu.jsx）

- **コンポーネント:** react-admin の `<Menu>` ＋ MUI `MenuItem` / `ListSubheader` / `Divider`。
- **並び:** Dashboard → Connections → Members → Meetings → 1 to 1 → Role History → Divider → "SETTINGS" → Categories → Roles。
- **アイコン:** 各項目に emoji（📊 🗺 👥 📋 🤝 🏅）。Settings 配下の Categories / Roles はアイコンなし。
- **アクティブ:** `path === href || path.startsWith(href)` で selected、左 3px primary ボーダー。
- **リンク先:** `/`, `/connections`, `/members`, `/meetings`, `/one-to-ones`, `/role-history`, `/categories`, `/roles`（**Settings はパスに含まない**）。

### 4.3 AppBar（実装）

- react-admin 標準の AppBar。モックのような「パンくず」「検索ボックス」「🔔」「ME」の組み合わせは未実装。タイトル・メニュー開閉・テーマ切替・更新・ユーザーメニュー等は react-admin デフォルト。

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

| # | 観点 | モック v2 | 実装 | Fit / Gap |
|---|------|-----------|------|-----------|
| A1 | パンくず | Religo › [現在ページ]。Religo クリックで Dashboard | react-admin の Breadcrumb またはタイトル。表現が異なる可能性 | **Gap:** モックと同じ「Religo › ページ名」のパンくずなし |
| A2 | 検索ボックス | 角丸・placeholder「検索…」・幅 210px | なし | **Gap:** 未実装 |
| A3 | 通知アイコン | 🔔 円ボタン | なし | **Gap:** 未実装 |
| A4 | アバター | 32px 円「ME」、グラデ | react-admin はユーザーメニュー（別UI）。モックと同じ「ME」アバターは未 | **Gap:** モックと同じ見た目のアバター未実装 |

---

## 6. まとめ

### 6.1 Fit（揃っているところ）

- メニュー項目の**順序**と**アイコン**（Dashboard 〜 Role History）。
- SETTINGS の**階層**（見出し＋Categories / Roles）と**インデント**。
- **アクティブ状態**の左ボーダー（3px primary）。

### 6.2 Gap（モックに合わせるなら対応したいところ）

| 優先度 | 項目 | 内容 |
|--------|------|------|
| 高 | サイドバー上部 | **ロゴブロック**（R マーク＋「Religo」＋「DragonFly Chapter」）を追加 |
| 高 | サイドバー下部 | **ユーザー表示**（アバター＋「メンバー管理者」＋メール）を追加 |
| 高 | AppBar | **パンくず**「Religo › 現在ページ」を表示 |
| 中 | AppBar | **検索ボックス**（placeholder「検索…」、幅 210px 程度） |
| 中 | AppBar | **通知アイコン**（🔔）と**アバター**（ME） |
| 低 | ルート | /categories → /settings/categories 等、モックと URL を揃えるかは要件次第 |
| 低 | サイドバー幅 | 240px を明示 |

### 6.3 実装時の参照

- **モックの見た目:** http://localhost/mock/religo-admin-mock-v2.html を開き、サイドバー・AppBar の構造とスタイルを確認。
- **CSS 変数・クラス:** 本ドキュメント §2・§3 および `religo-admin-mock-v2.html` の `<style>` 内の `#sidebar`, `#appbar`, `.sb-*`, `.ab-*`, `.nav`, `.nav-sub` を参照。
- **React Admin のカスタム:** `Layout` に `appBar` / `sidebar` を渡してカスタムコンポーネントに差し替える必要あり。react-admin の Layout API を確認すること。

---

## 7. 関連ドキュメント

- [FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) — 全体のフィット＆ギャップ（§1 シェルは本ドキュメントで詳細化）
- [MOCK_UI_VERIFICATION.md](MOCK_UI_VERIFICATION.md) — モック比較の手順・ルール
