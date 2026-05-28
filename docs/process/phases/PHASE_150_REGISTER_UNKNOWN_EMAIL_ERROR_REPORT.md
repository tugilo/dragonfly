# Phase 150 REPORT

## Phase

- **Phase ID:** 150
- **Type:** implement
- **Completed at:** 2026-05-28 22:07 JST
- **Related SSOT:** SPEC-011

## 実施内容

- member 未一致時に **422** + `errors.email`（汎用 200 を廃止）
- `AuthRegisterTest` を 422 / Cache なし / Mail 未送信に更新
- UI は既存 catch で email ステップに留まる（コード変更なし）

## Merge Evidence

（merge 後に記載）

merge commit id:
source branch: feature/phase150-register-unknown-email-error
target branch: develop
phase id: 150
phase type: implement
related ssot: SPEC-011

test command: docker compose ... exec app php artisan test
test result: （merge 後に記載）

changed files: （merge 後に記載）

scope check: OK
ssot check: OK
dod check: OK
