# Phase G2: SSOT / docs alignment after G1 — PLAN

| Phase ID | G2 |
|----------|-----|
| Name | SSOT / docs alignment after G1 |
| Type | docs |

---

## Purpose

G1 実行後に残った docs / SSOT の未コミット変更を整理し、Git と DevOS ドキュメントの整合を回復する。

---

## Background

G1（phase12t merge + M4 Members UI suite integration）実行時に、SSOT・process・progress・INDEX 等の docs が未コミットのままワークツリーに残っていた。これらを Phase として明示的に整理し、履歴を壊さずに Git 管理下に置く。

---

## Scope

- **In scope:** docs/SSOT/*、docs/process/*、docs/dragonfly_progress.md、docs/INDEX.md、docs/01_architecture/、docs/02_specifications/、docs/03_operations/、docs/git/*、docs/networking/*（docs 配下の新規・変更）
- **Out of scope:** 実装コード（www/bootstrap/app.php、www/app/Console/、www/resources/*、www/database/csv/、www/tests/ 等）。.cursor/ は含めない。

---

## Tasks

| # | Task | 内容 |
|---|------|------|
| 1 | 変更ファイル分類 | 未コミット変更を A: SSOT/docs、B: Phase ドキュメント、C: 実装コードに分類。G2 では A と B のみ commit。 |
| 2 | docs 整合確認 | 対象ファイルの内容が SSOT / process ルールと矛盾しないことを確認。 |
| 3 | docs commit | Category A と B のファイルのみ add / commit。メッセージ: `G2 SSOT/docs alignment after G1`。 |
| 4 | PHASE_REGISTRY 更新 | G2 を REGISTRY に追加。branch: develop、type: docs、status: completed。 |
| 5 | INDEX 更新 | docs/INDEX.md に G2 Phase（PLAN / WORKLOG / REPORT）を追加。 |
| 6 | REPORT 作成 | 変更ファイル一覧、commit id、push 状態、test/build 結果を REPORT に記載。 |

---

## Risks

- **docs の履歴破壊:** 既存 Phase の REPORT / PLAN を上書きしない。追加・更新のみ。
- **SSOT 誤更新:** 内容不明の変更は commit しない。分類で C に含めたものは除外。

---

## DoD

- [ ] docs（Category A および B）が Git 管理下に入っている。
- [ ] PHASE_REGISTRY に G2 が追加され、整合している。
- [ ] INDEX が G2 Phase ドキュメントを参照している。
- [ ] `php artisan test` および `npm run build` が壊れていない（docs のみの変更のため、既存のままであること）。
