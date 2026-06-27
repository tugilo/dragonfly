# Onboarding & Account Provisioning（Religo / DragonFly PoC）

**作成:** 2026-06-27 12:10 JST  
**関連 SSOT:** SPEC-010（AUTH_LOGIN_AND_OWNER_BINDING）、SPEC-011（メンバー初回登録）、SPEC-020 §11.6 順位 9 / §11.8 Phase E  
**Phase:** 266（Onboarding Preparation）

---

## 1. 目的

DragonFly メンバーへ Religo を試験配布する際の **アカウント作成方法を確定**する（SPEC-020 ブロッカー B9 / 順位 9 の解消）。

---

## 2. 現状（As-Is）

| 項目 | 状況 |
|------|------|
| 自己登録 API | **実装済み**。`POST /api/auth/register/request`（email 一致でコード送付）→ `POST /api/auth/register/complete`（コード + パスワードで `users` 作成） |
| owner 紐付け | 登録完了時に `users.owner_member_id = members.id`、`default_workspace_id = members.workspace_id`、`religo_role = member` を自動設定（`MemberAccountRegistrationService`） |
| 登録 UI | `ReligoLogin` 画面に登録フロー（`requestReligoRegistration` / `completeReligoRegistration`） |
| メール送信 | `ReligoRegistrationVerificationMail`。失敗時 503 + ログ |
| `members.email` | **180 名中ごく一部のみ整備**（B9 の主因） |
| Members 編集 | Phase 264/265 で **chapter_admin 限定**。email は `PUT /api/dragonfly/members/{id}` で設定可能（`DragonFlyMemberEmailTest` 済） |

**結論:** アカウント作成の **コード基盤は完成**している。残る課題は **`members.email` の整備（運用）** のみ。新規実装は MVP 段階では不要。

---

## 3. 確定したオンボーディング方式

### 3.1 プライマリ: メンバー自己登録（self-registration）

1. **管理者（次廣）が対象メンバーの `members.email` を登録**（Members 編集画面・admin 限定）。
2. メンバーに Religo の URL と「登録」導線を案内。
3. メンバーが自分の email を入力 → 確認コード受信 → パスワード設定でアカウント作成。
4. 作成時に owner が自動紐付くため、ログイン直後から自分の Owner に固定される（Phase 263 で query 改ざん不可）。

### 3.2 PoC 配布手順（チェックリスト）

- [ ] パイロット対象メンバー（例: 5〜10 名）を選定。
- [ ] 各メンバーの正しい email を Members 編集で登録（重複・別チャプター混在に注意。複数一致はコードが 422 にする）。
- [ ] メール送信設定（本番 SMTP）を確認。ローカル検証時は `RELIGO_REGISTRATION_EXPOSE_DEBUG_CODE=true` で `debug_code` を画面確認可。
- [ ] 対象メンバーへ URL + 登録手順を共有。
- [ ] 登録完了後、各自が自分の 1to1・接触履歴のみ見えることを確認（Phase 263 のスコープ）。

### 3.3 代替: 管理者による仮発行（将来・任意）

メールが使えないメンバー向けに、将来 `chapter_admin` が仮パスワード付きアカウントを発行する管理 API（`POST /api/admin/users` 相当）を検討。**MVP では不要**（自己登録で足りる）。実装する場合は Phase E の追補として別 Phase 化する。

---

## 4. 必要差分（Fit & Gap）

| 項目 | 状況 | MVP 必須 |
|------|------|----------|
| 自己登録 API / UI | 実装済み | — |
| owner 自動紐付け | 実装済み | — |
| `members.email` 整備 | 運用作業（admin が Members 編集で入力） | **Yes（運用）** |
| 本番メール送信設定 | 環境設定 | Yes |
| 管理者仮発行フロー | 未実装 | No（将来） |
| 招待リンク（トークン付き）方式 | 未実装 | No（自己登録で代替） |

---

## 5. 判定

**順位 9（オンボーディング整備）の完了条件「アカウント作成方法が確定」を満たす。**

- 方式: **メンバー自己登録（email 一致 + 確認コード）を正式採用**。
- 前提作業: **admin による `members.email` 整備**（Members 編集・admin 限定）。
- 追加実装: MVP では不要。仮発行・招待リンクは将来拡張。

これにより Phase 267（1to1 実施後記録 MVP）へ進める。
