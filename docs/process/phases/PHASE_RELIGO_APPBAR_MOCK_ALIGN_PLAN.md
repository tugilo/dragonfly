# PHASE Religo AppBar Mock Align — PLAN

**Phase:** Phase 2 — AppBar モック準拠化  
**作成日:** 2026-03-17  
**SSOT:** docs/SSOT/FIT_AND_GAP_MENU_HEADER.md、モック `www/public/mock/religo-admin-mock-v2.html` の `#appbar`

---

## 1. 背景

- Phase 1 で CustomSidebar を導入し、ロゴ・ユーザー表示を追加済み。
- AppBar は react-admin 標準のままで、モック v2 の「パンくず・検索・通知・ME アバター」と一致していない。
- 本 Phase は shell の見た目・情報配置のモック準拠のため、検索・通知はダミーでよい。

---

## 2. 目的

- CustomAppBar を新規作成し、Layout の `appBar` として差し替える。
- 左にパンくず（Religo › 現在ページ）、検索UI（ダミー）、通知アイコン（ダミー）、ME アバターを配置する。
- 既存のページ表示・遷移に悪影響を与えない。サイドバー開閉ボタンは維持する。

---

## 3. 対象ファイル

| 種別 | パス |
|------|------|
| 新規 | `www/resources/js/admin/CustomAppBar.jsx` |
| 変更 | `www/resources/js/admin/ReligoLayout.jsx` |

---

## 4. 非対象（やらないこと）

- 検索機能の本接続
- 通知機能の本接続
- 認証ユーザー連携
- URL 変更
- CRUD 画面変更

---

## 5. 実装方針

- react-admin の `Layout` に `appBar={CustomAppBar}` を渡す。
- CustomAppBar は MUI AppBar を使用。左端に SidebarToggleButton（react-admin）を置き、パンくずは useLocation で pathname を取得しラベルマップで表示。検索は InputBase のダミー、通知は IconButton、右端に ME アバター。
- 高さ 56px、白背景、下ボーダー・薄いシャドウでモックに合わせる。

---

## 6. タスク分解

| # | タスク | 内容 |
|---|--------|------|
| 1 | CustomAppBar 新規 | AppBar 56px、白背景、flex 配置 |
| 2 | サイドバー開閉 | SidebarToggleButton を左端に配置 |
| 3 | パンくず | Religo › [現在ページ名]。pathname → ラベルマップ。Religo クリックで / へ |
| 4 | 検索UI | 角丸・placeholder「検索…」・幅 210px 程度のダミー |
| 5 | 通知アイコン | 🔔 IconButton（ダミー） |
| 6 | ME アバター | 32px 円・グラデ・「ME」 |
| 7 | ReligoLayout 変更 | appBar={CustomAppBar} を渡す |
| 8 | 動作確認 | パンくず・各要素表示・遷移に影響なし |

---

## 7. テスト観点

- パンくずが表示される
- 現在ページ表示が極端に不自然でない
- 検索UI・通知アイコン・ME アバターが表示される
- 既存表示に悪影響がない
- 狭い幅でも極端に壊れない

---

## 8. DoD

- [ ] CustomAppBar 導入済み
- [ ] パンくず表示
- [ ] 検索UI表示
- [ ] 通知アイコン表示
- [ ] ME アバター表示
- [ ] 既存遷移に影響なし
- [ ] PLAN / WORKLOG / REPORT 作成済み
