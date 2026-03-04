# テンプレートセットアップ報告

## 変更ファイル一覧

| 種別 | パス |
|------|------|
| 新規 | `infra/docker/php/Dockerfile` |
| 新規 | `infra/docker/node/Dockerfile` |
| 新規 | `infra/docker/nginx/default.conf` |
| 新規 | `infra/compose/docker-compose.yml` |
| 新規 | `bin/setup.sh` |
| 新規 | `versions.env` |
| 新規 | `Makefile` |
| 新規 | `docs/process/TEMPLATE_SETUP_PLAN.md` |
| 新規 | `docs/process/TEMPLATE_SETUP_WORKLOG.md` |
| 新規 | `docs/process/TEMPLATE_SETUP_REPORT.md` |

既存で変更したファイルはなし（`.gitignore` 等はそのまま）。

---

## 実行手順

1. **Docker Desktop を起動する**
2. **新規プロジェクトを作る**（テンプレートのルートで）:

   ```bash
   make new-project fluo
   ```

   - テンプレートの**隣**に `fluo/` が作成され、**fluo 用の infra/** がコピーされる
   - 続けて `fluo` 内で `make setup` が実行され、Laravel が `fluo/www/` に構築される（infra/ と www/ は同階層）

3. **既存プロジェクトでセットアップし直す**（プロジェクトのルートで）:

   ```bash
   cd fluo
   make setup
   ```

4. 完了メッセージの「Laravel project: ...」でパスを確認し、ブラウザで `http://localhost` を開く。

---

## 確認方法

1. **`make new-project fluo`**（テンプレート内）または **`make setup`**（プロジェクト内）がエラーで終了しないこと
   - 途中でエラーが出た場合は、Docker のログや `bin/setup.sh` の出力を確認する。

2. **コンテナが 5 本立っていること**
   ```bash
   docker ps
   ```
   - `fluo-app`, `fluo-node`, `fluo-nginx`, `fluo-db`, **`fluo-phpmyadmin`** の 5 つが表示されること。

3. **Laravel が表示されること**
   - ブラウザで `http://localhost` を開く。
   - Laravel のウェルカムページが表示されること。

4. **phpMyAdmin にアクセスできること**
   - ブラウザで `http://localhost:8081` を開く。
   - ログイン: ユーザ名 `root` / パスワード `root`、または ユーザ名 `fluo`（プロジェクト名）/ パスワード `fluo`。

5. **migrate が成功していること**
   ```bash
   cd fluo
   docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan migrate:status
   ```
   - または `make setup` 時のログに `migrate` 成功メッセージが出ていること。

---

## トラブルシュート

- **Composer がホストに無い**: 不要。Composer は app コンテナ内でのみ使用。
- **ポート 80 が使えない**: **そのプロジェクトの** `infra/compose/docker-compose.yml` の nginx の `ports` を変更する。
- **ポート 8081 が使えない**（phpMyAdmin）: そのプロジェクトの `infra/compose/docker-compose.yml` で phpmyadmin の `ports` を変更する。
- **DB 接続エラー**: コンテナ起動直後は DB の準備に数秒かかることがある。再度 `migrate` を実行して確認する。
- **Mac / WSL2**: `sed` は使用していないため、どちらの環境でも同じ手順で実行可能。
