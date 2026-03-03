# Phase DF-RA-01: ReactAdmin 基盤導入 PLAN

## 目的

DragonFly の ReactAdmin + MUI フロントエンドを、既存 Laravel API を壊さず安全に導入するための基盤（エントリ・ルート・ビルド）を整える。

## スコープ

- Vite に admin 用エントリ（`resources/js/admin/app.jsx`）を追加する。
- `/admin` に Blade で `#admin-root` のみを出力する仮ルートを追加する。
- React 18 createRoot で ReactAdmin を `#admin-root` にマウントする。
- 依存: react, react-dom, react-admin, @mui/material, @mui/icons-material, @emotion/react, @emotion/styled を npm で導入する。

## 非スコープ

- DataProvider の実装（Phase A-2）。
- DragonFlyBoard や Resource の実装（Phase B）。
- 既存 `/` や `/dragonfly/{number}` の変更。
- docs/design の変更。

## 成果物

- `docs/process/phases/PHASE_DF_RA_01_SETUP_PLAN.md`（本ファイル）
- `docs/process/phases/PHASE_DF_RA_01_SETUP_WORKLOG.md`
- `docs/process/phases/PHASE_DF_RA_01_SETUP_REPORT.md`
- `www/package.json`（依存追加）
- `www/resources/js/admin/app.jsx`（createRoot + Admin 最小）
- `www/vite.config.js`（admin エントリ追加）
- `www/routes/web.php`（/admin ルート追加）
- `www/resources/views/admin.blade.php`（#admin-root + Vite admin のみ）

## リスク

- ReactAdmin のデフォルト dataProvider が未設定だとエラーになるため、空の getList を返す最小 dataProvider を app.jsx 内に用意する。

## DoD

- [ ] `npm run build` が成功する。
- [ ] `npm run dev` 起動後、http://localhost/admin で画面が表示され、console に error が出ない。
- [ ] 既存ルート（/ , /dragonfly/{number}）は変更しない。
- [ ] PLAN / WORKLOG / REPORT 作成済み。
- [ ] 1 commit にまとめている（feat: Phase DF-RA-01 ReactAdmin setup）。
