# リファーラル提案 — 実装 Phase ロードマップ

**機能族 SSOT:** [REFERRAL_SUGGESTION_COMMON.md](../../SSOT/REFERRAL_SUGGESTION_COMMON.md)  
**121:** SPEC-015 · **定例会:** SPEC-016  
**要件 Phase A:** ✅ 2026-06-04（docs のみ）

---

## Phase 対応表（COMMON §9）

| Phase ID | ブランチ（想定） | 種別 | 内容 | SPEC 段階 | 三点セット |
|----------|------------------|------|------|-----------|------------|
| **190** | `feature/phase190-referral-suggest-mvp-api` | implement | migration・Models・AI 生成・generate/get/patch API（121＋定例会） | B MVP（API） | [PLAN](PHASE_190_REFERRAL_SUGGESTION_MVP_API_PLAN.md) / [WORKLOG](PHASE_190_REFERRAL_SUGGESTION_MVP_API_WORKLOG.md) / [REPORT](PHASE_190_REFERRAL_SUGGESTION_MVP_API_REPORT.md) |
| **191** | `feature/phase191-referral-suggest-mvp-ui` | implement | 1to1・Meetings 入口・提案モーダル・`npm run build` | B MVP（UI） | [PLAN](PHASE_191_REFERRAL_SUGGESTION_MVP_UI_PLAN.md) / [WORKLOG](PHASE_191_REFERRAL_SUGGESTION_MVP_UI_WORKLOG.md) / [REPORT](PHASE_191_REFERRAL_SUGGESTION_MVP_UI_REPORT.md) |
| **192** | `feature/phase192-referral-suggest-register-stale` | implement | register-introduction・stale バッジ・過去 run UI | C | [PLAN](PHASE_192_REFERRAL_SUGGESTION_REGISTER_STALE_PLAN.md) / [WORKLOG](PHASE_192_REFERRAL_SUGGESTION_REGISTER_STALE_WORKLOG.md) / [REPORT](PHASE_192_REFERRAL_SUGGESTION_REGISTER_STALE_REPORT.md) |
| **193** | `feature/phase193-referral-suggest-reporting` | implement | introductions 由来フィルタ・ダッシュボード KPI 足場 | D | [PLAN](PHASE_193_REFERRAL_SUGGESTION_REPORTING_PLAN.md) / [WORKLOG](PHASE_193_REFERRAL_SUGGESTION_REPORTING_WORKLOG.md) / [REPORT](PHASE_193_REFERRAL_SUGGESTION_REPORTING_REPORT.md) |
| **194** | `feature/phase194-referral-suggest-rules-p2` | implement | 121 紹介表・MP 節のルール前処理（AI 併用） | E | [PLAN](PHASE_194_REFERRAL_SUGGESTION_RULES_P2_PLAN.md) / [WORKLOG](PHASE_194_REFERRAL_SUGGESTION_RULES_P2_WORKLOG.md) / [REPORT](PHASE_194_REFERRAL_SUGGESTION_RULES_P2_REPORT.md) |
| **195** | `feature/phase195-referral-suggest-cross-match` | implement | §0 理想: 横断・§0.7 同意・§0.8/8.6 二経路・§0.8.7 Givers Gain・紹介お願い UX | F | PLAN 未作成 |

**North Star:** [REFERRAL_SUGGESTION_COMMON.md](../../SSOT/REFERRAL_SUGGESTION_COMMON.md) §0・§0.5・§0.7・§0.8・**§0.8.6–7**。

### Phase 195 DoD（ドキュメント確定分・PLAN に転記）

| # | 項目 | SSOT |
|---|------|------|
| 1 | 横断コーパスは **同意済み** owner の 121 のみ | §0.7 |
| 2 | 提案に `corpus_source`（`self` / `member_network`） | §0.8.6 |
| 3 | `member_network` は **A に紹介お願い**・121 with A 促進。**B 直接ボタンなし** | §0.8, §0.8.7 |
| 4 | `register-introduction` 既定 **from=A, to=C**（②） | §6 |
| 5 | Givers Gain レビュー: C 横取り UI・自動量産なし | §0.8.7 |

---

## 進め方（DevOS）

1. **Phase N の PLAN を読む** → Scope・DoD を確認  
2. `feature/phaseNNN-...` ブランチを切る  
3. 実装し **WORKLOG に判断理由**を追記  
4. `php artisan test`（191 以降は `npm run build` も）  
5. **REPORT** を締め → develop merge → push → Merge Evidence 記録  
6. **PHASE_REGISTRY** を `completed` に更新  
7. **次 Phase の PLAN** へ（本表の順番）

**1 Phase = 1 merge push**（develop 反映まで完了してから次へ）。

---

## 受入テスト用データ（全 Phase 共通）

| ソース | ID / ファイル | 用途 |
|--------|---------------|------|
| 121 | `one_to_ones.id=42`（福田） | `紹介（次廣→）` 表 |
| 121 | `one_to_ones.id=71`（垣谷） | 相互紹介・visitor |
| 定例会 | 第210回 `chapter_weekly_20260602.md` | MP 2名・紹介希望先 |
| 定例会 | 第208回 `chapter_weekly_20260526.md` | MP・求めている紹介先 |

---

## 変更履歴

| 日付 | 内容 |
|------|------|
| 2026-06-04 22:14 JST | Phase 195 DoD 表（§0.8.6 二経路・§0.8.7 Givers Gain・B 直接禁止）。 |
| 2026-06-04 22:07 JST | Phase 195 に §0.7 横断共有同意（設定 UI・同意済みコーパスのみ）を明記。 |
| 2026-06-04 22:03 JST | Phase 195 候補（全記録・関係コンテキスト）をロードマップに追記。COMMON §0 理念と整合。 |
| 2026-06-04 13:38 JST | Phase 190〜194 ロードマップ・三点セット雛形作成。 |
