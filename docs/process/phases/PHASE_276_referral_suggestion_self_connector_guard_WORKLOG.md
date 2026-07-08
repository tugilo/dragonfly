# Phase 276 WORKLOG: リファーラル提案 — 自己つなぎ手誤提案ガード

tool: cursor

## 2026-07-08 14:41 JST

- 判断: 海沼功 121 の `run #19` で `via_connector` が `from=37 / to=37` と保存された原因は、AI 出力の `connector_member_id=37` を Normalizer が不変条件検証せず採用したこと。
- 判断: COMMON §0.8 の三者モデルでは `connector A != requester C` が必須。実装では UI ではなく保存前の Normalizer で reject する。
- 作成: [FIT_AND_GAP_REFERRAL_SUGGESTION_SELF_CONNECTOR.md](../../SSOT/FIT_AND_GAP_REFERRAL_SUGGESTION_SELF_CONNECTOR.md) に Fit/Gap と Phase 276 の対応方針を整理。
- 作成: 本 Phase PLAN を作成。実装は PLAN 確定後に着手する。

## 2026-07-08 14:52 JST

- 実装: `ReferralSuggestionPayloadNormalizer` で `via_connector` の `fromId === ownerMemberId` / `fromId === toId` を保存前に reject する guard を追加した。
- 実装: 通常社外紹介で AI が `suggested_contact_label` に社外像を返した場合も、`suggested_to_label` に fallback して表示・保存できるようにした。
- 実装: `ReferralSuggestionAiService` のプロンプトに、`connector_member_id` は requester 以外の章内メンバーに限定する指示を追加した。
- 既存データ: `one_to_one_referral_suggestions.id=39` は `from=37 / to=37` の自己つなぎ手誤候補だったため、監査行は残したまま `dismissed` に更新した。
- 検証: `php artisan test --filter=ReferralSuggestionViaConnectorNormalizerTest` → 4 passed / 11 assertions。
- 検証: `php artisan test --filter=ReferralRelationshipGenerateTest` → 5 passed / 18 assertions。
- 検証: `php artisan test` → 590 passed / 2161 assertions。

