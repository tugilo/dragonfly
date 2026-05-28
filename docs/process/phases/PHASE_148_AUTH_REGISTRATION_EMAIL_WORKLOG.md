# Phase 148 WORKLOG: SPEC-011 確認コードメール送信

## 2026-05-28 21:54 JST — Mailable + sync 送信

- **判断:** Laravel 標準 `Mail::to()->send()` を `MemberAccountRegistrationService` 内で同期的に呼ぶ。Queue は SPEC-011 Out of scope。
- **理由:** 登録頻度が低く、既存 `QUEUE_CONNECTION=sync` と整合。

## 2026-05-28 21:54 JST — 送信失敗

- **判断:** `Throwable` を catch → `Cache::forget` → `HttpResponseException` 503 + 汎用 message。コードはログに出さない。
- **理由:** SPEC-011 §5.3 / §6.3。200 で成功を装わない。

## 2026-05-28 21:54 JST — テスト

- **判断:** `Mail::fake()` で送信断言。失敗系は `Mail::shouldReceive('to')->andThrow()`。
- **理由:** SMTP 実接続不要で CI / ローカル再現可能。

## 2026-05-28 21:54 JST — UI

- **判断:** 「確認コードを送信」ボタン文言、verify ステップに「メールに記載の 6 桁」と明記。`debug_code` Alert は従来どおりローカルのみ。
- **理由:** 本番ではメール受信が正規経路。
