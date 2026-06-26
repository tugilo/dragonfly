# Phase 257 PLAN: 軍司敦哉 第1回121 Zoom要約反映

## Phase Overview

| Item | Value |
|------|-------|
| Phase ID | 257 |
| Name | gunji_atsuya_first_121 |
| Phase Type | docs |
| Status | completed |
| Started At | 2026-06-26 11:53 JST |
| Branch | develop（commit / merge 未実施） |

## Purpose

2026-03-30 JST 15:30-16:30 に実施された軍司敦哉さんとの初回121について、ユーザー提供の要約とNCASプロフィール情報を校正し、既存の `1to1_gunji_lstep_webhook.md` を正式な1to1シリーズ文書として更新する。

軍司さんはDragonFlyメンバーであり、株式会社Conduct 代表取締役としてLINE公式アカウント運用代行・Lステップ導線設計を行っている。今回の記録では、軍司さんのプロフィール、次廣との協業テーマ、AIチャットボット + LINEシステム、ホットペッパー / サロンボード連携、相互紹介方針、Action Items を後から参照できる形に整理する。

## Related SSOT

| Spec ID | File | Relevance |
|---------|------|-----------|
| SPEC-012 | `docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md` | Zoom / 要約由来の1to1履歴化方針 |
| SPEC-019 | `docs/SSOT/ONETOONE_MULTI_SESSION_IMPORT_REQUIREMENTS.md` | 1相手1ファイル・複数セッション管理方針 |
| SPEC-015 | `docs/SSOT/ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md` | 1to1記録を後続のリファラル提案に活用する文脈 |
| — | `docs/meetings/1to1/README.md` | 1to1文書の命名・front matter・DB取り込み運用 |
| — | `docs/PROJECT_NAMING.md` | Religo / DragonFly / dragonfly の命名区別 |

## Scope

### In Scope

- `docs/meetings/1to1/1to1_gunji_lstep_webhook.md` の更新
- 軍司敦哉さんの基本プロフィール、事業、人物背景、紹介してほしい先の整理
- 2026-03-30 第1回121の主要成果、決定事項、協業テーマ、Action Items、確認待ち事項の整理
- 旧アジェンダ文書の論点を、後続打ち合わせ用の付録として保持
- `docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md` の同期
- Phase 257 の PLAN / WORKLOG / REPORT 作成

### Out of Scope

- Religo DB への取り込み
- `www/` 配下の実装変更
- NCASプロフィールにない実施方法（Zoom / 対面等）の推測補完
- 旧アジェンダ全文の再展開（今回の正は実施後議事録）

## DoD

- 軍司敦哉さんとの第1回121が、日付・時刻付きで1to1シリーズ文書に保存されている。
- 軍司さんのプロフィール、LINE公式アカウント運用代行、次廣側の事業共有、協業可能性、相互紹介方針、Action Items が整理されている。
- docs変更に合わせて INDEX / progress / PHASE_REGISTRY が同期されている。
- docsフェーズのためテストはスキップし、その理由を REPORT に記録する。

## Tasks

- [x] 関連SSOTとPhase番号を確認する
- [x] 既存1to1文書とINDEX登録状況を確認する
- [x] Phase 257 PLAN / WORKLOG / REPORT を作成する
- [x] 軍司敦哉さんの1to1シリーズ文書を更新する
- [x] INDEX / progress / PHASE_REGISTRY を同期する

## Risks / Notes

- 実施方法はユーザー提供情報に明記がないため、本文では TODO として残す。
- Religo `one_to_ones.id` は未確認のため TODO とし、DB取り込みは今回スコープ外とする。
- ユーザー提供要約の `[引用]` 表記は、議事録本文では引用番号として扱わず、要約由来の内容として校正・統合する。
