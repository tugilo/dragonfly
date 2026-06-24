# SONAE PoC Runbook（DragonFly）

**SSOT:** [SONAE_REQUIREMENTS.md](SONAE_REQUIREMENTS.md) §5.6  
**実装計画:** [SONAE_IMPLEMENTATION_PLAN.md](SONAE_IMPLEMENTATION_PLAN.md)  
**最終更新:** 2026-06-24 21:53 JST

---

## 1. 目的

BNI DragonFly チャプター向け Religo SONAE PoC の導入・訓練・L2 自動発報を、BCP 担当と tugilo が共同で実行するための手順書。

---

## 2. 前提

| 項目 | 内容 |
|------|------|
| 環境 | Religo 管理画面 `http://localhost/admin#/sonae/*`（本番は各環境 URL） |
| L1 | 手動訓練・LINE 回答・集計（Phase 246–248 完了） |
| L2 | JMA fixture 取得・発報条件・自動発報（Phase 249–251 完了） |
| 通知対象 | **LINE 友だち紐付け済みメンバーのみ**（§5.5） |

---

## 3. 導入ステップ（§5.6 実行手順）

### Step 1 — チャプター bootstrap

1. Religo 管理画面にログイン
2. メニュー **SONAE > ダッシュボード** を開く
3. 未 bootstrap の場合 **セットアップ** を実行（`POST /api/sonae/chapters/bootstrap`）
4. **Religo メンバー同期** で `sonae_members` を更新

**確認:** `GET /api/sonae/context` で chapter id が返ること。

### Step 2 — LINE Messaging API 設定

1. **SONAE > LINE 設定** で Channel ID / Secret / Access Token を登録
2. Webhook URL を LINE Developers に設定（`POST /sonae/line/webhook/{chapter}`）
3. 友だち追加 URL を周知

**確認:** Webhook 疎通・テスト Push（Phase 245）。

### Step 3 — メンバー紐付け

1. **SONAE > メンバー** で未紐付け一覧を確認
2. 招待トークンまたは紐付けフローで LINE 連携
3. ダッシュボードの **LINE 紐付け率** を確認

**推奨:** 訓練前に紐付け率を BCP が目視確認。

### Step 4 — 手動訓練（L1 達成）

1. **SONAE > 訓練** で訓練発報
2. メンバーが LINE / 回答 URL で安否回答
3. **集計**・訓練履歴で回答率・前回比を確認
4. 改善メモを記録

**L1 達成基準:** 1 回以上の訓練発報 → 回答 → 集計が end-to-end で完了。

### Step 5 — JMA 自動発報（L2 達成）

1. **SONAE > 発報条件** で種別・対象地域・閾値を設定（初期は OFF 推奨）
2. **SONAE > 気象庁連携** で取得間隔を設定
3. 紐付け率が十分になったら **自動取得 ON**
4. 発報条件を **ON** にした種別のみ自動通知

**L2 達成基準:** fixture または手動取得でイベント ingest → 条件マッチ → 通知作成まで確認。

---

## 4. PoC JMA fixture 運用

| 項目 | 内容 |
|------|------|
| 配置 | `www/storage/app/sonae/jma/fixtures/*.json` |
| サンプル | `earthquake_sample.json` |
| 手動取得 | 管理画面「手動取得」または `php artisan sonae:jma-fetch` |
| ログ | 管理画面 JMA 画面 / `GET /api/sonae/jma/logs` |

**fixture 追加手順:**

1. JSON に `entries` 配列で event を追加（`type`, `source_event_key`, `severity`, `areas` 等）
2. `source_event_key` はユニーク（重複は skipped）
3. 手動取得を実行し、ログの `created_event_count` を確認
4. 発報条件が ON かつマッチすれば notification が作成される

**本番 JMA:** PoC では未接続。本番化時は `SonaeJmaFeedProviderInterface` 実装を HTTP 版に差し替える。

---

## 5. 運用推奨

- **自動発報 ON** は手動訓練で LINE 登録率が十分になってから（§5.5）
- 訓練と本番災害は **同一回答 UI**（履歴のみ分離）
- 被害あり人数・活動困難等の集計定義は §6.4 に準拠

---

## 6. PoC 完了後（BCP フィードバック）

| 観点 | 記録先 |
|------|--------|
| 訓練回答率・改善点 | BCP 議事 / 1to1 |
| 自動発報の誤検知・閾値 | 発報条件 UI で調整 |
| SPEC-017 active 化判断 | tugilo + BCP 合意後、SSOT_REGISTRY の Status 更新 |

---

## 7. 関連 API 一覧（PoC）

| 用途 | エンドポイント |
|------|----------------|
| コンテキスト | `GET /api/sonae/context` |
| JMA 設定 | `GET/PUT /api/sonae/jma/settings` |
| JMA 取得 | `POST /api/sonae/jma/fetch` |
| 発報条件 | `GET/PUT /api/sonae/chapters/{id}/alert-settings` |
| 訓練 | `/api/sonae/chapters/{id}/training-events/*` |

---

## 8. 更新履歴

| 日時 | 内容 |
|------|------|
| 2026-06-24 21:53 JST | Phase 252 初版。§5.6 実行手順・fixture 運用・L1/L2 達成基準 |
