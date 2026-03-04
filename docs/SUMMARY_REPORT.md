# tugilo Infrastructure Constitution v1.0

**基盤憲章** — tugilo Standard Docker Infrastructure を制度として固定する文書。  
元の「全体まとめ報告」の内容を包含し、宣誓・バージョン管理・変更可否・承認フローを追記した。

---

## 宣誓文

**tugilo の全プロジェクトは、本基盤を唯一の Docker 標準とする。**  
**個別最適ではなく全体最適を優先する。**  
**Docker 構成の正（SSOT）は本リポジトリのみとする。**

---

## 制度としての目的（なぜ制度化したか）

- **属人化防止**: 誰が関わっても同じ手順・同じ判断基準で動くようにする。
- **AI 暴走防止**: Cursor 等の AI が独自解釈で compose や bin を書き換えないよう、変更可否と承認フローを明示する。
- **案件間の一貫性**: 全案件が同じ思想（infra・project.env・healthcheck・PORT_GUARD）を共有し、差分はドキュメントで管理する。
- **長期的保守性**: バージョンと変更可否を決めておくことで、将来の変更を Phase 管理し、戻れない状態を維持する。

---

## 1. プロジェクトの位置づけ

- **tugilo Standard Docker Infrastructure v1.0** … 全案件共通の唯一の Docker 基盤。
- **SSOT** … Docker 構成の正は本リポジトリのみ。新規案件は必ずここから開始。
- **思想** … 一貫性（同じ構成・手順・AI 指示）、堅牢性（ポート競合・起動順序・文字コードの標準化）。

---

## 2. 時系列で見た実施内容（最初から）

### 2.1 初回セットアップ（土台）

- Laravel + Docker（PHP 8.4, Node 20, MariaDB 11.2, Nginx, phpMyAdmin）。
- `make setup` / `make new-project <名前>` でプロジェクト作成。
- ポート: 80 / 8081 / 3307。COMPOSE_PROJECT_NAME でプロジェクト名を指定。

### 2.2 プロジェクトごと infra

- 各プロジェクトが自分の `infra/` を持ち、その中で `docker compose` する構成に変更。
- `make new-project <名前>` でテンプレートをコピーしてから、そのプロジェクトで `make setup` を実行。

### 2.3 docs・進捗・INDEX ルール

- `docs/INDEX.md` と `docs/process/README.md` を新設。
- 進捗は **docs/<プロジェクト名>_progress.md** に統一。PLAN/WORKLOG/REPORT は docs/process/ に配置。
- ドキュメント追加・変更・削除時は **必ず INDEX を更新** するルールを .cursorrules / README に明記。

### 2.4 Cursor ルール

- テンプレート用 `.cursorrules`、プロジェクト用 `.cursorrules.project`（`{{PROJECT}}` を置換）を追加。
- `make new-project` で各プロジェクトに `.cursorrules` を自動生成。  
- 進捗・INDEX ルールを README に追記。

### 2.5 Docker 監査（protectlab / tsuboi / muraconet / dandreez）

- 上記 4 プロジェクトの docker-compose 等を横断調査し、template に取り込む「標準」を決定。
- **取り込み内容**: healthcheck（db→app→nginx/phpmyadmin）, restart: unless-stopped, ポートを project.env で管理, depends_on condition: service_healthy, MariaDB の文字セット/照合順序, nginx の client_max_body_size 64m。
- 成果物: PHASE_TEMPLATE_DOCKER_AUDIT_PLAN / WORKLOG / REPORT、監査表・標準採用根拠。

### 2.6 ポートガード（PHASE_TEMPLATE_PORT_GUARD）

