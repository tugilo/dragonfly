# Phase DF-BOARD-01: DragonFlyBoard MVP REPORT

## 変更ファイル一覧

| 種別 | パス |
|------|------|
| 新規 | `docs/process/phases/PHASE_DF_BOARD_01_MVP_PLAN.md` |
| 新規 | `docs/process/phases/PHASE_DF_BOARD_01_MVP_WORKLOG.md` |
| 新規 | `docs/process/phases/PHASE_DF_BOARD_01_MVP_REPORT.md` |
| 新規 | `www/app/Http/Controllers/Api/DragonFlyMemberController.php` |
| 新規 | `www/resources/js/admin/pages/DragonFlyBoard.jsx` |
| 変更 | `www/routes/api.php`（GET /dragonfly/members 追加） |
| 変更 | `www/resources/js/admin/app.jsx`（dashboard={DragonFlyBoard} 追加） |

## 実装内容

- **DragonFlyMemberController::index**: members の id, display_no, name, name_kana, category を返す。
- **DragonFlyBoard.jsx**: Grid 左に Owner ID 入力・Members Autocomplete、右に Summary カード。interested / want_1on1 の Switch で PUT flags 後 summary 再取得。
- **Admin**: dashboard に DragonFlyBoard を指定し、/admin で Board を表示。

## 確認方法

- `npm run build` が成功すること。
- /admin でメンバーを選択すると Summary が表示されること。
- interested / want_1on1 のトグルを変更すると即 PUT され、表示が更新されること。
- Console に error が出ないこと。

## DoD

- [x] build 成功。
- [x] Summary 表示・トグル即反映を実装済み。
- [x] PLAN / WORKLOG / REPORT 作成済み。
- [ ] 1 commit にまとめる。
