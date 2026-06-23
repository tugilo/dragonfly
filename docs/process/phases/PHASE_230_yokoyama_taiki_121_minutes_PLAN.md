# Phase 230 PLAN: 横山太樹 第1回121 Zoom要約反映

## Phase Overview

| Item | Value |
|------|-------|
| Phase ID | 230 |
| Name | yokoyama_taiki_121_minutes |
| Phase Type | docs |
| Status | completed |
| Started At | 2026-06-19 15:00 JST |
| Branch | develop（commit / merge 未実施） |

## Purpose

2026-06-19 JST 14:00 から実施した横山太樹さん（株式会社ARATAS / DragonFly ビジター）との第1回 121 について、ユーザー提供の Zoom 要約を校正・構造化し、既存の 1to1 ドキュメントへ実施後議事録として反映する。

## Related SSOT

| Spec ID | File | Relevance |
|---------|------|-----------|
| SPEC-012 | `docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md` | Zoom 由来の 1to1 予定・実施・要約を 1to1 履歴へ反映する運用に対応 |
| SPEC-013 | `docs/SSOT/ONETOONE_PREP_PROFILE_REQUIREMENTS.md` | ローカル Markdown の 1to1 原稿・議事録を整理し、Religo レコードに接続する運用に対応 |

## Scope

### In Scope

- `docs/meetings/1to1/1to1_yokoyama_taiki_aratas.md` への Zoom 要約反映
- `docs/INDEX.md` の該当行更新
- `docs/dragonfly_progress.md` への進捗追記
- `docs/process/PHASE_REGISTRY.md` への Phase 230 追記
- Phase 230 の PLAN / WORKLOG / REPORT 作成

### Out of Scope

- Religo DB への `one_to_ones.id=81` の completed 反映
- `www/` 配下の実装変更
- Zoom 文字起こし原文の保存
- 横山さんへの送信代行

## DoD

- 横山さんとの第1回 121 の主要成果・合意・アクションが整理されている。
- ARATAS の財務顧問サービス、次廣側の法人化・資金繰り・銀行対応課題、銀行格付けの学び、AI/セキュリティ議論、BNI 入会検討、独協大学縁が議事録に反映されている。
- 未確認事項と次回相談予定が分かる。
- `docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md` が同期されている。
- docs フェーズのためテストはスキップし、その理由を REPORT に記録する。

## Tasks

- [x] ユーザー提供 Zoom 要約から議事録構造を決める
- [x] 既存 1to1 ドキュメントの実施後追記欄を議事録へ置換する
- [x] INDEX / progress / phase registry / report を更新する

## Risks / Notes

- Zoom 要約の `[引用]` は原文参照マーカーであり、議事録では削除して内容のみ反映する。
- 終了時刻は未提供のため TODO のままにする。
- Religo `one_to_ones.id=81` は既存記載を保持し、DB ステータス反映は今回スコープ外とする。
