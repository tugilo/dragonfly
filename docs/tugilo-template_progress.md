# tugilo-template 進捗

このファイルは **tugilo-template** プロジェクトの進捗を記録する。

---

## 更新ルール

- 進捗・Phase の実施内容をこのファイルに追記する。
- 更新したら **必ず** [docs/INDEX.md](INDEX.md) が本ファイルを一覧に含んでいることを確認する。

---

## 履歴

（Phase や日付ごとに追記する）

| 日付 | Phase / 内容 |
|------|------------------|
| 2026-03-01 | 初回セットアップ: Laravel + Docker（PHP 8.4, Node 20, MariaDB 11.2, Nginx, phpMyAdmin）。make setup / make new-project。 |
| 2026-03-01 | プロジェクトごと infra に変更。make new-project でテンプレートをコピーしてから make setup。 |
| 2026-03-01 | docs/INDEX.md・進捗ルール（docs/<プロジェクト>_progress.md）・PLAN/WORKLOG/REPORT を docs/process/ に配置するルールを確立。 |
| 2026-03-01 | Cursor ルール: .cursorrules / .cursorrules.project。make new-project で .cursorrules を自動生成。 |
| 2026-03-01 | Docker 監査（protectlab / tsuboi / muraconet / dandreez）に基づく標準化。healthcheck・restart・project.env・depends_on condition・MariaDB 文字セット・nginx client_max_body_size。PHASE_TEMPLATE_DOCKER_AUDIT_*.md。 |
| 2026-03-01 | PORT_GUARD: bin/preflight.sh で空きポート自動スライド。project.env に決定ポート保存。PHASE_TEMPLATE_PORT_GUARD_*.md。 |
| 2026-03-01 | 全案件標準化: GLOBAL_STANDARD_DECLARATION・GLOBAL_DIFF_MATRIX。PORT_GUARD 強化（レンジ・docker ps・PORT_GUARD フラグ）。make doctor。README を標準仕様書 v1.0 に昇格。PHASE_TEMPLATE_STANDARDIZE_*.md。 |
| 2026-03-01 | 公式移行ガイド: PHASE_TEMPLATE_MIGRATION_GUIDE（3パターン・ポート・DB・doctor・DoD）。PHASE_S_001_*.md。 |
| 2026-03-01 | 全体まとめ: docs/SUMMARY_REPORT.md 作成（最初からの流れを整理）。INDEX に追加。 |
| 2026-03-02 | **基盤憲章**: SUMMARY_REPORT を Infrastructure Constitution v1.0 に昇格。宣誓文・制度としての目的・Versioning Policy・Change Control Matrix・Change Approval Flow を追記。PHASE_S_002_INFRASTRUCTURE_CONSTITUTION_*.md。 |
| 2026-03-02 | **http://localhost で Laravel 表示**: APP_PORT デフォルトを 80 に変更。Docker 起動時は http://localhost で Laravel 初期画面が開くように。ポートレンジを APP 80–89 に（競合時は 81,82,… にスライド）。README に Fluolig 例・「make new-project が正しいコマンド」の注意を追記。 |
| 2026-03-02 | **fluolig 起動フィックス**: app healthcheck を pgrep から `/proc/1/comm` 判定に変更（php 公式イメージに pgrep なし対応）。phpMyAdmin に platform: linux/arm64 を追加（Mac ARM 対応）。preflight.sh の is_port_in_use でループ変数 p が find_free_port の p を上書きしていたバグを bound_port に変更。setup.sh でポート戻り値を各レンジ内にクランプし、PMA/APP が DB ポート範囲と被らないようガード追加。fluolig で make setup 成功を確認。 |
| 2026-03-02 | **make project**: `make project <名前>` を追加（`make new-project <名前>` の短縮）。README に使用例を追記。 |
| 2026-03-02 | **既存プロジェクトは Docker 触らず docs スタイルのみ**: 移行ガイドに「既存環境はそのまま」パターン追加。docs/tugilo-style-append.cursorrules（.cursorrules 追記用ブロック）と bin/adopt-tugilo-style.sh（一括取り込み）を新設。既存案件は infra を変えず進捗・INDEX・Phase のひな形と .cursorrules 追記だけで tugilo スタイルに合わせられるように。GLOBAL_DIFF_MATRIX・移行ガイドのポート表記を現行（APP 80–89）に統一。 |
| 2026-03-02 | **adopt-tugilo-style の準備OK**: すでに tugilo スタイルが揃っている場合は何もせず「準備OK」メッセージを表示。不足分だけ作成・追記するように変更。 |
| 2026-03-02 | **Laravel を www/ に配置**: プロジェクト構成を変更し、Laravel を **www/** 直下に、**infra/ と www/ を同階層**に。compose のボリュームを PROJECT_DIR/www:/var/www に変更。setup.sh で mkdir -p www、new-project で mkdir www。.gitignore を www/ 基準に変更。.cursorrules.project・README・TEMPLATE_SETUP_*.md を更新。 |
| 2026-03-02 | **ordigo プロジェクト作成**: make project ordigo で /Users/tugi/docker/ordigo を生成。Laravel 12 を www/ にインストールし、http://localhost で動作確認。 |
