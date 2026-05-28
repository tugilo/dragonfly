# Phase 148 REPORT: SPEC-011 確認コードメール送信（implement）

## Phase

- **Phase ID:** 148
- **Name:** SPEC-011 確認コードメール送信 implement
- **Type:** implement
- **Completed at:** 2026-05-28 21:54 JST

## 実施内容

- `ReligoRegistrationVerificationMail` + テキスト Blade テンプレート（日本語・6桁コード・TTL）
- `MemberAccountRegistrationService` — 送信成功時 log、失敗時 Cache forget + 503
- `AuthRegisterTest` — Mail::fake 送信断言、503 + Cache クリア、計 7 tests
- `ReligoLogin.jsx` — 「確認コードを送信」、メール案内文言
- `.env.religo_app.example` — SMTP プレースホルダ、`RELIGO_REGISTRATION_EXPOSE_DEBUG_CODE=false`
- Phase 147 docs 同梱、SPEC-011 DoD 更新

## テスト結果

```
php vendor/bin/phpunit --filter=AuthRegisterTest — OK (7 tests, 21 assertions)
php vendor/bin/phpunit — OK (394 tests, 1513 assertions)
npm run build — OK
```

## DoD チェック

| 項目 | 結果 |
|------|------|
| Mailable 送信 | OK |
| 503 + Cache ロールバック | OK |
| debug_code 本番抑止 | OK（config） |
| AuthRegisterTest | OK |
| npm run build | OK |
| scope check | OK |
| ssot check | OK |

## 取り込み証跡（develop への merge 後）

| 項目 | 内容 |
|------|------|
| merge commit id | （merge 後に記載） |
| source branch | develop |
| target branch | develop |
| phase id | 147 + 148 |
| phase type | docs + implement |
| related ssot | SPEC-011 |
| test command | php vendor/bin/phpunit |
| test result | AuthRegisterTest 7 passed |

## 本番確認（人手）

1. `religo_app` `.env` の `MAIL_*` が正しいこと
2. `RELIGO_REGISTRATION_EXPOSE_DEBUG_CODE=false`
3. Members に email 設定済みメンバーで「初回登録」→ メール受信
