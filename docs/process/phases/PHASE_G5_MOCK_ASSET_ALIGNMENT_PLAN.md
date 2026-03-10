# Phase G5: mock asset / reference file alignment — PLAN

| Phase ID | G5 |
|----------|-----|
| Name | mock asset / reference file alignment |
| Type | docs |

---

## Purpose

religo-admin-mock-v2.html を repo 上の正式な参照資産として整理し、docs / SSOT の参照整合を確保する。

---

## Background

G3 で mock-v2 は「docs/reference asset」として分類され、repo 管理方針の整理対象となった。G4 では CSV import のみ取り込み、mock-v2 は除外した。本 Phase で mock-v2 を Git 管理下に置き、参照 doc との整合を取る。

---

## Scope

- www/public/mock/religo-admin-mock-v2.html（参照資産として track）
- mock-v2 を直接参照している docs/SSOT/process 文書のうち、**必要最小限**の文言更新のみ
- docs/process/phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_PLAN.md
- docs/process/phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_WORKLOG.md
- docs/process/phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_REPORT.md
- docs/process/PHASE_REGISTRY.md
- docs/INDEX.md

---

## Out of Scope

- 実装コード（www/resources, www/app 等）の変更
- .cursor/
- CSV import 関連
- PHASE_G3_* 等、mock-v2 と直接関係ない docs
- 既存 religo-admin-mock.html の内容変更

---

## Target Files

| 種別 | パス |
|------|------|
| 参照資産 | www/public/mock/religo-admin-mock-v2.html |
| G5 Phase docs | docs/process/phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_*.md |
| 履歴 | docs/process/PHASE_REGISTRY.md |
| 索引 | docs/INDEX.md |

必要に応じ、mock-v2 を「repo 管理の参照用モック」と明記する 1 か所のみ最小限更新（例: INDEX の説明行）。既存の FIT_AND_GAP / MEMBERS_MOCK_VS_UI 等の参照パスはそのままでよい（実体を track するだけ）。

---

## Tasks

| # | Task | 内容 |
|---|------|------|
| 1 | mock-v2 の参照関係確認 | どの docs が参照しているか、既存 mock との役割差を確認。 |
| 2 | G5 docs 作成 | PLAN / WORKLOG / REPORT を作成。 |
| 3 | mock-v2 の正式取り込み | 対象ファイルのみ add → commit。 |
| 4 | docs 参照文言の最小更新 | 必要なら INDEX 等 1 か所のみ。 |
| 5 | test/build 実行 | php artisan test、npm run build。 |
| 6 | REGISTRY / INDEX / REPORT 更新 | G5 行追加、INDEX に G5 リンク、REPORT に証跡。 |

---

## Risks

- **既存 mock との役割混同:** religo-admin-mock.html は従来どおり「メイン」、mock-v2 は Members 等の拡張参照用と docs で使い分け済み。役割は衝突しない。
- **docs 参照漏れ:** 既に FIT_AND_GAP、MEMBERS_MOCK_VS_UI、M4* PLAN 等で mock-v2 を参照。実体を track するだけで参照は有効になる。
- **実装資産と参照資産の混線:** 本 Phase では mock ファイルと docs のみ扱い、実装コードは触らない。

---

## DoD

- [ ] mock-v2 が repo 管理下に入っている（git add 済み・commit 済み）。
- [ ] 参照 docs の表現が実態に合う（既存参照パスはそのまま；必要なら INDEX 等 1 か所のみ）。
- [ ] php artisan test および npm run build が壊れていない。
- [ ] PHASE_REGISTRY / INDEX / REPORT が更新されている。
