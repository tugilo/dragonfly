# Phase 181 PLAN — Markdown ビューア P1（GFM 表・見出し階層）

## 基本情報

| 項目 | 内容 |
|------|------|
| Phase ID | 181 |
| Name | markdown_viewer_gfm |
| Type | implement |
| 作成日時 | 2026-06-02 16:11 JST |
| Branch | feature/phase181-markdown-viewer-gfm |

## Related SSOT

- [FIT_AND_GAP_MARKDOWN_VIEWER.md](../../SSOT/FIT_AND_GAP_MARKDOWN_VIEWER.md) — MV-T01, MV-T02, P1
- SPEC-014 — 議事録 Markdown 表示

## Scope

- `www/package.json`, `www/package-lock.json`（`remark-gfm` 追加）
- `www/resources/js/admin/components/MarkdownView.jsx`
- `docs/SSOT/FIT_AND_GAP_MARKDOWN_VIEWER.md`
- `docs/process/PHASE_REGISTRY.md`, `docs/INDEX.md`, `docs/dragonfly_progress.md`
- Phase 181 PLAN / WORKLOG / REPORT

## DoD

- [x] `remark-gfm` 導入し GFM 表が HTML 表としてレンダリングされる
- [x] h1/h2/h3 の見出しサイズ差を明確化
- [x] 1to1 Dialog / Meetings 議事録タブの表示が退行しない
- [x] `npm run build` 成功
- [x] Fit/Gap MV-T01 / MV-T02 を Fit または Partial→Fit に更新
- [x] PHASE_REGISTRY / progress 更新

## モック比較

対象外（Markdown ビューア専用 UI 改善。モックに相当画面なし）。

## スコープ外（P2 以降）

- Meetings メモタブの Markdown 化（MV04）
- 1to1 履歴メモ（MV05）
- 議事録内相対リンク解決（MV-T05）
