# Phase 231 REPORT: DragonFly 定例会 2026-06-23 議事録保存

## Summary

ユーザー提供の Zoom 要約を校正・構造化し、BNI DragonFly 第212回定例会（2026-06-23）の議事録として `docs/meetings/chapter/chapter_weekly_20260623.md` を新規作成した。

成果物では、主要成果、参加者・ビジター、BNI概要、BOR、教育「送りバント」、岡元智美さんの3年目更新、ウィークリープレゼン、船津麻理子さん / 次廣淳のメインプレゼン、5月度統計、今週のリファーラル160件、リファーラル新制度確認、清原佳彩美さんのシェアストーリー、横山尚武さん→小中貴晃さんの推薦の言葉、入会案内、プレゼント抽選、アクションを整理した。

## Deliverables

- `docs/meetings/chapter/chapter_weekly_20260623.md`
- `docs/meetings/chapter/README.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_231_dragonfly_weekly_20260623_minutes_PLAN.md`
- `docs/process/phases/PHASE_231_dragonfly_weekly_20260623_minutes_WORKLOG.md`
- `docs/process/phases/PHASE_231_dragonfly_weekly_20260623_minutes_REPORT.md`

## Decisions

- Zoom 要約の `[引用]` マーカーは議事録本文には残さず、内容のみを校正して反映した。
- 参加人数は Zoom 要約値と CSV登録値に差があったため、どちらか一方に寄せず、議事録冒頭と未解決事項に両方を記録した。
- 5月度統計の外部リファーラルは、要約値398件が合計338件と不整合のため、既存議事録と整合する272件に補正し、正式値確認の注記を残した。
- 「産給金額」は既存議事録の表記に合わせて「サンキュー金額」へ統一した。
- 「百花両林」は BOR 画像の右上表記に合わせて「百華繚凛」へ校正した。
- Religo DB への `dragonfly:import-chapter-minutes` は今回スコープ外とし、Markdown 保存と索引同期までを完了範囲にした。

## DoD Check

| Item | Result |
|------|--------|
| 第212回定例会の要点を議事録化 | OK |
| Zoom 要約の `[引用]` マーカー削除・表記校正 | OK |
| INDEX / progress / phase registry を同期 | OK |
| テスト結果 | docs フェーズのためスキップ |

## Merge Evidence

| Item | Value |
|------|-------|
| merge commit id | 未実施（commit / merge 未依頼） |
| source branch | develop（commit / merge 未実施） |
| target branch | develop |
| phase id | 231 |
| phase type | docs |
| related ssot | SPEC-014 |
| test command | スキップ（docs フェーズ） |
| test result | スキップ（docs フェーズ） |
| changed files | `docs/meetings/chapter/chapter_weekly_20260623.md`, `docs/meetings/chapter/README.md`, `docs/INDEX.md`, `docs/dragonfly_progress.md`, `docs/process/PHASE_REGISTRY.md`, `docs/process/phases/PHASE_231_dragonfly_weekly_20260623_minutes_PLAN.md`, `docs/process/phases/PHASE_231_dragonfly_weekly_20260623_minutes_WORKLOG.md`, `docs/process/phases/PHASE_231_dragonfly_weekly_20260623_minutes_REPORT.md` |
| scope check | OK |
| ssot check | OK |
| dod check | OK |

## Notes

- Religo DB への議事録取り込みは今回スコープ外。必要に応じて別途 `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan dragonfly:import-chapter-minutes docs/meetings/chapter/chapter_weekly_20260623.md` を実行する。
- 参加人数と5月度統計の正式値は Nキャスまたは Zoom / 統計資料で要確認。
