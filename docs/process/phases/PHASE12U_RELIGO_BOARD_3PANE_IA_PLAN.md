# PHASE12U Religo Board 3ペイン IA — PLAN

**Phase:** Board を 3 ペインに再構成し、選択→BO→関係ログの導線を最短化する  
**作成日:** 2026-03-05  
**SSOT:** [ROADMAP.md](../../SSOT/ROADMAP.md), [DATA_MODEL.md](../../SSOT/DATA_MODEL.md), [ADMIN_UI_THEME_SSOT.md](../../SSOT/ADMIN_UI_THEME_SSOT.md)

---

## 1. 目的（ROADMAP 準拠）

- Board を「3 ペイン」に再構成し、操作を最短化する。
  - **左:** メンバー選択（検索・一覧・selectedMember 確定）
  - **中:** BO（Round 割当編集）。Meeting 選択 + Round 編集を中央に集約。
  - **右:** 関係ログ（メモ／1to1／紹介の導線と要点表示）。

## 2. スコープ（守る）

- **既存 API のみ**で構成する。新 API 追加禁止。
- 「表示と導線」を整える。データ仕様の変更は禁止。
- 既存の保存導線（Round 保存・メモ作成・1to1 作成）を壊さない。
- 変更対象: `DragonFlyBoard.jsx` を中心。必要なら `www/resources/js/admin/components/religo/` にコンポーネント抽出（可読性優先で Board 内に留めても可）。

## 3. UI 仕様

### (A) レイアウト

- Container maxWidth="lg"（または xl）+ Grid で 3 カラム。
  - 左ペイン: xs=12 md=3
  - 中ペイン: xs=12 md=6
  - 右ペイン: xs=12 md=3
- すべて Card ベース。余白は Stack spacing で統一。

### (B) 左ペイン：メンバー選択

- 上部に「メンバー検索」を置く（Autocomplete または TextField + List）。
- メンバー一覧は「番号 + 名前」を主表示、補助に summary_lite（同室回数／最終メモ等）を小さく。
- クリックで selectedMember を確定し、中央・右に反映。
- 選択中は ListItem の selected 表現 + Chip（Selected）。

### (C) 中ペイン：BO（Round 編集）

- Meeting 選択カードを中央ペイン最上段に配置。
- Round 編集は「選択中 Round のみ表示」。Unsaved/Saved/Loading を Chip で明確に。
- 保存ボタンは中央ペイン下部（CardActions）。LoadingButton + 成功 Snackbar + 失敗 Alert。

### (D) 右ペイン：関係ログ

- selectedMember 未選択時は「左でメンバーを選択してください」を表示。
- 選択時: (1) 選択メンバーのサマリ（名前／番号 + summary_lite）、(2) クイックアクション（メモを書く・1to1 を登録）、(3) 要点表示（last_memo, same_room_count 等）。(4) 紹介は「Coming soon」無効ボタンで期待だけ作る。

## 4. DoD

- [ ] Board が 3 ペインになり、選択→BO→右ログの導線が迷わない
- [ ] 既存の Round 保存、メモ作成、1to1 作成が壊れていない
- [ ] php artisan test が green
- [ ] PLAN/WORKLOG/REPORT を追加し、INDEX/progress 更新、REPORT に取り込み証跡

## 5. Git

- ブランチ: `feature/phase12u-board-3pane-ia-v1`
- コミット: 1 コミット。メッセージ: `ui: Phase12U Board 3-pane IA`
