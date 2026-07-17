# Phase 282 PLAN — 今村千絵 初回121事前準備

**作成:** 2026-07-15 14:02 JST  
**Phase Type:** implement  
**Branch:** `feature/phase282-imamura-chie-121-prep`  
**Related SSOT:** SPEC-013, SPEC-019, `docs/meetings/1to1/README.md` §重複防止, `docs/PROJECT_NAMING.md`

---

## Purpose

DragonFly メンバー・今村千絵さん（Latte Hua／身体と心を整えるダイエットコーチング）との **2026-07-15 14:00–15:00 JST** 初回121に向け、NCASプロフィールと第215回定例会メインプレゼンを軸に、相互プロフィールを深掘りする読み上げ原稿を作成し、Zoom取込済みの `one_to_ones` 行へ取り込む。

---

## Scope

変更可能範囲は docs とローカルDBへの1to1事前準備反映。

- `docs/meetings/1to1/1to1_imamura_chie_latte_hua.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_282_imamura_chie_121_prep_PLAN.md`
- `docs/process/phases/PHASE_282_imamura_chie_121_prep_WORKLOG.md`
- `docs/process/phases/PHASE_282_imamura_chie_121_prep_REPORT.md`
- ローカルDB: `members`（今村さん `id=47` の `ncast_profile_url` 等・必要最小限）／`one_to_ones`（既存 `id=113` の notes 更新のみ。**新規行禁止**）

---

## DoD

- NCAS・第215回MPから基本プロフィール、G.A.I.N.S.、ONE to ONE シート、メインプレゼン要点を出典に沿って整理する。
- **2026-07-15 14:00–15:00 JST** の初回121について、双方のメインプレゼンを中心にプロフィールを深掘りする60分原稿を作成する。
- Zoom取込済み `one_to_ones.id=113` を正とし、同日・同相手の新規行を作らない。
- 同IDへ原稿を `import-1to1-notes` で取り込み、`members.id=47` に NCAS URL を反映する。
- 未確認事項（病名など）を断定せず当日確認の問いとして明示する。
- `docs/INDEX.md` / `docs/dragonfly_progress.md` / `docs/process/PHASE_REGISTRY.md` を同期する。
- React変更はないためビルドは不要。Laravelテストを実行する。

---

## Tasks

1. SSOT・Phase番号・既存 `one_to_ones`（Zoom #113）を確認する。
2. NCAS・定例会MP・次廣メインプレゼンから原稿を作成する。
3. 既存 #113 へ notes 取込、member の NCAS URL を更新する。
4. INDEX・進捗・PHASE_REGISTRY・WORKLOG・REPORT を同期する。
