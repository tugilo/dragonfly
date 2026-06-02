# Phase 182 WORKLOG — Markdown ビューア P2

## 判断

1. **Meetings メモタブ** — 議事録タブと同じ `MarkdownView`（dense=false）を使い、枠スタイル（`action.hover` + 左ボーダー）は維持。編集は既存 Dialog の textarea のまま（MV07）。
2. **1to1 履歴メモ** — 時系列リスト内のため `dense={true}` でコンパクト表示。追加入力は MuiTextField のまま。
3. **プレーンテキスト** — Markdown パーサはプレーン文字列も段落として表示するため、既存データの互換性は問題なし。
