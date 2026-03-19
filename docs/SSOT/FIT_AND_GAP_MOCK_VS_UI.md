# フィット＆ギャップ：モック vs 実装UI

**SSOT（モック）:** `www/public/mock/religo-admin-mock-v2.html`（同一内容で religo-admin-mock2.html の可能性あり）  
**対象:** Phase16B/16C 時点の管理画面実装（React Admin + MUI）  
**比較:** モック http://localhost/mock/religo-admin-mock-v2.html#/members ／ 実装 http://localhost/admin#/members

---

## 1. シェル（サイドバー・AppBar）

**メニュー・ヘッダーに特化した詳細調査:** [FIT_AND_GAP_MENU_HEADER.md](FIT_AND_GAP_MENU_HEADER.md) を参照（モック v2 の構造・クラス・Fit/Gap 一覧）。

| 観点 | モック | 実装 | Fit / Gap |
|------|--------|------|-----------|
| サイドバー | 固定幅 240px、Religo ロゴ＋DragonFly Chapter、ナビ項目＋SETTINGS 配下 Categories/Roles、フッターにユーザー（メンバー管理者） | React Admin Layout + ReligoMenu。アイコン＋ラベル（Dashboard, Connections, Members, Meetings, 1 to 1, Role History, SETTINGS > Categories, Roles） | **Fit:** 項目順・SETTINGS 階層は同一。**Gap:** ロゴ/製品名・フッターのユーザー表示なし（React Admin デフォルトは AppBar のみ） |
| AppBar | パンくず、検索ボックス、通知アイコン、アバター | React Admin デフォルト（Skip to content, メニュー開閉, テーマ切替, 更新等）。パンくずは React Admin の Breadcrumb で別表現の可能性 | **Gap:** モックの「検索」「🔔」「ME」アバターは未実装または別コンポーネント |
| ルート | `#/dashboard`, `#/settings/categories` 等 | React Admin は `#/categories`, `#/roles`（Settings はメニューラベルのみでパスに含まない） | **Gap:** モックの `/settings/categories` は実装で `/categories`。導線は同じ |

---

## 2. Dashboard

| 観点 | モック | 実装 | Fit / Gap |
|------|--------|------|-----------|
| タイトル・説明 | 「Dashboard」「今日の活動・未アクション・KPI」 | 同一 | **Fit** |
| ヘッダーアクション | 「Connectionsへ」「＋ 1to1追加」 | 同一（Connectionsへ、＋ 1to1追加） | **Fit** |
| 統計カード 4 種 | 未接触(30日以上) / 今月の1to1回数 / 紹介メモ数 / 例会メモ数（数値・色・アイコン） | 同一構成・同一ラベル。アイコン色は MUI の error/primary/success/secondary | **Fit** |
| 今日やること（Tasks） | 4 件（伊藤 勇樹 1to1予定、水野 花菜 メモ追加、田中 誠一 1to1、例会メモ未整理） | 2 件のみ（伊藤 勇樹、田中 誠一）。静的な表示 | **Gap:** 件数・内容は静的。モックは「水野」「例会メモ未整理」あり |
| クイックショートカット | Connections、Members一覧、＋1to1を追加、例会一覧 | 同一 4 ボタン | **Fit** |
| 最近の活動 | タイムライン 6 件（佐藤 メモ追加、田中 1to1登録、例会#247 BO割当…） | 3 件のみ静的表示 | **Gap:** 件数・実データ連携は未。実装に「表示は静的です」注記あり |
| レイアウト | 左 1fr / 右 340px の two-col | Grid で md={8} / md={4} | **Fit** |

---

## 3. Connections

