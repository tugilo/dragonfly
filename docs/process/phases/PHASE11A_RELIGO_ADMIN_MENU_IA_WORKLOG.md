# PHASE11A Religo 管理画面メニュー整理（IA）— WORKLOG

**Phase:** メニュー IA 整理  
**作成日:** 2026-03-04

---

## Step 1: ブランチ・PLAN

- develop から `feature/phase11a-admin-menu-ia-v1` を作成。
- PHASE11A_RELIGO_ADMIN_MENU_IA_PLAN.md を作成。

## Step 2: カスタム Menu / Layout

- React Admin の `Menu` を利用したカスタムメニューコンポーネント（ReligoMenu）を作成。順序: Board（Dashboard）→ Members → 区切り → Meetings → 区切り → 1 to 1。
- 区切りは MUI `ListDivider` で表現。
- `Layout` に `menu={ReligoMenu}` を渡す ReligoLayout を作成。

## Step 3: Resource とプレースホルダー

- Resource: `members`、`meetings`、`one-to-ones` を app.jsx に追加。各 list はプレースホルダー（短文表示）でクリック時に壊れないようにする。
- 既存 `dragonflyFlags` Resource はメニューに表示しない（カスタムメニューのみ表示）。

## Step 4: 動作確認・docs

- メニュー順・区切り・遷移の確認。Board（/）表示は既存どおり。
- INDEX.md / dragonfly_progress.md 更新。REPORT 作成。

## Step 5: 1 コミット・merge

- `git add -A && git commit -m "feat: reorganize admin menu IA (Religo)"` → push → develop へ --no-ff merge → test → push。
