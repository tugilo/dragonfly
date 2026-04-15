# PLAN — ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1

| 項目 | 内容 |
|------|------|
| **Phase ID** | ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1 |
| **種別** | implement |
| **Related SSOT** | SPEC-006、[DATA_MODEL.md](../../SSOT/DATA_MODEL.md)、[ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md](../../SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md) |
| **ブランチ** | `feature/phase-onetoones-cross-chapter-ws-hierarchy-p1` |

## 目的

1. **解釈 A** を製品・SSOT で確定する: `one_to_ones.workspace_id` は **記録コンテキスト（オーナー側チャプター）**、target は別チャプター可。
2. **API/UI** で相手の所属チャプターと「他チャプター」を識別可能にする。
3. **Country > Region > Workspace** の **DB 正規化の入口**を追加する（管理画面の国別 CRUD は非スコープ）。

## スコープ

- Migration: `countries`, `regions`, `workspaces.region_id`（nullable）
- Eloquent: `Country`, `Region`、既存 `Workspace` / `OneToOne` の relation
- `MemberWorkspaceAttributes`、1 to 1 `formatRecord` 拡張、`GET /api/dragonfly/members` / `show` / `GET /api/workspaces`
- 管理画面: 1 to 1 一覧・相手 Autocomplete・サマリカード
- SSOT: `DATA_MODEL.md`, `ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md`, §5.1 文言整理

## 非スコープ

- 複数チャプター所属ユーザーの権限モデル
- Dashboard リードロジック全面改修・guest 仮登録
- 国/リージョンの管理 UI フル実装・既存 workspace の一括バックフィル

## 調査対象（完了）

- `OneToOneIndexService`, `StoreOneToOneRequest`, `DragonFlyMemberController`, admin 1to1 一覧・フォーム

## 実装方針

- **採用案:** `countries` + `regions` + `workspaces.region_id`（代替: 文字列カラムのみは却下し、正規化の入口を優先）
- **API:** 既存キーを壊さず **追加項目**（`recording_workspace_name`, `target_*`, `is_cross_chapter` 等）
- **UI:** `memberDisplay.js` にチャプター付き主行を集約し、直書き散在を避ける

## 影響範囲

- DB 新テーブル 2 + `workspaces` 列 1
- API 応答拡張（後方互換）
- フロント: OneToOnesList, OneToOnesFormParts, memberDisplay

## リスク

- 応答ペイロード増加（許容）
- `toArray()` と `workspace` リレーションの二重: **unset + フラットマージ**で回避

## DoD

1. PLAN / WORKLOG / REPORT 完備、PHASE_REGISTRY / INDEX / progress 更新
2. SSOT に解釈 A と階層が明記されている
3. 1 to 1 API に target 所属・`is_cross_chapter` がある
4. `countries` / `regions` / `workspaces.region_id` が存在する
5. `php artisan test` / `npm run build` 成功
6. 1 commit（本 Phase 完了時）
