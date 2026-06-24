# PHASE_248_sonae_religo_shell WORKLOG

**作成日時:** 2026-06-24 21:28 JST  
**最終更新日時:** 2026-06-24 21:28 JST

---

## chapter 解決

- `ReligoActorContext::resolveWorkspaceIdForUser` を正とし、`SonaeChapterResolver` で `sonae_chapters.external_id` と突合。
- Phase 247 の `resolve?workspace_id=` は後方互換で残し、Shell 正本は `GET /api/sonae/context`。

## middleware

- `sonae.chapter` は chapter スコープ API 全体に適用。route `{chapter}` がユーザーの workspace 紐付け chapter と一致しない場合 403。
- 未 bootstrap は 404 + `bootstrap_required: true`（他 chapter id 指定時は 403 を優先）。

## UI

- `SonaeChapterContext` を context API 駆動に変更。bootstrap ボタンで `POST /api/sonae/chapters/bootstrap`。
- Dashboard に Religo 同期（訓練前の手動 sync 導線）。

## テスト

- `SonaeChapterTestHelpers` で user.default_workspace_id + religo chapter を共通化。
- 既存 Sonae Feature テストを middleware 通過形に更新。
