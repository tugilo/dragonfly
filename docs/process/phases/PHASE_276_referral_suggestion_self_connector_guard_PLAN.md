# Phase 276 PLAN: リファーラル提案 — 自己つなぎ手誤提案ガード

## Phase 情報

| 項目 | 内容 |
|------|------|
| Phase ID | 276 |
| Phase 種別 | implement |
| ブランチ | `feature/phase276-referral-self-connector-guard` |
| 開始 | 2026-07-08 14:41 JST |
| Status | in_progress |

## 背景・目的

海沼功さんとの 121（`one_to_ones.id=110`）後にリファーラル提案を生成したところ、`via_connector` 提案として **`suggested_from_member_id=37` / `suggested_to_member_id=37`** が保存され、「次廣さんが次廣さんに紹介する」意味のない候補が表示された。

COMMON §0.8 の `via_connector` は「他メンバー A の社外 contact B を、依頼者 C へ紹介してもらう」導線であり、**A と C は別人**でなければならない。

本 Phase では、AI が誤って依頼者本人を connector として返しても、サーバ側で保存前に破棄し、必要に応じて UI / 文言も補強する。

## Related SSOT

- **SPEC-015** [ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md](../../SSOT/ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md)
- **SPEC-016** [CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md](../../SSOT/CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md)
- **SPEC-022** [CONNECTION_PREPARATION_REQUIREMENTS.md](../../SSOT/CONNECTION_PREPARATION_REQUIREMENTS.md)
- [REFERRAL_SUGGESTION_COMMON.md](../../SSOT/REFERRAL_SUGGESTION_COMMON.md) §0.8 / §0.8.6 / §0.8.7
- [FIT_AND_GAP_REFERRAL_SUGGESTION_SELF_CONNECTOR.md](../../SSOT/FIT_AND_GAP_REFERRAL_SUGGESTION_SELF_CONNECTOR.md)

## Scope

### In

| 領域 | 対象 |
|------|------|
| Normalizer | `www/app/Services/Religo/ReferralSuggestionPayloadNormalizer.php` |
| AI prompt | `www/app/Services/Ai/ReferralSuggestionAiService.php` |
| UI 防御（必要時） | `www/resources/js/admin/components/ReferralSuggestionList.jsx`、`www/resources/js/admin/referralSuggestionApi.js` |
| Tests | `ReferralRelationshipGenerateTest` または Normalizer unit test、既存 `ReferralSuggestionViaConnectorNormalizerTest` 拡張 |
| Docs | Fit&Gap、Phase 276 三点セット、INDEX、progress、PHASE_REGISTRY |

### Out

- `introductions` のデータモデル変更
- LINE / Messenger 連携
- `document` / `relationship` 生成モード選択 UI の本格追加
- 横断コーパス同意モデルの再設計
- 既存 run の物理削除

## Tasks

1. **Normalizer guard** — `via_connector` で `fromId === ownerMemberId` または `fromId === toId` の候補を保存しない。
2. **Label fallback** — 通常社外紹介で AI が `suggested_contact_label` を返した場合も `suggested_to_label` として拾えるようにする。
3. **Prompt hardening** — `connector_member_id` は requester 以外の章内メンバーのみ、と明示する。
4. **Tests** — 自己つなぎ手候補が保存されないこと、正常な `via_connector` は維持されること、label fallback が効くことを確認。
5. **Existing data handling** — `one_to_one_referral_suggestions.id=39` を `dismissed` にするか、REPORT に判断を記録する。
6. **Verification** — `php artisan test`、React 変更時は `npm run build`。
7. **Docs sync** — Fit&Gap、INDEX、progress、PHASE_REGISTRY、REPORT を同期。

## DoD

- [ ] `via_connector` で `connector_member_id = requester` の AI 出力が suggestion として保存されない。
- [ ] `via_connector` で `from_member_id = to_member_id` の suggestion が保存されない。
- [ ] 正常な `via_connector`（他メンバー A → requester C、contact label あり）は保存される。
- [ ] 通常社外紹介で `suggested_contact_label` に入った社外像が表示用 `suggested_to_label` に残る。
- [ ] 海沼功 121 の再生成で「次廣→次廣」候補が出ない、または既存 run の誤候補が却下済みとして扱われる。
- [ ] `php artisan test` が成功する。
- [ ] React を変更した場合、`npm run build` が成功する。
- [ ] `docs/INDEX.md` / `docs/dragonfly_progress.md` / `docs/process/PHASE_REGISTRY.md` / REPORT が同期されている。

## 実装方針

最優先は **AI 出力を信用しすぎないサーバ側不変条件**。UI で隠すだけでは run に不正候補が残るため、`ReferralSuggestionPayloadNormalizer` で reject する。

`via_connector` の正しい形は `from=A`, `to=C`, `A != C`, `contactLabel != null`。この条件を満たさないものは、AI raw response には残っても suggestion 行には保存しない。

## Open

- [ ] 既存誤提案 #39 を手動で `dismissed` 更新するか。
- [ ] `relationship` 生成の説明を今回の UI scope に含めるか。
- [ ] `consented_owner_count=0` なのに `member_network` が出る場合の扱いを P0 で止めるか、P2 とするか。

