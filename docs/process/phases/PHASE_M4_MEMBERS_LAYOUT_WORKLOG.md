# Phase M-4 Members パッと見レイアウト — WORKLOG

**Phase:** M-4  
**作成日:** 2026-03-06  
**参照:** [PHASE_M4_MEMBERS_LAYOUT_PLAN.md](PHASE_M4_MEMBERS_LAYOUT_PLAN.md)、[MEMBERS_MOCK_VS_UI_SUMMARY.md](../../SSOT/MEMBERS_MOCK_VS_UI_SUMMARY.md) §1.3

---

## Step0: 現状確認

- **Members 画面:** React Admin の `<List>` で、`title`（Members ＋ サブタイトル）、`actions`（Connectionsへ・＋メンバー追加）、`filters={membersFilters}`（SearchInput alwaysOn、ReferenceInput category/role、BooleanInput interested/want_1on1）、`sort`、`perPage={25}`。
- **表示の流れ:** タイトル＋サブタイトル → ツールバー（アクションボタン）→ **Filter ボタンで開くフィルタ** → Datagrid（表）。統計カードはなし。
- **結論:** モックの「ヘッダー → 統計カード → 常時表示フィルタバー → 一覧」の順になっていない。フィルタはボタンで開閉される形。

---

## Step1: 統計 4 種の表示方針

- **方針:** まずは**クライアント集計**。一覧データ（List の useListContext の `data` と `total`）から算出する。
- **総メンバー数:** `total` を表示。API がページングを返す場合は「現在のフィルタ結果の総数」となる。
- **1to1未実施(30日):** 現在の `data` 配列から、`summary_lite.last_contact_at` が 30 日より前または null の件数をカウント。**制約:** ページング時は「表示中 N 件中」の値になる。全件統計が必要な場合は将来 API で stats を返す Phase で対応。
- **interested ON / want_1on1 ON:** 現在の `data` から `summary_lite.interested` / `summary_lite.want_1on1` が true の件数をカウント。同上、ページング時は表示中件数ベース。
- **値が算出できない場合:** データ未読込時は "—" または 0。安全のため、`data` が空でも 0 を表示するロジックにする。

---

## Step2: 常時表示フィルタバーの配置方針

- **方針:** List の子として、Datagrid の**上**に「フィルタバー」を常時表示するブロックを置く。React Admin の Filter ボタンで開く UI に依存せず、**同じ filter 状態**（useListContext の filterValues / setFilters）にバインドした入力コンポーネントを横並びで配置する。
- **項目:** SearchInput（q）、ReferenceInput（category_id）、ReferenceInput（role_id）、BooleanInput（interested）、BooleanInput（want_1on1）、並び順（sort/order）。大カテゴリ（group_name）は既存 API/UI にないため**今回は追加しない**（GAP として残す）。
- **レイアウト:** 1 行を優先。幅が足りない場合は flexWrap で折り返し可。モックの `.fbar` に近い余白・間隔にする。

---

## Step3: Datagrid 維持の判断理由

- **判断:** 一覧形式は**今回いったん Datagrid（表）のまま維持**する。
- **理由:** M-4 の目的は「ブロック順・パッと見の流れ」をモックに合わせること。カードグリッド化は実装コストが大きいため後続 Phase で対応する。ヘッダー → 統計カード → フィルタバー → 一覧（表）の順にすれば、モックと「上から見たブロックの並び」は揃う。
- **既存機能:** M-2 の列（番号・名前・カテゴリ・役職・同室回数・1to1回数・最終接触・直近メモ・フラグ・Actions）、M-3 の検索/フィルタ/ソート、Drawer・モーダル導線は**一切変更しない**。

---

## Step4: モック比較結果（M-4b 実装後）

- **ブロック順:** ヘッダー（タイトル＋サブタイトル＋Connectionsへ・＋メンバー追加）→ 統計カード 4 枚 → フィルタバー（常時表示）→ Datagrid。モックと同一の流れ。
- **統計カード:** 4 種表示。クライアント集計のため、ページング時は「表示中 N 件中」の値になる制約を REPORT に記載。
- **フィルタバー:** 検索・カテゴリ・役職・Interested・Want 1on1・並び順を常時表示。大カテゴリは GAP。
- **一覧:** 表のまま。カードグリッドは GAP（後続 Phase）。
