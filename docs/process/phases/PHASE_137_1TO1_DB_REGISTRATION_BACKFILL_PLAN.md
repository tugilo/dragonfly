# Phase 137 PLAN: 1to1議事録のDB登録バックフィル

## Phase

- **Phase ID:** 137
- **Name:** 1to1議事録のDB登録バックフィル
- **Type:** implement
- **Started at:** 2026-05-25 20:26 JST

## Related SSOT

- **SPEC-006:** `docs/SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md`
- **DATA_MODEL:** `docs/SSOT/DATA_MODEL.md` §1.2 / §4.9

## Scope

- **DB操作:** `one_to_ones`
- **Docs:** Phase 137 PLAN / WORKLOG / REPORT、`docs/process/PHASE_REGISTRY.md`、`docs/dragonfly_progress.md`、対象1to1議事録
- **Out of scope:** UI/API実装変更、予定のみの1to1登録、木村健悟・岡元智美（記録未完/TODO）、田渕・田辺・軍司

## DoD

- 実施済みで DB 未登録だった 1to1 を `one_to_ones` に登録する。
- DB 登録済みで議事録に id 未記載のものを同期する。
- 重複登録しない。
- 対象議事録へ `Religo 1to1 レコード` として DB id を追記する。
- WORKLOG / REPORT / PHASE_REGISTRY / 進捗を更新する。

## 対象

| 相手 | source | 操作 |
|---|---|---|
| 野口 裕子 | `1to1_noguchi_yuko_hair_salon_viv.md` | DB 新規登録 |
| 佐藤 拓斗 | `1to1_sato_takuto_brightlink.md` | DB 新規登録（Phase 120 漏れ） |
| 米澤 侑桂 | `1to1_yonezawa_yuka_comechan_design.md` | 議事録へ `id=12` 追記のみ |

## 重複判定

- `one_to_ones.notes` に source path が含まれる場合は登録しない。
