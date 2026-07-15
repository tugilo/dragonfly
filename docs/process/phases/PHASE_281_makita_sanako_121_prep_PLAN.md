# Phase 281 PLAN — 牧田佐奈子 初回121事前準備

**作成:** 2026-07-15 12:34 JST  
**Phase Type:** implement  
**Branch:** `feature/phase281-makita-sanako-121-prep`  
**Related SSOT:** SPEC-006, SPEC-013, SPEC-021, `docs/meetings/1to1/README.md`, `docs/PROJECT_NAMING.md`

---

## Purpose

2026-07-09 静岡合同懇親会で接点ができた BNI ENISHI チャプターの牧田佐奈子さん（有限会社 HOLON／ダイアナ浜松）との初回121に向けて、ユーザー提供の略歴・G.A.I.N.S.・Canvaメインプレゼンと、次廣のメインプレゼンを軸に、相互プロフィールを深掘りする読み上げ原稿を作成する。

---

## Scope

変更可能範囲は docs とローカルDBへの1to1事前準備反映。

- `docs/meetings/1to1/1to1_makita_sanako_holon.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_281_makita_sanako_121_prep_PLAN.md`
- `docs/process/phases/PHASE_281_makita_sanako_121_prep_WORKLOG.md`
- `docs/process/phases/PHASE_281_makita_sanako_121_prep_REPORT.md`
- ローカルDB: `regions` / `workspaces` / `categories` / `members` / `one_to_ones`（牧田佐奈子さんのクロスチャプター121に必要な行のみ）

---

## DoD

- 牧田佐奈子さんの基本プロフィール、G.A.I.N.S.、メインプレゼン要点を出典に沿って整理する。
- **2026-07-15 13:00–14:00 JST** の初回121について、双方のメインプレゼンを中心にプロフィールを深掘りする60分原稿を作成する。
- 牧田さん側・次廣側それぞれに、説明、深掘り質問、接点確認、クロージングを用意する。
- 未確認事項を断定せず、当日確認する問いとして明示する。
- SPEC-021 の手動クロスチャプター解決に沿って ENISHI・牧田佐奈子さんをローカルDBへ重複なく登録する。
- 2026-07-15 13:00–14:00 JST の `planned` 121を1行だけ作成し、同IDへ原稿を取り込む。
- `docs/INDEX.md` / `docs/dragonfly_progress.md` / `docs/process/PHASE_REGISTRY.md` を同期する。
- React変更はないためビルドは不要。Laravelテストを実行する。

---

## Tasks

1. SSOT・Phase番号・既存1to1運用を確認する。
2. 牧田さんのPDF・Canvaメインプレゼンと、次廣のメインプレゼンを整理する。
3. 初回121の読み上げ原稿を作成する。
4. クロスチャプター相手・121予定をローカルDBへ作成し、原稿を取り込む。
5. INDEX・進捗・PHASE_REGISTRY・WORKLOG・REPORTを同期する。
