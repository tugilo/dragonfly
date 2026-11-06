# Phase 323 PLAN — 1to1 の手動登録ルールを明確にし、`one_to_ones.id` を正とする

**作成:** 2026-11-06 10:39 JST  
**Phase Type:** docs  
**Branch:** 作業ツリー未分離（現在 `feature/phase321-members-left-at` に Phase 321 等の未コミット変更があるため、切り替えると巻き込む。commit・merge はユーザー指示後）  
**Related SSOT:** SPEC-012 `docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md`／`docs/SSOT/ZOOM_IMPORT_DEDUP_REQUIREMENTS.md`／`docs/SSOT/DATA_MODEL.md` §4.12／SPEC-019 `docs/SSOT/ONETOONE_MULTI_SESSION_IMPORT_REQUIREMENTS.md`

---

## Purpose

1to1 を DB に載せる経路を **Zoom 取込** と **手動登録** の2つとして明文化する。どちらで作っても、議事録や運用で使う識別子は **Religo が自動採番する `one_to_ones.id`** とし、Zoom の会議 ID は突合用の属性に留める。

## 背景（2026-11-06 の全件突合で判明）

- 運用ルール（1to1 README §重複防止、`.cursor/rules/1to1-dedup.mdc`、`/import-religo` スキル）が「Zoom 取込済みの id を正とし、新規行を作らない」流れしか書いていない。
- そのため、相手主催の Zoom（中田雄斗・松永健汰）や Google Meet、対面の面談でも「Zoom 取込待ち・新規行禁止」と書かれ、DB に載らない回が溜まった（2026-11-06 時点で 8 回分を手動採番、松永さんを追加採番）。
- Zoom 連携は自分がホストした会議しか一覧に出ない（SPEC-012 §6 で既知）。相手主催の回は、待っていても取込に出ない。

---

## Scope

- `docs/meetings/1to1/README.md`（§重複防止を「登録経路と ID の正」に改める）
- `.cursor/rules/1to1-dedup.mdc`
- `.claude/skills/import-religo/SKILL.md`・`.agents/skills/import-religo/SKILL.md`（1to1 重複防止の節）
- `docs/SSOT/DATA_MODEL.md` §4.12（ID の正を1段落）
- `docs/SSOT/ZOOM_IMPORT_DEDUP_REQUIREMENTS.md`（登録経路・衝突しない仕組みの調査結果・残るギャップ）
- `docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md`（§6 相手ホストの注記に手動登録への参照）
- `docs/process/phases/PHASE_323_*`・`docs/process/PHASE_REGISTRY.md`・`docs/INDEX.md`・`docs/dragonfly_progress.md`

対象外: コード変更（手動登録時の重複警告、planned→completed の自動昇格、DB 一意制約など。ギャップとして記録し別 Phase）。既存議事録の「新規行禁止」表記の一括書き換え。

---

## 決めること（本 Phase で確定）

| 項目 | 決定 |
|------|------|
| ID の正 | `one_to_ones.id`（Religo の自動採番）。Markdown・INDEX・運用で参照するのはこの id だけ |
| Zoom の会議 ID / UUID | `zoom_meeting_id`・`zoom_meeting_uuid` は突合用の属性。識別子として使わない |
| 登録経路 A（Zoom 取込） | 自分がホストした Zoom。取込画面で相手を確定して登録 |
| 登録経路 B（手動登録） | Zoom 取込に出ない面談（相手主催の Zoom、Meet、対面、電話）。管理画面の 1to1 作成（`external_source=manual`） |
| 手動登録の前の確認 | 同じ相手・同じ日の行、Zoom 取込の保留・未処理の候補が無いことを確かめる。あれば新規に作らずそれを使う |
| 後から Zoom 取込が来た場合 | 同じ owner＋相手＋同じ日の行があれば新規作成しない（既存の自動紐づけ） |

---

## DoD

- 上記 Scope の文書に、2経路・ID の正・手動登録前の確認手順が矛盾なく書かれている。
- 「Zoom 取込待ち・新規行禁止」を、相手主催等にも当てはめる記述が運用ルールから無くなっている。
- 衝突しない仕組みの調査結果（守られている点・ギャップ）が ZOOM_IMPORT_DEDUP に記録されている。
- PHASE_REGISTRY・INDEX・進捗を同期。REPORT 記入（Merge Evidence は commit・merge 後）。

---

## Tasks

1. 衝突しない仕組みの調査（DB 制約・取込の重複判定・手動登録 API・現 DB の重複有無）。
2. README・Cursor ルール・スキル2つを改訂。
3. DATA_MODEL・ZOOM_IMPORT_DEDUP・SPEC-012 に追記。
4. WORKLOG・REPORT・PHASE_REGISTRY・INDEX・進捗。
