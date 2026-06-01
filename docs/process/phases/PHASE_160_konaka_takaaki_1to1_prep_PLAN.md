# PHASE_160_konaka_takaaki_1to1_prep PLAN

## Phase Type
docs

## Purpose
2026-06-01 JST 15:00-16:00 に予定されている DragonFly メンバー小中貴晃さんとの 1to1 に向け、ユーザー提供のプロフィールシート／ONE to ONE シート／G.A.I.N.S.／推薦・ありがとう情報を既存テンプレートに沿って整理する。

## Background
小中さんは株式会社BeCheerz代表取締役として、AIツール情報発信、AI研修、業務効率化・生産性向上支援、システム開発、医療向けAIカルテ生成支援を扱っている。次廣の業務改善・システム化・AI活用領域と近接するため、初回 1to1 では事業理解に加え、協業境界、紹介条件、相互紹介の言い方を短時間で確認できる準備資料が必要。

## Related SSOT
SPEC-013 1 to 1 事前準備（NCAS/PDF 添付・テキスト化・AI 原稿生成・BYO key）

## Scope
docs のみ変更する。実装・DB変更・画像ファイル移動は行わない。

## Target Files
- docs/meetings/1to1/1to1_konaka_takaaki_becheerz.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_160_konaka_takaaki_1to1_prep_PLAN.md
- docs/process/phases/PHASE_160_konaka_takaaki_1to1_prep_WORKLOG.md
- docs/process/phases/PHASE_160_konaka_takaaki_1to1_prep_REPORT.md

## Implementation Strategy
既存の `docs/meetings/1to1/_TEMPLATE.md` と直近の 1to1 事前資料の構成に合わせ、固定プロフィール、事業理解、G.A.I.N.S.、紹介条件、推薦・ありがとうからの人物像、初回セッション設計、台本、リファーラル戦略、会後追記用の履歴枠を1ファイルにまとめる。ユーザー提供情報で確定している日時は YAML に反映し、Religo DB ID は未登録として TODO にする。

## Tasks
- [x] 小中さん 1to1 事前ドキュメントを新規作成する
- [x] INDEX / progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する
- [x] 差分を確認する

## DoD
- 小中さんとの 1to1 で使えるプロフィール・質問・台本・紹介戦略が1ファイルに整理されている
- `first_session_date` と `first_session_time_jst` が YAML に記載されている
- docs/INDEX.md から新規ドキュメントへ辿れる
- docs/dragonfly_progress.md に作業記録がある
- docs/process/PHASE_REGISTRY.md に Phase 160 が記録されている
