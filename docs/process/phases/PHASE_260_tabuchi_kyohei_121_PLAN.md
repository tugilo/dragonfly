# Phase 260 PLAN: 田渕恭平 第1回121 Zoom要約反映

## Phase Overview

| Item | Value |
|------|-------|
| Phase ID | 260 |
| Name | tabuchi_kyohei_121 |
| Phase Type | docs |
| Status | completed |
| Started At | 2026-06-26 14:21 JST |
| Branch | develop（commit / merge 未実施） |

## Purpose

2026-05-14 JST 17:00-18:00 に実施された BNI DragonFly 田渕恭平さんとの第1回121について、ユーザー提供のZoom文字起こし要約とプロフィール情報を校正し、既存の1to1シリーズ文書へ実施後議事録として反映する。

田渕さんは田渕石材株式会社の6代目後継者として、庵治石を墓石・建築・庭園だけでなく、インテリア、アパレル、アクセサリー、体験価値へ広げる「令和の新石器時代」を掲げている。今回の記録では、田渕さんの事業・次廣のAI業務改善システム構築・相互紹介方針・業務整理ニーズ・Action Items を後から参照できる形に整理する。

## Related SSOT

| Spec ID | File | Relevance |
|---------|------|-----------|
| SPEC-012 | `docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md` | Zoom由来の1to1要約を履歴化する方針 |
| SPEC-019 | `docs/SSOT/ONETOONE_MULTI_SESSION_IMPORT_REQUIREMENTS.md` | 1相手1ファイル・複数セッション管理方針 |
| SPEC-015 | `docs/SSOT/ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md` | 1to1記録を後続のリファラル提案に活用する文脈 |
| — | `docs/meetings/1to1/README.md` | 1to1文書の命名・front matter・DB取り込み運用 |
| — | `docs/PROJECT_NAMING.md` | Religo / DragonFly / dragonfly の命名区別 |

## Scope

### In Scope

- `docs/meetings/1to1/1to1_tabuchi_kyohei_tabuchi_stone.md` の第1回121実施後議事録への更新
- 田渕さんの基本プロフィール、庵治石事業、「令和の新石器時代」構想、次廣側の事業共有、相互紹介方針、Action Items の整理
- `docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md` の同期
- Phase 260 の PLAN / WORKLOG / REPORT 作成

### Out of Scope

- Religo DB への取り込み
- `www/` 配下の実装変更
- Zoom原文の引用番号付け
- 電話番号・メールアドレス等の既存プロフィール記載方針の変更

## DoD

- 田渕恭平さんとの第1回121が、時刻付きで1to1シリーズ文書に保存されている。
- 田渕さんの事業、庵治石の価値、次廣側の事業共有、相互紹介方針、Action Items が整理されている。
- docs変更に合わせて INDEX / progress / PHASE_REGISTRY が同期されている。
- docsフェーズのためテストはスキップし、その理由を REPORT に記録する。

## Tasks

- [x] 関連SSOTとPhase番号を確認する
- [x] 既存1to1文書の有無と構造を確認する
- [x] Phase 260 PLAN / WORKLOG / REPORT を作成する
- [x] 田渕恭平さんの1to1シリーズ文書を実施後議事録へ更新する
- [x] INDEX / progress / PHASE_REGISTRY を同期する

## Risks / Notes

- 既存ファイルは事前準備文書として作成済みだったため、新規作成ではなく `### 【第1回】2026-05-14` のTODOを実施後議事録に差し替える。
- Religo `one_to_ones.id` は既存記載の **82** を維持するが、DB取り込みは今回スコープ外とする。
- ユーザー提供要約の `[引用]` 表記は、議事録本文では引用番号として扱わず、Zoom要約由来の内容として校正・統合する。
