---
doc_type: internal_runbook
title: "動物病院 LINE予約チラシ — スクリーンショット取得ガイド"
owner: tugilo（次廣 淳）
related_flyer: "animal_hospital_line_reservation_flyer_202606.md"
source_system: "/Users/tugi/docker/yamabuki/www/yamabuki"
created: "2026-06-03 16:45 JST"
---

# スクリーンショット取得ガイド

チラシは **文字より画面キャプチャ** で説明する構成。以下を `images/` に保存する。

## 1. 環境起動（yamabuki）

```bash
cd /Users/tugi/docker/yamabuki
docker compose up -d
```

- アプリ: http://localhost （port 80 が他プロジェクトと競合する場合は compose の ports を一時変更）
- phpMyAdmin: http://localhost:8080

## 2. 取得する画面（6枚）

### 飼い主向け（LIFF・スマホ幅）

ブラウザ DevTools で **iPhone 幅（375px）** にして撮影。

| # | 保存名 | URL | ポイント |
|---|--------|-----|----------|
| 1 | `01_liff_select_pet.png` | `/liff/reserve/select_pet` | 「受診するペットをお選びください」が見える |
| 2 | `02_liff_select_date.png` | `/liff/reserve/select_date` | 週カレンダー・空き枠の色分けが見える |
| 3 | `03_liff_confirm.png` | `/liff/reserve/confirm` | ペット・日時・目的の確認画面 |

※ LIFF は LINE 連携・診察券認証が必要な場合あり。ローカルでは **テスト用 owner_id** で URL パラメータを付与するか、管理画面から電話予約フローで同等画面を `/admin/reserve/...` から取得しても可。

### スタッフ向け（PC幅）

| # | 保存名 | URL | ポイント |
|---|--------|-----|----------|
| 4 | `04_admin_todays_reserve.png` | `/admin/todays_reserve` | 「今日の診察」一覧 |
| 5 | `05_admin_reserve_list.png` | `/admin/reserve_list` | 予約一覧・検索 |

ログイン: Laravel Auth（管理ユーザー）

### LINE 通知

| # | 保存名 | 取得方法 |
|---|--------|----------|
| 6 | `06_line_reminder.png` | 予約前日リマインダーの **LINE トーク画面** をキャプチャ。実機またはステージング。文言例: 予約日・時間・ペット名 |

## 3. 加工ルール

- 個人名・カルテ番号・電話番号 → **モザイク**
- 余白は **スマホ画面／管理画面の枠だけ** 切り抜き（背景のデスクトップは入れない）
- PNG、横幅 **800〜1200px** 程度（A4 PDF 用）

## 4. チラシへの反映

`animal_hospital_line_reservation_flyer_202606.md` 内の `images/xx_....png` 参照が自動で表示される。  
6枚そろったら Markdown → PDF 化して配布用 A4 を確認。

## 5. 代替（スクショが間に合わない場合）

- 藤枝デモ（6/6 RF 後）で **実画面を見せる** 前提なら、チラシは概念図（Mermaid）＋「デモでご覧ください」でも可
- イラスト素材は別途検討（有料ストック等）