| 観点 | モック | 実装 | Fit / Gap |
|------|--------|------|-----------|
| タイトル・説明 | 「Connections」「Meeting → BO割当 → 関係ログの中心」 | 同一 | **Fit** |
| ヘッダーアクション | 「BO割当を保存」「Meetingsへ」 | 「💾 BO割当を保存」「📋 Meetingsへ」 | **Fit** |
| 3 ペイン構成 | 左 Members リスト / 中央 Meeting+BO / 右 Relationship Log | 左 メンバー選択（Owner ID + Autocomplete）/ 中央 Meeting 選択 + Round タブ + BO1/BO2 / 右 関係ログ | **Fit:** 3 カラムの役割は同じ |
| 左ペイン | メンバー検索＋クリックで選択、アバター＋名前＋group/cat | メンバー検索＋**縦リスト**（アバター＋名前＋カテゴリ）。クリックで右ペインに表示。例会選択時はタップで「BO1 に追加」等のメニュー表示 | **Fit:** リスト＋検索に変更済み。BO 割当時はメニューで BO を選択 |
| 中央ペイン | Meeting セレクト＋BO カード（BO1, BO2…）＋「BO割当を保存」 | Meeting セレクト＋**BO1/BO2 表示**（同室枠）＋割当メンバー**縦リスト**（行クリックでメンバー詳細モーダル、メモ・削除）＋各「BO○ を保存」＋割当をクリア＋同室枠追加 | **Fit:** BO 表示は BO1/BO2 に統一。割当メンバーは縦リストで視認性向上。各 BO に保存ボタン |
| 右ペイン | 選択メンバー名＋関係ログ＋1to1履歴＋メモ/1to1/詳細ボタン | 選択メンバー名＋同室/1to1回数＋クイックアクション（メモを書く、**1to1を登録**）＋気になる/1on1したい Switch＋直近メモ。1to1登録は**日付＋開始・終了時刻**の簡易入力 | **Fit:** 役割は同じ。**Fit:** 1to1 登録 UI を日付・開始・終了の 3 フィールドに簡素化 |
| 右ペイン（C-6） | — | **🧠 Relationship Summary**（同室回数・直近同室・1to1・直近メモ）＋**💡 次の一手**（ルールベース提案、最大3件）。モック追加ではなく UX 知性追加 | **Fit** |
| 右ペイン（C-7） | — | **Relationship Score**（関係温度 ★☆☆☆☆〜★★★★★）。ContactSummary から UI 計算のみ | **Fit** |
| 右ペイン（C-8） | — | **💡 Introduction Hint**（紹介候補、業種（名前）→ 業種（名前）最大3件）。members の summary_lite と C-7 スコアを利用 | **Fit** |
| モーダル | メモ追加・1to1作成・フラグ編集はモックにあり | メモ追加・1to1登録（日付＋開始/終了時刻）・**メンバー詳細**（BO 割当メンバー行タップで開く）。フラグは Switch でインライン。紹介は「Coming soon」 | **Fit**（メンバー詳細モーダル追加済み） |

---

## 4. Members

### 4.1 モックの Members ページ要素（religo-admin-mock-v2.html#/members）

モックは **カード形式（.cgrid + .mcard）** で、1 人分の情報を 1 枚のカードにまとめて表示する。

| ブロック | モック要素（HTML/CSS クラス） | 内容 |
|----------|------------------------------|------|
| **ページヘッダ** | `.pg-hdr` | h1「Members」、p「仕事 / 役職 / 関係性を把握し、1to1とメモで接点を増やす」 |
| **ヘッダー右** | `.pg-hdr-r` | 「🗺 Connectionsへ」「＋ メンバー追加（将来）」disabled |
| **統計** | `.stats`（4 × `.stat`） | 総メンバー数 / 1to1未実施(30日) / interested ON / want_1on1 ON |
| **フィルタバー** | `.fbar` | 検索（名前・カテゴリ・ロール）、大カテゴリ select、カテゴリ select、ロール select、⭐ interested / 🔁 want_1on1 トグル、並び順 select、件数 |
| **一覧コンテナ** | `.cgrid` | grid 3 列（1300px 以下で 2 列） |
| **1 枚のカード** | `.mcard` | 下記の通り 1 人分を 1 カードに集約 |

**1 枚の .mcard 内の要素:**

| カード内ブロック | クラス | 表示内容 |
|------------------|--------|----------|
| ヘッダー | `.mc-hdr` | `.mc-no`（#01）、役職 chip、`.mc-name`、`.mc-kana` |
| 本文 | `.mc-body` | `.mc-cat`（大カテゴリ/実カテゴリ）、`.mc-rel`（同室回数・最終接触）、`.mc-memo`（直近メモ抜粋）、`.mc-flags`（⭐ interested / 🔁 want_1on1） |
| アクション | `.mc-act` | ✏️ メモ、📅 1to1、📝 1to1メモ、詳細 → |
| 関係ログ | `.mc-logs` | 「関係ログ（最近）」＋複数 `.log-i`（種別ラベル・日付・テキスト） |

