# Phase 131 WORKLOG: 1to1議事録のDB登録フォローアップ

## 2026-05-21 16:12 JST

### 判断

- Phase 120 以降に作成・実施済みへ更新された1to1議事録を、`one_to_ones` の1セッション1行として登録する。
- 田辺光さんの文書は現時点で「第1回予定」「会後に議事録追記」状態のため、実施済み1to1としては登録しない。
- 中村啓吾さん・西岡優希さんは既存 `members` を利用し、重複 member を作らない。
- DB未登録の相手は、現行スキーマ上 `one_to_ones.target_member_id` が必須のため、最小の `visitor` として `members` に作成する。
- 下辻氏は `chapter_primary: bni_kernel` かつ既存 `workspaces.slug = bni_kernel` があるため `members.workspace_id = 4` とする。
- 権堂千栄実さんは所属チャプターが BNI パッシオーネと確認済みのため、`workspaces.slug = bni_passione` を作成し、`members.workspace_id = 6` とする。
- 藤本勇輝さん・辻亮さん・前田和良さんは所属チャプター／組織の正式確認が残るため、`members.workspace_id = null` とする。
- 正式時刻が不明な中村啓吾さん・権堂千栄実さん・前田和良さんは、日付のみで `scheduled_at` を作らず `scheduled_at = null` とする。

### 実施結果

- `one_to_ones` へ7件を追加した（id 25〜31）。
- `members` へ5件を追加した（前田和良、辻亮、下辻氏、藤本勇輝、権堂千栄実）。
- `workspaces` へ BNI パッシオーネ（`slug = bni_passione`）を追加した。
- 対象議事録へ `Religo 1to1 レコード` として `one_to_ones.id` を追記した。

### 追加した `one_to_ones`

| id | 相手 | source |
|---:|---|---|
| 25 | 前田 和良 | `docs/meetings/1to1/1to1_maeda_referral_imaishi.md` |
| 26 | 辻 亮 | `docs/meetings/1to1/1to1_tsuji_ryo_mainc_meo.md` |
| 27 | 下辻氏（名 TODO） | `docs/meetings/1to1/1to1_shimotsuji_hs_neo_project.md` |
| 28 | 中村 啓吾 | `docs/meetings/1to1/1to1_nakamura_keigo_shakumoto.md` |
| 29 | 藤本 勇輝 | `docs/meetings/1to1/1to1_fujimoto_yuki_tax_advisor.md` |
| 30 | 権堂 千栄実 | `docs/meetings/1to1/1to1_gondo_chiemi_campanula.md` |
| 31 | 西岡 優希 | `docs/meetings/1to1/1to1_nishioka_foreign_trainee.md` |
