# Phase 265 WORKLOG — Member UI Separation

**Branch:** `feature/phase265-member-ui-separation`

---

## 判断ログ

### role の配布
- react-admin の `usePermissions()` / function-as-child を活用するため、`authProvider.getPermissions()` が `/api/users/me` の `religo_role` を返すよう実装。モジュールスコープでキャッシュし `religo-auth-changed`・login・logout でクリア。
- AppBar は既に `ReligoOwnerContext` が `/api/users/me` を取得済みのため、再 fetch を避けて context に `religoRole` / `isChapterAdmin` を追加して利用。

### Resource / route 分岐
- `<Admin>` を function-as-child 化し、`permissions === 'chapter_admin'` のときのみ Categories/Roles Resource、`MemberEdit`、member-merge / SONAE ルートを描画。
- `/settings`（所属チャプター）と `/zoom-import` は member にも残す（自分のチャプター確認・自分の Zoom 取り込みは member 機能）。

### メニュー
- `ReligoMenu` で `usePermissions()` により Member merge / SONAE セクション / Categories / Roles を member 非表示。SETTINGS 見出しと「所属チャプター」は維持。

### Owner 表示専用
- `CustomAppBar` は admin のみ Owner Select を表示。member は owner 名を静的ラベル表示（変更不可）。owner はサーバ側で固定（Phase 263）済み。

### 結果
- `npm run build` 成功。
- バックエンド非変更、`php artisan test` 567 passed（回帰確認）。
