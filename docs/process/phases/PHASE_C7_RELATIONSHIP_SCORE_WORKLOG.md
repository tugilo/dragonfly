# PHASE C-7 Relationship Score — WORKLOG

**Phase:** C-7

---

## Step1 — score 計算関数

- `calculateRelationshipScore(summary)` を DragonFlyBoard.jsx 内に定義。引数は ContactSummary 相当（null 許容）。戻り値 0〜5。SSOT の計算ルールに従う。

## Step2 — Score UI

- ブロック見出し「Relationship Score」、★ 表示。配置は 🧠 Relationship Summary の下。

## Step3 — CSS

- 既存 MUI / .conn-pane / .pane-body。カード風は C-6 と同様。

## Step4 — fallback

- summary が null または取得前は「—」表示。

## Step5 — 既存 UI

- Relationship Log / Summary の既存表示・fetch は変更しない。追加のみ。

## Step6 — build

- npm run build 成功。
