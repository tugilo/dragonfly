# WORKLOG: Phase 186 — ONETOONES-CANCEL-UI-P1

## 判断

- **Cancel Dialog:** `religoFetch` で POST cancel を直接呼ぶ（dataProvider に cancel 未追加・一覧専用のため）。
- **Edit:** `ONE_TO_ONE_STATUS_CHOICES_EDIT` で canceled 除外。既に canceled の行は read-only 表示 + 理由 Chip。
- **理由 Chip:** 状態列に status + cancel_reason ラベルを横並び（§10.1 #4）。
