# PHASE_TEMPLATE_STANDARDIZE_ALL_PROJECTS_WORKLOG.md

## 実施内容

### Step0: 標準宣言・PLAN

- `PHASE_TEMPLATE_GLOBAL_STANDARD_DECLARATION.md`: 宣言・適用範囲・標準仕様・禁止事項・例外承認フロー・将来バージョン管理方針を記載。
- `PHASE_TEMPLATE_STANDARDIZE_ALL_PROJECTS_PLAN.md`: 目的・ゴール・絶対遵守・実装ステップ・DoD。

### Step1: 差分監査の最終固定

- `PHASE_TEMPLATE_GLOBAL_DIFF_MATRIX.md`: 項目 × template / protectlab / tsuboi / muraconet / dandreez × 採用のマトリクスを作成。template が最適解である理由（一元管理・起動安定性・ポート競合解消・例外の可視化・将来拡張）を論理的に記載。既存4プロジェクトの移行時の対応を表で整理。

### Step2: PORT_GUARD 強化

- **ポートレンジ制限**: APP_PORT 8000–8999, DB_PORT 3307–3399, PMA_PORT 8081–8181。`bin/preflight.sh` の `find_free_port START [MAX]` に max_port を追加し、`setup.sh` で各デフォルトと max を渡すように変更。
- **docker ps 検出**: `get_docker_host_ports()` を追加。`docker ps --format '{{.Ports}}'` をパースしてホストポートを取得し、`find_free_port` 内で `DOCKER_HOST_PORTS` を設定して `is_port_in_use` が Docker のバインドも考慮するようにした。
- **PORT_GUARD フラグ**: `project.env` に `PORT_GUARD=true` を出力。`PORT_GUARD=false` の場合はスライドせずデフォルト（または環境変数指定値）をそのまま使用するように `setup.sh` を修正。
- **APP デフォルト**: 80 → 8000 に変更。compose の `${APP_PORT:-80}` を `${APP_PORT:-8000}` に変更。

### Step3: make doctor

- `bin/doctor.sh`: Docker 起動確認・必須ファイル（compose, project.env）・project.env 整合性・ポート使用確認・healthcheck（コンテナの unhealthy 検出）・Laravel 応答（curl 200）を実施。project.env が無い場合もデフォルトポートで部分実行可能にした。
- `Makefile`: `make doctor` で `bin/doctor.sh` を実行するターゲットを追加。

### Step4: README を標準仕様書へ昇格

- タイトルを「tugilo Standard Docker Infrastructure v1.0」とし、全案件共通標準基盤であることを明記。
- 標準宣言・GLOBAL_DIFF_MATRIX へのリンクを追加。
- セクション追加: 標準思想（SSOT・一貫性・堅牢性）、適用ポリシー、例外承認フロー、将来バージョン管理方針。
- 構成・標準機能を「全案件標準」に合わせて更新（ポートレンジ・PORT_GUARD 詳細・make doctor）。
- プロジェクト構成に `bin/doctor.sh` を追加。よく使う操作に `make doctor` を追加。
- ドキュメント一覧に GLOBAL_STANDARD_DECLARATION・GLOBAL_DIFF_MATRIX を追加。更新履歴に本 Phase を追記。

### Step5: WORKLOG / REPORT / INDEX

- 本 WORKLOG と REPORT を作成。
- `docs/INDEX.md` の process 一覧に STANDARDIZE_ALL_PROJECTS および GLOBAL 系ドキュメントを追記。
