# Phase 121 PLAN: チャプター外1to1相手の所属チャプター補正

## Phase

- **Phase ID:** 121
- **Name:** チャプター外1to1相手の所属チャプター補正
- **Type:** implement
- **Started at:** 2026-05-17 22:28 JST

## Related SSOT

- **SPEC-006:** `docs/SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md`
- **DATA_MODEL:** `docs/SSOT/DATA_MODEL.md` §4.1 / §4.2 / §4.9 / §5.1

## Scope

- **DB操作:** `workspaces`, `members`
- **Docs:** Phase 121 PLAN / WORKLOG / REPORT, `docs/process/PHASE_REGISTRY.md`, `docs/dragonfly_progress.md`, `docs/INDEX.md`
- **Out of scope:** 新規UI/API実装、所属チャプター未確定者の推測登録、国/リージョン階層の完全整備

## DoD

- チャプター外1to1相手のうち所属チャプターが文書上確認できる人を、`members.workspace_id` で該当 `workspaces` に紐づける。
- 必要な `workspaces` は冪等に作成する。
- 所属チャプター未確定の人は更新せず、未確定として残す。
- 更新結果をDB照会で確認する。

## 対象

| 相手 | 所属チャプター |
|---|---|
| 鈴木 健介 | BNI Diana |
| 飯塚氏（名 TODO） | BNI 大人なじみ |
| 伊藤 隆夫 | BNI 大人なじみ |
| 田村 広大 | BNI カーネル |
| 礒部 昌之 | BNI レブリー |

## 保留

- 木村 秀継: 文書上 `chapter_primary: null` のため、所属チャプター確定後に更新する。