モックでは **一覧はカードのみ**。リスト（表）形式の切替はない。

---

### 4.2 実装との要素別比較（フィット＆ギャップ）

| # | 観点 | モック | 実装 | Fit / Gap |
|---|------|--------|------|-----------|
| M1 | タイトル・説明 | 「Members」＋サブ説明 | タイトル「Members」＋サブ説明（同一文） | **Fit** |
| M2 | ヘッダーアクション | Connectionsへ、＋メンバー追加（将来）disabled | 同一 | **Fit** |
| M3 | ブロック順 | ヘッダー → 統計 → フィルタバー → 一覧 | 同一 | **Fit** |
| M4 | 統計カード 4 種 | 総数 / 1to1未実施(30日) / interested / want_1on1 | 4 種を常時表示（クライアント集計） | **Fit** |
| M5 | フィルタバー常時表示 | 検索・大カテゴリ・カテゴリ・ロール・トグル・並び順・件数 | 検索・カテゴリ・役職・Interested/Want 1on1・並び順・件数。大カテゴリ単独は未 | **Gap:** 大カテゴリ単独フィルタなし |
| M6 | **一覧の形式** | **カードグリッド**（.cgrid + .mcard） | **Datagrid（表）** | **Gap:** カード形式なし |
| M7 | 一覧：番号 | .mc-no（#01） | display_no 列 | **Fit** |
| M8 | 一覧：名前 | .mc-name | name 列 | **Fit** |
| M9 | 一覧：かな | .mc-kana | 列なし | **Gap** |
| M10 | 一覧：カテゴリ | .mc-cat（大/実） | カテゴリ列（group_name / name） | **Fit** |
| M11 | 一覧：役職 | 役職 chip | current_role 列 | **Fit** |
| M12 | 一覧：同室回数 | .mc-rel 内 | SameRoomCountField | **Fit** |
| M13 | 一覧：1to1回数 | —（モックのカード本文には同室・最終接触のみ。1to1回数は Drawer Overview） | OneToOneCountField 列あり | **Fit**（実装が先行） |
| M14 | 一覧：最終接触 | .mc-rel 内（日付 or ⚠ N日未接触） | LastContactField | **Fit** |
| M15 | 一覧：直近メモ | .mc-memo（抜粋・2行 clamp） | LastMemoField（20字で切って表示） | **Fit**（表示長の差は軽微） |
| M16 | 一覧：interested / want_1on1 | .mc-flags（フラグ表示） | FlagsField（Chip） | **Fit** |
| M17 | 一覧：関係ログ（最近） | .mc-logs（カード内に数件） | なし（詳細 Drawer で代替） | **Gap** |
| M18 | 行/カードアクション | メモ・1to1・1to1メモ・詳細 | メモ・1to1・1to1メモ・🚩フラグ・詳細（5 種） | **Fit**（実装はフラグ追加） |
| M19 | 詳細 UI | 右側 Drawer（Overview / Memos / 1to1） | Drawer 同一構成 | **Fit** |
| M20 | フラグ編集 | モーダル（interested / want_1on1） | 行アクション「🚩 フラグ」で Dialog | **Fit** |

---

### 4.3 まとめ（Members）

- **Fit:** ヘッダー・統計・フィルタバー・一覧の列の多く（番号・名前・カテゴリ・役職・同室・1to1回数・最終接触・メモ・フラグ・行アクション）・Drawer・各モーダル・フラグ編集。
- **Gap:**
  1. **一覧が表のみでカード形式がない** — モックは「その人の全ての情報が 1 枚のカードで見える」構成。
  2. **一覧にかな（name_kana）がない**。
  3. **一覧に関係ログ（最近）がない**（詳細 Drawer では確認可能）。
  4. **大カテゴリ単独フィルタ**が未実装。

**推奨（要望）:** リスト形式（表）とカード形式を **スイッチで切替**できるようにすると、モックに近い「1 人分の情報をまとめて見る」体験と、表での比較・ソートの両方を満たせる。

---

### 4.4 旧 §4 表（参照用）

