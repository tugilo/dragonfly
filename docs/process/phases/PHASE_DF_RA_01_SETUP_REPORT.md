# Phase DF-RA-01: ReactAdmin 基盤導入 REPORT

## 変更ファイル一覧

| 種別 | パス |
|------|------|
| 新規 | `docs/process/phases/PHASE_DF_RA_01_SETUP_PLAN.md` |
| 新規 | `docs/process/phases/PHASE_DF_RA_01_SETUP_WORKLOG.md` |
| 新規 | `docs/process/phases/PHASE_DF_RA_01_SETUP_REPORT.md` |
| 新規 | `www/resources/js/admin/app.jsx` |
| 新規 | `www/resources/views/admin.blade.php` |
| 変更 | `www/package.json`（react, react-dom, react-admin, @mui/material, @mui/icons-material, @emotion/react, @emotion/styled 追加） |
| 変更 | `www/package-lock.json` |
| 変更 | `www/vite.config.js`（admin エントリ追加） |
| 変更 | `www/routes/web.php`（GET /admin 追加） |

既存の `/` および `/dragonfly/{number}` は変更していない。

---

## 実行手順

1. **依存インストール（初回または package.json 変更後）**
   ```bash
   cd www
   npm install
   ```

2. **開発サーバー起動**
   ```bash
   cd www
   npm run dev
   ```

3. **本番ビルド**
   ```bash
   cd www
   npm run build
   ```

4. **Admin 画面表示**
   - ブラウザで http://localhost/admin を開く（Vite 利用時はプロキシ設定に応じてポートを確認すること）。

---

## 確認方法

- **build 成功**: `npm run build` がエラーで終了しないこと。
- **/admin 表示**: ReactAdmin の UI（サイドバー・ヘッダー等）が表示され、console に error が出ないこと。
- **既存ルート**: `/` および `/dragonfly/{number}` が従来どおり動作すること。

---

## DoD 確認

- [x] `npm run build` が成功する。
- [x] `/admin` 用の Blade と JS エントリを追加済み。起動後 http://localhost/admin で表示・console error なしを手動確認可能。
- [x] 既存ルートは変更していない。
- [x] PLAN / WORKLOG / REPORT 作成済み。
- [ ] 1 commit にまとめる（feat: Phase DF-RA-01 ReactAdmin setup）。
