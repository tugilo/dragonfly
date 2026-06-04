# PLAN: Phase 192 — リファーラル提案 紹介登録・stale・過去 run

**Phase ID:** 192 / `REFERRAL-SUGGESTION-REGISTER-STALE`  
**種別:** implement  
**Related SSOT:** SPEC-015 §6–§7, SPEC-016 §6–§7, [REFERRAL_SUGGESTION_COMMON.md](../../SSOT/REFERRAL_SUGGESTION_COMMON.md) §6, SPEC-009

**ロードマップ:** [REFERRAL_SUGGESTION_PHASE_ROADMAP.md](REFERRAL_SUGGESTION_PHASE_ROADMAP.md)

**前提:** Phase 191 merge 済み。

---

## 1. 目的

提案の **採用→introductions 登録**、一覧 **stale バッジ**、モーダル **過去 run 切替**を API/UI 両方で完成させる（COMMON / 各 SPEC の Phase C）。

---

## 2. スコープ

### 2.1 API

- `POST /api/one-to-one-referral-suggestions/{id}/register-introduction`
- `POST /api/meeting-referral-suggestions/{id}/register-introduction`（`introductions.meeting_id` 必須）
- `GET /api/one-to-ones` に `referral_suggestion_stale`（N+1 回避の eager または subquery）
- `GET /api/meetings` に同フラグ

### 2.2 UI

- 採用フロー: 編集フィールド → **保存のみ** / **保存して紹介に登録**（確認 Dialog）
- stale バッジ（121 一覧・Meetings 一覧）
- 過去 run セレクト / タブ

### 2.3 テスト

- register-introduction Feature tests（introduction 行 + introduction_id リンク）
- stale フラグ tests

---

## 3. DoD

- [ ] 121 提案から introductions 作成・`one_to_one_id` メタ追跡可能
- [ ] 定例会提案から introductions + `meeting_id`
- [ ] import 後 digest 変更で stale=true
- [ ] `php artisan test` + `npm run build`
- [ ] develop merge + Merge Evidence

---

## 4. ブランチ

`feature/phase192-referral-suggest-register-stale`