| 観点 | モック | 実装 | Fit / Gap |
|------|--------|------|-----------|
| タイトル・説明 | 「Members」「仕事 / 役職 / 関係性を把握し…」 | タイトル「Members」＋サブ説明（M-2） | **Fit** |
| ヘッダーアクション | 「Connectionsへ」「＋ メンバー追加（将来）」disabled | 同一 | **Fit** |
| **ブロック順** | ヘッダー → 統計カード → フィルタバー → 一覧 | 同一（M-4b でヘッダー→統計→フィルタバー→一覧に統一） | **Fit** |
| 統計カード | 総メンバー数 / 1to1未実施(30日) / interested ON / want_1on1 ON | **4 種を常時表示**（M-4b。クライアント集計・表示件数ベースの制約あり） | **Fit** |
| フィルタバー | 検索、大カテゴリ、カテゴリ、ロール、interested/want_1on1 トグル、並び順、件数 | **常時表示**（検索・カテゴリ・役職・Interested/Want 1on1・並び順・件数）。大カテゴリは未 | **Fit:** 常時表示は実装。**Gap:** 大カテゴリ単独フィルタは未 |
| 一覧形式 | **カードグリッド**（mcard） | **Datagrid（表）**（M-4 ではブロック順優先のため表のまま維持。カード化は後続 Phase） | **Gap:** カードグリッド未対応 |
| 一覧列 | 番号・名前・カナ・大/実カテゴリ・役職・同室・1to1回数・最終接触・メモ抜粋・フラグ・関係ログ（最近） | 番号・名前・カテゴリ・役職・同室回数・1to1回数・最終接触・直近メモ・フラグ・Actions（M-2/M-3 で列追加済み） | **Fit:** 1to1回数・フラグは表示。**Gap:** かな・関係ログ（最近）は未 |
| 行アクション | メモ、1to1、1to1メモ、詳細 | **5 種**（メモ、1to1、1to1メモ、**🚩 フラグ**、詳細）（M-5b） | **Fit** |
| メモ/1to1/1to1メモモーダル | タイトルに「— メンバー名」、種別・本文・重要フラグ等 | 実装も同様の Dialog | **Fit** |
| 詳細（一覧から） | **右側 Drawer**（Overview / Memos / 1to1 タブ） | **Drawer** で実装済み | **Fit** |
| Member Show（/members/:id） | — | **Overview / Memos / 1to1 タブで履歴表示**（M-6b）。contacts summary・contact-memos・one-to-ones を既存 API で取得。「Coming soon」除去。一覧への導線あり | **Fit** |
| フラグ編集モーダル | モックに「🚩 フラグ編集」モーダル（interested / want_1on1） | **行アクション「🚩 フラグ」で Dialog**（M-5b）。Interested / Want 1on1 の Switch、保存で既存 PUT /api/dragonfly/flags を流用。Connections と同じ API | **Fit** |

---

## 5. Meetings

**詳細調査（モック v2 #/meetings 基準）:** [FIT_AND_GAP_MEETINGS.md](FIT_AND_GAP_MEETINGS.md) を参照。M1〜M6 で一覧・統計・ツールバー・Drawer・例会メモモーダルを実装済み。

| 観点 | モック | 実装 | Fit / Gap |
|------|--------|------|-----------|
| タイトル・説明 | 「Meetings」「例会管理 / BO割当 / メモ」 | 同一（M1） | **Fit** |
| ヘッダーアクション | 「Connectionsで編集」 | 同一 | **Fit** |
| 統計カード | 総例会数 / 総BO数（今年）/ メモ有り例会 / 次回例会 | 4 種表示（M6）。副表示（今年度・平均・割合）は未実装 | **Fit** |
| レイアウト | two-col：左が例会一覧、右が例会詳細パネル | 一覧＋行クリックで Drawer。右パネル常時表示ではない | **Partial Fit**（詳細は Drawer で表示。機能は充足） |
| 一覧テーブル | 番号・日付・BO数・メモ・Actions（📝メモ、🗺BO編集） | 番号・開催日・BO数・メモ・Actions（M1/M2） | **Fit** |
| 例会詳細 | 右パネル：番号・日付・BO数・メモ有無・メモ本文・BO割当・メモ編集/Connectionsへ | Drawer で同内容（M3） | **Fit（Drawer 採用）** |
| 例会メモモーダル | 「📝 例会メモ編集 — #247」＋Connections リンク | 同一（M4） | **Fit** |

