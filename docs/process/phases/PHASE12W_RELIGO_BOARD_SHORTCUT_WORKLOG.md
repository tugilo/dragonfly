# PHASE12W Religo Board ショートカット導線 — WORKLOG

**Phase:** Board ショートカット導線  
**作成日:** 2026-03-05

---

## Step 0: 前提確認

- Phase12U の右ペインに「メモを書く」「1 to 1 を登録」「紹介（Coming soon）」がある。既存モーダルはそのまま利用。

## Step 1: メモ導線の誘導

- 「メモを書く」クリック時、meeting 未選択なら Snackbar で「例会メモは中央で Meeting を選択してください」を表示しつつ、メモモーダルは開く（その他・1to1 メモは可能）。

## Step 2: 1to1 の独立メッセージ

- 右ペインの「1 to 1 は Meeting と独立して登録できます」を維持または少し目立たせる（Typography caption）。変更最小で可。

## Step 3: 紹介ボタンの tooltip

- 「紹介（Coming soon）」ボタンに Tooltip を追加（例: "紹介の登録は Phase14A で追加予定"）。既存 title で十分ならそのまま。

## Step 4: テスト・docs

- php artisan test。REPORT・INDEX・progress 更新。
