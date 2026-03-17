# フィット＆ギャップ：Meetings 画面（モック vs 実装）

**調査日:** 2026-03-17  
**モック（SSOT）:** http://localhost/mock/religo-admin-mock-v2.html#/meetings  
**実装:** http://localhost/admin#/meetings  

本ドキュメントは Meetings ページに特化した調査結果である。全体のフィット＆ギャップは [FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) を参照。

---

## 1. モックの構造（religo-admin-mock-v2.html#/meetings）

### 1.1 ページ構成

| ブロック | 要素（HTML/ID・クラス） | 内容 |
|----------|--------------------------|------|
| **ページヘッダ** | `.pg-hdr` | `.pg-hdr-l`: h1「Meetings」、p「例会管理 / BO割当 / メモ」。`.pg-hdr-r`: ボタン「🗺 Connectionsで編集」→ `#/connections` |
| **統計** | `.stats`（4 × `.stat`） | 総例会数（247 / 今年度20回）、総BO数（今年）（76 / 平均3.8/例会）、メモ有り例会（18 / 91%）、次回例会（7/22 / #248予定） |
| **レイアウト** | `.two-col` | 左: 例会一覧テーブル。右: 例会詳細パネル（カード） |
| **テーブルツールバー** | `.tbl-toolbar` | 見出し「例会一覧」、検索（placeholder「番号 / 日付」）、select（すべて / メモあり / メモなし）、件数表示（例: 6件） |
| **一覧テーブル** | `#meetings-table` | thead: 番号・日付・BO数・メモ・Actions。tbody は JS で MEETINGS から描画 |
| **行アクション** | 各 tr 内 | 「📝 メモ」（例会メモ編集モーダル）、「🗺 BO編集」（#/connections へ） |
| **右パネル** | `#meeting-detail-panel` | `.card-title`: 「📋 例会詳細」。`#meeting-detail-body`: 未選択時「例会を選択してください」。選択時は下記の詳細表示 |
| **例会詳細（選択時）** | `#meeting-detail-body` 内 | 番号・日付、BO数/メモ有無のサマリカード、メモ本文（ありの場合）、BO割当一覧（BO1, BO2…＋メンバー名）、ボタン「📝 メモ編集」「🗺 Connectionsへ」 |
| **モーダル** | `#mol-meeting-memo` | タイトル「📝 例会メモ編集 — #247」、textarea「例会メモ」、info-box「BO割当の詳細は Connectionsで編集」、キャンセル／保存する |

### 1.2 モックのデータ構造（MEETINGS）

```javascript
{ id, num, date, bo, notes }
// 例: { id:247, num:"#247", date:"2025-07-08", bo:4, notes:"今回は新メンバー…" }
```

- **番号:** `num`（表示用 "#247"）
- **日付:** `date`
- **BO数:** `bo`
- **メモ:** `notes` の有無で「あり」「なし」チップ、本文は詳細パネルに表示

---

## 2. 実装の構造（現状）

### 2.1 フロントエンド

- **コンポーネント:** `www/resources/js/admin/pages/MeetingsList.jsx`
- **構成:** React Admin の `<List>` ＋ `<Datagrid>`
  - **タイトル:** 「Meetings」＋ サブ説明「例会管理 / BO割当 / メモ」（M1）
  - **ヘッダーアクション:** 「🗺 Connectionsで編集」→ `/connections`（Fit）
  - **統計カード:** 総例会数・総BO数・メモ有り例会・次回例会（M6。GET /api/meetings/stats）
  - **ツールバー:** 検索（番号/日付）・メモフィルタ・件数（M5）
  - **一覧:** 番号・開催日・BO数・メモ・参加者PDF・Actions。行クリックで Drawer（M3）。行アクション「📝 メモ」「🗺 BO編集」（M2）。参加者PDF列は M7-P1-LIST で追加（後述）
  - **Drawer:** 例会詳細・メモ本文・BO割当・メモ編集/Connections へ（M3）
  - **モーダル:** 例会メモ編集（M4）

### 2.2 API

- **一覧:** `GET /api/meetings`（Religo MeetingController）
  - **返却項目:** `id`, `number`, `held_on`, `breakout_count`, `has_memo`（M1）、`has_participant_pdf`（M7-P1-LIST。参加者PDF登録有無、boolean のみ。一覧用途のためファイル名は返さない）
  - **クエリ:** `q`（番号・日付の検索、M5）、`has_memo`（1=メモありのみ / 0=メモなしのみ、M5）
- **詳細:** `GET /api/meetings/{meetingId}` — meeting（id, number, held_on, breakout_count, has_memo）、memo_body、participant_import（has_pdf, original_filename。M7-P1）、rooms（BO割当＋member_names）（M3）
- **例会メモ:** `GET /api/meetings/{meetingId}/memo`（body 取得）、`PUT /api/meetings/{meetingId}/memo`（保存・空で削除）（M4）
- **統計:** `GET /api/meetings/stats` — total_meetings, total_breakouts, meetings_with_memo, next_meeting（M6）
- **参加者PDF（M7-P1）:** `GET /api/meetings/{meetingId}/participants/import`（メタ）、`POST /api/meetings/{meetingId}/participants/import`（アップロード）、`GET .../participants/import/download`（ダウンロード）。詳細 API の participant_import は Drawer 用。

### 2.3 参加者PDF列・データ仕様（M7-P1-LIST）

