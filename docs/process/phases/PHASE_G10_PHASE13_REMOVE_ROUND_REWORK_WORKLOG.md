# Phase G10: phase13 remove round rework — WORKLOG

| Phase ID | G10 |
|----------|-----|
| 作業日 | 2026-03-11 |

---

## 方針

- develop から feature/phase13-remove-round-v2 を新規作成。旧 phase13 は merge しない。
- DragonFlyBoard.jsx のみ変更。backend（Service/api/Model）は develop がすでに round なし前提のため触らない。
- Round 由来の**表示・コメント・内部 label** を "BO" に統一。state 構造（roundsEdit[0].rooms）は維持し API 互換を保つ。

---

## Task 別メモ

- **Task1:** roundsEdit, roundsLoading, roundsSaving, roundsError, selectedRoundIndex, memoContextRoundLabel。表示 "Round 1", round.label, "Round" を洗い出し。
- **Task2:** コメント "Meeting + Round" → "Meeting + BO（Round なし。BO はデフォルト 2）"。setRoundsEdit の label: 'Round 1' → label: 'BO'。メモダイアログの "Round" → "BO"。openMemoDialogForMeetingMember に渡す roundLabel を 'BO' に。
- **Task3:** PHASE_G10_* 作成。REGISTRY/INDEX は G10 完了時に追加。
- **Task4–5:** test → build → REPORT。
