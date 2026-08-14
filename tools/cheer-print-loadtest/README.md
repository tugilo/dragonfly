# Cheer Print 負荷試験ツール（tugilo）

**ローカル Docker（`grafana/k6`）** から Cheer Print 関連サイトへ段階負荷をかけ、  
進捗を見ながら測定し、**誰が見ても分かる日本語報告書**を自動生成する。

| 項目 | 内容 |
|------|------|
| 案件 SSOT | `docs/proposals/takemura_cheer_print_event_access_plan.md` |
| 要件 | `docs/proposals/takemura_cheer_print_loadtest_program_requirements.md` |
| Phase | 300 |
| 本番枠 | 2026-08-08 22:00〜24:00 JST |
| **発生元（推奨）** | **ローカル Docker** |
| 発生元（予備） | `ssh tugilo.com`（回線不足時のみ・常用しない） |
| 自動開始 | launchd（下記） |

## 方針

- Mac に k6 を直入れしなくてよい（Docker で実行）
- **tugilo.com に負荷試験の負荷を掛けない**
- Cheer Print 本番 EC2 上では動かさない
- GET（閲覧）のみ。異常時は Ctrl+C

## セットアップ

```bash
docker pull grafana/k6:latest
cd tools/cheer-print-loadtest
node -v   # 報告生成用（Node 18+）
```

## ドライラン（弱い負荷・推奨確認）

```bash
./run.sh dry
```

約1〜2分。生成物:

- `results/summary_static_landing_*.json`
- `results/summary_wp_origin_*.json`
- `results/report_*.md` … **共有用**
- `results/report_*.html` … ブラウザ用

サンプル: `samples/report_dryrun_sample.md`

## 本番枠（Stage A→B→C）

合意済みの夜間枠でのみ。

```bash
./run.sh full
```

### 22:00 自動開始（launchd・推奨）

Mac ローカル時刻で **8月8日 22:00** に `full` を起動する。  
ラッパーが **日付ガード（既定: 2026-08-08）**・Docker 確認・`caffeinate`・通知を行い、  
**`./run.sh full`（報告生成まで）が終わったら LaunchAgent を自動解除**する。

```bash
./bin/install_launchd.sh    # 登録（今夜一回用）
./bin/uninstall_launchd.sh  # 手動解除（通常は不要・自動で外れる）
```

| 確認 | コマンド / 場所 |
|------|-----------------|
| 登録状態 | `launchctl print gui/$(id -u)/com.tugilo.cheer-print-loadtest-full \| head -40` |
| 実行ログ | `results/logs/scheduled_full_*.log` |
| launchd 出力 | `results/logs/launchd_stdout.log` / `launchd_stderr.log` |

**必須**

- Docker Desktop 起動済み（常時起動 Mac ならそのまま可）
- 成功／失敗どちらでも、本番 `full` 実行後は Agent を外す（枠外の SKIP では外さない）

上限を抑える例:

```bash
MAX_VU_WP=50 MAX_VU_STATIC=80 ./run.sh full
```

| 変数 | 意味 | dry | full |
|------|------|-----|------|
| `SLEEP` | 閲覧間隔（秒） | 1 | 1 |
| `TIMEOUT_MS` | タイムアウト | 30000 | 30000 |
| `MAX_VU_STATIC` | 静的最大 VU | 2 | 100 |
| `MAX_VU_WP` | WP 最大 VU | 2 | 100 |

## シナリオ単体（Docker）

```bash
STAMP=$(TZ=Asia/Tokyo date '+%Y%m%d_%H%M')
docker run --rm -i -v "$PWD:/work" -w /work \
  -e PROFILE=dry -e MAX_VU=2 -e STAMP="$STAMP" -e SOURCE=local-docker \
  grafana/k6:latest run scenarios/static_landing.js
```

## 報告書のみ再生成

```bash
node report/generate_report.mjs --dir results --stamp 20260807_2346
```

## 停止

`Ctrl+C`

## 判定（自動）

| 判定 | 目安 |
|------|------|
| 問題なし | 成功率 ≥ 99% かつ p95 ≤ 2.0s |
| 要改善 | 成功率 95〜99% または p95 2〜5s |
| 危険 | 成功率 < 95% または p95 > 5s |

総合はシナリオのうち最も悪い判定。

## ディレクトリ

```text
tools/cheer-print-loadtest/
  bin/         launchd 登録・予約実行ラッパー
  launchd/     説明（plist は install が生成）
  scenarios/   k6（static_landing / wp_origin / lib）
  report/      報告書生成
  results/     出力（git 管理外）
  samples/     ドライランサンプル報告
  run.sh
  README.md
```