- **一覧表示:** 列「参加者PDF」をメモの次・Actions の前に配置。`has_participant_pdf`（boolean）に基づき Chip で「あり」（success）/「なし」（default）を表示。既存のメモ列と同じスタイル（height 18px, fontSize 0.7rem）。
- **一覧 API:** `GET /api/meetings` の各要素に `has_participant_pdf: boolean` を含む。`meeting_participant_imports` の存在有無で判定。一覧用途のため original_filename は返さない。
- **詳細（Drawer）:** `GET /api/meetings/{meetingId}` の `participant_import: { has_pdf, original_filename }` で PDF 有無・ファイル名を表示。登録ボタン／ダウンロードリンクは Drawer 内に配置（M7-P1）。

---

## 3. フィット＆ギャップ一覧

| # | 観点 | モック | 実装 | Fit / Gap |
|---|------|--------|------|-----------|
| M01 | タイトル | 「Meetings」 | 「Meetings」 | **Fit** |
| M02 | サブ説明 | 「例会管理 / BO割当 / メモ」 | 同一（M1） | **Fit** |
| M03 | ヘッダーアクション | 「🗺 Connectionsで編集」 | 同一 | **Fit** |
| M04 | 統計カード | 4 種（総例会数・総BO数・メモ有り例会・次回例会） | 4 カード表示（M6）。副表示（今年度・平均・割合）は未実装 | **Fit** |
| M05 | レイアウト | two-col（左: 一覧、右: 詳細パネル固定） | 一覧＋行クリックで Drawer。右パネル常時表示ではない | **Partial Fit**（詳細は Drawer で表示。two-col 固定ではないが、行選択で例会詳細を確認する機能は充足） |
| M06 | ツールバー | 例会一覧・検索（番号/日付）・メモあり/なし・件数 | 同一（M5） | **Fit** |
| M07 | 一覧：番号 | 列「番号」(#247 形式) | 列「番号」(number) | **Fit** |
| M08 | 一覧：日付 | 列「日付」 | 列「開催日」(held_on) | **Fit** |
| M09 | 一覧：BO数 | 列「BO数」(チップ表示) | 列「BO数」Chip（M1） | **Fit** |
| M10 | 一覧：メモ | 列「メモ」（あり/なしチップ） | 列「メモ」あり/なし Chip（M1） | **Fit** |
| M10b | 一覧：参加者PDF | モックにはなし（拡張） | 列「参加者PDF」あり/なし Chip（M7-P1-LIST）。has_participant_pdf に基づく。詳細・ファイル名は Drawer で確認 | **Fit**（実装拡張） |
| M11 | 一覧：名前 | なし（モックは番号・日付・BO・メモ・Actions） | 名前列なし（M1 で削除済み） | **Fit**（解消済み） |
| M12 | 行アクション | 「📝 メモ」「🗺 BO編集」 | 同一（M2） | **Fit** |
| M13 | 行クリック | 選択で右パネルに例会詳細表示 | 行クリックで Drawer に例会詳細表示（M3） | **Fit**（表示は Drawer。導線は同等） |
| M14 | 右パネル / 詳細 | 例会詳細（番号・日付・BO数・メモ有無・メモ本文・BO割当・メモ編集/Connectionsへ） | Drawer で同内容を表示（M3）。右パネル固定ではない | **Fit（Drawer 採用）**（機能面では同等） |
| M15 | 例会メモ編集 | モーダル「📝 例会メモ編集 — #247」＋Connections 案内 | 同一（M4） | **Fit** |

---

## 4. まとめ

Meetings 画面は M1〜M6 により、**一覧のみの仮画面から、統計・ツールバー・一覧・行アクション・詳細 Drawer・例会メモ編集 Dialog まで揃った実用画面**になっている。主要な Fit/Gap は §3 のとおり。**主要機能は概ね実装済みで、実運用に耐える状態**に到達している。

### Fit（揃っているところ）

- ページタイトル「Meetings」＋サブ説明「例会管理 / BO割当 / メモ」（M1）
- ヘッダーアクション「🗺 Connectionsで編集」
- 統計カード 4 種（総例会数・総BO数・メモ有り例会・次回例会）（M6）
- ツールバー（検索・メモフィルタ・件数）（M5）
- 一覧列：番号・開催日・BO数・メモ・参加者PDF・Actions（M1, M7-P1-LIST）。参加者PDFは has_participant_pdf に基づく Chip 表示。行アクション「📝 メモ」「🗺 BO編集」（M2）
- 行クリックで Drawer に例会詳細（番号・日付・BO数・メモ有無・参加者PDF有無・メモ本文・BO割当・メモ編集/Connectionsへ・参加者PDF登録/ダウンロード）（M3, M7-P1）
- 例会メモ編集モーダル（一覧・Drawer 両方から起動、保存で一覧/Drawer に反映）（M4）

### 残差分（表現差・副表示）

- **レイアウト:** モックは two-col（右パネル常時表示）。実装は Drawer で詳細表示。機能は同等。
- **統計カードの副表示:** モックの「今年度20回」「平均3.8/例会」「91%」等は未実装。数値 4 種は表示済み。
- 上記以外の主要な Gap は解消済み。

### 次の改善候補

- 統計カードに今年度回数・平均/例会・割合などの副表示を追加する場合の Phase。
- 統計の自動更新（メモ保存後の再取得）が必要な場合の対応。

---

**関連:** [FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) §5 Meetings、[MOCK_UI_VERIFICATION.md](MOCK_UI_VERIFICATION.md)
