# Phase 131 PLAN: 1to1議事録のDB登録フォローアップ

## Phase

- **Phase ID:** 131
- **Name:** 1to1議事録のDB登録フォローアップ
- **Type:** implement
- **Started at:** 2026-05-21 16:12 JST

## Related SSOT

- **SPEC-006:** `docs/SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md`
- **DATA_MODEL:** `docs/SSOT/DATA_MODEL.md` §1.2 / §4.9

## Scope

- **DB操作:** `workspaces`, `members`, `one_to_ones`
- **Docs:** `docs/process/phases/PHASE_131_1TO1_DB_REGISTRATION_FOLLOWUP_*`, `docs/process/PHASE_REGISTRY.md`, `docs/dragonfly_progress.md`, 対象1to1議事録
- **Out of scope:** UI/API実装変更、事前台本・予定のみの1to1登録、既存登録済み1to1の二重登録

## DoD

- Phase 120以降に作成・更新された実施済み1to1議事録を `one_to_ones` に登録する。
- 既存登録済みの1to1は重複登録しない。
- `members` に相手が存在しない場合は、最小の `visitor` / `guest` レコードを作成してから1to1を登録する。
- 登録後に件数・対象者・重複スキップを確認する。
- 対象議事録へ `Religo 1to1 レコード` としてDB idを追記する。
- WORKLOG / REPORT / PHASE_REGISTRY / 進捗を更新する。

## 対象判定

- **登録対象:** 実施済み議事録として本文に反映済みのもの。
  - 前田 和良
  - 辻 亮
  - 下辻（株式会社hsネオプロジェクト）
  - 中村 啓吾
  - 藤本 勇輝
  - 権堂 千栄実
  - 西岡 優希
- **スキップ:** 田辺 光さんは現時点の文書が「予定・会後追記待ち」のため、実施済み議事録としては登録しない。

## 重複判定

- `one_to_ones.notes` に source path が含まれる場合は登録しない。
- 同一 owner / target / scheduled_at の `one_to_ones` がある場合は登録しない。
- scheduled_at が未確定のものは、同一 owner / target の completed が既に存在すれば登録しない。
