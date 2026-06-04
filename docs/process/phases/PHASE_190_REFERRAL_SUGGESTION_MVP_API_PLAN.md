# PLAN: Phase 190 — リファーラル提案 MVP API（121＋定例会）

**Phase ID:** 190 / `REFERRAL-SUGGESTION-MVP-API`  
**種別:** implement  
**Related SSOT:** SPEC-015, SPEC-016, [REFERRAL_SUGGESTION_COMMON.md](../../SSOT/REFERRAL_SUGGESTION_COMMON.md), [DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.19–§4.20, SPEC-013（BYO AI）

**ロードマップ:** [REFERRAL_SUGGESTION_PHASE_ROADMAP.md](REFERRAL_SUGGESTION_PHASE_ROADMAP.md)

**前提:** Phase 189 merge 済み。`user_ai_credentials`・`OneToOnePrepService` 利用可。SPEC-015/016 要件（Phase A）merge 済み。

---

## 1. 目的

121（`one_to_ones.notes`）と定例会（`meeting_minutes.body_markdown`）の **リファーラル提案**について、**run 保存・AI 生成・一覧取得・ステータス更新** API を実装する。UI は Phase 191。

---

## 2. スコープ

### 2.1 DB

- migration: `one_to_one_referral_suggestion_runs` / `one_to_one_referral_suggestions`（§4.19）
- migration: `meeting_referral_suggestion_runs` / `meeting_referral_suggestions`（§4.20）
- Eloquent Models（4 テーブル）＋リレーション

### 2.2 共有サービス

- `App\Services\Religo\ReferralSuggestionDigest` — 本文正規化＋ SHA-256
- `App\Services\Religo\ReferralSuggestionAiService` — プロンプト組立・OpenAI 呼出（`OneToOnePrepService` / `AiClientFactory` 流用）
- `App\Services\Religo\OneToOneReferralSuggestionService` — 121 生成・digest 重複抑制・run/suggestion 永続化
- `App\Services\Religo\MeetingReferralSuggestionService` — 定例会側（participants サマリ付き）

### 2.3 API（owner スコープ）

| メソッド | パス |
|----------|------|
| POST | `/api/one-to-ones/{id}/referral-suggestions/generate` |
| GET | `/api/one-to-ones/{id}/referral-suggestions` |
| PATCH | `/api/one-to-one-referral-suggestions/{id}` |
| POST | `/api/meetings/{id}/referral-suggestions/generate` |
| GET | `/api/meetings/{id}/referral-suggestions` |
| PATCH | `/api/meeting-referral-suggestions/{id}` |

**generate 既定:** 同一 digest の最新 run があれば **新 run を作らず**それを返す（COMMON §3）。

**PATCH:** `status`（dismissed/deferred/accepted 準備）・`edited_snapshot`（accepted 用フィールドは Phase 192 で register と連携可、本 Phase は status 更新のみでも可）。

### 2.4 テスト

- `OneToOneReferralSuggestionTest` — 生成・digest 抑制・owner 拒否・completed+notes 前提
- `MeetingReferralSuggestionTest` — has_minutes 前提・MP 議事録フィクスチャ

### 2.5 process / docs

- 本 PLAN / WORKLOG / REPORT
- `PHASE_REGISTRY.md` 更新
- `dragonfly_progress.md` 1 行

### 2.6 対象外（次 Phase）

- React UI（Phase 191）
- `register-introduction`（Phase 192）
- 一覧 `referral_suggestion_stale` フラグ（Phase 192）
- introductions フィルタ・KPI（Phase 193）
- ルール前処理（Phase 194）

---

## 3. 実装タスク（順序）

| # | タスク |
|---|--------|
| 1 | migration 2 本 + Models |
| 2 | ReferralSuggestionDigest |
| 3 | ReferralSuggestionAiService（121 / meeting 用 system prompt 分岐） |
| 4 | OneToOneReferralSuggestionService + Controller + routes |
| 5 | MeetingReferralSuggestionService + Controller + routes |
| 6 | FormRequest（PATCH validation） |
| 7 | Feature tests |
| 8 | REPORT・Registry・progress |

---

## 4. DoD

- [ ] migration 適用可（`php artisan migrate`）
- [ ] 121: `completed` + notes ありで generate → run + suggestions 保存
- [ ] 121: 同一 digest 再 generate → 新 run なし（既存 latest 返却）
- [ ] 定例会: `meeting_minutes` ありで generate → run + suggestions（`source_section` / `subject_member_id` 列）
- [ ] AI 未設定時は 422 または明確エラー（Prep と同趣旨）
- [ ] owner 不一致・前提不足（planned 121 / minutes なし）は 403/422
- [ ] PATCH dismissed / deferred が persist
- [ ] `php artisan test` 全通過
- [ ] WORKLOG に設計判断を記録
- [ ] develop merge + push + Merge Evidence

---

## 5. モック比較

UI 未実装のため本 Phase では **API のみ**。Phase 191 で [MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md) に従う（一覧行アクションは FIT_AND_GAP 更新）。

---

## 6. ブランチ

`feature/phase190-referral-suggest-mvp-api`
