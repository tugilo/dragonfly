# PHASE_136_MITARAI_FUDOTECH_1TO1_DB_REGISTRATION PLAN

## Phase Type
implement

## Purpose

株式会社風土テック・御手洗さんとの第1回 1to1 実施済み議事録を、Religo DB の `members` / `one_to_ones` に登録する。あわせて、西岡さんとの三者紹介進行を 1to1 文書へ履歴として追記する。

## Background

Phase 135 で御手洗さんとの第1回 1to1 実施後議事録を作成済み。ユーザーから、DragonFly メンバー西岡さんが御手洗さんとの接続を了承したため、御手洗さんへグループ作成可否を確認する紹介文を作成済み。これを 1to1 の履歴として残し、過去 Phase 120 / 131 と同様に DB 登録する。

## Related SSOT

- SPEC-006 1 to 1 とチャプター外（他チャプター BNI メンバー）— 解釈A・階層・API/UI
- `docs/SSOT/DATA_MODEL.md` §4.2 members / §4.12 one_to_ones

## Scope

- DB操作: `workspaces`, `members`, `one_to_ones`
- Docs: `docs/meetings/1to1/1to1_mitarai_fudotech.md`, `docs/INDEX.md`, `docs/dragonfly_progress.md`, `docs/process/PHASE_REGISTRY.md`, Phase 136 文書
- Out of scope: UI/API 実装変更、紹介グループ作成そのもの、御手洗さんの正式プロフィール確定

## Target Files
- `docs/meetings/1to1/1to1_mitarai_fudotech.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_136_MITARAI_FUDOTECH_1TO1_DB_REGISTRATION_PLAN.md`
- `docs/process/phases/PHASE_136_MITARAI_FUDOTECH_1TO1_DB_REGISTRATION_WORKLOG.md`
- `docs/process/phases/PHASE_136_MITARAI_FUDOTECH_1TO1_DB_REGISTRATION_REPORT.md`

## Implementation Strategy

Phase 120 / 131 と同じ方針で、DB に相手 member が存在しない場合は `members.type = visitor` の最小レコードを作成する。`one_to_ones.workspace_id` は記録コンテキストとして DragonFly 側 workspace を維持し、御手洗さんの所属は `members.workspace_id = bni_vortex` とする。`one_to_ones.notes` に source path を含め、二重登録を防ぐ。

## Tasks
- [ ] DB 現状確認（owner / target / workspace / 既存 `one_to_ones`）
- [ ] 必要に応じて `workspaces.slug = bni_vortex` と御手洗さん member を作成する
- [ ] `one_to_ones` に第1回 1to1 を登録する
- [ ] `1to1_mitarai_fudotech.md` に DB id と西岡さん紹介進行を追記する
- [ ] INDEX、PHASE_REGISTRY、進捗、WORKLOG / REPORT を同期する
- [ ] 重複確認と `php artisan test` を実行する

## DoD
- `one_to_ones` に御手洗さんとの第1回 1to1 が1件登録されている
- `members` に御手洗さんが重複なく登録され、所属チャプターが VORTEX として扱える
- `1to1_mitarai_fudotech.md` に `Religo 1to1 レコード` と西岡さん紹介進行が記録されている
- docs INDEX / PHASE_REGISTRY / 進捗 / REPORT が同期されている
- `php artisan test` が成功する
