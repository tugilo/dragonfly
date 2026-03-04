# PHASE08 Religo workspace_id 自動取得 — WORKLOG

**Phase:** 1 to 1 登録 UI の workspace_id 自動取得  
**作成日:** 2026-03-04

---

## Step 1: ブランチ・PLAN

- develop から `feature/phase08-auto-workspace-id-v1` を作成。
- PHASE08_RELIGO_AUTO_WORKSPACE_ID_PLAN.md を作成。GET /api/workspaces が無いため最小 API 追加を PLAN に含めた。

## Step 2: 最小 API 追加

- **Workspace モデル:** App\Models\Workspace（table: workspaces, fillable: name, slug）。
- **WorkspaceController:** GET /api/workspaces → id 昇順で id, name, slug を返す。
- **routes/api.php:** Route::get('/workspaces', [WorkspaceController::class, 'index'])。

## Step 3: UI 実装（DragonFlyBoard.jsx）

- マウント時（useEffect）に GET /api/workspaces を 1 回呼ぶ。結果を state（workspaces または defaultWorkspaceId / workspaceLoadError）で保持。
- 1 to 1 登録モーダル: 取得成功かつ 1 件以上なら先頭 id を workspace_id に使用。入力欄は read-only で「ワークスペース: {name} (ID: {id})」表示。0 件 or 失敗時はガイド文言を表示し保存ボタン無効。

## Step 4: 手動スモーク（REPORT に記載）

- workspace 取得成功 → 自動で workspace_id が入り planned 登録できること。
- workspace 取得失敗 or 0 件 → 保存不可でガイドが出ること。

## Step 5: ドキュメント

- WORKLOG / REPORT 作成。INDEX と dragonfly_progress を更新。
