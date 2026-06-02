# Phase 182 PLAN — Markdown ビューア P2（例会メモ・1to1 履歴メモ）

## 基本情報

| 項目 | 内容 |
|------|------|
| Phase ID | 182 |
| Name | markdown_viewer_p2 |
| Type | implement |
| 作成日時 | 2026-06-02 16:36 JST |
| Branch | feature/phase182-markdown-viewer-p2 |

## Related SSOT

- [FIT_AND_GAP_MARKDOWN_VIEWER.md](../../SSOT/FIT_AND_GAP_MARKDOWN_VIEWER.md) — MV04, MV05, P2

## Scope

- `www/resources/js/admin/pages/MeetingsList.jsx` — Drawer メモタブ
- `www/resources/js/admin/pages/OneToOnesEdit.jsx` — 履歴メモ（contact_memos）閲覧
- `docs/SSOT/FIT_AND_GAP_MARKDOWN_VIEWER.md`
- `docs/process/PHASE_REGISTRY.md`, `docs/INDEX.md`, `docs/dragonfly_progress.md`
- Phase 182 PLAN / WORKLOG / REPORT

## DoD

- [x] Meetings Drawer **メモタブ**が `MarkdownView` で表示（`pre-wrap` 廃止）
- [x] 1to1 Edit **履歴メモ**が `MarkdownView` で表示（編集 textarea は現状維持）
- [x] プレーンテキストのみのメモも退行なく表示
- [x] `npm run build` 成功
- [x] Fit/Gap MV04 / MV05 を **Fit** に更新
- [x] PHASE_REGISTRY / progress 更新

## モック比較

対象外（Markdown ビューア専用 UI 改善）。

## スコープ外

- Members 抜粋（MV06）
- 議事録内相対リンク（MV-T05 / P3）
