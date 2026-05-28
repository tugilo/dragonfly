# Phase 149 PLAN: SPEC-011 member 未一致 — 初回登録画面エラー表示（docs）

## Phase

- **Phase ID:** 149
- **Name:** 初回登録 — members.email 未一致時の UX 要件改定
- **Type:** docs
- **Started at:** 2026-05-28 22:05 JST

## Related SSOT

- **SPEC-011:** `docs/SSOT/AUTH_REGISTRATION_EMAIL_REQUIREMENTS.md`

## 背景

本番で `tugi@tugilo.com` を初回登録した際、**Members に email 未登録**のためメールもコードも発行されなかったが、API は 200 汎用メッセージのため UI が確認コードステップへ進み、ユーザーが詰まった。

## Scope

- SPEC-011 の §2 / §4 / §5.3 / §7 / §8 / §9 / §12 更新
- Phase 149 PLAN / WORKLOG / REPORT
- PHASE_REGISTRY、INDEX、dragonfly_progress

## Out of scope

- API / UI のコード変更（**次 implement Phase**）

## DoD

- [x] member 未一致時 **422 + 画面エラー**が SPEC-011 に明記されている
- [x] 列挙リスクと UX のトレードオフが §7.1 に記録されている
- [x] Phase 149 implement 用 DoD（§12）が定義されている

## 次 Phase（implement 想定）

- Service / ReligoLogin / AuthRegisterTest の改修
