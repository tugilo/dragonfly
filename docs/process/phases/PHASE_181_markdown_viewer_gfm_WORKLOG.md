# Phase 181 WORKLOG — Markdown ビューア P1

## 判断

1. **GFM 表** — `react-markdown` v10 では pipe 表のパースに `remark-gfm` が必須。`MarkdownView` の `table`/`th`/`td` コンポーネントは Phase 180 で定義済みのため、プラグイン追加のみで効果が出る。
2. **見出し** — 議事録は `##` / `###` が多い。h1〜h3 で fontSize を段階化し、h4 以降は h3 に近いサイズとする。
3. **package.json** — ユーザー承認済み（「OKです…実装を開始」）。node コンテナで `npm install remark-gfm` を実行。
