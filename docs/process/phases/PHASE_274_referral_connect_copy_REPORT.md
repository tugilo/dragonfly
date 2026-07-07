# Phase 274 REPORT: リファーラル提案 — 紹介文作成（つなぐ準備・コピペ）

## Summary

2026-07-08 08:02 JST — SPEC-022 に基づき、リファーラル提案の**各行**に「紹介文を作成」ボタンと子モーダル（A/B 手動指定・案2）を実装。`POST .../generate-connect-copy` API で了承依頼・グループ初回投稿・つなぎ手依頼の文案ブロックを生成し、クリップボードコピー可能にした。

## Deliverables

- `docs/SSOT/CONNECTION_PREPARATION_REQUIREMENTS.md`（SPEC-022）
- API: `ReferralConnectCopyService`, `ReferralConnectCopyAiService`, 2 エンドポイント
- UI: `ReferralConnectCopyDialog.jsx`, `ReferralSuggestionList.jsx` 更新
- Tests: `ReferralConnectCopyTest`, `ReferralConnectCopyPartyDefaultsTest`

## Decisions

- 案2: 子モーダルで A/B 手動指定。提案はきっかけ + 初期値のみ。
- MVP: コピペ文案のみ。DB 永続化・LINE API は P2。
- `via_connector`: 主導線は「紹介文を作成」。旧「紹介をお願い」は outlined「1 to 1」に降格。
- `introductions` 自動作成なし（採用して登録は既存フロー維持）。

## DoD Check

| Item | Result |
|------|--------|
| SPEC-022 登録 | OK |
| 行ボタン + 子モーダル | OK |
| generate-connect-copy API | OK |
| party_b_label のみ生成 | OK |
| via_connector → connector_request | OK |
| 双方メンバー → consent + group_opening | OK |
| npm run build | OK（ホスト） |
| php artisan test | 未実施（Docker なし・merge 前に必須） |
| Merge Evidence | PR 待ち |

## Merge Evidence

| Item | Value |
|------|-------|
| merge commit id | （未 merge — PR #5） |
| source branch | cursor/referral-connect-copy-c1fc |
| target branch | main（cloud agent）/ develop（ローカル運用時 feature/phase274-referral-connect-copy） |
| phase id | 274 |
| phase type | implement |
| related ssot | SPEC-022, SPEC-015, SPEC-016, SPEC-009 |
| test command | docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test |
| test result | 未実施（cloud agent 環境に Docker なし） |
| changed files | 下記 git diff 参照 |
| scope check | OK |
| ssot check | OK（SPEC-022 ステータス更新） |
| dod check | INCOMPLETE（php artisan test・merge 待ち） |

## Changed files（implement）

```
www/app/Http/Controllers/Religo/MeetingReferralSuggestionController.php
www/app/Http/Controllers/Religo/OneToOneReferralSuggestionController.php
www/app/Http/Requests/Religo/GenerateReferralConnectCopyRequest.php
www/app/Services/Ai/ReferralConnectCopyAiService.php
www/app/Services/Religo/ReferralConnectCopyCorpusBuilder.php
www/app/Services/Religo/ReferralConnectCopyPartyDefaults.php
www/app/Services/Religo/ReferralConnectCopyService.php
www/resources/js/admin/components/ReferralConnectCopyDialog.jsx
www/resources/js/admin/components/ReferralSuggestionDialogCore.jsx
www/resources/js/admin/components/ReferralSuggestionList.jsx
www/resources/js/admin/referralSuggestionApi.js
www/routes/api.php
www/tests/Feature/Religo/ReferralConnectCopyTest.php
www/tests/Unit/Religo/ReferralConnectCopyPartyDefaultsTest.php
docs/SSOT/CONNECTION_PREPARATION_REQUIREMENTS.md
docs/process/phases/PHASE_274_referral_connect_copy_{PLAN,WORKLOG,REPORT}.md
docs/process/PHASE_REGISTRY.md
docs/dragonfly_progress.md
docs/INDEX.md
```
