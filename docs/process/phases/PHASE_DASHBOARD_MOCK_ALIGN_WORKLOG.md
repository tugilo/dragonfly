# PHASE Dashboard Mock Align — WORKLOG

**Phase:** Phase D（Dashboard モック一致）  
**作成日:** 2026-03-05  
**SSOT:** docs/SSOT/DASHBOARD_REQUIREMENTS.md、モック `www/public/mock/religo-admin-mock2.html` #pg-dashboard

---

## 運用ルール

- 各 Step で「SSOT のどの行（どの要件）を根拠にそうしたか」を必ず記録する。
- 迷いが出た点は「SSOT の該当箇所」と「採用した判断」を書く。
- Phase D-1 では Step0（現状確認）まで記入。D-2 で Step1〜 を追記する。

---

## Step0: 現状確認（Phase D-1 時点）

**日付:** 2026-03-05

**確認内容:**

- 既存 `www/resources/js/admin/pages/Dashboard.jsx` の構成を DASHBOARD_REQUIREMENTS.md と照合する。
- 差分メモ（実装 vs モック）を以下に記録する。

**既存実装の構成（要約）:**

- ページヘッダー: タイトル「Dashboard」、サブ「今日の活動・未アクション・KPI」、注記「表示は静的です（実データ連携は今後の Phase で対応）」、右に「Connectionsへ」「＋ 1to1追加」ボタン。
- 統計カード: 4 枚（未接触、今月の1to1、紹介メモ数、例会メモ数）。値は静的（4, 7, 12, 31）。Grid 使用。
- 今日やること: **2 件のみ**（伊藤 勇樹、田中 誠一）。モックは **4 件**（伊藤、水野 花菜、田中、例会#248 メモ未整理）→ **Gap**。
- クイックショートカット: 4 ボタンあり。文言は「Connections（会の地図）」「Members一覧」「＋ 1to1を追加」「例会一覧」。導線は /connections, /members, /one-to-ones/create, /meetings。
- 最近の活動: **3 件**。モックは **6 件**→ **Gap**。
- レイアウト: Grid container、左 md={8} / 右 md={4}。モックは 1fr / 340px、gap 14px。→ 数値で合わせる必要あり。

**根拠:** DASHBOARD_REQUIREMENTS.md §2 ページ構成、§3.3 Tasks「4 件」、§3.5 最近の活動「6 件」、§4 レイアウト「1fr 340px」「gap 14px」。

**Step0 結論:** Phase D-2 で (1) ヘッダー注記削除または統一、(2) stats をダミー値 3/5/8/4 に変更、(3) 2 カラムを 1fr/340px・gap 14px・1100px で 1 列に、(4) Tasks を 4 件に増やす、(5) Activity を 6 件に増やす、を実施する。

---

## Step1: ページヘッダー（Phase D-2 で追記）

**SSOT:** DASHBOARD_REQUIREMENTS.md §3.1（タイトル・サブ・右ボタン2つ、注記はモックに無いため削除可）。

**変更内容:** タイトルを h1・fontSize 21・fontWeight 700・letterSpacing -0.3 に。サブを fontSize 12・color text.secondary・mt 3px 相当に。右に「🗺 Connectionsへ」（contained→/connections）「＋ 1to1追加」（outlined→/one-to-ones/create）。注記「表示は静的です…」を削除（モックに無い）。margin-bottom 18px 相当（mb: 2.25）。

**目視確認:** OK。構成・文言・導線をモック通りに合わせた。

---

## Step2: 統計カード（Phase D-2 で追記）

**SSOT:** DASHBOARD_REQUIREMENTS.md §3.2、PLAN §7 ダミー値（3/5/8/4）。

**変更内容:** display:grid、gridTemplateColumns: repeat(4,1fr)、gap 12px、mb 16px。4枚のラベル・補足・アイコンはモック通り。値は 3, 5, 8, 4 に固定。未接触のみ値に warning.main 色。900px/600px で 2列・1列にレスポンシブ。

