# Members：モックと実装の差・要件まとめ

**目的:** Members 画面について、モック（SSOT）と実装 UI の差分を整理し、要件を一覧化する。  
**参照:** [MEMBERS_REQUIREMENTS.md](MEMBERS_REQUIREMENTS.md)（要件 SSOT）、[FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) §4、  
**モック:** `www/public/mock/religo-admin-mock-v2.html`（#/members）  
**比較:** モック http://localhost/mock/religo-admin-mock-v2.html#/members ／ 実装 http://localhost/admin#/members  
**作成日:** 2026-03-06

---

## 1. モックの定義（SSOT）

### 1.1 参照モック

| モック | 用途 | 一覧形式 |
|--------|------|----------|
| **religo-admin-mock-v2.html** (#/members) | 管理画面全体の SSOT。Members は**統計カード＋横並びフィルタバー＋カードグリッド** | カード（mcard） |
| members-mock.html | Members 単体モック（テーブル版） | テーブル |

本ドキュメントでは **religo-admin-mock-v2.html** を「モック」の正とする。

### 1.2 モックの Members 画面構成（religo-admin-mock-v2）

| ブロック | 内容 |
|----------|------|
| **ページヘッダ** | h1「Members」、p「仕事 / 役職 / 関係性を把握し、1to1とメモで接点を増やす」 |
| **ヘッダーアクション** | 「Connectionsへ」「＋ メンバー追加（将来）」disabled |
| **統計カード（4種）** | 総メンバー数 / 1to1未実施(30日) / interested ON / want_1on1 ON |
| **フィルタバー** | 検索（名前・カテゴリ・ロール）、大カテゴリ select、カテゴリ select、ロール select、interested / want_1on1 トグル、並び順 select、件数表示 |
| **一覧** | カードグリッド（mcard）。各カード: 番号・役職 chip・名前・かな・大/実カテゴリ・同室回数・最終接触・直近メモ・interested/want_1on1 フラグ・操作（✏️メモ、📅1to1、📝1to1メモ、詳細→）・関係ログ（最近） |
| **詳細** | 右側 Drawer。タブ: Overview / Memos / 1to1。Overview: 同室・1to1回数・最終接触・役職・直近メモ・メモ追加・1to1予定・Connectionsで開く。Memos/1to1: 履歴一覧 |
| **モーダル** | メモ追加、1to1予定作成、1to1メモ、**フラグ編集**（interested / want_1on1） |

---

## 1.3 基本レイアウトの差と「パッと見で分かる」UI

**問題:** モック（religo-admin-mock-v2.html#/members）と実装（/admin#/members）を並べると **UI が全然違って見える**。パッと見で同じ画面だと分かるようにするには、**基本レイアウト**と**ブロックの並び・見た目**をモックに合わせる必要がある。

### 基本レイアウトの差

| 観点 | モック | 実装 | 影響 |
|------|--------|------|------|
| **シェル** | 左サイドバー（幅 240px・暗色）、上部 AppBar（パンくず・検索・通知・アバター）、メインは #content | React Admin の Layout（サイドバー・AppBar はデフォルトの見た目）。パンくず・検索・アバターの有無・配置が異なる | 画面全体の「雰囲気」が違う |
| **Members ページの構成** | **上から順に**：① ページヘッダ（h1＋サブコピー＋ボタン）→ ② **統計カード 4 枚（横並び）** → ③ **フィルタバー（横並び・常時表示）** → ④ **カードグリッド（mcard）** | **上から順に**：① List タイトル＋ツールバー（ボタン）→ ② フィルタは「フィルタ」ボタンで開くドロワー/ポップover → ③ **表（Datagrid）**。統計カードなし | モックは「数→条件→カード」の流れで一目で分かる。実装は「表だけ」が目立ち、数も条件もパッと見で分かりにくい |
| **一覧の形** | **カード**（1 メンバー＝1 カード）。番号・名前・かな・カテゴリ・同室/最終接触・メモ抜粋・フラグ・操作・関係ログが 1 ブロックにまとまる | **表**（行×列）。横スクロールしやすく情報は揃うが、モックのような「1 人 1 カード」の視認性はない | パッと見で「誰がいて、どういう状態か」がカードの方が認識しやすい |

### 目指す UI（パッと見で分かる）

- **ブロック順をモックと揃える:** ヘッダー → **統計カード行** → **横並びフィルタバー（常時表示）** → 一覧（カード or 表）。
- **統計カード:** 総メンバー数・1to1未実施(30日)・interested ON・want_1on1 ON を、モックと同様にページ上部に常時表示する。
- **フィルタバー:** 検索・大カテゴリ・カテゴリ・ロール・interested/want_1on1 トグル・並び順・件数を、**1 行に並べて常時表示**する（隠す場合は「フィルタ」ボタンではなく、モックに近い配置）。
- **一覧:** モックに合わせて**カードグリッド**にするか、表のまま**ブロック構成だけ**（統計＋フィルタバー）を揃えるかは Phase で選択。いずれにしても「パッと見で同じ画面」と分かることを目標とする。
- **リスト／カード切替（推奨）:** 一覧を**リスト形式（表）**と**カード形式**でスイッチできるようにすると、モックの「1 人分の情報が 1 枚のカードで見える」体験と、表での比較・ソートの両方を満たせる。詳細は docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md §4.2・4.3 を参照。

### 実装時の参照

- モックの HTML/CSS: `www/public/mock/religo-admin-mock-v2.html` の `#pg-members`、`.stats`、`.fbar`、`.cgrid`、`.mcard`。
- 比較用 URL: モック http://localhost/mock/religo-admin-mock-v2.html#/members ／ 実装 http://localhost/admin#/members 。

---

## 2. 実装の現状（React Admin）

### 2.1 実装ファイル

- 一覧・モーダル・Drawer: `www/resources/js/admin/pages/MembersList.jsx`
- Show ページ（/members/:id）: `www/resources/js/admin/pages/MemberShow.jsx`

### 2.2 実装の Members 画面構成

| ブロック | 内容 |
|----------|------|
| **ページヘッダ** | タイトル「Members」のみ（サブ説明なし） |
| **ヘッダーアクション** | 「Connectionsへ」「＋ メンバー追加（将来）」 | **Fit** |
| **統計カード** | なし | **Gap** |
| **フィルタ** | React Admin 標準の Filter（検索等）。大カテゴリ/カテゴリ/ロール/トグル/並び順は未 | **Gap** |
| **一覧** | Datagrid（表）。列: 番号・名前・カテゴリ・役職・同室回数・最終接触・直近メモ・Actions（✏️メモ、📅1to1、📝1to1メモ、詳細）。**1to1回数列・かな・interested/want_1on1・関係ログはなし** | **Gap（表 vs カード、列不足）** |
| **行アクション** | メモ・1to1・1to1メモ・詳細の 4 種 | **Fit** |
| **詳細** | 一覧の「詳細」→ **Drawer**（Overview / Memos / 1to1）。API からメモ・1to1 取得表示 | **Fit** |
| **メモ/1to1/1to1メモモーダル** | 種別・本文・例会/1to1紐付け・重要フラグ等 | **Fit** |
| **フラグ編集** | Members 画面からはなし（Connections では Switch で更新） | **Gap** |
| **Member Show（/members/:id）** | 番号・名前・カテゴリ・現在役職。「メモ履歴・1to1履歴 Coming soon」 | **Gap** |

---

## 3. モック vs 実装 差分一覧

| # | 観点 | モック | 実装 | 判定 |
|---|------|--------|------|------|
| 1 | サブタイトル | 「仕事 / 役職 / 関係性を把握し…」 | なし | Gap |
| 2 | 統計カード | 4 種（総数・1to1未実施30日・interested・want_1on1） | なし | Gap |
| 3 | フィルタ | 検索＋大カテゴリ＋カテゴリ＋ロール＋interested/want_1on1 トグル＋並び順＋件数 | 検索等のみ（多条件フィルタ未） | Gap |
| 4 | 一覧形式 | カードグリッド | 表（Datagrid） | Gap |
| 5 | 一覧列：1to1回数 | あり（カード内） | なし | Gap |
| 6 | 一覧：かな | あり | なし | Gap |
| 7 | 一覧：interested / want_1on1 | フラグ表示あり | なし | Gap |
| 8 | 一覧：関係ログ（最近） | カード内にあり | なし | Gap |
| 9 | 行アクション 4 種 | メモ・1to1・1to1メモ・詳細 | 同一 | Fit |
| 10 | メモ/1to1/1to1メモモーダル | あり | あり | Fit |
| 11 | 詳細 UI | 右側 Drawer（Overview/Memos/1to1） | Drawer（同一構成） | Fit |
| 12 | フラグ編集モーダル | あり | Members からはなし | Gap |
| 13 | Member Show ページ | — | 履歴は Coming soon | Gap |

---

## 4. 要件との対応（MEMBERS_REQUIREMENTS ベース）

### 4.1 一覧の表示項目（§3.1）

| 項目 | 要件 | モック | 実装 |
|------|------|--------|------|
| display_no | 必須 | ○ | ○ |
| name | 必須 | ○ | ○ |
| category（大/実） | 必須 | ○ | ○（1列で表示） |
| current_role | 必須 | ○ | ○ |
| same_room_count | 必須 | ○ | ○ |
| last_memo（80字まで） | 必須 | ○ | ○（20字で切って表示） |
| one_to_one_count | 必須 | ○ | **× 未表示** |
| last_contact_at | 必須 | ○ | ○ |
| interested / want_1on1 | 任意 | ○ | × |
| name_kana | 任意 | ○ | × |

**要件上の不足:** 一覧に **one_to_one_count（1to1回数）** が必須だが未実装。

### 4.2 一覧の操作（§4）

| 操作 | 要件 | モック | 実装 |
|------|------|--------|------|
| 検索（name / display_no / name_kana） | 必須 | ○ | React Admin の Filter に依存（API 検索パラメータは要確認） |
| フィルタ（大カテゴリ・実カテゴリ・役職・メモあり/なし・1to1あり/なし） | 必須 | ○ 大カテゴリ・カテゴリ・ロール・トグル | 未（多条件フィルタなし） |
| ソート（display_no / name / last_contact_at 等） | 推奨 | ○ 並び順 select | 未（API 固定の可能性） |
| メモ追加 | 必須 | ○ | ○ |
| 1to1予定作成 | 必須 | ○ | ○ |
| 履歴を見る（Drawer/Modal） | 必須 | ○ Drawer | ○ Drawer |
| 詳細へ | 必須 | ○ Drawer | ○ Drawer |

### 4.3 詳細・編集

| 項目 | 要件 | 実装 |
|------|------|------|
| Member Show（詳細） | マスター情報＋メモ履歴＋1to1履歴＋役職履歴 | Drawer でメモ・1to1履歴は実装済み。Show ページ（/members/:id）は履歴 Coming soon |
| Member Edit | 名前・かな・カテゴリ・表示番号等のマスター編集 | 未実装（本 Phase 外の可能性あり） |

### 4.4 メモ・1to1（Members 起点）

| 項目 | 要件 | 実装 |
|------|------|------|
| メモ追加（target 指定・body 必須） | 最短 1 クリックでメモ入力 UI | ○ モーダルで実装 |
| 1to1予定作成（owner-target・status=planned） | 行アクションから導線 | ○ モーダルで実装 |
| 1to1メモ（過去 1to1 紐付け任意） | 行アクションから導線 | ○ モーダルで実装 |
| フラグ（interested / want_1on1） | 一覧ではアイコン/バッジ可。編集は任意 | 一覧に表示なし。Members からフラグ編集モーダルなし |

---

## 5. 要件まとめ（実装者が見るチェックリスト）

### 5.1 すでに Fit のもの

- ヘッダーアクション（Connectionsへ、＋メンバー追加（将来））
- 一覧の行アクション 4 種（メモ・1to1・1to1メモ・詳細）
- メモ追加・1to1予定・1to1メモの各モーダル（項目・導線）
- 詳細は **Drawer**（Overview / Memos / 1to1）で一覧を離れずに履歴照会可能

### 5.2 ギャップ（モック・要件との差）— 対応優先度の目安

| 優先度 | 項目 | 内容 |
|--------|------|------|
| 高 | **一覧に 1to1回数列を追加** | MEMBERS_REQUIREMENTS §3.1 必須。summary_lite.one_to_one_count を表示 |
| 高 | **検索・フィルタ・ソート** | 検索（name/display_no/name_kana）、大カテゴリ・実カテゴリ・役職フィルタ、並び順。API に q / group / category / role / sort 等が必要な場合は API 拡張 |
| 中 | **統計カード 4 種** | 総メンバー数、1to1未実施(30日)、interested ON、want_1on1 ON。API またはクライアント集計 |
| 中 | **サブタイトル** | 「仕事 / 役職 / 関係性を把握し、1to1とメモで接点を増やす」 |
| 中 | **一覧で interested / want_1on1 表示** | 要件では任意。アイコンまたはバッジで表示 |
| 低 | **一覧形式をカードに** | モックはカードグリッド。要件は「一覧・検索・フィルタ・ソート・行アクション」であり形式は指定なし。表のままでも DoD は満たせる |
| 低 | **かな・関係ログ（最近）** | かなは任意。関係ログは Drawer で代替可能 |
| 低 | **Members からフラグ編集** | モックには「🚩 フラグ編集」あり。Connections では Switch で更新済み。Members からモーダルで編集するかは要件「任意」 |
| 低 | **Member Show ページの履歴** | /members/:id 直アクセス時。Drawer と共通 API で実装すれば Show でも表示可能 |

### 5.3 非目標（今回はやらない）

- メンバーの Create/Delete（運用で対応）
- 欠席・代理出席の管理
- 紹介（introductions）機能（Coming soon で留める）
- relationship_score の表示

---

## 6. 参照

- [MEMBERS_REQUIREMENTS.md](MEMBERS_REQUIREMENTS.md) — 要件 SSOT
- [MEMBERS_REQUIREMENTS_REVIEW.md](MEMBERS_REQUIREMENTS_REVIEW.md) — 要件整理・推奨設計
- [FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) §4 — 管理画面全体の Members 差分
- モック: http://localhost/mock/religo-admin-mock-v2.html → #/members
