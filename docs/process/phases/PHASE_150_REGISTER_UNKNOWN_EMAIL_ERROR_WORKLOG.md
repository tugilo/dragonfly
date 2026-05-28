# Phase 150 WORKLOG

## 2026-05-28 22:07 JST — Service 422 化

- **判断:** `resolveMemberForRegistration` が null のとき `ValidationException` を throw。
- **理由:** SPEC-011 §5.3 / Phase 149 docs。汎用 200 は verify へ進む UX 問題の根因。
- **メッセージ:** SSOT 記載文言をそのまま使用。

## 2026-05-28 22:07 JST — UI 変更なし

- **判断:** `ReligoLogin.jsx` は変更しない。
- **理由:** `requestReligoRegistration` が 422 で throw → catch が `setError` のみ。`setStep('verify')` は try 内のみ。

## 2026-05-28 22:07 JST — テスト

- **判断:** `test_request_is_generic_for_unknown_email` を 422 断言に改名・拡張（Cache なしも断言）。
