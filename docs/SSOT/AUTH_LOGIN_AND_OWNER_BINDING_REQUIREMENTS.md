# Religo：ユーザーログインと Owner（オーナー）紐づけ — 要件 SSOT

| 項目 | 内容 |
|------|------|
| **状態** | **active** — ログインと Owner の要件の正。**改訂は変更履歴＋別 Phase**。 |
| **Spec ID** | **SPEC-010**（[SSOT_REGISTRY.md](../02_specifications/SSOT_REGISTRY.md)） |
| **作成** | **2026-05-18 09:45 JST** |
| **関連** | [ADMIN_GLOBAL_OWNER_SELECTION.md](ADMIN_GLOBAL_OWNER_SELECTION.md)（SPEC-003・§6 認証後方針の先取り）[DATA_MODEL.md](DATA_MODEL.md)（Workspace/User・`owner_member_id`）[USER_ME_AND_ACTOR_RESOLUTION.md](USER_ME_AND_ACTOR_RESOLUTION.md)（acting user）[REFERRAL_RECORDING_REQUIREMENTS.md](REFERRAL_RECORDING_REQUIREMENTS.md)（SPEC-009・owner スコープ）[WORKSPACE_RESOLUTION_POLICY.md](WORKSPACE_RESOLUTION_POLICY.md) |

---

## 1. 背景

- Religo は **「Owner（自分）視点」と `members.id` での `owner_member_id` スコープ**を中心に設計されている（[DATA_MODEL.md](DATA_MODEL.md) §1.2）。
- 管理画面は現状、**グローバルヘッダーで `users.owner_member_id` を選択・永続化**する（[ADMIN_GLOBAL_OWNER_SELECTION.md](ADMIN_GLOBAL_OWNER_SELECTION.md) / SPEC-003）。
- **API の acting user** は `ReligoActorContext` で解決され、認証が無い場合は **`users.id` 昇順先頭**にフォールバックする（[USER_ME_AND_ACTOR_RESOLUTION.md](USER_ME_AND_ACTOR_RESOLUTION.md) §1）。運用上「誰でも同一オペレータ」になる。
- 本ドキュメントは、**ログインアカウント を導入し、そのアカウントが解決すべき Owner（自分のメンバー）と一貫する**ようにするための **製品要件・セキュリティ境界・API 方針**をまとめる。

---

## 2. 目的（Goals）

1. **ログイン後の単一 Actor:** すべての状態変更・閲覧の主体は **`auth()->user()` に解決できる**こと（開発用フォールバックは明示的フラグまたは環境で限定可能とする）。
2. **アカウント と Owner の一意な紐づけ（一般ユーザー）:** 一般ユーザーは **自分に許可された 1 の `members.id` が Owner** となる。画面上の「自分」が **ログインとは別ソースで差し替えられない**（冒称防止）。
3. **API と UI の整合:** `GET /api/users/me` の `owner_member_id` は **認証済みユーザーに紐づく正**とし、既存の React 側 `ReligoOwnerContext` は **サーバ返却と矛盾しない**。
4. **スコープのサーバ強制:** クライアントがクエリ／body で **任意の `owner_member_id` を指定できても、許可されていない ID では処理しない**（403 またはサーバ側上書き方針を別途定義）。
5. **後方整合:** 「Owner ID で関係データをキーングする」という既存モデルは維持する（ADMIN_GLOBAL_OWNER §6 と同旨）。

---

## 3. 用語

| 用語 | 定義 |
|------|------|
| **ログインユーザー** | Laravel `users` の 1 行。認証済みセッション／トークンで特定される。 |
| **Owner メンバー** | `members.id`。Religo での「自分」に相当。**`users.owner_member_id` が参照する値**を正とする（DATA_MODEL と整合）。 |
| **スコープオーナー** | 単一リクエストで「データを誰視点で読むか／書くか」のオーナー。認証後は **原則ログインユーザーの Owner メンバーと同一**。

---

## 4. データモデル要件

### 4.1 既存カラムの意味（維持）

- **`users.owner_member_id`:** 当該ログインユーザーが Religo 上で操作する **自分の `members.id`**。本要件の中心。
- **`users.default_workspace_id`:** 所属チャプター（workspace）。既存の [DATA_MODEL.md](DATA_MODEL.md)・[WORKSPACE_RESOLUTION_POLICY.md](WORKSPACE_RESOLUTION_POLICY.md) に従う。

### 4.2 制約（推奨）

- **一般ユーザー:** `owner_member_id` は **NULL 不可**（初回ログイン後、オンボーディング完了までの一時的 NULL は許容する場合は Phase で定義）。
- **Owner と workspace の整合:** `members.workspace_id` と `users.default_workspace_id` は **運用上矛盾がない**こと（既存の BNI 前提「1 user = 1 workspace」と矛盾する場合は 422／設定ガイダンス）。

### 4.3 将来的拡張（スコープ外の例）

- 1 ユーザーが複数チャプターをまたぐ（users ⇄ workspaces 多対多）は **別仕様**。本要件では **[DATA_MODEL.md](DATA_MODEL.md) の単一チャプター前提**を維持する。
- 「代理入力」権限・マルチ Owner は **別 Spec** とする（本 SPEC では未定義）。

---

## 5. 認証方式（検討枠組み）

本 SSOT は **具体パッケージを固定しない**。次のどれでも満たせることを期待する。

- **セッション + Cookie**（同一オリジン SPA）
- **トークン**（SPA / ネイティブ向け、`Authorization` ヘッダ）

**共通要件:**

