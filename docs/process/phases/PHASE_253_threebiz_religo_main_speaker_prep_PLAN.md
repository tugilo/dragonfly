# Phase 253 PLAN: スリーバイス 2026-06-30 Religo共有 メインスピーカー準備

## Phase Overview

| Item | Value |
|------|-------|
| Phase ID | 253 |
| Name | threebiz_religo_main_speaker_prep |
| Phase Type | docs |
| Status | completed |
| Started At | 2026-06-25 22:25 JST |
| Branch | develop（commit / merge 未実施） |

## Purpose

2026-06-30 JST 08:00-08:45 に予定されているスリーバイス チームMTGで、次廣がメインスピーカーとして Religo の開発経緯・思想・リファーラル創出の仕組みを20分程度で共有するための準備稿を作成する。

あわせて、Gensparkでスライド化しやすいように、準備稿を元にしたスライド生成プロンプトを同一ドキュメント内に整理する。

## Related SSOT

| Spec ID | File | Relevance |
|---------|------|-----------|
| SPEC-018 | `docs/SSOT/TEAM_MEETING_MINUTES_REQUIREMENTS.md` | チームMTG文書の保存場所・front matter・DB連携方針 |
| SPEC-015 / SPEC-016 | `docs/SSOT/REFERRAL_SUGGESTION_COMMON.md` | Religoのリファーラル提案思想、横断共有同意、つなぎ手経由、Givers Gain 整合 |
| SPEC-009 | `docs/SSOT/REFERRAL_RECORDING_REQUIREMENTS.md` | リファーラル記録時の from/to とつなぎ手功績の考え方 |
| — | `docs/PROJECT_NAMING.md` | Religo / DragonFly / dragonfly の命名区別 |

## Scope

### In Scope

- `docs/meetings/team/team_threebiz_20260630.md` の新規作成
- 20分程度の話者用準備稿
- A/B/C/Dを使ったリファーラル経路の説明例
- 「他者の121記録そのものは見せないが、つながりは見せる」方針の明文化
- Zoom文字起こし要約のコピペからAI校正で議事録化する運用説明
- Gensparkスライド生成プロンプト
- `docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md` の同期
- Phase 253 の PLAN / WORKLOG / REPORT 作成

### Out of Scope

- Religo DB への取り込み
- `www/` 配下の実装変更
- 実際のスライド生成
- 2026-06-30 実施後のZoom要約反映

## DoD

- 2026-06-30 08:00-08:45 のスリーバイス チームMTG向けに、Religo共有の目的・話の流れ・20分準備稿・具体例・問いかけが整理されている。
- Religoの思想が、記憶力を記録力で補うこと、会の地図、リファーラル候補、つなぎ手経由、Givers Gain、プライバシー配慮として説明されている。
- Gensparkで読み込ませれば、説明スライドを作れる粒度のプロンプトが含まれている。
- docs変更に合わせて INDEX / progress / PHASE_REGISTRY が同期されている。
- docsフェーズのためテストはスキップし、その理由を REPORT に記録する。

## Tasks

- [x] 関連SSOT・既存チームMTG文書を確認する
- [x] Phase 253 PLAN / WORKLOG / REPORT を作成する
- [x] スリーバイス 2026-06-30 Religo共有準備ドキュメントを作成する
- [x] Gensparkスライド生成プロンプトを作成する
- [x] INDEX / progress / PHASE_REGISTRY を同期する

## Risks / Notes

- 6/30当日の実施後議事録ではないため、本文に「事前準備稿」と明記し、実施後追記枠を残す。
- 他者121の扱いは誤解を招きやすいため、「記録本文を見せる」のではなく「つながりの経路を見せる」と表現する。
- Gensparkプロンプトは、固有名詞とBNIの理念を誤変換しないよう、Religo / DragonFly の命名ルールを明記する。
