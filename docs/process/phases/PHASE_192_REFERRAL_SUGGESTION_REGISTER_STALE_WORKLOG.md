# WORKLOG: Phase 192 — REFERRAL-SUGGESTION-REGISTER-STALE

**Phase ID:** 192  
**ステータス:** 実装完了（2026-06-04 21:24 JST）— develop merge 前

---

## 設計判断

| 判断 | 理由 | 日付 |
|------|------|------|
| `ReferralIntroductionRegistrationService` を 121/定例会で共有 | introductions マッピング・トランザクションが同一。formatSuggestion はコールバックで各 Service に委譲 | 2026-06-04 21:24 JST |
| stale は `ReferralSuggestionStaleIndexEnricher` で一覧後バッチ付与 | digest 計算は PHP の `ReferralSuggestionDigest` と一致。SQL で SHA256 しない | 2026-06-04 21:24 JST |
| to が null の提案は「採用…」で Dialog から ID 入力 | SPEC P1: introductions は member to 必須。ラベルのみ候補は手動 to 指定 | 2026-06-04 21:24 JST |
| 過去 run 切替は Phase 191 の Select をそのまま利用 | Phase 192 の UI 要件を満たすため新規タブは不要 | 2026-06-04 21:24 JST |

---

## 実装サマリ

**API**
- `POST .../register-introduction`（121・定例会）
- 一覧 `referral_suggestion_stale`（`GET /api/one-to-ones`・`GET /api/meetings`）

**UI**
- `RegisterReferralIntroductionDialog`（保存のみ / 保存して紹介に登録）
- 一覧「要再生成」Chip（121・Meetings）

**テスト:** ReferralSuggestion + index stale 計 15 passed

---

## ブロッカー

- なし
