# Phase G2: SSOT / docs alignment after G1 — WORKLOG

| Phase ID | G2 |
|----------|-----|
| 作業日 | 2026-03-11 |

---

## 方針

- Category A（SSOT/docs）と B（Phase ドキュメント）のみ commit。Category C（実装コード）は含めない。
- .cursor/、www/bootstrap/app.php、www/app/Console/、www/database/csv/、www/public/mock/、www/tests/Feature/ は G2 では扱わない。

---

## Task 別メモ

- **Task1 分類:** 変更一覧を A/B/C に振り分け。
- **Task2 整合確認:** docs 配下の追加・変更が INDEX / REGISTRY と矛盾しないことを確認。
- **Task3 commit:** `git add` 対象を A+B に限定し、1 commit で push。
- **Task4–6:** REGISTRY / INDEX / REPORT 更新。
