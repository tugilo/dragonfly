# tugilo Standard Docker 移行ガイド v1.0

既存案件を tugilo-template 標準基盤へ安全に移行するための **公式手順書** です。  
事故を防ぐため、必ず本ガイドのパターンと手順に従ってください。

---

## 1. 移行パターン定義

### パターンA：最小移行（安全優先）

**対象**

- 既存 Docker がほぼ template と同じ（nginx + php-fpm + MariaDB + project.env 想定）。
- 差分が少なく、infra/bin/Makefile を上書きコピーするだけで足りる案件。

**手順**

1. 既存 `infra/` をバックアップ（例: `infra.bak/` にリネームまたはコピー）。
2. tugilo-template の `infra/` `bin/` `Makefile` `versions.env` を当該プロジェクトへコピー。
3. `project.env` を既存のポート・プロジェクト名に合わせて作成（既存が 80/3307/8081 ならその値で。標準は APP 80–89・DB 3307–3399・PMA 8081–8181）。
4. `make doctor` を実行し、Docker 起動・project.env・ポート・healthcheck・Laravel 応答を確認。
5. 差分（独自の volume や env がある場合）を `docs/<プロジェクト>_progress.md` または GLOBAL_DIFF_MATRIX にメモし、今後の変更時に参照する。

---

### パターンB：標準移行（推奨）

**対象**

- healthcheck 未実装。
- 固定ポート使用中（80 / 3306 / 8080 等）。
- Apache 内包型（nginx 分離していない）。

**手順**

1. 既存 Docker を停止（`docker compose down` 等）。
2. 既存 `infra/` をバックアップした上で、template の `infra/` `bin/` `Makefile` `versions.env` で置換。
3. **APP_PORT を標準レンジへ**（APP 80–89。競合時は PORT_GUARD で 81,82,… にスライド）。既存が 80 のままでも動く。標準に寄せる場合は `make setup` で project.env を自動生成。
4. `PORT_GUARD=true` のまま（または未指定でデフォルト true）で `make setup` を実行し、ポート競合時は自動スライドさせる。
5. `make doctor` を実行し、全項目 OK または許容できる警告のみであることを確認。
6. 既存機能（migrate・ログイン・API 等）の動作確認を行う。

---

### パターンC：例外移行

**対象**

- 本番専用 compose（HTTPS・certbot・scheduler・queue を含む）。
- 特殊ネットワーク構成（独自 subnet・社内 DB 参照等）。

**手順**

1. **template をベースとする**。開発用 compose は template の infra をそのまま使い、本番用だけ別 compose ファイル（例: `docker-compose.prod.yml`）で維持する構成を推奨。
2. 差分（追加サービス・ポート・volume）を [GLOBAL_DIFF_MATRIX](PHASE_TEMPLATE_GLOBAL_DIFF_MATRIX.md) に追記し、「なぜ template と違うか」を明示する。
3. [例外承認フロー](PHASE_TEMPLATE_GLOBAL_STANDARD_DECLARATION.md) に従い、理由を `docs/` に記録する（例: `<プロジェクト>_progress.md` に「本番のみ scheduler/queue を使用するため compose を分離」等）。

---

### 既存環境はそのまま（Docker 変更なし）— docs 開発スタイルのみ取り込む

**対象**

- 既に Docker や環境がセットアップ済みで、**infra や compose の変更は不要**な案件。
- tugilo の「進捗・INDEX・Phase（PLAN/WORKLOG/REPORT）」という開発スタイルだけ揃えたい場合。

**手順**

1. **docs/ のひな形を用意する**  
   tugilo-template の以下を当該プロジェクトにコピーし、`{{PROJECT}}` をプロジェクト名に置換する。  
   - `docs/INDEX.project` → 当該プロジェクトの `docs/INDEX.md`  
   - `docs/_progress.project.md` → 当該プロジェクトの `docs/<プロジェクト名>_progress.md`  
   - `docs/process/README.md` → 当該プロジェクトの `docs/process/README.md`（ディレクトリがなければ作成）
