# Phase 120 WORKLOG: 1to1議事録のDB登録

## 2026-05-17 22:24 JST

### 判断

- `DATA_MODEL.md` では、1回ごとの主記録は `one_to_ones.notes` に保存する方針のため、今回の登録先は `one_to_ones` とした。
- 既存DBを確認したところ、船津麻理子さんは `one_to_ones.id = 15` として登録済みだったため二重登録しない。
- 田渕恭平さんの文書は「初回1to1台本」「予定」状態で、実施済み議事録とは判断しない。今回は未登録とし、実施後に別途登録する。
- 他チャプター相手で `members` に存在しない人は、現行スキーマ上 `one_to_ones.target_member_id` が必須のため、最小の `visitor` として `members` に作成する。所属チャプター別 `workspace` は未整備のため `workspace_id = null` とする。

### 実施方針

- 重複判定は次の順で行う。
  - `one_to_ones.notes` に source path が含まれる。
  - 同一 owner / target / scheduled_at の `one_to_ones` が存在する。
  - scheduled_at が未確定のものは、同一 owner / target の completed が既に存在すれば登録しない。
- `scheduled_at` は文書のJST日時をそのまま保存する。正式時刻が TODO のものは、時刻が不明な場合のみ `scheduled_at = null` とする。

## 2026-05-17 22:27 JST

### 実施結果

- `one_to_ones` へ8件を追加した（id 17〜24）。
- 既存登録済みとして、船津麻理子さん（id 15）は追加しなかった。
- 実施済み議事録ではなく事前台本・予定状態として、田渕恭平さんは今回登録しなかった。
- DB未登録だった相手は `members.type = visitor`, `workspace_id = null` の最小レコードとして作成した。

### 追加した `one_to_ones`

| id | 相手 | source |
|---:|---|---|
| 17 | 鈴木 健介 | `docs/meetings/1to1/1to1_suzuki_kensuke_studio_suzu.md` |
| 18 | 竹内 駿太 | `docs/meetings/1to1/1to1_takeuchi_shunta_athlete_insurance.md` |
| 19 | 松倉 健治 | `docs/meetings/1to1/1to1_matsukura_kenji_glassfilm_coating.md` |
| 20 | 飯塚氏（名 TODO） | `docs/meetings/1to1/1to1_iizuka_graphic_design.md` |
| 21 | 田村 広大 | `docs/meetings/1to1/1to1_tamura_kodai_money_cooking.md` |
| 22 | 木村 秀継 | `docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md` |
| 23 | 伊藤 隆夫 | `docs/meetings/1to1/1to1_ito_takao_phoenix_jsp.md` |
| 24 | 礒部 昌之 | `docs/meetings/1to1/1to1_isobe_masayuki_nestle_detective.md` |

### 文書反映

- 各議事録の「基本情報」に `Religo 1to1 レコード` として `one_to_ones.id` を追記した。
