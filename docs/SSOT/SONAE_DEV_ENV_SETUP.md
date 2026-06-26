# SONAE 開発環境セットアップ手順（religo-dev）

**目的:** 本番相当データ + 開発用 LINE 公式アカウントで、**religo-dev.tugilo.com** 上で SONAE PoC（L1/L2）を検証する。  
**関連:** [SONAE_POC_RUNBOOK.md](SONAE_POC_RUNBOOK.md) · [SONAE_REQUIREMENTS.md](SONAE_REQUIREMENTS.md) §10 · [DEPLOYMENT.md](../DEPLOYMENT.md)  
**最終更新:** 2026-06-24 22:18 JST

---

## 0. 全体像

```text
[1] develop push → GitHub Actions → religo-dev デプロイ
[2] make db-replicate-prod-to-dev  … 本番 DB → テスト DB（dev バックアップ付き）
[3] SONAE マスタ seeder（dev サーバ）
[4] 開発用 LINE Messaging API チャネル作成（LIFF 不要）
[5] 管理画面 bootstrap / LINE 設定 / 紐付け / 訓練
[6] （任意）JMA fixture・発報条件（L2）
```

| 環境 | URL | DB | ブランチ |
|------|-----|-----|----------|
| **開発（PoC 検証）** | https://religo-dev.tugilo.com/admin | `religo_dev` | develop |
| **本番** | https://religo.tugilo.com/admin | `religo_app` | main |

**原則:** LINE Webhook は **1 チャネル = 1 URL**。開発用 LINE と本番 DragonFly LINE は **別チャネル** とする。

---

## 1. コードを religo-dev に反映

### 1.1 develop を push（済みならスキップ）

```bash
git checkout develop
git pull origin develop
git push origin develop
```

### 1.2 デプロイ確認

- GitHub **Actions** → `deploy` ワークフローが develop で成功していること
- ブラウザ: https://religo-dev.tugilo.com/admin が開くこと

詳細: [DEPLOYMENT.md](../DEPLOYMENT.md)

---

## 2. 本番データでテスト DB をリプレイス

ローカル Docker **不要**。SSH 直結。

```bash
cd /path/to/dragonfly
make db-replicate-prod-to-dev
```

確認フレーズ（そのまま入力）:

```text
REPLICATE prod to dev
```

### 2.1 スクリプトが行うこと

| 順 | 処理 |
|----|------|
| 1 | **dev バックアップ** → `backups/dev_YYYYMMDD_HHMMSS.sql` |
| 2 | prod を dump（**本番 DB は読み取りのみ**） |
| 3 | dev を DROP/CREATE して prod ダンプを流し込み |
| 4 | dev 上で workspace 名補正 + 未適用 migration |

### 2.2 dev を元に戻す（ロールバック）

```bash
make db-restore-dev BACKUP=backups/dev_YYYYMMDD_HHMMSS.sql
```

---

## 3. SONAE マスタデータ（dev サーバ）

`db-replicate` 後、`sonae_alert_types` 等は空のことがある。SSH で seeder を実行。

```bash
ssh tugilo.com <<'EOF'
set -e
cd /var/www/laravel/religo_dev
PHP=/usr/bin/php8.4
$PHP artisan db:seed --class=SonaeAlertTypeSeeder --force
$PHP artisan db:seed --class=SonaeAlertThresholdOptionSeeder --force
echo "SONAE seeders done."
EOF
```

---

## 4. 開発用 LINE 公式アカウント（Messaging API）

### 4.1 LIFF は PoC では不要

| 機能 | 方式 | LIFF |
|------|------|------|
| Push 通知 | Messaging API | 不要 |
| Webhook | HTTPS Webhook | 不要 |
| メンバー紐付け | `SONAE-LINK:{token}` メッセージ | 不要 |
| 安否回答 | 通知内 URL → `/sonae/respond/{token}` | 不要 |

将来、LINE 内で紐付け UI を出す場合に LIFF を検討する。

### 4.2 LINE Developers でチャネル作成