**目視確認:** OK。4枚横並び・値固定・アイコン色分けを実装。

---

## Step3: 2 カラム（Phase D-2 で追記）

**SSOT:** DASHBOARD_REQUIREMENTS.md §4（1fr 340px、gap 14px、1100px 以下で 1 列）。

**変更内容:** メインコンテンツを display:grid、gridTemplateColumns: '1fr 340px'、gap: 1.75（14px）。@media (max-width: 1100px) で gridTemplateColumns: '1fr'。

**目視確認:** OK。2カラム・1100px で 1 列化を実装。

---

## Step4: 今日やること（Phase D-2 で追記）

**SSOT:** DASHBOARD_REQUIREMENTS.md §3.3（4件、背景・左ボーダー・ボタン/チップ）。

**変更内容:** 見出し「⚡ 今日やること（Tasks）」、4件:(1) 伊藤 勇樹 — #fff3e0・warn 左ボーダー・「1to1予定」→/one-to-ones/create (2) 水野 花菜 — 同様・「メモ追加」は API 禁止のため disabled で見た目のみ (3) 田中 誠一 との1to1 — primary.light・primary 左ボーダー・チップ「予定」(4) 例会 #248 メモ未整理 — #f8f9fa・#ccc 左ボーダー・「Meetingsへ」→/meetings。行間 gap 8px、padding 9px 12px、border-radius 8px。

**目視確認:** OK。4件・スタイル・導線をモック通り。

---

## Step5: クイックショートカット（Phase D-2 で追記）

**SSOT:** DASHBOARD_REQUIREMENTS.md §3.4（4ボタン・文言・導線・スタイル）。

**変更内容:** 見出し「🔗 クイックショートカット」。4ボタン: Connections（会の地図）contained→/connections、Members一覧 outlined→/members、＋1to1を追加 outlined→/one-to-ones/create、例会一覧 outlined color inherit→/meetings。gap 10px、flex-wrap。

**目視確認:** OK。文言・導線をモック通り。

---

## Step6: 最近の活動（Phase D-2 で追記）

**SSOT:** DASHBOARD_REQUIREMENTS.md §3.5（6件・tl-item 体裁・最後は border なし）。

**変更内容:** 見出し「🕐 最近の活動」。6件をモックの並びで静的表示: 佐藤 メモ追加、田中 1to1登録、例会#247 BO割当、渡辺 1to1完了、森 interested フラグ、小林 メモ追加。各行: アイコン dot・タイトル 13px/600・メタ 11px サブ。borderBottom #f5f5f5、最後の子は border なし。padding 10px 0、gap 12px。

**目視確認:** OK。6件・区切り線・余白をモック通り。

---

## Step7: 全体確認（Phase D-2 で追記）

**確認内容:** モック #pg-dashboard と実装を比較。余白・gap・見出し・カード角丸/影・2カラム・stats・Tasks・timeline、および 1100px 以下で 1 列化。

**結果:** OK。構成・文言・2カラム 1fr/340px・gap 14px・Tasks 4件・Activity 6件・stats 値 3/5/8/4 を一致。レスポンシブは @media (max-width: 1100px) で 1 列を確認。差分なし。

---

## 迷い・判断メモ（随時追記）

- **「メモ追加」ボタン:** API 追加禁止のため、水野 花菜 行の「メモ追加」は `disabled` で見た目のみ実装。SSOT §3.3「メモ追加→メモモーダル」は将来 Phase で対応。
- **「1to1予定」導線:** PLAN の「/one-to-ones/create でOK」に従い、伊藤 行は /one-to-ones/create へリンク。
- **チップ「予定」:** モックは chip-planned（オレンジ系）。MUI Chip で bgcolor/#e65100 系で近似。

---

## テスト・ビルド結果（Phase D-2 完了時）

- **php artisan test:** 53 passed (226 assertions)
- **npm run build:** 成功（Vite build 完了）
