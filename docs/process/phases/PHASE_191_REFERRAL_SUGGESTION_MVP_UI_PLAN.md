# PLAN: Phase 191 — リファーラル提案 MVP UI（121＋定例会）

**Phase ID:** 191 / `REFERRAL-SUGGESTION-MVP-UI`  
**種別:** implement  
**Related SSOT:** SPEC-015 §10, SPEC-016 §10, [REFERRAL_SUGGESTION_COMMON.md](../../SSOT/REFERRAL_SUGGESTION_COMMON.md), [MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md)

**ロードマップ:** [REFERRAL_SUGGESTION_PHASE_ROADMAP.md](REFERRAL_SUGGESTION_PHASE_ROADMAP.md)

**前提:** Phase 190 merge 済み（generate/get/patch API 利用可）。

---

## 1. 目的

1 to 1 一覧・Meetings（議事録モーダル含む）から **リファーラル提案モーダル**を開き、生成・提案一覧・却下/保留・再生成・過去 run 切替（API が返す範囲）まで操作できる UI を実装する。

---

## 2. スコープ

### 2.1 React

| コンポーネント | 役割 |
|----------------|------|
| `OneToOneReferralSuggestionDialog.jsx` | 121 モーダル |
| `MeetingReferralSuggestionDialog.jsx` | 定例会モーダル |
| `ReferralSuggestionList.jsx`（共有） | 提案行・status アクション |
| `OneToOnesList.jsx` | 行「リファーラル」ボタン（completed + notes） |
| Meetings 一覧 / 議事録 Dialog | 「リファーラル」ボタン（has_minutes） |

- 既存 `MarkdownView` / `MarkdownReadablePanel` で原文参照
- AI 未設定時の Alert（Settings 導線）

### 2.2 ビルド

- `npm run build` 成功必須

### 2.3 docs

- [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) または Meetings Fit/Gap に **リファーラル行アクション**を追記（モック列は FIT_AND_GAP 正）
- PLAN / WORKLOG / REPORT / Registry / progress

### 2.4 対象外

- `register-introduction` ボタン（Phase 192 — API 未実装なら disabled + ツールチップ）
- stale バッジ（Phase 192 — API フラグ待ち）

---

## 3. DoD

- [ ] 121 id=42 でモーダル→再生成→提案表示（手動 or E2E メモ）
- [ ] 定例会第210回で同様
- [ ] disabled 条件（planned / notes 空 / minutes なし）とツールチップ
- [ ] 却下・あとでが PATCH 反映
- [ ] `npm run build` OK
- [ ] `php artisan test` 回帰なし
- [ ] develop merge + Merge Evidence

---

## 4. モック比較

**必須:** [MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md) — 1to1 一覧行アクション・Meetings 導線をモックまたは FIT_AND_GAP 正と比較し差分を Fit/Gap に記録。

---

## 5. ブランチ

`feature/phase191-referral-suggest-mvp-ui`
