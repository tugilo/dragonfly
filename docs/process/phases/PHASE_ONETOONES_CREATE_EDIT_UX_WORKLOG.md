# WORKLOG: ONETOONES-P3（1 to 1 Create/Edit UX）

## Step 1: 現状調査

- **目的:** P1/P2 後の Create/Edit/List の責務と重複を把握する。
- **実施:** `OneToOnesList`・分離済み `OneToOnesCreate` / `OneToOnesEdit`・`GET /api/users/me` を確認。
- **結果:** Create は別ページ、`/api/users/me` は既存（Dashboard でも利用）。Owner フィルタに一覧デフォルトが無く毎回負荷が出うる。
- **影響:** フロント中心。バックエンド変更は不要。

## Step 2: Owner 既定の取得方針

- **目的:** 「自分前提」の操作感とマルチユーザーの両立。
- **実施:** `religoOwnerMemberId.js` の `fetchReligoOwnerMemberId` と `ownerMemberIdFallback` を一覧・作成で共用。一覧は `fetchReligoOwnerMemberId` 完了までローディングし、`filterDefaultValues` を設定してから `List` をマウント（二重リクエストを抑制）。
- **結果:** クイック作成 Dialog も `filterValues.owner_member_id` を Owner として POST。
- **影響:** `OneToOnesList.jsx`、`OneToOnesCreate.jsx`。

## Step 3: Create UX（クイック Dialog）

- **目的:** モーダル必須とせず、一覧上から軽く登録できるようにする。
- **実施:** `OneToOnesQuickCreateDialog`（MUI Dialog + `POST /api/one-to-ones`）。ツールバー主＝Dialog、副＝`/one-to-ones/create`。
- **結果:** 保存後 `useRefresh`・notify・閉じる。
- **影響:** `OneToOnesList.jsx` のみ（List 子コンポーネント構成）。

## Step 4: Edit / notes 導線

- **目的:** 編集・メモの意味を揃える。
- **実施:** 既存 `OneToOnesEdit` のヘッダー・Toolbar・notes helper を維持。一覧メモ Dialog に要約文案と「編集でメモを更新」ラベル。
- **結果:** P1 の編集導線は維持。
- **影響:** 文言中心。

## Step 5: SSOT / 進捗

- **目的:** `notes` vs `contact_memos` を DATA_MODEL / FIT_AND_GAP に短く固定。
- **実施:** §4.12 追記、FIT_AND_GAP §6 行更新、Phase 文書・REGISTRY・INDEX・dragonfly_progress。

## Step 6: 検証

- **目的:** 回帰なくビルド・テスト通過。
- **実施:** `docker compose … exec node npm run build`、`docker compose … exec app php artisan test`。
- **結果:** build OK、`php artisan test` **280 passed**。
