# Phase 323 REPORT — 1to1 の手動登録ルールを明確にし、`one_to_ones.id` を正とする

**作成:** 2026-11-06 10:47 JST  
**Phase Type:** docs  
**Status:** completed（2026-11-06 10:46 JST develop へ merge）

---

## 結果

- 1to1 の行の作り方を **Zoom 取込**（自分がホストした Zoom）と **手動登録**（相手主催の Zoom・Meet・対面など取込に出ない面談）の2経路として明文化した。
- ID の正を **`one_to_ones.id`（自動採番）** と明記した。Zoom の会議 ID / UUID は突合用の属性。
- 「Zoom 取込待ち・新規行禁止」を相手主催等の回に当てはめないことを、運用ルール（README・Cursor ルール・スキル・`.cursorrules`）に書いた。
- 衝突しない仕組みを調査し、結果を `ZOOM_IMPORT_DEDUP_REQUIREMENTS.md` §11 に記録した。

## 衝突しない仕組みの調査（要約）

守られていること: `one_to_ones.id` は主キーで経路を問わず一意。Zoom 取込は UUID・予定の会議 ID・同じ owner＋相手＋同じ日の順で既存行を探し、手動行があれば新規作成せず紐づける（テストあり）。議事録取込は既存 id の notes 更新のみ。2026-11-06 時点の DB に重複は 0 件。

残るギャップ（別 Phase のコード変更）:

| # | 内容 |
|---|------|
| G1 | 手動登録 API に重複チェックが無い（運用で防いでいる） |
| G2 | 同日判定は相手 `members` 行の一致に頼る（Phase 322 で照合改善予定） |
| G3 | 予定行に実施の取込が来ても `planned` のまま |
| G4 | 予定の取込は会議 ID 一致で既存とみなす（個人ミーティング ID の再利用で誤紐づけのおそれ） |
| G5 | DB の一意制約なし。同日に同じ相手と2回会うと1行にまとめられる |
| G6 | 回の見出しの無い補足資料が本編の行を上書きする（議事録取込） |

## 変更ファイル

- `docs/meetings/1to1/README.md`
- `docs/meetings/1to1/_TEMPLATE.md`
- `.cursor/rules/1to1-dedup.mdc`
- `.claude/skills/import-religo/SKILL.md`
- `.agents/skills/import-religo/SKILL.md`
- `.cursorrules`
- `docs/SSOT/DATA_MODEL.md`
- `docs/SSOT/ZOOM_IMPORT_DEDUP_REQUIREMENTS.md`
- `docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md`
- `docs/process/phases/PHASE_323_onetoone_manual_registration_rule_{PLAN,WORKLOG,REPORT}.md`
- `docs/process/PHASE_REGISTRY.md`・`docs/INDEX.md`・`docs/dragonfly_progress.md`

## Merge Evidence

merge commit id: 1f872c1ab392bb5a819c56d53029670b0532dc51  
source branch: feature/phase323-onetoone-manual-registration-rule  
target branch: develop  
phase id: 323  
phase type: docs  
related ssot: SPEC-012・ZOOM_IMPORT_DEDUP_REQUIREMENTS・DATA_MODEL §4.12・SPEC-019

test command: php artisan test  
test result: スキップ（docs フェーズ）

changed files（feature commit `2cc40ad`）: `.agents/skills/import-religo/SKILL.md`・`.claude/skills/import-religo/SKILL.md`・`.cursor/rules/1to1-dedup.mdc`・`.cursorrules`・`docs/SSOT/DATA_MODEL.md`・`docs/SSOT/ZOOM_IMPORT_DEDUP_REQUIREMENTS.md`・`docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md`・`docs/meetings/1to1/README.md`・`docs/meetings/1to1/_TEMPLATE.md`・`docs/process/phases/PHASE_323_*`（3件）。INDEX / 進捗 / PHASE_REGISTRY は `feature/docs-sync-20261106` に含めた

scope check: OK（PLAN の Scope 内。コード変更なし）  
ssot check: OK（DATA_MODEL・ZOOM_IMPORT_DEDUP・SPEC-012 を更新。SSOT_REGISTRY の追加は不要）  
dod check: OK