1. [LINE Developers Console](https://developers.line.biz/console/) にログイン
2. **Provider** を作成（例: `tugilo`）
3. **Create a new channel** → **Messaging API**
4. チャネル名例: **`SONAE Dev (DragonFly PoC)`**（本番 DragonFly LINE とは別）

### 4.3 Messaging API 設定

**LINE Official Account Manager** で:

| 項目 | 設定 |
|------|------|
| Messaging API | **利用する** |
| 応答メッセージ | **OFF**（Bot 自動返信オフ推奨） |
| Webhook | **ON**（URL は Step 5 で確定） |

控えるもの:

- **Channel ID**
- **Channel secret**
- **Channel access token**（長期推奨）
- **友だち追加 URL**（または QR）

---

## 5. SONAE bootstrap と LINE 連携（管理画面）

URL: **https://religo-dev.tugilo.com/admin**

`tugi@tugilo.com` 等、Religo にログインできるアカウントで入る。

### Step 5.1 — bootstrap

1. 左メニュー **SONAE > ダッシュボード**
2. 未セットアップなら **セットアップ** を実行
3. **Religo メンバー同期** で名簿を反映

**確認:** メンバー数が DragonFly 名簿と一致すること（例: 184 件前後）。

### Step 5.2 — LINE 設定

1. **SONAE > LINE 設定** を開く
2. 画面に表示される **Webhook URL** をコピー  
   形式: `https://religo-dev.tugilo.com/sonae/line/webhook/{chapter_key}`
3. LINE Developers / Official Account Manager の **Webhook URL** に **5.2 の URL をそのまま** 登録
4. 管理画面に以下を入力して保存:
   - Channel ID
   - Channel Secret
   - Access Token
   - 友だち追加 URL

### Step 5.3 — Webhook 疎通確認

1. スマホで **開発用 LINE** を友だち追加
2. LINE Developers の Webhook **Verify** が成功すること
3. （任意）管理画面の **テスト Push** または API で Push 確認

---

## 6. メンバー紐付け（LIFF なし）

### 方法 A — 招待トークン（推奨）

1. **SONAE > メンバー** で対象メンバーの **LINE 招待** を発行
2. 表示される `SONAE-LINK:xxxxxxxx` を **開発用 LINE アカウント** から送信
3. Webhook が受信し、紐付け完了
4. メンバー一覧で **LINE 紐付け済み** を確認

### 方法 B — 管理者直接紐付け（自分だけテスト）

管理画面または API `POST /api/sonae/chapters/{id}/members/{member_id}/line-link` で `line_user_id` を指定（開発者の userId）。

**line_user_id の確認:** Webhook ログ、または LINE からメッセージ送信後の `sonae_error_logs` / DB `sonae_line_user_links`。

---

## 7. L1 訓練（手動発報 → 回答 → 集計）

1. **SONAE > 訓練** で訓練を作成・発報
2. 紐付け済み LINE に Push が届く
3. メッセージ内 **回答 URL**（`https://religo-dev.tugilo.com/sonae/respond/...`）を開く
4. 安否・活動状況等を回答
5. **集計**・訓練履歴で回答率を確認

**L1 達成:** 上記が end-to-end で 1 回通ること。

---

## 8. L2（任意）— JMA fixture + 発報条件

1. **SONAE > 発報条件** … 種別・地域・閾値（初期は必要な種別のみ **ON**）
2. **SONAE > 気象庁連携** … 手動取得を実行
3. fixture: サーバ `storage/app/sonae/jma/fixtures/*.json`（デプロイに含まれる）
4. ingest → 条件マッチ → 自動通知を確認

詳細: [SONAE_POC_RUNBOOK.md](SONAE_POC_RUNBOOK.md) §4

---

## 9. 本番（prod）へ進むとき

| 項目 | 開発（今） | 本番（後） |
|------|-----------|-----------|
| URL | religo-dev.tugilo.com | religo.tugilo.com |
| DB | `make db-replicate-prod-to-dev` で同期 | 本番 DB そのまま |
| LINE | **SONAE Dev** チャネル | **DragonFly 公式 LINE** |
| コード | develop → Actions | develop → **main** merge → Actions |
| 利用者 | tugilo / BCP 内部テスト | メンバー訓練周知 |

本番 DragonFly LINE の Webhook を prod URL に切り替える。**dev 用 LINE チャネルと共用不可。**

---

## 10. トラブルシュート

| 症状 | 確認 |
|------|------|
| Webhook Verify 失敗 | URL が `religo-dev`・`chapter_key` 一致か。HTTPS 有効か |
| Push が届かない | 友だち追加済みか。Access Token 有効か。紐付け済みか |
| 回答 URL が 404 | トークン期限・通知対象の `response_token` |
| SONAE メニューがない | develop デプロイ成功か。`/admin` 再読込 |
| メンバー 0 件 | bootstrap + Religo 同期。`db-replicate` 後に seeder/bootstrap 再実行 |

---

## 11. コマンド早見表

```bash
# 本番 → dev DB（dev バックアップ付き）
make db-replicate-prod-to-dev

# dev ロールバック
make db-restore-dev BACKUP=backups/dev_YYYYMMDD_HHMMSS.sql

# 本番 → ローカル（開発用）
make db-pull TARGET=prod

# ローカル DB バックアップ
make db-export
```

リモート artisan（dev）:

```bash
ssh tugilo.com "cd /var/www/laravel/religo_dev && /usr/bin/php8.4 artisan migrate:status"
```

---

## 12. 更新履歴

| 日時 | 内容 |
|------|------|
| 2026-06-24 22:18 JST | 初版。db-replicate-prod-to-dev・開発 LINE（LIFF 不要）・L1/L2 検証手順 |
