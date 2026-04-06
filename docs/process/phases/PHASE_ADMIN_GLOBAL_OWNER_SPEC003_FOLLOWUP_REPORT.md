# ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP — REPORT

**Phase ID:** ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP  
**種別:** implement  
**Related SSOT:** [ADMIN_GLOBAL_OWNER_SELECTION.md](../../SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md)

---

## 実施概要

SPEC-003 の follow-up として、`owner_member_id` 未設定時でも **`/settings`（ReligoSettings）を表示**できるようレイアウトを調整し、1 to 1 一覧から **グローバル Owner と二重定義になり得た `owner_member_id` フィルタ UI** を削除した。SSOT §5.1 に **実装と文言の整合用**の補足を追記し、未使用の **`religoOwnerMemberId.js` を削除**した。

**取り込み単位（重要）:** リポジトリの取り込み済みブランチ（`develop` の直前コミット）には **`ReligoOwnerContext` / `religoOwnerStore` / AppBar 連携**が未マージのため、本 Phase のブランチでは **follow-up 差分に加え、グローバル Owner の前提実装（同一コミット）**を含めた。ビルド可能な最小単位であり、PLAN の follow-up 項目（`/settings`・1 to 1 フィルタ・§5.1・死蔵 JS 削除）をすべて含む。

## 変更内容

| 区分 | 内容 |
|------|------|
| レイアウト | `ReligoLayout.jsx`：`useLocation` で `pathname === '/settings'` のときは owner 未設定でも `props.children` を表示（ゲートしない） |
| 一覧 UI | `OneToOnesList.jsx`：`owner_member_id` の `NumberInput` 削除。`filterDefaultValues` は `exclude_canceled` のみ。統計・`TargetMemberFilterSelect`・クイック作成は `useReligoOwner()` の ID を使用 |
| SSOT | `ADMIN_GLOBAL_OWNER_SELECTION.md`：§4.4 に `/settings` 例外、§5.1 に補足段落、メタ表・§8・変更履歴を更新 |
| FIT/GAP | `FIT_AND_GAP_MENU_HEADER.md` §4.1 に `/settings` 例外。`FIT_AND_GAP_MOCK_VS_UI.md` の Owner 行を Context ベースの記述に更新 |
| 削除 | `www/resources/js/admin/religoOwnerMemberId.js` |

## SSOT整合

- §4.4 に **`/settings` のみ**メイン表示の例外を明記（PLAN §7・§10.1）。
- §5.1 に **「独自に owner を決めて付与禁止」**と **`ReligoOwnerContext` / `religoOwnerStore` 由来 ID をクエリに含めることの許容**を追記し、dataProvider 外の `fetch` と矛盾しない読みにした（PLAN §10.3）。
- グローバル単一 Owner の方針は維持（一覧で別 owner を切り替える UI は復活させていない）。

## 判断結果

| 論点 | 採用した決定 |
|------|----------------|
| `/settings` | PLAN §10.1 の推奨案（パターンA） |
| OneToOnesList | PLAN §10.2 の推奨案（UI 削除） |
| §5.1 | PLAN §10.3 の推奨案（SSOT 補足） |
| religoOwnerMemberId.js | PLAN §10.4 の推奨案（削除） |

## 未完了事項

本 Phase のスコープ外として PLAN に列挙済みのもののみ（Owner 検索 UI、全 fetch ラッパ化、サーバ権限など）。

## 次Phase候補

- Owner Select の検索付き（UI）
- 直 fetch の共通ラッパへの段階的移行（リファクタ）
- サーバ側 owner 整合チェック（認証 Phase）

## Merge Evidence

| 項目 | 内容 |
|------|------|
| merge commit id | （merge 後に追記） |
| source branch | `feature/phase-admin-global-owner-spec003-followup`（推奨） |
| target branch | develop |
| test command | `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node npm run build` / `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` |
| test result | `npm run build` 成功（exit 0）。`php artisan test`：**332 passed**（1332 assertions）、Duration 約 6.7s |

## 変更ファイル

### follow-up 差分（PLAN §3.1 直撃）

- `www/resources/js/admin/ReligoLayout.jsx`
- `www/resources/js/admin/pages/OneToOnesList.jsx`
- `www/resources/js/admin/religoOwnerMemberId.js`（削除）
- `docs/SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md`
- `docs/SSOT/FIT_AND_GAP_MENU_HEADER.md`
- `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md`

### 同一 merge に含めた前提実装（`develop` 未取り込みのため）

- `www/resources/js/admin/ReligoOwnerContext.jsx`
- `www/resources/js/admin/religoOwnerStore.js`
- `www/resources/js/admin/app.jsx`
- `www/resources/js/admin/dataProvider.js`
- `www/resources/js/admin/CustomAppBar.jsx`
- `www/resources/js/admin/pages/Dashboard.jsx`
- `www/resources/js/admin/pages/DragonFlyBoard.jsx`
- `www/resources/js/admin/pages/MemberShow.jsx`
- `www/resources/js/admin/pages/MembersList.jsx`
- `www/resources/js/admin/pages/OneToOnesCreate.jsx`
- `www/resources/js/admin/pages/dashboard/DashboardHeader.jsx`

### Phase 記録・INDEX

- `docs/process/phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_{PLAN,WORKLOG,REPORT}.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/dragonfly_progress.md`
- `docs/INDEX.md`
