# PHASE_TEMPLATE_PORT_GUARD_PLAN.md

## 背景

- `make setup` 実行時に **APP_PORT（80）, DB_PORT（3307）, PMA_PORT（8081）** のいずれかが既に使用中だと、docker compose のバインドで失敗しセットアップが止まる。
- 複数プロジェクトや他サービスとのポート競合はよくあるため、**競合時は自動で空きポートへスライドし、setup を成功させる**仕組みがほしい。

## 目的

- 既定ポートが使用中でも **make setup が失敗しない**。
- **自動的に空きポートへスライド**する。
- 決定したポートを **project.env に保存**し、以降の compose で一貫して使う。
- README に挙動を明記する。
- **既存の docker-compose.yml 構造・make setup の使い方は変えない**。

## 方針：自動スライド

- 対象ポート: **APP_PORT**, **DB_PORT**, **PMA_PORT**。
- デフォルト: APP_PORT=80, DB_PORT=3307, PMA_PORT=8081。
- 各ポートについて「使用中なら +1 ずつ探す」を **最大10回** まで試行。
- 空きポートを見つけたらその値を採用し、**project.env に書き込む**。
- 10回以内に空きが見つからなければ **エラー終了**（仕様で上限を明示）。

## 絶対遵守

- 既存の docker-compose.yml 構造は壊さない。
- make setup の使い方は変えない（引数やオプションは現状のまま）。
- **sed は使用禁止**（project.env は preflight の結果を setup.sh で here-doc 等で書き出す）。
- 1 Phase = 1 commit。
- PLAN / WORKLOG / REPORT 作成必須。

## 成果物

| 成果物 | 内容 |
|--------|------|
| bin/preflight.sh | ポート使用確認・空きポート探索（関数化、mac/WSL2 両対応） |
| bin/setup.sh 修正 | project.env 生成前に preflight 実行、決定ポートを project.env に反映 |
| README 更新 | ポート競合時の挙動・自動スライド・最大試行・強制指定の記載 |
| PHASE_TEMPLATE_PORT_GUARD_WORKLOG.md | 実施ログ |
| PHASE_TEMPLATE_PORT_GUARD_REPORT.md | 実装概要・動作確認・DoD |

## 強制指定

- ユーザーが **明示的にポートを指定した場合はスライドしない**（例: `APP_PORT=9000 make setup` → 9000 をそのまま使用。9000 が使用中ならバインド失敗は従来通り許容）。

## DoD（Definition of Done）

- ポート競合時でも `make setup` が成功する。
- docker compose up が成功する。
- http://localhost:<自動割当ポート> で Laravel が表示される。
- project.env に確定ポートが保存されている。
