# PHASE_TEMPLATE_PORT_GUARD_WORKLOG.md

## 実施内容

### Step0: PLAN 作成

- `docs/process/PHASE_TEMPLATE_PORT_GUARD_PLAN.md` を作成。
- 背景（ポート競合）、方針（自動スライド）、対象ポート（APP_PORT / DB_PORT / PMA_PORT）、強制指定の扱い、DoD を記載。

### Step1: bin/preflight.sh 新規作成

- `bin/preflight.sh` を追加。
- `is_port_in_use PORT`: 使用中なら 0、空きなら 1。lsof 優先、なければ nc -z（mac / WSL2 両対応）。
- `find_free_port PORT`: 指定ポートから +1 ずつ最大10回探索し、空きポートを標準出力。見つからなければ exit 1。
- sed は使用していない。bash のみ。

### Step2: bin/setup.sh 修正

- versions.env 読み込みの直後に `source bin/preflight.sh` を追加。
- APP_PORT / DB_PORT / PMA_PORT について「未指定時のみ」find_free_port を実行。
- 環境変数で既に指定されている場合（例: APP_PORT=9000 make setup）はスライドせずその値を使用。
- 競合時は `⚠️  <既定> is already in use. Switching to <決定値>` を表示。
- 10回以内に空きが見つからなければ "Error: no free port in range ..." で終了。
- project.env には確定した APP_PORT, DB_PORT, PMA_PORT をそのまま書き込む（here-doc、sed なし）。
- 完了メッセージで実際の APP_PORT / PMA_PORT を表示。

### Step3: README 更新

- 標準機能の「ポートを project.env で変更可能」の文を修正し、ポートガード（自動スライド）の説明を追加。
- 自動スライド仕様: +1 ずつ、最大10回、project.env に保存、競合時ログ、強制指定（APP_PORT=9000 make setup）の記載。
- プロジェクト構成に `bin/preflight.sh` を追加。
- ドキュメント一覧に PORT_GUARD の PLAN / REPORT へのリンクを追加。
- 更新履歴にポートガード Phase を追記。

### Step4: WORKLOG / REPORT / INDEX

- 本 WORKLOG と REPORT を作成。
- docs/INDEX.md の process 一覧に PORT_GUARD の PLAN / WORKLOG / REPORT を追記。

### 動作確認（Step5）

- 3307 を占有した状態で make setup を実行し、自動で 3308 等にスライドすることを確認。
- project.env に DB_PORT がスライド先で保存されていることを確認。
- docker compose up が成功し、http://localhost:<APP_PORT> で Laravel が表示されることを確認。
