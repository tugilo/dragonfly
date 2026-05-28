# PHASE C-7 Relationship Score — PLAN

**Phase:** C-7  
**SSOT:** docs/SSOT/RELATIONSHIP_SCORE_SSOT.md

---

## 1. 目的

Connections 右ペインに **Relationship Score（関係温度）** を追加し、関係の深さを ★ で直感的に表示する。UI 計算のみ。

## 2. スコープ

| Step | 内容 |
|------|------|
| Step1 | calculateRelationshipScore(summary) 作成（0〜5） |
| Step2 | Relationship Score ブロック UI 追加（Summary の下） |
| Step3 | 既存 MUI / .conn-pane を使用 |
| Step4 | summary が null のときは — 表示 |
| Step5 | 既存 UI を壊さない（追加のみ） |
| Step6 | npm run build 成功 |

## 3. 非目標

- 新 API・Backend・DB・Service 変更

## 4. 成果物

- **UI:** DragonFlyBoard.jsx に Relationship Score ブロック（★ 表示）
- **docs:** RELATIONSHIP_SCORE_SSOT、PLAN / WORKLOG / REPORT、INDEX 更新

## 5. DoD

- [ ] Relationship Score 表示
- [ ] ContactSummary のみ使用
- [ ] test / build 成功
- [ ] 1 Phase = 1 commit = 1 push、REPORT に証跡

## 6. Git

- C-7a: `feature/relationship-score-docs-c7a`
- C-7b: `feature/relationship-score-impl-c7b`
- C-7c: `feature/relationship-score-close-c7c`
