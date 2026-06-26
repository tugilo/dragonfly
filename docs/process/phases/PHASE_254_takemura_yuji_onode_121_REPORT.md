# Phase 254 REPORT: 竹村裕司 第1回121 Zoom要約反映

## Summary

2026-06-26 JST 09:00-10:00 に実施された竹村裕司さんとの第1回121について、ユーザー提供のZoom文字起こし要約をもとに、1to1シリーズ文書を新規作成した。

竹村さんが芳賀崇利さん紹介ゲストとして参加し、2026-07-07からDragonFlyメンバー予定であること、元大阪GaiYenチャプターのメンバー、株式会社ONODE 代表取締役、ゲスト登録カテゴリーのプロモーション動画制作、121で共有されたコンビニプリントサービス「チアプリント」、チアプリントの強み、次廣のAI活用開発・予約管理・Religoとの協業余地、Dリーグ・ダンス業界接点、Action Items を整理した。

## Deliverables

- `docs/meetings/1to1/1to1_takemura_yuji_onode.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_254_takemura_yuji_onode_121_PLAN.md`
- `docs/process/phases/PHASE_254_takemura_yuji_onode_121_WORKLOG.md`
- `docs/process/phases/PHASE_254_takemura_yuji_onode_121_REPORT.md`

## Decisions

- 前回ゲストプロフィールにより、正式氏名・読み・会社名・役職・HP・メール・電話が確認できたため、YAMLと基本プロフィールに反映した。
- ファイル名は正式氏名と会社名に合わせて `1to1_takemura_yuji_onode.md` とした。
- `chapter_primary` は、2026-07-07からDragonFlyメンバー予定という文脈を踏まえて `bni_dragonfly` とし、本文・YAMLに「芳賀さんゲスト」「メンバー予定」と明記した。
- ゲスト登録カテゴリーは **プロモーション動画制作**、121での入口商材は **チアプリント** として分けて整理した。
- 次廣との協業余地は、システム開発そのものだけでなく、Religo / 予約管理システムの売り出し方・見せ方について竹村さんのマーケティング視点を借りる可能性として整理した。
- Dリーグ・ダンス業界の話題は、竹村さんのダンス出身・ロイヤルラッツ契約・次廣側のDYMメッセンジャーズ接点が重なるため、リファーラル戦略の材料として独立して記録した。
- 前回ゲストプロフィールのアンケート・対応履歴を、入会見込み、意思決定傾向、連携できそうなメンバー、芳賀さん/飯田千帆さん/竹内駿太さん/増本重孝さんのメモとして追記した。

## DoD Check

| Item | Result |
|------|--------|
| 第1回121を時刻付きで保存 | OK |
| チアプリントの強みを整理 | OK |
| ONODE事業を整理 | OK |
| ゲストプロフィール・アンケート・対応履歴を整理 | OK |
| BNI登録方針と紹介しやすい入口を整理 | OK |
| 次廣との協業余地を整理 | OK |
| Dリーグ・ダンス業界接点を整理 | OK |
| Action Items / Pending Confirmation を整理 | OK |
| INDEX / progress / phase registry を同期 | OK |
| テスト結果 | docsフェーズのためスキップ |

## Merge Evidence

| Item | Value |
|------|-------|
| merge commit id | 未実施（commit / merge 未依頼） |
| source branch | develop（commit / merge 未実施） |
| target branch | develop |
| phase id | 254 |
| phase type | docs |
| related ssot | SPEC-006, SPEC-012, SPEC-019, `docs/meetings/1to1/README.md`, `PROJECT_NAMING.md` |
| test command | スキップ（docsフェーズ） |
| test result | スキップ（docsフェーズ） |
| changed files | `docs/meetings/1to1/1to1_takemura_yuji_onode.md`, `docs/INDEX.md`, `docs/dragonfly_progress.md`, `docs/process/PHASE_REGISTRY.md`, `docs/process/phases/PHASE_254_takemura_yuji_onode_121_PLAN.md`, `docs/process/phases/PHASE_254_takemura_yuji_onode_121_WORKLOG.md`, `docs/process/phases/PHASE_254_takemura_yuji_onode_121_REPORT.md` |
| scope check | OK |
| ssot check | OK |
| dod check | OK |

## Notes

- Religo DBへの取り込みは今回スコープ外。
- チアプリントの正式英字表記、Religo `one_to_ones.id` は未確認。
- 2026-07-07入会後、NCAS情報と正式カテゴリーが確認できたら本文・YAML・INDEXを更新する。
