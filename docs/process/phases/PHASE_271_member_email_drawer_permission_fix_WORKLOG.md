# Phase 271 WORKLOG — Members ドロワー email 編集の admin 判定安定化

**Branch:** `feature/phase271-member-email-drawer-permission-fix`

---

## 判断と実装

### 1. ブラウザ確認での発見

Phase 270 後、ブラウザで `http://localhost/admin#/members` を確認したところ、メニュー上は admin 機能が表示され、`/api/users/me` も `religo_role=chapter_admin` を返していたが、ドロワーの email 編集カードは表示されなかった。

原因は、ドロワー内の表示条件が `useReligoOwner().isChapterAdmin` のみに依存しており、Context の初期値・更新タイミングに影響される可能性があること。

### 2. 修正方針

`MemberDetailDrawer` 内に `canEditMemberEmail` state を追加し、ドロワー open 時に `religoFetch('/api/users/me')` で現在ログインユーザーの `religo_role` を直接確認する方式へ変更した。

- 初期値は既存 `isChapterAdmin` を利用。
- `isChapterAdmin` が true なら即表示。
- false の場合でも `/api/users/me` で `chapter_admin` を確認できれば表示。
- API 失敗時は false（非表示）に倒す。

### 3. 確認

- `npm run build` 成功。
- `php artisan test` 567 passed。
- ブラウザで新バンドル `app-dELvr92Q.js` を読み込み、Members 詳細ドロワーに「ログイン用メールアドレス」入力と「メールを保存」ボタンが表示されることを確認。
