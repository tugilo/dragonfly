# WORKLOG: BO-AUDIT-P5

## API

- **`GET /api/workspaces`:** 既存 `WorkspaceController::index`（id/name/slug・id 昇順）。追加実装なし。

## UI

- **`ReligoSettings.jsx`:** `me` + workspaces 並列取得。Select はプレースホルダ + 必須選択、**保存は `default_workspace_id` のみ**送信。成功時 `religo-workspace-changed` を dispatch。
- **ルーティング:** `react-admin` の `CustomRoutes` で `/settings`。
- **メニュー:** SETTINGS 配下に「所属チャプター」リンク。

## Header / Dashboard

- **CustomAppBar:** `me.workspace_id` と workspace 一覧で名称表示。`pathname` 変化と `religo-workspace-changed` で再 fetch。
- **Dashboard:** `GET /api/workspaces` を追加取得し、DashboardHeader へ **名前**を渡す。イベントで `loadMe` + `loadWorkspaceRows` を再実行。

## フィット＆ギャップ

- **`/api/users/me`:** 変更なし。PATCH の検証（`exists:workspaces`）は既存のまま。
- **`ReligoActorContext` / BO 監査:** ロジック変更なし。UI は **所属を DB に書く**だけで SSOT と一致。

## 多対多・null

- UI は **選択必須**（空のまま保存不可）。サーバの PATCH `default_workspace_id: null` は API 上は引き続き可能（本 UI では送らない）。
