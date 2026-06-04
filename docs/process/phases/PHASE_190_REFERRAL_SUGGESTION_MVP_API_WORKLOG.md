# WORKLOG: Phase 190 — REFERRAL-SUGGESTION-MVP-API

**Phase ID:** 190  
**ステータス:** 実装完了（2026-06-04 13:49 JST）— merge 前

---

## 設計判断（実装時に追記）

| 判断 | 理由 | 日付 |
|------|------|------|
| 121 / 定例会で **別 Service**、AI・Normalizer・Digest は共有 | 入口条件・FK・direction 列挙が異なるが run/suggestion パターンは COMMON と同型 | 2026-06-04 |
| 同一 digest 再 generate → **既存 run 返却**（HTTP 201 + `reused_existing_run: true`） | SPEC §4.2。OpenAI 呼び出し抑制 | 2026-06-04 |
| MySQL インデックス名を **短縮**（`o2o_ref_run_*` 等） | 自動生成名が 64 文字超で migration 失敗 | 2026-06-04 |
| Meeting API は **owner_member_id 一致のみ** guard（1to1 は row owner 一致） | 定例会行に owner が無いため acting user の owner で run を分離 | 2026-06-04 |
| `referral_suggestion_stale` を GET list に含める | Phase 192 本格 UI 前でも API 契約を先に固定 | 2026-06-04 |
| routes は **auth:sanctum** ブロック内（prep と同列） | owner 操作・BYO AI と同じ認可帯 | 2026-06-04 |

---

## 実装メモ

- migration 4 テーブル + Models 4
- `ReferralSuggestionDigest` / `ReferralSuggestionMemberRoster` / `ReferralSuggestionPayloadNormalizer`
- `ReferralSuggestionAiService` — OpenAI JSON 出力（Prep と同 Http fake パターン）
- `OneToOneReferralSuggestionService` / `MeetingReferralSuggestionService`
- Controllers + `PatchReferralSuggestionRequest`
- Feature tests 11 件（`OneToOneReferralSuggestionTest` 7 + `MeetingReferralSuggestionTest` 4）

---

## ブロッカー

- なし

---

## テスト

- `php artisan test --filter=ReferralSuggestion` — 11 passed
- 全体 `php artisan test` — 455 passed / 1 failed（`ImportOneToOneNotesCommandTest` — 本 Phase 変更外・要別途確認）
