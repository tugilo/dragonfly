# PHASE C-6 Connections Intelligence — PLAN

**Phase:** C-6  
**SSOT:** docs/SSOT/CONNECTIONS_INTELLIGENCE_SSOT.md

---

## 1. 目的

Connections 右ペインに **Relationship Summary** と **Next Action** を追加し、関係判断を速くする。UI 知性のみ。新 API 禁止。

## 2. スコープ

| Step | 内容 |
|------|------|
| Step0 | 現状確認（summary / one-to-ones 取得箇所・二重 fetch なし設計） |
| Step1 | 右ペインに 🧠 Relationship Summary ブロック追加（Relationship Log の上） |
| Step2 | 表示項目：同室回数・直近同室・1to1・直近メモ。値なしは — |
| Step3 | Next Action：ルール A〜D、最大 3 件、ショートアクション |
| Step4 | データ取得は既存 fetch を利用（二重 fetch 禁止） |
| Step5 | UI スタイル：.conn-pane / .pane-body を壊さない。カード風 |
| Step6 | php artisan test / npm run build 成功 |

## 3. 非目標

- 新 API・DB・Backend・Service 変更
- 既存 summary 取得の二重化

## 4. 成果物

- **UI:** DragonFlyBoard.jsx 右ペインに Relationship Summary + Next Action ブロック
- **docs:** CONNECTIONS_INTELLIGENCE_SSOT、PLAN / WORKLOG / REPORT、INDEX 更新

## 5. DoD

- [ ] Relationship Summary 表示
- [ ] Next Action 最大 3 件
- [ ] 既存 UI 壊れていない
- [ ] test / build 成功
- [ ] 1 Phase = 1 commit = 1 push、develop に --no-ff merge、REPORT に証跡

## 6. Git

- C-6a: `feature/connections-intelligence-docs-c6a`
- C-6b: `feature/connections-intelligence-impl-c6b`
- C-6c: `feature/connections-intelligence-close-c6c`
