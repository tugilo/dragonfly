# Phase 276 REPORT: リファーラル提案 — 自己つなぎ手誤提案ガード

## Summary

2026-07-08 14:41 JST — Fit&Gap と PLAN を作成。

2026-07-08 14:52 JST — `via_connector` の自己つなぎ手誤提案を保存前に reject する guard を実装。AI prompt を補強し、通常社外紹介の label fallback も追加した。既存誤提案 `one_to_one_referral_suggestions.id=39` は監査行を残して `dismissed` に更新済み。

## Deliverables

- [FIT_AND_GAP_REFERRAL_SUGGESTION_SELF_CONNECTOR.md](../../SSOT/FIT_AND_GAP_REFERRAL_SUGGESTION_SELF_CONNECTOR.md)
- [PHASE_276_referral_suggestion_self_connector_guard_PLAN.md](PHASE_276_referral_suggestion_self_connector_guard_PLAN.md)
- [PHASE_276_referral_suggestion_self_connector_guard_WORKLOG.md](PHASE_276_referral_suggestion_self_connector_guard_WORKLOG.md)
- `www/app/Services/Religo/ReferralSuggestionPayloadNormalizer.php`
- `www/app/Services/Ai/ReferralSuggestionAiService.php`
- `www/tests/Unit/Religo/ReferralSuggestionViaConnectorNormalizerTest.php`

## Current Status

in_progress（実装・テスト完了、merge 未実施）

## Decisions

- `via_connector` の自己つなぎ手誤提案は、UI だけで隠さず `ReferralSuggestionPayloadNormalizer` で保存前に reject する。
- 通常社外紹介で AI が `suggested_contact_label` に社外像を返すケースは、`suggested_to_label` fallback として扱う方針。
- 既存誤提案 `one_to_one_referral_suggestions.id=39` は、物理削除せず `dismissed` に更新して監査履歴を残す。

## DoD Check

| Item | Result |
|------|--------|
| Fit&Gap 作成 | OK |
| PLAN 作成 | OK |
| WORKLOG 作成 | OK |
| `connector_member_id = requester` reject | OK |
| `from_member_id = to_member_id` reject | OK |
| 正常な `via_connector` 維持 | OK |
| `suggested_contact_label` fallback | OK |
| 既存 #39 の扱い | OK — `dismissed` 更新 |
| test | OK — 590 passed / 2161 assertions |
| React build | 対象外（`www/resources/js` 変更なし） |
| Merge Evidence | 未実施 |

## Test Results

| Command | Result |
|---------|--------|
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test --filter=ReferralSuggestionViaConnectorNormalizerTest` | 4 passed / 11 assertions |
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test --filter=ReferralRelationshipGenerateTest` | 5 passed / 18 assertions |
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` | 590 passed / 2161 assertions |

## Merge Evidence

未実施。実装完了後に記録する。

