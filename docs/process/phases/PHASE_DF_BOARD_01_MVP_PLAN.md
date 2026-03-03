# Phase DF-BOARD-01: DragonFlyBoard MVP PLAN

## 目的

左ペインで member 検索、右ペインで summary カード表示、interested / want_1on1 のトグルで flags 更新し、BNI 現場で「誰に・気になる/1on1」を即記録できる MVP を実装する。

## スコープ

- Custom page: DragonFlyBoard（`resources/js/admin/pages/DragonFlyBoard.jsx`）。
- UI 構成: Grid container、左に Autocomplete（members 一覧）、右に Summary 表示カード。
- Autocomplete で選択した member を target とし、owner_member_id は暫定で固定または選択可能にする。
- Summary は GET /api/dragonfly/contacts/{target_member_id}/summary?owner_member_id=... で取得し、カード表示。
- トグル: interested / want_1on1 を変更したら PUT /api/dragonfly/flags/{target_member_id} を呼び、成功後に summary を再取得する。
- members 一覧取得: GET /api/dragonfly/members を新設（id, display_no, name, name_kana, category の一覧）。既存 API を壊さない。

## 非スコープ

- デザインの完成度。
- 1on1 管理画面。
- 認証・owner の永続化。

## 成果物

- `docs/process/phases/PHASE_DF_BOARD_01_MVP_PLAN.md`（本ファイル）
- `docs/process/phases/PHASE_DF_BOARD_01_MVP_WORKLOG.md`
- `docs/process/phases/PHASE_DF_BOARD_01_MVP_REPORT.md`
- `www/app/Http/Controllers/Api/DragonFlyMemberController.php`（index: members 一覧）
- `www/routes/api.php` に GET /api/dragonfly/members 追加
- `www/resources/js/admin/pages/DragonFlyBoard.jsx`
- Admin のカスタムメニューから DragonFlyBoard へのルート登録

## DoD

- [ ] build 成功。
- [ ] Summary が表示される。
- [ ] interested ON/OFF で即反映（PUT 後 summary 再取得）。
- [ ] console error なし。
- [ ] PLAN / WORKLOG / REPORT 作成済み。
- [ ] 1 commit にまとめている。
