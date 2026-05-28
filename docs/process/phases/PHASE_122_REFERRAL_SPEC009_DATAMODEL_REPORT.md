# Phase 122 REPORT: SPEC-009 + DATA_MODEL（リファーラル）

## 概要

SPEC-009 の未決 TODO を製品既定として閉じ、`DATA_MODEL.md` に内部リファーラルテーブルおよび `introductions.referral_kind` を SSOT として追記した。コード・マイグレーションは含まない。

## Phase

- **Phase ID:** 122
- **Type:** docs
- **Completed at:** 2026-05-18 07:25 JST（ローカル作業完了）

## Related SSOT

- SPEC-009: `docs/SSOT/REFERRAL_RECORDING_REQUIREMENTS.md`
- `docs/SSOT/DATA_MODEL.md`

## DoD

| 項目 | 状態 |
|------|------|
| 製品既定の文章化 | OK |
| DATA_MODEL 更新 | OK |
| SPEC-009 Registry active | OK |
| Phase 記録・REGISTRY | OK |

## Merge Evidence

- **merge commit id:** （未 merge）`develop` 取り込み後に `git log -1 --format=%H develop` で追記すること。
- **source branch:** feature/phase122-referral-spec009-datamodel（推奨）
- **target branch:** develop
- **test command:** スキップ（docs Phase）
- **test result:** N/A
- **changed files:** `git diff --name-only` で取り込み時に記録

## scope check

OK

## ssot check

OK（SPEC-009 active、DATA_MODEL 更新）

## dod check

OK
