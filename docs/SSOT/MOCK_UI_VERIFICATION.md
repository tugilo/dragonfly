# モック比較による UI 検証ルール

**目的:** 管理画面 UI 改修を必ずモックと比較しながら進めるための SSOT（手順・チェックリスト・参照 URL）。  
**SSOT モック:** `www/public/mock/religo-admin-mock.html`  
**比較差分の記録先:** [FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md)

---

## 1. モックの URL とファイルパス

| 種別 | URL / パス |
|------|------------|
| 管理画面モック（メイン） | **URL:** http://localhost/mock/religo-admin-mock.html |
| 上記の実体ファイル | `www/public/mock/religo-admin-mock.html` |
| Members 詳細 Drawer 用 | `www/public/mock/members-mock.html`（Drawer＋タブのレイアウト参照） |

---

## 2. 比較の標準手順

1. **モック**をブラウザで開く（または該当 mock ファイルの該当セクションを読む）。
2. **実装**をブラウザで開く（例: http://localhost/admin#/members, http://localhost/admin#/meetings）。
3. **画面別チェック項目**（§4）でモックと実装を照合する。
4. 差分があれば **FIT_AND_GAP_MOCK_VS_UI.md** に記録する。
5. 修正は **Phase 化**するか、軽微なら **即時修正**する。

---

## 3. ブラウザで左右に並べて比較する手順（推奨）

1. **左タブ:** http://localhost/mock/religo-admin-mock.html  
2. **右タブ:** http://localhost/admin#/members（または対象画面）  
3. **同一操作**（例: 「詳細」クリック）を両方で行い、Drawer / モーダルの出方・タブ名・ボタン文言を比較する。

---

## 4. 画面別チェック項目（モック vs 実装）

### 4.1 Shell（全画面共通）

| 項目 | モック | 実装で確認すること |
|------|--------|---------------------|
| サイドバー幅 | 240px | ReligoLayout / Menu の幅 |
| メニュー順 | Connections → Members → Meetings → 区切り → 1 to 1 → Role History → 区切り → Settings（Categories, Roles） | ReligoMenu の並び・ネスト |
| AppBar | パンくず・検索・🔔・ME アバター | タイトル・更新等が同じ位置感か |

※ モックの #content 内は現在 **Members のみ** 実コンテンツあり。他画面はメニューだけなので、各画面の「あるべき構成」は **FIT_AND_GAP の表**を正とする。

### 4.2 Members

| 項目 | モック | 実装で確認すること |
|------|--------|---------------------|
| ページヘッダー | 「Members」＋サブコピー「仕事 / 役職 / 関係性を…」 | タイトル＋任意でサブ説明 |
| ヘッダーアクション | 「Connectionsへ」「＋ メンバー追加（将来）」disabled | 同一ボタン |
| 統計カード | 総メンバー数 / 1to1未実施(30日) / interested ON / want_1on1 ON の 4 種 | 未実装なら FIT_AND_GAP の Gap として記録 |
| フィルタバー | 検索・大カテゴリ・カテゴリ・ロール・interested/want_1on1 トグル・並び順・件数 | Datagrid の Filter と比較 |
| 一覧 | カードグリッド（番号・名前・カナ・カテゴリ・役職・同室・最終接触・メモ抜粋・フラグ・✏️メモ/📅1to1/📝1to1メモ/詳細） | 実装は Datagrid。行アクションが ✏️📅📝詳細 の 4 種あるか |
| 詳細 | 右側 Drawer（Overview / Memos / 1to1 タブ） | 「詳細」で Drawer が開き、タブが同じか |

### 4.3 Meetings

| 項目 | モック（FIT_AND_GAP より） | 実装で確認すること |
|------|----------------------------|---------------------|
| ページヘッダー | 「Meetings」「例会管理 / BO割当 / メモ」 | タイトル＋任意でサブ説明 |
| ヘッダーアクション | 「Connectionsで編集」 | 同一 |
| 統計カード | 総例会数 / 総BO数 / メモ有り例会 / 次回例会 | 未実装なら Gap として記録 |
| 一覧 | 番号・日付・BO数・メモ・Actions（📝メモ、🗺BO編集） | 回・開催日・名前・Actions（詳細）があるか |
| 例会詳細 | 右パネル or Drawer（番号・日付・BO数・メモ有無・BO割当・メモ編集・Connectionsへ） | 「詳細」で Drawer が開き、Overview/Breakouts/Memos タブがあるか |

### 4.4 その他画面（Dashboard, Connections, 1 to 1, Role History, Settings）

- **FIT_AND_GAP** の該当セクション（§2 Dashboard 〜 §9 Settings）の表を開く。
- モックには該当コンテンツが単一ファイル内にないため、**FIT_AND_GAP の「モック」列を“あるべき姿”として参照**する。
- 実装では、同じ見出し・同じアクション・同じレイアウト（two-col 等）があるかを確認する。

---

## 5. このルールの適用（運用ルール）

- **UI を触る Phase の PLAN** には、次の定型句を **必ず** 書く。  
  **「モック比較: docs/SSOT/MOCK_UI_VERIFICATION.md に従う」**
- **実装後**は、対象画面をモックと同一操作で比較し、差分は **docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md** に記録する。
- **Members 以外**のモックコンテンツが単一ファイルに無い現状は、**FIT_AND_GAP の“モック”列を正**として扱う。

---

## 6. モックの制限（現状）

- `religo-admin-mock.html` の #content は **Members の一枚** のみ。Dashboard / Meetings 等のコンテンツは同じファイル内にない。
- そのため「各画面」の見た目は、**Members はモックを直接参照**し、**他画面は FIT_AND_GAP の表＋モックのデザインシステム（ボタン・カード・フィルタバー・モーダル）** を参照する。
