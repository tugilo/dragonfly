# PLAN: Phase 194 — リファーラル提案 ルール前処理（Phase E / P2）

**Phase ID:** 194 / `REFERRAL-SUGGESTION-RULES-P2`  
**種別:** implement  
**Related SSOT:** SPEC-015 §5.1 P2, SPEC-016 §5.1 P2, [REFERRAL_SUGGESTION_COMMON.md](../../SSOT/REFERRAL_SUGGESTION_COMMON.md) §9

**ロードマップ:** [REFERRAL_SUGGESTION_PHASE_ROADMAP.md](REFERRAL_SUGGESTION_PHASE_ROADMAP.md)

**前提:** Phase 193 merge 済み。

---

## 1. 目的

AI 生成の **前処理**として、議事録 md の構造化節から候補を抽出し、AI 入力を enrich する（または AI OFF 時の部分候補）。121 の `紹介（次廣→）` 表、定例会 MP の `紹介希望先` / `求めている紹介先` 見出しを対象。

---

## 2. スコープ

- `ReferralSuggestionRuleParser`（121 / chapter モード）
- generate フロー: ルール候補 → AI プロンプトに同梱 → マージ or AI 優先（WORKLOG で決定）
- Feature tests: `1to1_fukuda` 相当 notes、`chapter_weekly_20260602` 相当 body のフィクスチャ
- WORKLOG にパターン一覧（正規表現 / 見出し）を記録

**対象外:** 内部リファーラル（TYFCB）候補 — 将来 Phase

---

## 3. DoD

- [ ] 121: `紹介（次廣→）` 行から最低 1 候補（AI なしでも rule-only モード or AI 入力 enriched）
- [ ] 定例会: MP 節から `source_section=main_presentation` 候補
- [ ] 既存 Phase 190–193 テスト回帰
- [ ] develop merge + Merge Evidence

---

## 4. ブランチ

`feature/phase194-referral-suggest-rules-p2`

---

## 5. 機能族完了

本 Phase merge 後、COMMON §9 の **A〜E** 実装ロードマップ完了。以降は運用フィードバックで SSOT 改訂。