---

## 6. 1 to 1

**モック:** `www/public/mock/religo-admin-mock-v2.html` の `#pg-one-to-ones`（ルート `#/one-to-ones`）  
**実装:** `www/resources/js/admin/pages/OneToOnesList.jsx`・`/admin#/one-to-ones`・API `GET/POST /api/one-to-ones`・**`GET/PATCH /api/one-to-ones/{id}`**（ONETOONES-P1）

### 6.1 モックのページ要素（v2 #/one-to-ones）

| ブロック | モック（HTML / JS） | 内容 |
|----------|---------------------|------|
| **ページヘッダ** | `.pg-hdr` | h1「1 to 1」、p「予定・実施・キャンセル履歴の管理」 |
| **ヘッダー右** | `.pg-hdr-r` | 「＋ 1to1を追加」（`mol-1on1create`）、「🗺 Connectionsへ」 |
| **統計** | `.stats`（4 × `.stat`） | 予定中 / 完了（今月）/ キャンセル / want_1on1 ON（各サブラベル付き） |
| **フィルタバー** | `.fbar` | 検索（placeholder「相手の名前 / メモ」）、相手 select、ステータス select、日付 from〜to、`N件` |
| **テーブル** | `#oto-tbody`（`renderOto()`） | 列: 日付・相手（太字）・ステータス（chip・日本語ラベル）・Meeting（chip または —）・メモ（ellipsis）・Actions（📝 メモ → `openOtoMemoModal`、✏️ 編集 → `mol-1on1create`） |
| **1to1追加** | モーダル `mol-1on1create` | 日付・時刻・相手 select・ステータス・関連例会（任意）・メモ/アジェンダ |

### 6.2 実装との要素別比較

| # | 観点 | モック | 実装 | Fit / Gap |
|---|------|--------|------|-----------|
| O1 | タイトル・説明 | 「1 to 1」＋サブ説明 | List `title`＋本文領域にサブ「予定・実施・キャンセル履歴の管理」（AppBar パンくずは従来どおり） | **Partial Fit（ONETOONES-P2）:** モックと同一 DOM 構造ではないが趣旨どおり |
| O2 | ヘッダーアクション | ＋ 1to1を追加、Connectionsへ | **＋ 1to1を追加** は **クイック作成 Dialog**（主）、**フォームで追加** で `/one-to-ones/create`。Connections は outlined | **Partial Fit（ONETOONES-P3）:** モックは単一モーダル。実装は Dialog＋フルページの二段 |
| O3 | 統計カード 4 種 | 予定中 / 完了(今月) / キャンセル / want_1on1 | `GET /api/one-to-ones/stats` ＋ 4 カード。**一覧と同一 filter**（owner・target・status・from/to・q・workspace）で Index と共通 WHERE（ONETOONES-P4）。want_1on1 は **filter 後の一覧に現れる target** のフラグ件数 | **Partial Fit:** モックの「先月比」等は未 |
| O4 | フリーテキスト検索 | 「相手の名前 / メモ」 | Filter の `q` → API（`notes`・相手 `name` の LIKE）。placeholder はモックと同趣旨のラベル | **Fit（ONETOONES-P1）** |
| O5 | 相手フィルタ | 相手プルダウン | Owner 連動の `SelectInput`（`target_member_id`）＋ dataProvider 接続 | **Fit（ONETOONES-P1）** |
| O6 | ステータス・日付 | select ＋ from/to date | 同上。**Owner** は **一覧マウント前に `GET /api/users/me` で既定**（未設定時フォールバック 1）。`owner_member_id` **alwaysOn** | **Partial Fit（ONETOONES-P3）:** 既定 UX は改善。**Gap:** Owner をモックのように完全非表示には未対応 |
| O7 | 件数表示 | `.fcount`「12件」 | 一覧上部に「N 件」＋下部は RA 標準 Pagination | **Partial Fit（ONETOONES-P1）:** モックと同一レイアウトではないが件数は明示 |
| O8 | 日付列 | 日付文字列（デモデータ） | `COALESCE(started_at, scheduled_at)` を `EffectiveDateField` で日時ロケール表示 | **Fit**（実データは日時） |
| O9 | 相手列 | 太字名 | `target_name` | **Fit** |
| O10 | ステータス列 | chip ＋ 日本語（予定/完了/キャンセル系） | MUI **Chip**＋日本語（未知キーはフォールバック） | **Fit（ONETOONES-P2）** |
| O11 | Meeting 列 | `#247 — 日付` 形式の chip | **`meeting_label`（Chip）**＋ API で `meeting_number` / `meeting_held_on` 付与 | **Fit（ONETOONES-P2）** |
| O12 | メモ列 | ellipsis | `notes` + `ellipsis` | **Fit** |
| O13 | 行アクション | 📝 メモ、✏️ 編集（各行） | **操作**列: メモは Dialog（**notes＝要約** の説明＋「編集でメモを更新」）、編集は `#/one-to-ones/:id` | **Partial Fit（ONETOONES-P1/P3）:** contact_memos 連携は別 |
| O14 | 新規登録 UI | **モーダル** | **クイック作成 Dialog**（一覧）＋ **`/one-to-ones/create` フルページ** | **Partial Fit（ONETOONES-P3）:** 主導線を Dialog に寄せた |
| O15 | 新規フォーム項目 | 日付・時刻・相手・ステータス・関連例会・メモ | クイック: 相手・状態・**datetime-local**・`meeting_id`・**notes**。フル: Owner（**me 既定・変更可**）・他 | **Partial Fit:** Owner は一覧と Create で自動初期化。**Gap:** モックの日付+時刻分割 |

