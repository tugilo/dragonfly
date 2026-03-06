# PHASE C-6 Connections Intelligence — WORKLOG

**Phase:** C-6

---

## Step0 — 現状確認

- Connections 右ペイン：`targetMember` 変更時に `loadSummary()` で `/api/dragonfly/contacts/:id/summary` を取得。`refetchOneToOnes()` で `/api/one-to-ones` を取得。二重 fetch はしていない。
- state: `summary`, `oneToOnes`, `loadingSummary`。C-6b ではこれらを再利用し、追加 fetch は行わない。

## Step1 — UI 追加

- Relationship Log の上に「🧠 Relationship Summary」ブロックを追加する。

## Step2 — 表示項目

- same_room_count / last_same_room_meeting（#number, held_on）/ one_on_one_count・直近日付 / latest_memos 3 件。取得できない項目は — 表示。

## Step3 — Next Action

- ルール A〜D をクライアントで計算。最大 3 件。📅 1to1登録 → 1to1 入力フォーカス、✏️ メモを書く → メモモーダル、👥 詳細 → members 画面。

## Step4 — データ取得

- 既存の `summary` と `oneToOnes` のみ使用。新規 fetch なし。

## Step5 — UI スタイル

- 既存 .conn-pane / pane-body を壊さない。カード風 border / padding / radius。

## Step6 — テスト

- php artisan test / npm run build 成功。

## 判断メモ

- 取得できないフィールドは — 表示：レイアウト崩れ防止・SSOT 方針。
- Next Action はクライアント計算：新 API 禁止のため。
