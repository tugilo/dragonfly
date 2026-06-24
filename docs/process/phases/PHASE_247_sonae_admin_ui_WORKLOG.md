# PHASE_247_sonae_admin_ui WORKLOG

**作成日時:** 2026-06-24 21:22 JST  
**最終更新日時:** 2026-06-24 21:22 JST

---

## アーキテクチャ

- react-admin `CustomRoutes` + nested `/sonae/*`。`Resource` / dataProvider 拡張は避け、`sonaeApi.js` で `{ data, meta }` を直接処理。
- `SonaeChapterProvider` が `ReligoOwnerContext.resolvedWorkspaceId` → `GET /api/sonae/chapters/resolve` → chapter id を解決。未 bootstrap 時は警告表示。
- `ReligoLayout` で `/sonae/*` を Owner 選択バイパス（SONAE は Owner 非依存）。

## 画面実装

| 画面 | 根拠 API |
|------|----------|
| Dashboard | chapter show KPI + training-events 先頭3件 |
| Members | members index / unlinked / sync / import-csv / line-invite |
| LINE | line-account GET/PUT |
| Training | dispatch + index + notification summary |

## API 追加

- `resolve`: PoC 用 workspace_id → sonae_chapters（religo external_id）。Phase 248 で middleware 化予定。
- training index に `notification_id` を追加し、集計ダイアログから summary API を呼べるようにした。