2. **.cursorrules に tugilo 開発スタイルを追記する**  
   tugilo-template の `docs/tugilo-style-append.cursorrules` の内容を、当該プロジェクトの **.cursorrules の末尾にそのまま追記**する。  
   （既存の .cursorrules が無い場合は、このファイル全体を .cursorrules として保存してよい。）
3. 以降、進捗は `docs/<プロジェクト名>_progress.md` に記録し、ドキュメントの追加・変更時は `docs/INDEX.md` を更新する。Phase が必要な場合は `docs/process/` に PLAN/WORKLOG/REPORT を置く。

**補足**

- Docker・compose・Makefile・bin には一切手を入れない。
- 既存の開発ルール（.cursorrules の既存内容）は残し、上記「開発スタイル」部分だけ追記する形にする。
- **省略**: tugilo-template の `bin/adopt-tugilo-style.sh` を実行すると、上記 1〜2 を一括で行える。当該プロジェクトのルートで `PROJECT=<名前> bash /path/to/tugilo-template/bin/adopt-tugilo-style.sh` または、template から `bash bin/adopt-tugilo-style.sh <対象プロジェクトのパス> <プロジェクト名>`。

---

| 状況 | 対応 |
|------|------|
| **既存が APP_PORT=80 のまま維持したい** | 標準が 80 なのでそのままでよい。競合時は PORT_GUARD で 81,82,… にスライド。 |
| **ポートを固定したい（スライドさせない）** | `PORT_GUARD=false` を project.env に設定し、`APP_PORT=80` 等を明示。 |
| **DB_PORT / PMA_PORT** | 標準レンジは DB 3307–3399、PMA 8081–8181。既存が 3306/8080 なら、移行時に 3307/8081 に変更するか、`PORT_GUARD=false` で既存値を維持する。 |

---

## 3. 既存データベースの扱い

- **dump 取得**: 移行前に `docker compose exec db mysqldump -u root -p ...` 等でダンプを取得し、別途保存する。
- **volumes 確認**: 既存の `db_data` 等の volume 名が template と異なる場合、compose の volume 名を合わせるか、データをインポートし直す必要がある。
- **文字コード確認**: template 標準は utf8mb4_unicode_ci。既存 DB が異なる場合は、移行後に `SHOW VARIABLES LIKE 'character_set%';` 等で確認し、必要なら dump/import 時に文字コードを指定する。

---

## 4. doctor による確認

**必須チェック**

```bash
make doctor
```

**確認項目**

- Docker running
- project.env 整合（COMPOSE_PROJECT_NAME, PROJECT, APP_PORT, DB_PORT, PMA_PORT 等）
- ポート競合（使用中ポートが想定どおりか）
- healthcheck OK（unhealthy がいないこと）
- Laravel HTTP 200（`http://localhost:<APP_PORT>` で応答すること）

いずれかが ❌ または 許容できない ⚠️ の場合は、ガイドの手順に戻り修正してから再度 doctor を実行する。

---

## 5. 移行完了の定義（DoD）

以下が満たされたら移行完了とする。

- [ ] `docker compose up`（または `make setup` 後の compose up）が成功している。
- [ ] `make doctor` の全項目が OK（または許容できる警告のみ）。
- [ ] 既存機能の動作確認（ログイン・migrate・主要画面・API）ができている。
- [ ] 進捗ファイル（`docs/<プロジェクト>_progress.md`）に移行日・採用パターン（A/B/C）・特記事項を記録している。

---

## 6. 禁止事項

- **既存 compose を独自改造しない**。template の infra をコピーした上で、必要な差分だけをドキュメント化して維持する。
- **標準をコピーせず手書きで再構築しない**。必ず template リポジトリから `infra/` `bin/` `Makefile` をコピーし、そのうえで project.env や docs で調整する。

---

*本ガイドは [PHASE_S_001_TEMPLATE_MIGRATION_GUIDE](PHASE_S_001_TEMPLATE_MIGRATION_GUIDE_PLAN.md) の成果物です。*
