# Phase DF-RA-01: ReactAdmin 基盤導入 WORKLOG

## 実装ステップと内容

### Step 0: PLAN 作成

- `docs/process/phases/PHASE_DF_RA_01_SETUP_PLAN.md` を作成（目的・スコープ・非スコープ・成果物・リスク・DoD）。

### Step 1: WORKLOG 雛形

- 本ファイル `PHASE_DF_RA_01_SETUP_WORKLOG.md` を作成。

### Step 2: ReactAdmin 導入

1. **npm 依存の追加**
   - `react`, `react-dom`, `react-admin`, `@mui/material`, `@mui/icons-material`, `@emotion/react`, `@emotion/styled` を dependencies に追加。
   - 実行: `npm install react react-dom react-admin @mui/material @mui/icons-material @emotion/react @emotion/styled`

2. **resources/js/admin/app.jsx 作成**
   - React 18 の `createRoot` で `document.getElementById('admin-root')` にマウント。
   - `react-admin` の `<Admin>` を使用。dataProvider は最小実装（getList が `{ data: [], total: 0 }` を返すダミー）を渡し、起動時エラーを防ぐ。

3. **Vite エントリ追加**
   - `vite.config.js` の `input` に `'resources/js/admin/app.jsx'` を追加。

4. **/admin 仮ルート**
   - `routes/web.php` に `Route::get('/admin', ...)` を追加。
   - 返却 view は `admin`（Blade）。Blade には `div#admin-root` のみとし、`@vite(['resources/js/admin/app.jsx'])` で admin 用 JS のみ読み込む（既存 app.css は読み込まないか、必要なら admin 用に最小限にする）。

### Step 3: 起動テスト

- `npm run dev` を実行。
- ブラウザで http://localhost/admin を開き、ReactAdmin の初期画面（空の List 等）が表示されることを確認。
- 開発者ツールの Console に error が出ないことを確認。

### Step 4: REPORT 作成

- `docs/process/phases/PHASE_DF_RA_01_SETUP_REPORT.md` に変更ファイル一覧・実行手順・確認方法を記載。

### Step 5: 1 commit

- 上記変更をすべてステージし、`feat: Phase DF-RA-01 ReactAdmin setup` で 1 コミット。

## 注意事項

- 既存の `resources/js/app.js` および `resources/css/app.css` は変更しない。
- 既存ルート（`/`, `/dragonfly/{number}`）は変更しない。
