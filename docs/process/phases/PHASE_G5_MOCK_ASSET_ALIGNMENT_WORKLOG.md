# Phase G5: mock asset / reference file alignment — WORKLOG

| Phase ID | G5 |
|----------|-----|
| 作業日 | 2026-03-11 |

---

## 方針

- mock-v2 と G5 用 docs、REGISTRY、INDEX のみ commit。add -A 禁止。
- 実装コード・.cursor・CSV・G3 等は触らない。
- 既存の「religo-admin-mock.html = メイン」「religo-admin-mock-v2.html = Members 等参照用」の使い分けはそのまま。

---

## Task 別メモ

- Task1: FIT_AND_GAP、MEMBERS_MOCK_VS_UI、M4* PLAN 等が mock-v2 を参照。既存 asset は religo-admin-mock.html（tracked）のみ。mock-v2 は拡張版として track して問題なし。
- Task2: G5 PLAN/WORKLOG/REPORT 作成済み。
- Task3: mock-v2 + G5 docs + REGISTRY + INDEX のみ add → commit。
- Task4: 参照パスは既に正しいため、INDEX に「参照用モック（mock-v2）」の説明を追加する程度で十分。
- Task5–6: test → build → push → REPORT 証跡。