- ポート競合時も `make setup` が失敗しないよう、**空きポートへ自動スライド** する仕組みを導入。
- **bin/preflight.sh** を新規作成: `is_port_in_use` / `find_free_port`（lsof または nc、最大10回）。決定ポートを project.env に保存。
- **bin/setup.sh** を修正: project.env 生成前に preflight を実行。競合時は `⚠️  3307 is already in use. Switching to 3309` のようにログ出力。
- 強制指定時（例: `APP_PORT=9000 make setup`）はスライドしない。README に挙動を明記。
- 成果物: PHASE_TEMPLATE_PORT_GUARD_PLAN / WORKLOG / REPORT。

### 2.7 全案件標準化（PHASE_TEMPLATE_STANDARDIZE_ALL_PROJECTS）

- **標準宣言**: GLOBAL_STANDARD_DECLARATION（適用範囲・標準仕様・禁止事項・例外承認フロー・将来バージョン方針）。
- **差分の固定**: GLOBAL_DIFF_MATRIX（template と 4 プロジェクトの比較表・template が最適解である理由・移行時の対応）。
- **PORT_GUARD 強化**: ポートレンジ制限（APP 8000–8999 / DB 3307–3399 / PMA 8081–8181）、**docker ps** のバインドも検出、**PORT_GUARD=true/false** フラグ。APP デフォルトを **8000** に変更。
- **make doctor**: 基盤自己診断（Docker 起動・必須ファイル・project.env・ポート・healthcheck・Laravel 応答）。
- **README を標準仕様書に昇格**: 「tugilo Standard Docker Infrastructure v1.0」、標準思想・適用ポリシー・例外承認フロー・将来バージョン管理方針を追記。
- 成果物: STANDARDIZE の PLAN/WORKLOG/REPORT、GLOBAL_STANDARD_DECLARATION、GLOBAL_DIFF_MATRIX、bin/doctor.sh、README 更新。

### 2.8 公式移行ガイド（PHASE_S_001_TEMPLATE_MIGRATION_GUIDE）

- 既存案件を template 標準へ **安全に移行するための公式手順書** を固定（ドキュメントのみ、コード変更なし）。
- **移行パターン**: A（最小移行・安全優先）、B（標準移行・推奨）、C（例外移行）。
- **ポートの扱い**: 80 維持なら PORT_GUARD=false。標準へ寄せるなら 8000 系 + PORT_GUARD=true。
- **既存 DB**: dump 取得・volumes 確認・文字コード確認。
- **doctor**: `make doctor` による必須確認項目を記載。
- **移行完了 DoD**: compose up 成功・doctor 全項目 OK・既存機能確認・進捗ファイル記録。
- **禁止事項**: 既存 compose の独自改造禁止、標準を手書きで再構築しない。
- 成果物: PHASE_S_001_TEMPLATE_MIGRATION_GUIDE_PLAN、PHASE_TEMPLATE_MIGRATION_GUIDE（本体）、WORKLOG、REPORT。

---

## 3. 現在の構成・使い方（要約）

| 項目 | 内容 |
|------|------|
| **新規プロジェクト** | `make new-project PROJECT=<名前>`（テンプレート内で実行）。隣に `<名前>` ができ、その中で `make setup` が実行される。 |
| **既存プロジェクトのセットアップ** | プロジェクト直下で `make setup`。ポートは PORT_GUARD で自動スライド（標準は APP=8000, DB=3307, PMA=8081）。 |
| **基盤の自己診断** | `make doctor`。Docker・project.env・ポート・healthcheck・Laravel 応答を確認。 |
| **設定の正** | project.env（APP_PORT, DB_PORT, PMA_PORT, PORT_GUARD 等）。compose は変更せず、project.env で制御。 |

---

## 4. ドキュメント一覧（docs/ まわり）

- **INDEX**: docs/INDEX.md（一覧と更新ルール）。追加・変更・削除のたびに更新必須。
- **進捗**: docs/<プロジェクト名>_progress.md。
- **process**: PLAN / WORKLOG / REPORT を docs/process/ に配置。TEMPLATE_SETUP、DOCKER_AUDIT、PORT_GUARD、STANDARDIZE、GLOBAL 宣言・差分マトリクス、MIGRATION_GUIDE の各 Phase。
- **本ファイル**: docs/SUMMARY_REPORT.md（**基盤憲章 v1.0**。全体まとめ報告を包含し、宣誓・Versioning Policy・Change Control Matrix・Change Approval Flow を追加）。

