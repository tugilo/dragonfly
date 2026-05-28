# PHASE C-8 Introduction Hint — PLAN

**Phase:** C-8  
**SSOT:** docs/SSOT/INTRODUCTION_HINT_SSOT.md

---

## 1. 目的

Connections 右ペインに **Introduction Hint（紹介発想）** を追加し、紹介候補を「業種（名前） → 業種（名前）」で最大 3 件表示する。UI 計算のみ。

## 2. スコープ

| Step | 内容 |
|------|------|
| Step1 | calculateIntroductionHints(members, getScore) 作成。members の summary_lite 等を利用。 |
| Step2 | メンバーリストから条件1〜4 を満たすペアを抽出。 |
| Step3 | 最大 3 件に絞る（優先度: score 合計または同室回数）。 |
| Step4 | 💡 Introduction Hint ブロック UI 追加（Relationship Score の下、Relationship Log の上）。 |
| Step5 | 候補 0 件のとき「紹介候補なし」表示。 |
| Step6 | npm run build 成功。 |

## 3. 非目標

- 新 API・Backend 変更
- 全メンバー分の詳細 summary を新規 fetch（members の summary_lite で足りる範囲で実装）

## 4. 成果物

- **UI:** DragonFlyBoard.jsx に Introduction Hint ブロック
- **docs:** INTRODUCTION_HINT_SSOT、PLAN / WORKLOG / REPORT、INDEX 更新

## 5. DoD

- [ ] Introduction Hint 表示
- [ ] 新 API なし
- [ ] test / build 成功
- [ ] 1 Phase = 1 commit = 1 push、REPORT に証跡

## 6. Git

- C-8a: `feature/introduction-hint-docs-c8a`
- C-8b: `feature/introduction-hint-impl-c8b`
- C-8c: `feature/introduction-hint-close-c8c`
