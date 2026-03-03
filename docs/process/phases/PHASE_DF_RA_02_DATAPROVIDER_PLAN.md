# Phase DF-RA-02: DataProvider 最小実装 PLAN

## 目的

DragonFly API と接続する最小 DataProvider を作成し、ReactAdmin から GET flags・PUT flags・GET summary の疎通を確認する。

## スコープ

- `resources/js/admin/dataProvider.js` を新規作成する。
- 実装対象メソッド:
  - **getList** … flags（GET /api/dragonfly/flags?owner_member_id=...）
  - **update** … flags（PUT /api/dragonfly/flags/{id}）
  - **getOne** … summary 用のカスタム（GET /api/dragonfly/contacts/{id}/summary?owner_member_id=...）
- fetch ベースで実装する（axios は使わない）。
- Admin に仮 Resource（dragonflyFlags）と DummyList を登録し、console.log で API 疎通を確認する。

## 非スコープ

- 1on1 sessions / 他 Resource。
- 認証・エラーハンドリングの完成。
- UI の仕上げ。

## 成果物

- `docs/process/phases/PHASE_DF_RA_02_DATAPROVIDER_PLAN.md`（本ファイル）
- `docs/process/phases/PHASE_DF_RA_02_DATAPROVIDER_WORKLOG.md`
- `docs/process/phases/PHASE_DF_RA_02_DATAPROVIDER_REPORT.md`
- `www/resources/js/admin/dataProvider.js`
- `www/resources/js/admin/app.jsx` の修正（dataProvider 差し替え・Resource 仮登録）

## リスク

- owner_member_id は V1 ではクエリで渡す前提。DataProvider の getList では暫定で固定値や window から取得する想定とする。

## DoD

- [ ] build 成功。
- [ ] /admin で dragonflyFlags の list を開いたときに getList が呼ばれ、API 疎通が console で確認できる。
- [ ] PLAN / WORKLOG / REPORT 作成済み。
- [ ] 1 commit にまとめている。
