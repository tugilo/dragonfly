# Phase 279 PLAN: リファーラル提案 — 再生成 force（同一 digest でも新 run）

| 項目 | 内容 |
|------|------|
| Phase ID | 279 |
| Type | implement |
| Status | completed |
| Branch | feature/phase279-referral-suggestion-force-regenerate |
| Related SSOT | SPEC-015, SPEC-016, `docs/SSOT/REFERRAL_SUGGESTION_COMMON.md` §3, `docs/SSOT/ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md` §4.2, `docs/SSOT/CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md` |

## Purpose

モーダルの **再生成** 操作で、議事録 digest が前回 run と同一でも **新しい run を作成**できるようにする。初回生成は従来どおり digest 重複抑制（既存 run 再利用）を維持する。

## Scope

| 対象 | 内容 |
|------|------|
| API | `POST .../referral-suggestions/generate` に `force`（boolean）を追加。121 / 定例会両方。 |
| Service | `generate(..., bool $force = false)`。`force=false` 時のみ digest 一致 run を再利用。 |
| UI | 既存 run がある状態の生成ボタン → `force=true`。通知文言を初回/再生成/再利用で分岐。 |
| Tests | 121 / 定例会 Feature test に `force` ケース追加。 |

## Out of Scope

- `dragonfly.sql` 同期
- AI prompt / Normalizer 変更（Phase 276 範囲）
- モック HTML との pixel 比較（ボタンラベル変更のみ）

## DoD

- [x] `force=false`（既定）で同一 digest は既存 run 再利用（既存テスト維持）
- [x] `force=true` で同一 digest でも新 run 作成・AI 呼び出し・`reused_existing_run=false`
- [x] 121 / 定例会 UI から再生成時に `force=true` が送られる
- [x] `php artisan test` 成功
- [x] `npm run build` 成功
- [x] PLAN / WORKLOG / REPORT / PHASE_REGISTRY 同期

## モック比較

docs/SSOT/MOCK_UI_VERIFICATION.md — 再生成ボタン動作のみ。文言差分は FIT_AND_GAP 不要（既存モーダル内操作）。
