# PLAN: Phase 193 — リファーラル提案 レポート・フィルタ（Phase D）

**Phase ID:** 193 / `REFERRAL-SUGGESTION-REPORTING`  
**種別:** implement  
**Related SSOT:** SPEC-015 §7.2, SPEC-016 §7.2, [DASHBOARD_DATA_SSOT.md](../../SSOT/DASHBOARD_DATA_SSOT.md), SPEC-009

**ロードマップ:** [REFERRAL_SUGGESTION_PHASE_ROADMAP.md](REFERRAL_SUGGESTION_PHASE_ROADMAP.md)

**前提:** Phase 192 merge 済み（`introduction_id` リンク運用中）。

---

## 1. 目的

`introductions` 一覧で **121 由来 / 定例会由来** をフィルタ可能にし、ダッシュボードに **「提案経由で登録した紹介（今月）」** KPI 足場を追加する。

---

## 2. スコープ

### 2.1 データ / API

- `introductions` 一覧 API: `source=one_to_one|chapter_meeting` クエリ（JOIN suggestion テーブル）
- または `introductions.source_type` 列追加 migration（PLAN 内でどちらか WORKLOG に決定）

### 2.2 UI

- introductions 一覧フィルタ（未実装 UI があれば。なければ API + 最小 List 拡張）
- Dashboard KPI 1 件（121+定例会合算または分解 — WORKLOG で決定）

### 2.3 docs

- DASHBOARD_DATA_SSOT 更新（KPI 定義）
- FIT/Gap 追記（あれば）

---

## 3. DoD

- [ ] フィルタで 121 起点 / 定例会起点の introductions のみ表示可能
- [ ] ダッシュボード KPI が suggestion 経由件数を反映
- [ ] `php artisan test`（+ UI 変更時 `npm run build`）
- [ ] develop merge + Merge Evidence

---

## 4. ブランチ

`feature/phase193-referral-suggest-reporting`
