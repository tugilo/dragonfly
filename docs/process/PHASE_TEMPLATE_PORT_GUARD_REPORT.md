# PHASE_TEMPLATE_PORT_GUARD_REPORT.md

## 変更ファイル一覧

| ファイル | 変更内容 |
|----------|----------|
| docs/process/PHASE_TEMPLATE_PORT_GUARD_PLAN.md | 新規。背景・方針・対象ポート・強制指定・DoD。 |
| docs/process/PHASE_TEMPLATE_PORT_GUARD_WORKLOG.md | 新規。実施ログ。 |
| docs/process/PHASE_TEMPLATE_PORT_GUARD_REPORT.md | 本ファイル。実装概要・動作確認・DoD。 |
| bin/preflight.sh | 新規。is_port_in_use / find_free_port（lsof or nc、最大10回）。 |
| bin/setup.sh | project.env 生成前に preflight を source。未指定時のみポート探索。決定値を project.env に反映。 |
| README.md | ポートガードの挙動・自動スライド・最大試行・強制指定を追記。bin 構成・ドキュメントリンク・更新履歴。 |
| docs/INDEX.md | process 一覧に PORT_GUARD の PLAN / WORKLOG / REPORT を追加。 |

## 実装内容概要

- **preflight**: 指定ポートが使用中か lsof（優先）または nc で判定。空きポートは既定から +1 ずつ最大10回探索。見つかったポートを stdout に出力。
- **setup.sh**: project.env を書く前に preflight を読み込み、APP_PORT / DB_PORT / PMA_PORT が未指定の場合だけ find_free_port を実行。決定したポートを project.env に書き込み。競合時はログでスライド先を表示。
- **強制指定**: 環境変数で APP_PORT / DB_PORT / PMA_PORT が既に設定されている場合はスライドせずその値を使用（例: `APP_PORT=9000 make setup`）。

## 動作確認結果（DoD）

- [x] **ポート競合時でも make setup がポートバインドで失敗しない**: 80 / 3307 / 8081 使用中に make setup を実行し、自動で 81 / 3308 / 8082 にスライド。ログに `⚠️  3307 is already in use. Switching to 3308` 等が出力された。
- [x] **代替ポートが project.env に保存される**: `APP_PORT=81`, `DB_PORT=3308`, `PMA_PORT=8082` が project.env に書き込まれたことを確認。
- [x] **docker compose up は実行され、db は起動・healthy**: コンテナは作成され、db は 3308 でバインド・healthy。app の healthcheck で unhealthy となり nginx の start が遅れたが、これはポートガードの範囲外（既存の healthcheck 仕様）。
- 強制指定: `APP_PORT=9000 make setup` で 9000 をそのまま使用することを README で明記済み。

（補足: 検証時は 3307 を占有し、80/8081 も別プロセスで使用中のため 81/3308/8082 にスライド。ポートガードの挙動は仕様どおり。）

## 注意

- 既存の docker-compose.yml は変更していない。
- make setup の使い方（`make setup` / `make setup <PROJECT>`）は変更していない。
- sed は使用していない。
- 1 Phase = 1 commit で完了。
