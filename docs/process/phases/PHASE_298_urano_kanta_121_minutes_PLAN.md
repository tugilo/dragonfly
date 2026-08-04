# Phase 298 PLAN — 浦野歓太 第1回121 Zoom要約反映

**作成:** 2026-08-03 16:05 JST  
**Phase Type:** docs（ローカルDB notes / status 更新を含む）  
**Branch:** develop（commit / merge 未実施）  
**Related SSOT:** SPEC-012, SPEC-013, SPEC-019, `docs/meetings/1to1/README.md`, `.cursor/rules/1to1-dedup.mdc`, `docs/PROJECT_NAMING.md`

## Purpose

2026-08-03 11:00 JST 開始の浦野歓太さん（株式会社 Anywel／BNI エトワール）第1回121について、ユーザー提供の Zoom 文字起こし要約と NCAS プロフィールを校正し、1to1シリーズ文書として保存する。Zoom取込行が無いため guest member と `one_to_ones` を **1行のみ**手動作成し、二重作成しない。

## Scope

- `docs/meetings/1to1/1to1_urano_kanta_anywel.md`（新規）
- `docs/INDEX.md` / `docs/dragonfly_progress.md` / `docs/process/PHASE_REGISTRY.md`
- Phase 298 PLAN / WORKLOG / REPORT
- ローカルDB: guest `members` ＋ `one_to_ones`（manual/completed）＋ notes import

## DoD

- 【第1回】実施後議事録（成果・合意・アクション・ASR校正・NCASプロフィール）
- 会後お礼文案（案Aメール／案B短文）
- Religo: guest member 1件・`one_to_ones` 1行（同日同相手の重複なし）・notes import
- INDEX / progress / registry 同期
- docsフェーズのため Laravel テスト・React ビルドは実行しない

## Tasks

1. 重複防止確認（浦野・本日 oto が未登録であること）と guest／oto 作成
2. 要約＋NCASプロフィールを校正し 121 文書を作成
3. `import-1to1-notes` と INDEX／progress／registry 同期
