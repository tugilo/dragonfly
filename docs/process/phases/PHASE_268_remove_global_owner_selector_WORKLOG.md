# Phase 268 WORKLOG — グローバル Owner セレクタ廃止

**Branch:** `feature/phase268-remove-global-owner-selector`

---

## 判断と実装

### 1. ヘッダー Owner UI の全廃

SPEC-020 ではマルチユーザーで「各メンバーが自分の 1to1 のみ」を前提とするため、ヘッダーで Owner を切り替える導線自体が矛盾する。Phase 265 では admin にのみ Select を残していたが、運用方針として Owner はログインユーザー固定にすると確定したため、`CustomAppBar` から以下を削除した。

- admin 用 `<FormControl>/<Select>`（owner 切替）
- member 用の表示専用 Owner ラベル（`isChapterAdmin` 分岐ごと撤去）
- 未使用になった import（`FormControl` / `InputLabel` / `Select` / `MenuItem` / `formatMemberPrimaryLine`）と `useReligoOwner` から取り出していた `ownerMemberId` / `members` / `savingOwner` / `patchOwner` / `isChapterAdmin`、ハンドラ `handleOwnerChange`。

`resolvedWorkspaceId` / `resolvedWorkspaceName`（所属チャプター表示）のみ Context から取得を継続。

### 2. owner 未設定時の案内更新

`ReligoLayout` の owner 未設定フォールバックは「画面上部の Owner で『自分』を選ぶ」案内だったが、選択 UI を廃止したため文言を更新。自己登録のメール不一致時はチャプター管理者へ連絡する旨に変更し、メンバー紐付けが必要であることを明示。

### 3. データスコープへの影響なし

Owner のスコープ解決は `ReligoOwnerContext` がログインユーザーの `/api/users/me` から取得する既存実装をそのまま使用。ヘッダー UI を消しても各画面のスコープは不変。`patchOwner` は Context に残置（ヘッダーからの呼び出しのみ廃止）。

### 4. ビルド・確認

`npm run build` 成功。ブラウザで Dashboard ヘッダーに Owner プルダウンが表示されないことを確認（検索・ログアウト・所属: DragonFly・通知・ME のみ）。
