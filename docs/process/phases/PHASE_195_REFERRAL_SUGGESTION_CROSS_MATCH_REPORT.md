# REPORT: Phase 195 — リファーラル提案 横断マッチング

**Phase ID:** 195  
**PLAN:** [PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_PLAN.md](PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_PLAN.md)  
**WORKLOG:** [PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_WORKLOG.md](PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_WORKLOG.md)

**完了日:** 2026-06-04 22:51 JST  
**ステータス:** 完了

---

## 1. 概要

- **横断コーパス:** `member_referral_corpus_settings`（オプトイン）、`ReferralRelationshipContextBuilder`（主役 121・同意済み他者 121・**主役/参加者関連定例会のみ**・**introductions 要約**）
- **生成:** `context_mode=document|relationship`（API 未指定時 document、UI は relationship）
- **提案種別:** `subject_should_meet`（章内つなぐ）＋ `via_connector`（社外・つなぎ手経由）。表示は氏名・根拠箇条書き・corpus_meta バナー
- **非スコープ（据え置き）:** Phase F メンバー別ニーズ索引（§0.2）、194 ルール前処理、193 KPI

---

## 2. DoD チェック

- [x] §0.7 貢献 ON/OFF 設定 UI・API
- [x] §0.8.6 `corpus_source` / `subject_should_meet` / `member_network`+`via_connector`
- [x] §0.8 `member_network`+`via_connector` のみ「紹介をお願い」。`subject_should_meet` は「1 to 1（つなぐ）」
- [x] register-introduction: `via_connector` 時 from=つなぎ手、to=依頼者
- [x] Givers Gain: B 直接ボタンなし
- [x] `context_mode=document` 回帰
- [x] `php artisan test` 476 passed
- [x] `npm run build` 成功
- [x] develop merge + Merge Evidence（下記）
- [x] PHASE_REGISTRY `195` → completed

---

## 3. Givers Gain レビュー（§0.8.7）

| チェック | OK |
|----------|-----|
| `member_network` に B 直接コンタクト UI がない | OK |
| `via_connector` の register で from≠依頼者（C）が既定 | OK |
| 貢献 OFF の 121 が他者コーパスに含まれない | OK |

---

## 4. 取り込み証跡（Merge Evidence）

| 項目 | 値 |
|------|-----|
| merge commit id | `8d7768badcb2a27cd6cc2e18b50ec3344a3c6fac` |
| source branch | `feature/phase195-referral-suggest-cross-match` |
| target branch | develop |
| phase id | 195 |
| phase type | implement |
| related ssot | SPEC-015, SPEC-016, SPEC-009 §2.1, REFERRAL_SUGGESTION_COMMON |
| test command | `php artisan test` / `npm run build` |
| test result | 476 passed / build OK |
| scope check | OK |
| ssot check | OK（DATA_MODEL §4.19–4.21） |
| dod check | OK |

---

## 5. 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-06-04 22:19 JST | REPORT 雛形 |
| 2026-06-04 22:51 JST | 実装完了。Pack 強化（主役関連定例会・introductions）・subject_should_meet・UI corpus_meta |
