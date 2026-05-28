# Phase G4: CSV import implementation bundle — WORKLOG

| Phase ID | G4 |
|----------|-----|
| 作業日 | 2026-03-11 |

---

## 方針

- 対象 4 ファイル＋G4 docs＋REGISTRY＋INDEX のみを commit。add -A は使わない。
- .DS_Store / .cursor / mock は add しない。

---

## Task 別メモ

- Task1: bootstrap は withCommands([ImportParticipantsCsvCommand::class]) のみ。Command/CSV/Test は PHASE_MEMBERS_CSV_IMPORT_200 で 1 セット。
- Task2: G4 PLAN/WORKLOG/REPORT 作成済み。
- Task3: 明示的に 10 ファイルを add して commit。
- Task4–6: test → build → push → docs 更新。