### 6.3 まとめ（1 to 1）

- **Fit:** 画面の位置づけ（1 to 1 一覧）、ヘッダーの「＋ 1to1を追加」「Connectionsへ」、テーブルの主列（日時・相手・メモ・**ステータス chip・例会ラベル**）、新規時のコア項目（相手・状態・日時・例会 ID・メモ）。バックエンドは index 用フィルタ・**stats**・**meeting_label**・単体 GET/PATCH まで揃っている（P1/P2）。
- **Gap（優先度の目安）:**
  1. （**ONETOONES-P4 で概ね解消**: stats は一覧 filter と連動。微差分が残れば FIT を更新。）
  2. **モック級の補助文案**（例: 先月比、カード副文案の細部）。
  3. **新規 UI:** モックの単一モーダルとは異なり **Dialog＋フルページ** の二段（ONETOONES-P3）。
  4. **行メモ:** 一覧は `notes` 閲覧＋編集誘導。`contact_memos` 本格・Members 連携は未。

### 6.4 実装メモ（ONETOONES-P1）

- **Phase:** `docs/process/phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_*`（Registry: **ONETOONES-P1**）。
- **API:** `GET /api/one-to-ones?q=…`（`IndexOneToOnesRequest`）、`GET/PATCH /api/one-to-ones/{id}`。
- **UI:** フィルタ（`q`・相手・状態・日付・Owner ID）、件数、操作列（メモ Dialog・編集）。

### 6.5 実装メモ（ONETOONES-P2）

- **Phase:** `docs/process/phases/PHASE_ONETOONES_STATS_DISPLAY_*`（Registry: **ONETOONES-P2**）。
- **API:** `GET /api/one-to-ones/stats`（`owner_member_id` 必須）。一覧 JSON に `meeting_label` 等を追加。
- **UI:** サブタイトル、統計 4 カード、ステータス Chip、例会 Chip。

### 6.6 実装メモ（ONETOONES-P3）

- **Phase:** `docs/process/phases/PHASE_ONETOONES_CREATE_EDIT_UX_*`（Registry: **ONETOONES-P3**）。
- **Owner:** `GET /api/users/me` → 一覧 `filterDefaultValues`・クイック作成・フル Create の初期値（`religoOwnerMemberId.js`）。
- **UI:** `OneToOnesQuickCreateDialog`、`OneToOnesCreate` / `OneToOnesEdit`（分離ファイル）。`DATA_MODEL` §4.12 に **notes** と contact_memos の住み分け追記。

### 6.7 実装メモ（ONETOONES-P4）

