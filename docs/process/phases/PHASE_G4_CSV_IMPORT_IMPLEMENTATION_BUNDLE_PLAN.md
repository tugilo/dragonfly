# Phase G4: CSV import implementation bundle — PLAN

| Phase ID | G4 |
|----------|-----|
| Name | CSV import implementation bundle |
| Type | implement |

---

## Purpose

Members CSV Import 200 の実装・テスト・サンプル CSV を 1 機能として Git 管理下に取り込む。

---

## Background

G3 にて、CSV import 関連 4 ファイルが 1 commit 候補として分類された。PHASE_MEMBERS_CSV_IMPORT_200 の PLAN/WORKLOG/REPORT は既に docs に存在するため、本 G4 はその実装束の取り込みのみを扱う。

---

## Scope

- **Target files（commit 対象）:**  
  www/bootstrap/app.php  
  www/app/Console/Commands/ImportParticipantsCsvCommand.php  
  www/database/csv/dragonfly_59people.csv  
  www/tests/Feature/ImportParticipantsCsvCommandTest.php  
  docs/process/phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_PLAN.md  
  docs/process/phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_WORKLOG.md  
  docs/process/phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_REPORT.md  
  docs/process/PHASE_REGISTRY.md（G4 行追加）  
  docs/INDEX.md（G4 Phase リンク追加）

---

## Out of Scope

- .cursor/
- www/public/mock/religo-admin-mock-v2.html
- database/csv/.DS_Store
- docs/process/phases/PHASE_G3_*（G3 は別 commit 候補）
- その他 docs / 実装残差

---

## Tasks

| # | Task | 内容 |
|---|------|------|
| 1 | 対象 4 ファイルの内容最終確認 | bootstrap は Command 登録のみ、Command/CSV/Test が 1 セットであることを確認。 |
| 2 | G4 docs 作成 | PLAN / WORKLOG / REPORT を作成。 |
| 3 | 対象ファイルのみ commit | add -A 禁止。上記 10 ファイルのみ add → commit。 |
| 4 | test/build 実行 | php artisan test、npm run build。 |
| 5 | push | origin develop。 |
| 6 | PHASE_REGISTRY / INDEX / REPORT 更新 | G4 行追加、INDEX に G4 リンク、REPORT に Merge Evidence。 |

---

## Risks

- **対象外ファイルの混入:** add するパスを明示し、.DS_Store / .cursor / mock を add しない。
- **CSV パス依存:** テストが `database_path('csv/dragonfly_59people.csv')` を前提とするため、CSV を同時に commit する。
- **bootstrap 単独変更の誤解:** Command 登録のみであり、Command クラスとセットで 1 機能であることを REPORT に明記する。

---

## DoD

- [ ] 対象 4 ファイルのみで機能単位として commit されている（＋ G4 docs、REGISTRY、INDEX）。
- [ ] php artisan test が通る。
- [ ] npm run build が通る。
- [ ] PHASE_REGISTRY / INDEX / REPORT が更新されている。
