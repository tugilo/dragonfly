# REPORT: ONETOONES-P3（1 to 1 Create/Edit UX 改善）

## 1. 実施内容サマリ

- 一覧の **Owner フィルタ既定** を `GET /api/users/me` ベースで設定（準備完了までスピナー）。**クイック作成 Dialog**（＋ 1to1を追加）を追加し、フルフォームは「フォームで追加」で維持。
- **フル Create** の `owner_member_id` 初期値に `ownerMemberIdFallback(me)` を使用。
- **メモ Dialog** に notes の位置づけ文案と編集ボタン文言整理。**DATA_MODEL / FIT_AND_GAP** に notes と contact_memos の住み分けを追記。

## 2. 変更ファイル一覧

### 更新

- `www/resources/js/admin/pages/OneToOnesList.jsx`
- `www/resources/js/admin/pages/OneToOnesCreate.jsx`
- `docs/SSOT/DATA_MODEL.md`
- `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- 本 REPORT / PLAN / WORKLOG

### 非変更（前提として既存利用）

- `www/resources/js/admin/religoOwnerMemberId.js`
- `www/resources/js/admin/pages/OneToOnesEdit.jsx`
- `www/resources/js/admin/pages/OneToOnesFormParts.jsx`
- `www/resources/js/admin/app.jsx`

## 3. 実装内容（詳細）

| 領域 | 内容 |
|------|------|
| Owner 既定 | `fetchReligoOwnerMemberId` → `filterDefaultValues`、クイック作成 POST の `owner_member_id`、Create の defaultValues |
| Create UX | `OneToOnesQuickCreateDialog`、Toolbar 2 ボタン構成 |
| notes | Dialog / Create / Edit の helper・タイトルで「要約メモ」「contact_memos は後続」と明示 |
| SSOT | DATA_MODEL §4.12 に **notes** と contact_memos の役割一段落。FIT_AND_GAP O2/O6/O14 等を P3 反映 |

## 4. 確認結果

| 項目 | 結果 |
|------|------|
| `npm run build` | 通過（Vite production build） |
| `php artisan test` | **280 passed**（1147 assertions） |
| Owner 初期値 | me またはフォールバック 1 で一覧・作成が開始できる想定 |
| P1/P2 回帰 | 統軸・フィルタ・行操作・stats API は既存ロジックを維持 |

## 5. 残課題

- 統計と一覧フィルタの完全同期。
- contact_memos 本格統合・1to1 メモ履歴 UI。
- モック級の Create モーダル項目完全一致（日付/時刻分割など）。

## 6. 次 Phase 提案

- stats とフィルタ連動の設計固定。
- `contact_memos` と `one_to_one_id` を踏まえたメモ本流。
- current user / member の正式化（認証導入後の `/api/users/me` 拡張）。

---

## Merge Evidence（develop 取り込み後に追記）

| 項目 | 値 |
|------|-----|
| merge commit id | _（取り込み後）_ |
| source branch | `feature/phase-onetoones-p3-create-edit-ux` |
| target branch | `develop` |
| phase id | ONETOONES-P3 |
| phase type | implement |
| related ssot | FIT_AND_GAP §6, DATA_MODEL §4.12 |
| test command | `php artisan test` |
| test result | _（取り込み後）_ |
| scope check | OK |
| ssot check | OK |
| dod check | OK |