- **Phase:** `docs/process/phases/PHASE_ONETOONES_P4_STATS_FILTER_MEMO_*`（Registry: **ONETOONES-P4**）。
- **Stats:** `OneToOneIndexService::applyIndexFilters` を stats と共有。`OneToOnesList` は `filterValues` から stats query を構築。
- **履歴メモ:** `GET/POST /api/one-to-ones/{id}/memos`、`OneToOnesEdit` 内 `OneToOneMemosPanel`。
- **users/me:** 応答に `id`、`member_id`（= `owner_member_id`）。

---

## 7. Role History

| 観点 | モック | 実装 | Fit / Gap |
|------|--------|------|-----------|
| タイトル・説明 | 「Role History」「役職履歴 / 任期管理 / 歴代役職一覧」 | タイトル「Role History」のみ | **Gap:** サブ説明なし |
| ヘッダーアクション | 「＋ 役職追加」「Connectionsへ」 | 「＋ 役職追加」→/roles/create、「Connectionsへ」 | **Fit**（役職追加はマスタ追加であり、モックの「役職履歴を追加」とは別。モックでは mol-role-add が履歴追加） |
| 統計カード | 現役職保有者 / 総履歴件数 / 歴代プレジ数 / 次期改選 | 実装には統計カードなし | **Gap:** 4 種の stats 未実装 |
| フィルタバー | 検索・メンバー・役職・年・件数＋info-box「役職フィルタ+年で…」 | Filter: role_id, member_id, from, to（SelectInput/TextInput） | **Fit:** 役職・メンバー・期間あり。**Gap:** モックの「年」単一入力は from/to で代替。info-box の説明文は未 |
| テーブル列 | メンバー・役職・任期開始・任期終了・状態・Actions（✏️編集） | メンバー・役職（Chip）・任期開始・任期終了・状態（現任/終了）。Actions 列は実装で削除済み | **Fit:** 列は同一。**Gap:** モックの「✏️ 編集」は役職履歴編集（mol-role-add）。実装は編集なしで「＋ 役職追加」のみ |
| 役職履歴追加モーダル | メンバー・役職・任期開始・終了 | 実装には「役職履歴を追加」専用モーダル/ページなし（Roles の Create はマスタ追加） | **Gap:** 履歴 1 件追加の UI が未実装 |

---

## 8. Settings — Categories

| 観点 | モック | 実装 | Fit / Gap |
|------|--------|------|-----------|
| タイトル・説明 | 「Settings — Categories」「大カテゴリ（group）と実カテゴリの管理」 | 「Settings — Categories」同一。サブ説明なし | **Gap:** サブ説明なし |
| ヘッダーアクション | 「＋ カテゴリ追加」→ モーダル | 「Create」→ /categories/create ページ | **Gap:** モックはモーダル、実装は別ページ Create。導線は異なる |
| 注意書き | warn-box「カテゴリの削除は…」 | 同一文面の Box | **Fit** |
| テーブル列 | 大カテゴリ(group)・実カテゴリ(name)・メンバー数・Actions（✏️編集、🗑削除） | 大カテゴリ(group)・実カテゴリ(name)・EditButton・DeleteButton。メンバー数列なし | **Gap:** メンバー数列なし。Edit/Delete は実装あり |
| カテゴリ追加/編集モーダル | 大カテゴリ・実カテゴリの入力 | Create/Edit ページで同一項目 | **Fit**（UI はページ vs モーダルの差のみ） |

---

## 9. Settings — Roles

| 観点 | モック | 実装 | Fit / Gap |
|------|--------|------|-----------|
| タイトル・説明 | 「Settings — Roles」「役職マスタの管理」 | 「Settings — Roles」同一。サブ説明なし | **Gap:** サブ説明なし |
| ヘッダーアクション | 「＋ 役職追加」→ モーダル | CreateButton → /roles/create | **Gap:** モーダル vs 別ページ（Categories と同様） |
| テーブル列 | 役職名・説明・現在の担当者数・Actions（✏️編集） | 役職名・説明・EditButton・DeleteButton。担当者数なし | **Gap:** 現在の担当者数列なし |
| 役職編集モーダル | 役職名・説明 | Create/Edit ページで同一 | **Fit** |

---

## 10. モーダル・Drawer 一覧

