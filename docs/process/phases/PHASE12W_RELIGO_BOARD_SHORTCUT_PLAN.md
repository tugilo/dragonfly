# PHASE12W Religo Board ショートカット導線 — PLAN

**Phase:** Board 上で選択メンバーに対するメモ／1to1／紹介（将来）を 1 クリックで開始できるようにする  
**作成日:** 2026-03-05  
**SSOT:** [ROADMAP.md](../../SSOT/ROADMAP.md), Phase12U の右ペイン

---

## 1. 目的（ROADMAP 準拠）

- Board 上で「選択メンバーに対するメモ／1to1／紹介（将来）」が 1 クリックで開始できるようにする。
- 新 API 禁止。既存導線の「距離を縮める」のみ。

## 2. スコープ

- 右ペインのクイックアクションを完成させる。
  - **メモ:** meeting 選択済みなら即モーダル。未選択なら meeting 選択へ誘導（Snackbar または既存 warning で誘導）。
  - **1to1:** 既存モーダルで登録。Meeting と独立であることを UI 文言で明示（既存 caption を維持・補強可）。
  - **紹介:** UI 上の入口のみ（disabled + tooltip）。本体は後続 Phase。

## 3. DoD

- [ ] 選択メンバーからメモ／1to1 を最短で開始できる
- [ ] Meeting と 1to1 が「独立」である意図が UI で伝わる
- [ ] 既存テスト green + docs 更新

## 4. Git

- ブランチ: `feature/phase12w-board-shortcut-v1`
- コミット: 1 コミット。メッセージ: `ui: Phase12W Board shortcut (メモ/1to1 最短導線)`
