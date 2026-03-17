# PHASE Religo Sidebar Mock Align — PLAN

**Phase:** Phase 1 — Sidebar モック準拠化  
**作成日:** 2026-03-17  
**SSOT:** docs/SSOT/FIT_AND_GAP_MENU_HEADER.md、モック `www/public/mock/religo-admin-mock-v2.html` の `#sidebar`

---

## 1. 背景

- Religo 管理画面は react-admin の標準 Layout のままであり、モック v2 のサイドバー構成（上部ロゴ・中央メニュー・下部ユーザー）と一致していない。
- FIT_AND_GAP_MENU_HEADER で「高」優先度の Gap として、ロゴブロックとフッター（ユーザー表示）が挙がっている。
- メニュー項目順・アイコン・SETTINGS 階層は既に Fit のため、**shell（見た目・情報配置）のモック準拠**に限定する。

---

## 2. 目的

- CustomSidebar を新規作成し、Layout の `sidebar` として差し替える。
- 上部にロゴブロック（R マーク＋Religo＋DragonFly Chapter）、中央に既存 ReligoMenu、下部にユーザー表示ブロックを配置する。
- 既存のメニュー順・遷移・階層は壊さない。

---

## 3. 対象ファイル

| 種別 | パス |
|------|------|
| 新規 | `www/resources/js/admin/CustomSidebar.jsx` |
| 変更 | `www/resources/js/admin/ReligoLayout.jsx` |
| 参照（変更しない） | `www/resources/js/admin/ReligoMenu.jsx` |

---

## 4. 非対象（やらないこと）

- AppBar カスタマイズ
- 検索API・通知API
- URL 変更（/settings/categories 等）
- resource 定義・権限制御の変更

---

## 5. 実装方針

- react-admin の `Layout` に `sidebar={CustomSidebar}` を渡す。Layout は Sidebar に `children` として Menu（ReligoMenu）を渡すため、CustomSidebar は `{ children }` を受け取り、その上にロゴ、下にユーザーを配置する。
- `useSidebarState`（react-admin）で開閉状態を引き継ぎ、MUI Drawer で 240px 幅・ダーク背景（#1e2a3a）のシェルを実装する。
- 既存 ReligoMenu はそのまま利用する（Menu 本体の作り直しはしない）。

---

## 6. タスク分解

| # | タスク | 内容 |
|---|--------|------|
| 1 | CustomSidebar 新規 | useSidebarState 利用、Drawer 240px・背景 #1e2a3a、responsive（temporary / permanent） |
| 2 | ロゴブロック | .sb-logo 相当：R マーク（32x32）、Religo、DragonFly Chapter。padding・border-bottom |
| 3 | メニュー領域 | children をスクロール可能な中央に配置 |
| 4 | ユーザーブロック | .sb-foot 相当：アバター ME、メンバー管理者、admin@dragonfly（仮固定） |
| 5 | ReligoLayout 変更 | Layout に sidebar={CustomSidebar} を渡す |
| 6 | 動作確認 | メニュー遷移・アクティブ表示・レイアウト崩れなし |

---

## 7. テスト観点

- メニュー順が崩れていない
- SETTINGS 階層が崩れていない
- 各リンク遷移が正常
- アクティブ表示が維持される
- 上部ロゴが表示される
- 下部ユーザー表示が表示される
- レイアウト崩れがない
- 狭い幅でも極端に壊れない

---

## 8. DoD

- [ ] CustomSidebar 導入済み
- [ ] ロゴブロック表示
- [ ] 既存 ReligoMenu がそのまま動作
- [ ] 下部ユーザー表示追加
- [ ] 既存遷移に影響なし
- [ ] PLAN / WORKLOG / REPORT 作成済み
