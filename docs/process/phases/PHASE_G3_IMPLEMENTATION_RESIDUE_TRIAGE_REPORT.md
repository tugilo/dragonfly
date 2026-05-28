# Phase G3: Implementation residue triage after G2 — REPORT

| Phase ID | G3 |
|----------|-----|
| Status | completed |
| 完了日 | 2026-03-11 |

---

## Summary

G2 後に残っていた実装寄り差分を 1 ファイルずつ確認し、4 分類（A: commit 候補 / B: 別 Phase / C: 方針確認 / D: 保留）で整理した。**CSV import 関連**（bootstrap/app.php、ImportParticipantsCsvCommand、dragonfly_59people.csv、ImportParticipantsCsvCommandTest）は 1 つの機能単位として **A: 次 Phase で commit 候補**。**religo-admin-mock-v2.html** と **.cursor/** は **C: repo 管理方針確認**。保留（D）はなし。推奨 Next Phase は G4（CSV import bundle）、G5（mock asset 整理）、G6（.cursor 方針）。

---

## Investigated Files

| path | kind | summary | likely related feature | safe to commit now | notes |
|------|------|---------|------------------------|--------------------|-------|
| www/bootstrap/app.php | implementation | ImportParticipantsCsvCommand を withCommands で登録 | Members CSV Import 200 | no（Command とセットで） | 単独では動かない |
| www/app/Console/Commands/ImportParticipantsCsvCommand.php | implementation | 定例会参加者CSVを members/participants に投入する Artisan コマンド | PHASE_MEMBERS_CSV_IMPORT_200 | yes（テスト・CSV とセットで） | 約 400 行、PLAN 参照あり |
| www/database/csv/dragonfly_59people.csv | tooling / data | 第200回用サンプル CSV（59 行、種別・名前・カテゴリ等） | Members CSV Import 200 | yes（コマンド・テストとセットで） | テストがこのパスを参照。.DS_Store は commit しない |
| www/tests/Feature/ImportParticipantsCsvCommandTest.php | test | dragonfly:import-participants-csv の Feature テスト | Members CSV Import 200 | yes（コマンド・CSV とセットで） | PLAN 明記、RefreshDatabase |
| www/public/mock/religo-admin-mock-v2.html | mock | 管理画面モック HTML（1262 行）。docs で SSOT 参照 | Members 等 UI 参照 | hold（方針確認後） | FIT_AND_GAP / MEMBERS_MOCK_VS_UI 等で参照。repo 管理するか要判断 |
| .cursor/rules/devos-v4.mdc | tooling | DevOS v4.3 ルール（alwaysApply） | プロジェクト DevOS | hold（方針確認後） | 個人環境 vs チーム共有で方針が分かれる |

---

## Classification Result

**A. 次の Phase で commit 候補**

- **CSV import bundle（1 単位）**  
  - www/bootstrap/app.php  
  - www/app/Console/Commands/ImportParticipantsCsvCommand.php  
  - www/database/csv/dragonfly_59people.csv  
  - www/tests/Feature/ImportParticipantsCsvCommandTest.php  
- 理由: PHASE_MEMBERS_CSV_IMPORT_200 の実装・テスト・サンプルデータが揃っており、1 機能として成立。既存 PLAN/WORKLOG/REPORT と対応。

**B. 別 Phase に分けるべき候補**

- 該当なし（今回の残差は CSV 1 束と mock・cursor のみ）。

**C. repo 管理方針確認が必要**

- **www/public/mock/religo-admin-mock-v2.html** — docs から SSOT として参照されている。religo-admin-mock.html は既に tracked。v2 を repo に含めるか、別 URL で配布するか方針確認。
- **.cursor/rules/devos-v4.mdc** — プロジェクト共通ルールなら repo 管理の価値あり。個人のみなら .gitignore 候補。

**D. 保留**

- 該当なし。

---

## Commit Candidate Group

- **1 グループ:** Members CSV Import 200（dragonfly:import-participants-csv）  
  - ファイル: bootstrap/app.php, app/Console/Commands/ImportParticipantsCsvCommand.php, database/csv/dragonfly_59people.csv, tests/Feature/ImportParticipantsCsvCommandTest.php  
  - 除外: database/csv/.DS_Store（generated、.gitignore 推奨）

---

## Hold / Exclude Candidate Group

- **方針確認後に commit 検討:** religo-admin-mock-v2.html、.cursor/rules/devos-v4.mdc  
- **commit しない:** .DS_Store（gitignore に追加を提案、実行はしない）

---

## Recommended Next Phases

| phase candidate name | purpose | target files | why separate | risk | recommended order |
|----------------------|---------|--------------|--------------|------|-------------------|
| **G4: CSV import implementation bundle** | PHASE_MEMBERS_CSV_IMPORT_200 の実装を 1 commit で取り込む | bootstrap/app.php, ImportParticipantsCsvCommand.php, dragonfly_59people.csv, ImportParticipantsCsvCommandTest.php | 実装・テスト・サンプルが 1 セット。PLAN 既存。 | 低。テストが CSV パスに依存するため 4 ファイル同時 commit が安全。 | 1 |
| **G5: mock asset / reference file 整理** | mock-v2 を repo 管理するか決め、必要なら commit または .gitignore | www/public/mock/religo-admin-mock-v2.html | docs が SSOT として参照。既存 religo-admin-mock.html との役割整理。 | 方針次第。track するなら INDEX 等の更新が必要。 | 2 |
| **G6: tooling / .cursor 管理方針** | .cursor を track するか、.gitignore するか決める | .cursor/rules/devos-v4.mdc | チームで DevOS を揃えるなら repo 管理、個人のみなら除外。 | 方針次第。 | 3 |

---

## Notes

- G3 では **commit / merge / push は行っていない**。
- ファイル数は少なく、機能単位も明確なため、安全装置（分類不能・判断不能・強依存・分離不能・秘密情報）には該当せず、全件分類済み。
- database/csv/.DS_Store は generated のため commit 対象外。.gitignore に `database/csv/.DS_Store` または `**/.DS_Store` を追加する提案は可能（実行は別 Phase で）。