| モック | 実装 | Fit / Gap |
|--------|------|-----------|
| ✏️ メモ追加 | MembersList の MemoModal。Connections でもメモ Dialog | **Fit** |
| 📅 1to1予定作成 | MembersList の O2oModal。Connections でも 1to1 登録 Dialog | **Fit** |
| 📝 1to1メモ | MembersList の O2oMemoModal（過去 1to1 紐付け選択あり） | **Fit** |
| 🚩 フラグ編集 | Connections 右ペインで Switch。Members からはなし | **Gap:** Members のフラグ編集モーダルなし |
| 📝 例会メモ編集 | Connections の BO から例会メモコンテキストあり。Meetings は **Drawer Memos タブ**で対象選択＋本文で追加（Phase17B） | **Fit:** Meetings 起点で例会メモ追加可能 |
| 📂 カテゴリ編集/追加 | CategoriesCreate / CategoriesEdit ページ | **Fit**（モーダルではない） |
| 🏅 役職編集/追加 | RolesCreate / RolesEdit ページ | **Fit** |
| 🏅 役職履歴を追加 | 未実装 | **Gap** |
| Member Detail Drawer（Overview / Memos / 1to1） | MembersList 内の MemberDetailDrawer で実装済み。一覧の「詳細」で開く | **Fit:** Drawer＋タブでモックと同等。MemberShow ページ（/members/:id）は履歴が Coming soon |

---

## 11. まとめ

- **Fit（揃っているところ）**
  - シェルのメニュー項目・階層（SETTINGS > Categories, Roles）。
  - Dashboard の見出し・統計カード・クイックショートカット・Tasks/最近の活動の**構成**。
  - Connections の 3 ペイン・BO 割当・関係ログ・メモ/1to1 の導線。
  - Members の一覧アクション（メモ・1to1・1to1メモ・詳細）と 3 モーダル。
  - Settings Categories/Roles の注意書き・CRUD と Create/Edit フォーム項目。
  - Role History のフィルタ・列・役職 Chip・現任/終了表示。
  - 1 to 1 の List＋Create＋Edit、フィルタ・件数・行操作（§6.4）に加え **統計（一覧 filter 連動）・サブタイトル・ステータス/例会**（§6.5–§6.7）、**Owner 既定・クイック作成**（§6.6）、**履歴メモ API＋Edit パネル**（§6.7）。**未:** モック級単一モーダル、Members 起点の 1to1メモ完全連携など。

- **主なギャップ**
  - **一覧の表現:** Members がモックはカードグリッド、実装は Datagrid（表）。§4.1〜4.3 にモックのカード要素（.mcard 内の mc-hdr / mc-body / mc-act / mc-logs）と実装の要素別比較を記載。**推奨:** リスト形式とカード形式をスイッチで切替可能にすると、モックに近い「1 人分の情報が 1 枚で見える」体験と表の利便性の両立が可能。
  - **統計カード不足:** Members / 1 to 1 / Role History ではモックの 4 種 stats が未実装。Meetings は M6 で実装済み。
  - **サブタイトル不足:** 多くのページで「pg-hdr-l p」相当の説明文がない。
  - **Meetings:** M1〜M6 で一覧・統計カード・ツールバー（検索・メモフィルタ・件数）・Drawer（例会詳細）・例会メモモーダルを実装済み。レイアウトは two-col ではなく Drawer 採用。詳細は [FIT_AND_GAP_MEETINGS.md](FIT_AND_GAP_MEETINGS.md) 参照。
  - **Member 詳細:** 一覧の「詳細」は **Drawer（Overview / Memos / 1to1）で実装済み**。URL 直アクセス /members/:id の Show ページはメモ・1to1履歴が Coming soon。
  - **Members の細かい Gap:** 一覧にかな（name_kana）・関係ログ（最近）なし、大カテゴリ単独フィルタなし（§4.2 参照）。
  - **Settings:** カテゴリ/役職の追加がモックはモーダル、実装は別ページ。テーブルの「メンバー数」「担当者数」列なし。
  - **Role History:** 「役職履歴を 1 件追加」するモーダル/ページが未実装。
  - **シェル:** ロゴ/製品名・AppBar 検索・通知・ユーザー表示が未実装またはデフォルトのまま。

以上を踏まえ、今後の Phase で「モック完全一致」を目指す場合は、上記ギャップを優先度付けして対応するとよい。