- CSRF方針（Cookie セッション時）
- `password_reset`／メール確認の要否は製品運用 Phase で決定
- **`users` とメンバー招待・紐づけ**の運用フロー（§8）

---

## 6. Authorization（サーバ必須）

### 6.1 オーナーの決定順（提案）

| 順位 | ルール |
|------|--------|
| 1 | 認証済みユーザーの **`users.owner_member_id`** を **スコープオーナー**とする。 |
| 2 | リクエストに `owner_member_id` が含まれる場合、**値は (1) と一致する場合のみ許可**。不一致は **403**（または 422 で「権限がありません」）。 |
| 3 | **管理者ロール**（将来）が「他メンバー視点で閲覧・代理操作」できる場合は **明示的に例外**とし、監査ログに **実行者と対象 owner** を残す。未導入なら **全拒否**。 |

### 6.2 既存 API への適用

- **Dashboard / DragonFly / contact-memos / one-to-ones / flags / introductions / internal_referrals** 等、**`owner_member_id` を受け取るエンドポイント**は、認証後は **§6.1 に合わせて検証**する。
- **現行の「query の owner > user.owner」**（例: `App\Http\Controllers\Religo\DashboardController`）は、認証後は **query の任意指定を廃止または管理者限定**に寄せるのが望ましい（一般ユーザーは query 無しで `me` の owner のみ）。

### 6.3 `ReligoActorContext`

- 認証導入後は **`auth()->user()` のみ**を acting user とする（[USER_ME_AND_ACTOR_RESOLUTION.md](USER_ME_AND_ACTOR_RESOLUTION.md) §1 の /2 フォールバックは **本番無効**または **APP_ENV=local のみ**等に限定）。

### 6.4 リファーラル（SPEC-009）

- [REFERRAL_RECORDING_REQUIREMENTS.md](REFERRAL_RECORDING_REQUIREMENTS.md) の **「API は owner スコープ」** を、**ログインユーザーの `owner_member_id` と一致**することで正式に満たす（§6.1 と同一）。

---

## 7. UI 要件

### 7.1 グローバル Owner セレクタ（SPEC-003 との関係）

- **一般ユーザー:** ヘッダーの Owner 選択は **非表示または読み取り専用**（表示するなら氏名のみ）。変更は **管理者オンボーディング／サポート**経由とするか、**設定画面で「自分のメンバー」が確定している限り編集不可**。
- **管理者（将来）:** 代理閲覧が認められるなら、**監査可能な UI** と **警告表示** を必須とする。

### 7.2 オンボーディング

- `owner_member_id` が **未設定のログインユーザー**向けに、**(a) メンバー紐づけ**（一覧から自分を選択・管理者承認）または **(b) 招待トークン**等のフローを定義する。完了まで **[ADMIN_GLOBAL_OWNER_SELECTION.md §4.4](ADMIN_GLOBAL_OWNER_SELECTION.md)** と同様に **Owner が要る画面はロック**でもよい。**例外ルートは `/settings`** のまま検討（所属 workspace と合わせて設定）。

### 7.3 フロントの `PATCH /api/users/me`

- **一般ユーザーによる `owner_member_id` の任意変更は禁止**（403）または **初回のみ 1 回限定**など、運用ポリシーを Phase で確定する。

---

## 8. アカウント provisioning（運用）

次のいずれか（または併用）を Phase で選択する。**本 SSOT は案を列挙するのみ**。

- **招待メール** — ログイン作成時にメンバー ID をバインド
- **初回 SSO / Magic link** — メール一致で members を照合（誤結合リスクの評価が必要）
- **管理者が User を作成**し `owner_member_id` を設定（少人数チャプター向け）

---

## 9. 移行・既存環境

- **単一共有 User + ヘッダー Owner 切替**からの移行では、**既存 `users.owner_member_id`** を各実ユーザーに **分割・コピー**するか、**新規 users 行を発行**するかを Runbook 化する。
- **テスト／シード:** `ReligoActorContext` のフォールバック削除に合わせ、Feature テストは **ログイン状態を明示**する。

---

## 10. 非目標（本ドキュメントの範囲外）

- パスワードポリシー・2FA の詳細
- SAML / OIDC 連携のベンダ別手順
- 監査ログの全列定義（必要なら [BO_AUDIT_LOG_DESIGN.md](BO_AUDIT_LOG_DESIGN.md) または別 SSOT で拡張）

---

## 11. Definition of Done（ドラフト）

Phase ごとに切る場合の **全体完了の目安**。

- [ ] 認証が有効な環境では、**未ログインで Owner 依存 API が使用できない**（401/403）。
- [ ] **`owner_member_id` のサーバ側検証**が主要 API に適用されている（§6）。
- [ ] **`GET/PATCH /api/users/me`** が認証コンテキストと矛盾しない。
- [ ] UI で **一般ユーザーが他者の Owner に切り替えられない**（§7.1）。
- [ ] SPEC-009 含む owner スコープ API と **権限モデルが文書どおり整合**している。
- [ ] `ADMIN_GLOBAL_OWNER_SELECTION` の **§6 認証後方針**と矛盾がないことを相互リンクで明示。
- [ ] `php artisan test` と `npm run build` が-green（implement Phase の受け入れ）。

---

## 12. 変更履歴

| 日時 (JST) | 内容 |
|------------|------|
| 2026-05-18 09:45 | 初版（SPEC-010・要件ドラフト）。 |
| 2026-05-18 10:09 JST | **Phase 126（docs）:** Registry / DATA_MODEL / INDEX と同期。**状態を active に昇格**。 |
