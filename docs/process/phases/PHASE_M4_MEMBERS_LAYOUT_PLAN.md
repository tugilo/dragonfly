# Phase M-4 Members パッと見レイアウト（モック準拠）— PLAN

**Phase:** M-4（Members 画面をモックと同じブロック構成・パッと見で分かる UI に合わせる）  
**作成日:** 2026-03-06  
**SSOT:** [MEMBERS_MOCK_VS_UI_SUMMARY.md](../../SSOT/MEMBERS_MOCK_VS_UI_SUMMARY.md) §1.3、[FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md)

---

## 1. 目的

- モック（religo-admin-mock-v2.html#/members）と実装（/admin#/members）を**パッと見で同じ画面**と分かるようにする。
- **基本レイアウトの差**（統計カードなし・フィルタが隠れている・表 vs カード）を解消し、**ブロック順と見た目**をモックに寄せる。
- シェル（サイドバー・AppBar の見た目）の変更は**本 Phase の対象外**。Members ページ内の構成のみ。

---

## 2. 比較 URL

| 種別 | URL |
|------|-----|
| モック（正） | http://localhost/mock/religo-admin-mock-v2.html#/members |
| 実装 | http://localhost/admin#/members |

---

## 3. 作業項目（優先順）

| # | 項目 | 内容 | 備考 |
|---|------|------|------|
| 1 | **統計カード 4 種** | ページ上部に常時表示。総メンバー数 / 1to1未実施(30日) / interested ON / want_1on1 ON。モックの `.stats` 相当。 | API で stats を返す endpoint を追加するか、既存一覧 API のメタで返すか、またはクライアントで集計するか要検討。 |
| 2 | **フィルタバーを横並びで常時表示** | 検索・大カテゴリ・カテゴリ・ロール・interested/want_1on1 トグル・並び順・件数を **1 行に並べて常時表示**。モックの `.fbar` 相当。 | 現在の React Admin の「フィルタ」ボタンで開く UI ではなく、List 上部に常時表示のバーとして実装。 |
| 3 | **一覧形式** | **方針選択が必要。** ① カードグリッド（モックの `.cgrid` / `.mcard`）に変更する ② 表（Datagrid）のまま、統計＋フィルタバーだけ揃えて「ブロック構成」をモックに合わせる。 | ① は見た目は一致するが実装コスト大。② はパッと見の「流れ」は揃うが一覧の形は表のまま。 |

---

## 4. 非対象（本 Phase ではやらない）

- シェル（左サイドバー幅・色、AppBar のパンくず・検索・アバター）の変更 → 別 Phase で検討。
- 既存の検索・フィルタ・ソートの**機能**は M-3 で実装済み。本 Phase は**配置・常時表示**の変更。

---

## 5. DoD

- Members 画面の上から「ヘッダー → 統計カード行 → フィルタバー（常時表示）→ 一覧」の順になっていること。
- モックと実装を並べて開いたときに、**ブロックの並びが同じ**で、パッと見で同じ画面と分かること。
- 既存の php artisan test / npm run build が通ること。

---

## 6. 参照

- モックの HTML/CSS: `www/public/mock/religo-admin-mock-v2.html` の `#pg-members`、`.stats`、`.fbar`、`.cgrid`、`.mcard`。
- [MEMBERS_MOCK_VS_UI_SUMMARY.md](../../SSOT/MEMBERS_MOCK_VS_UI_SUMMARY.md) §1.3 基本レイアウトの差と「パッと見で分かる」UI。
