# PHASE_158_kimura_kokuhosha_requirements PLAN

## Phase Type
docs

## Purpose
木村秀継さんとの第2回 1to1（2026-05-29 JST 14:00-15:00）で確認した、株式会社国宝社／BPS木村の製本販売管理システム改善要望を、提案書・簡易モック作成に使える別ドキュメントとして整理する。

## Background
既存の 1to1 履歴ファイルには会話全体、BNI活動知見、フィードバックも含まれている。次の提案活動では、木村さん側の業務要望・制約・確認待ち事項だけを短時間で参照できる資料が必要。

## Related SSOT
SPEC-013 1 to 1 事前準備（NCAS/PDF 添付・テキスト化・AI 原稿生成・BYO key）

## Scope
docs のみ変更する。実装・DB変更・画像ファイル移動は行わない。

## Target Files
- docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md
- docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha_requirements_20260529.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/phases/PHASE_158_kimura_kokuhosha_requirements_PLAN.md
- docs/process/phases/PHASE_158_kimura_kokuhosha_requirements_WORKLOG.md
- docs/process/phases/PHASE_158_kimura_kokuhosha_requirements_REPORT.md
- docs/process/PHASE_REGISTRY.md

## Implementation Strategy
1to1 本体は時系列記録として維持し、要望整理ドキュメント側に「要望」「現状課題」「制約」「対象外」「確認待ち」「簡易モックの観点」を集約する。画像から読み取れる既存画面の情報は、会話内容を補強する観察メモとして扱い、確定仕様とは分けて記録する。

## Tasks
- [ ] 要望整理ドキュメントを新規作成する
- [ ] 1to1 本体から要望整理ドキュメントへリンクする
- [ ] INDEX / progress / PHASE_REGISTRY を更新する
- [ ] 差分を確認する

## DoD
- 木村さん第2回 1to1 由来の要望が、別ドキュメントで確認できる
- 提案書・簡易モック作成に必要な初期スコープ、非スコープ、確認待ち事項が分離されている
- docs/INDEX.md から新規ドキュメントへ辿れる
- docs/dragonfly_progress.md に作業記録がある
- docs/process/PHASE_REGISTRY.md に Phase 158 が記録されている
