# PHASE12S Religo Board MUI 骨格・余白・階層 — PLAN

**Phase:** DragonFlyBoard を MUI らしい情報設計・余白・階層・密度に刷新（UI のみ）  
**作成日:** 2026-03-04  
**SSOT:** 本 PLAN、MUI / ReactAdmin の作法

---

## 1. 狙い

- スクショの「のっぺり・余白過多・重要度不明」を解消する。
- **機能追加は行わない**。Meeting 選択 / Round 追加 / BO 割当 / ルームメモ / メンバー追加 / 保存 / 個人メモ導線はすべて維持。
- MUI らしさ = Card/Paper の階層・Grid/Stack の整列・適切な幅/余白・Typography/Chip/Alert で重要度を表現。

## 2. 画面骨格

- **全体:** `Container maxWidth="lg"` で包み、中央寄せ。
- **上部:** コントロールバー（Meeting / 状態 Chip / 保存）を 1 枚の **Card** にまとめる。CardHeader に Meeting Select、右に Chip（Saved / Unsaved / Loading）。
- **下部:** **Grid** で 2 カラム（左: Round ナビ、右: Round 編集）。
- **右側:** Round 編集用 **Card** の内側に BO1 / BO2 を **Card** で並べ（Grid 均等配置）。各 BO は CardHeader（タイトル＋人数 Chip）＋ CardContent（ルームメモ → Divider → メンバー割当）。保存は **CardActions** に配置。

## 3. 見た目ルール

- 基本余白: Card 内側 `p: 2`。セクション間 `gap: 2`（Stack spacing={2}）。
- 入力は `size="small"` を基本。ボタンは `variant="contained"`（主要）と `outlined`（補助）を明確化。
- 状態は **Chip** で一貫（Unsaved=warning, Saved=success, Loading=info）。保存ボタンは **LoadingButton**（@mui/lab）でスピナー＋disabled。成功時は **Snackbar**。

## 4. 具体的な直し

- **Round ナビ（左）:** Tabs または List で縦ナビ。「+ Round」は `Button startIcon={<Add/>}` でナビの最下部。選択中は selected の見た目（背景/左ボーダー）。
- **BO カード:** CardHeader（BO1/BO2 ＋ 人数 Chip「3名」）、CardContent（ルームメモ minRows=3 → Divider → メンバー割当）。メンバー割当は Autocomplete + IconButton(＋)、追加済みは Chip の並び（Stack row wrap gap={1}）、Chip の右にメモ IconButton。
- **保存:** Round 編集 Card の下部を CardActions とし、LoadingButton で「ROUND 割当を保存」。

## 5. 禁止事項

- div の直置きで余白調整しない（Box/Stack/Grid で整える）。
- 固定 px だらけにしない（Container + Grid）。
- 重要ボタンを途中に散らさない（CardActions に寄せる）。
- 文字だけで状態を出さない（Chip/Alert）。

## 6. DoD

- [ ] 画面が Container で中央寄せされ、横の間延びが消えた
- [ ] コントロール（Meeting/状態/保存）が上部 Card にまとまった
- [ ] Round ナビが MUI らしい List/Tabs になった
- [ ] BO1/BO2 が Card になり、余白と区切りが整った
- [ ] メンバー割当が Chip で見やすく、折り返しても崩れない
- [ ] 保存が CardActions に集約され、Loading/Snackbar で分かる
- [ ] テスト green、docs 完備
