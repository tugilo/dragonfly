# Phase 231 PLAN: DragonFly 定例会 2026-06-23 議事録保存

## Phase Overview

| Item | Value |
|------|-------|
| Phase ID | 231 |
| Name | dragonfly_weekly_20260623_minutes |
| Phase Type | docs |
| Status | completed |
| Started At | 2026-06-23 12:46 JST |
| Branch | develop（commit / merge 未実施） |

## Purpose

ユーザー提供の Zoom 要約を校正・構造化し、BNI DragonFly 第212回定例会（2026-06-23）の議事録として `docs/meetings/chapter/` に保存する。

## Related SSOT

| Spec ID | File | Relevance |
|---------|------|-----------|
| SPEC-014 | `docs/SSOT/CHAPTER_MINUTES_REQUIREMENTS.md` | 定例会 Markdown 議事録を SSOT とし、Religo DB 取り込み対象にする運用に対応 |

## Scope

### In Scope

- `docs/meetings/chapter/chapter_weekly_20260623.md` の新規作成
- `docs/meetings/chapter/README.md` の第212回例示更新
- `docs/INDEX.md` の定例会議事録一覧更新
- `docs/dragonfly_progress.md` への進捗追記
- `docs/process/PHASE_REGISTRY.md` への Phase 231 追記
- Phase 231 の PLAN / WORKLOG / REPORT 作成

### Out of Scope

- Religo DB への議事録取り込み
- 参加者 CSV / PDF の内容修正
- `www/` 配下の実装変更
- Zoom 文字起こし原文の保存

## DoD

- 第212回定例会の主要成果、参加者、学習コーナー、メンバー更新、ウィークリープレゼン、メインプレゼン、統計、リファーラル、シェアストーリー、推薦の言葉、ビジター、アクションが議事録として整理されている。
- Zoom 要約の `[引用]` マーカーを削除し、既存議事録に合わせて表記を校正している。
- `docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md` が同期されている。
- docs フェーズのためテストはスキップし、その理由を REPORT に記録する。

## Tasks

- [x] 関連 SSOT と既存議事録フォーマットを確認する
- [x] Zoom 要約を校正して議事録 Markdown を作成する
- [x] INDEX / progress / phase registry / report を更新する

## Risks / Notes

- Zoom 要約には「産給金額」「初期券会計」などの誤変換が含まれるため、既存議事録の用語へ寄せる。
- 終了時刻は Zoom 要約に明記がないため、既存定例枠に合わせつつ要確認として残す。
- 未解決事項の末尾が途切れているため、本文では TODO として記録する。