---

## 5. 既存 4 案件との関係

| 案件 | 移行ガイドでの推奨パターン | 備考 |
|------|---------------------------|------|
| protectlab | B または C | Apache 内包・mailpit。標準移行で nginx+php-fpm に寄せるか、例外として差分をマトリクスに追記。 |
| tsuboi | A | ほぼ template に近い。最小移行で template をコピーし、pgadmin 等は docs で管理。 |
| muraconet | C | 本番専用・scheduler/queue/certbot。template を開発用ベースとし、本番用は別 compose。差分を GLOBAL_DIFF_MATRIX に追記。 |
| dandreez | B | 固定ポート・healthcheck なし。標準移行で template に置換し、PORT_GUARD でポートを整理。 |

移行時は **docs/process/PHASE_TEMPLATE_MIGRATION_GUIDE.md** に従う。

---

## 6. 次にやること（候補）

- 既存案件の **実際の移行**（上記 4 案件のいずれかから、MIGRATION_GUIDE に沿って実施し、progress に記録）。
- 移行完了ごとに **GLOBAL_DIFF_MATRIX** の「移行時の対応」を実績で更新。
- テンプレートの変更を既存プロジェクトに **取り込むかどうか** の判断と、必要に応じた infra/bin/Makefile の上書きコピー。

---

## Versioning Policy

- **v1.x**: 互換性を維持する変更のみ。既存の project.env・compose の使い方を壊さない。
- **v2.0**: 破壊的変更（例: デフォルトポートの変更・compose 構造の変更）を行う場合のメジャー版。
- 破壊的変更は **必ず Phase 管理**（PLAN / WORKLOG / REPORT）と **宣言**（本憲章または GLOBAL_STANDARD_DECLARATION の更新）を行う。
- **GLOBAL_DIFF_MATRIX** の更新は必須。既存案件への影響を明示する。

---

## Change Control Matrix

| 項目 | 変更可否 | 条件 |
|------|----------|------|
| project.env | **可** | 推奨制御点。プロジェクトごとに編集してよい。 |
| docker-compose.yml | **原則不可** | 変更する場合は Phase 管理 + 承認。テンプレート本体の変更は全案件に影響するため慎重に。 |
| bin/ | **原則不可** | 変更する場合は Phase 必須。preflight / setup / doctor の役割を崩さない。 |
| Makefile | **原則不可** | 変更する場合は Phase 必須。setup / new-project / doctor のインターフェースを崩さない。 |
| docs/process | **可** | 新規 Phase の PLAN / WORKLOG / REPORT 追加は推奨。**INDEX 更新必須**。 |
| README | **原則不可** | 標準仕様書として扱う。変更する場合は Phase 管理し、更新履歴に明記。 |

---

## Change Approval Flow

基盤に影響する変更（compose / bin / Makefile / 憲章の破壊的変更）は、以下を満たすこと。

1. **PLAN 作成** … docs/process/ に PHASE_*_PLAN.md を作成。背景・目的・成果物・DoD を記載。
2. **WORKLOG 記録** … 実施内容を WORKLOG に記録。
3. **REPORT 作成** … 変更点・DoD の達成状況を REPORT に記載。
4. **INDEX 更新** … docs/INDEX.md の process 一覧に追加・整合する。
5. **1 Phase = 1 commit** … 上記を満たしたうえで、1 コミットにまとめる。

---

*本憲章は、tugilo Standard Docker Infrastructure を制度として固定するため、SUMMARY_REPORT を昇格し宣誓・バージョン・変更可否・承認フローを追記したものです。*
