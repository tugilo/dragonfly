# Phase M7-P1-UX: PDF状態の視認性改善 — WORKLOG

**Phase:** M7-P1-UX  
**作成日:** 2026-03-17

---

## 判断

- 要件は「あり → success、なし → default」「アイコン追加（任意）: あり → 📄 or CloudDone」。
- 既に success / default は実装済みのため、追加するのはアイコンのみ。MUI の PictureAsPdfIcon を既存 import で利用し、Chip の icon に指定。fontSize 16 で他 Chip とバランスを取る。
- 「なし」はアイコンを付けずラベルのみとし、やりすぎない方針にした。

---

## 実装内容

- HasParticipantPdfField の「あり」の Chip に `icon={<PictureAsPdfIcon sx={{ fontSize: 16 }} />}` を追加。「なし」は変更なし。
