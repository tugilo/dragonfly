# Phase 311 PLAN — 栗林千代子 初回121事前準備（Webデザイン／平岡国彦紹介ビジター）

**作成:** 2026-09-17 15:00 JST  
**Phase Type:** docs  
**Branch:** `feature/phase311-kuribayashi-chiyoko-121-prep`（作業開始時の作業ツリーは `feature/phase308-takeuchi-shunta-121-second-prep` 上の未コミット混在。commit 時に develop から切り直す）  
**Related SSOT:** SPEC-012, SPEC-013, SPEC-019, `docs/meetings/1to1/README.md`, `docs/PROJECT_NAMING.md`, `.cursor/rules/1to1-dedup.mdc`

---

## Purpose

BNI DragonFly 第221回定例会（2026-09-08）にビジター参加した栗林千代子さん（個人事業主／Webデザイン）との初回121（カレンダー上 2026-09-17 14:15–15:15 JST）に向けて、ユーザー提供のビジター票・対応履歴とカレンダー／DBを突合し、聞き役中心の事前準備ドキュメントを作成する。

---

## Scope

変更可能範囲は docs のみ。

- `docs/meetings/1to1/1to1_kuribayashi_chiyoko_web_design.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_311_kuribayashi_chiyoko_121_prep_PLAN.md`
- `docs/process/phases/PHASE_311_kuribayashi_chiyoko_121_prep_WORKLOG.md`
- `docs/process/phases/PHASE_311_kuribayashi_chiyoko_121_prep_REPORT.md`

---

## DoD

- 栗林千代子さんの基本プロフィール、対応履歴、ほしい紹介（溢れたディレクター／デザイナー）を時刻付きの121文書として保存する。
- 第1回を **2026-09-17（木）JST 14:15–15:15**（Calendar/TimeRex）として記録し、ユーザー連絡の 15:00–16:00 との差分を明記する。
- 聞き役アジェンダ・台本・90秒自己紹介・会後お礼枠を用意する。入会クローズ禁止。
- Religo `members.id=346` を正とし、`one_to_ones` 未存在のため **新規行を作らない**。
- 同日ビジターの川上紗央莉さん、デザイン隣接の米澤さん／堀切さんを混同しない。
- `docs/INDEX.md` / `docs/dragonfly_progress.md` / `docs/process/PHASE_REGISTRY.md` を同期する。
- docsフェーズのため、Laravelテスト・Reactビルドは実行しない。

---

## Tasks

1. 既存1to1運用・SSOT・Phase番号・カレンダー・DBを確認する。
2. 栗林千代子さんの1to1準備ドキュメントを作成する。
3. INDEX と進捗を同期する。
4. PHASE_REGISTRY と REPORT を更新する。
