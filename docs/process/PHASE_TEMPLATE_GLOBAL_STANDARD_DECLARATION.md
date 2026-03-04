# tugilo 全案件標準宣言（GLOBAL STANDARD DECLARATION）

## 1. 宣言

- **tugilo-template** を **全案件共通の唯一の Docker 基盤** とする。
- Docker 構成の **SSOT（Single Source of Truth）** は本リポジトリ（tugilo-template）である。

## 2. 適用範囲

- **新規案件**: 必ず本テンプレートから開始する（`make new-project <名前>`）。
- **既存案件**: 順次移行対象とする。移行時は本テンプレートの infra をベースにし、差分は [GLOBAL_DIFF_MATRIX](PHASE_TEMPLATE_GLOBAL_DIFF_MATRIX.md) に従って正当な理由がある場合のみ許容する。

## 3. 標準仕様

| 項目 | 標準値 |
|------|--------|
| PHP | 8.4 |
| Node | 20 |
| MariaDB | 11.2 |
| healthcheck | 必須（db → app → nginx / phpmyadmin） |
| restart | unless-stopped（全サービス） |
| 設定管理 | project.env（ポート・バージョン） |
| PORT_GUARD | 有効（競合時は自動スライド、レンジ内） |
| ポートレンジ | APP_PORT 8000–8999 / DB_PORT 3307–3399 / PMA_PORT 8081–8181 |

## 4. 禁止事項

- 既存案件ごとに Docker 構成を **バラバラに** 作らない。本テンプレートをコピーした上で、必要な差分のみをドキュメント化して維持する。
- **監査なしに** compose を改造しない。変更する場合は PLAN / WORKLOG / REPORT で理由と影響を残す。

## 5. 例外承認フロー

標準から外れる運用（例: 別 Web サーバー・別 DB エンジン・特殊ポート）が必要な場合は、以下を満たすこと。

- 理由を **docs/** に記録する（例: `<プロジェクト>_progress.md` または process 内の REPORT）。
- 本テンプレート側に **取り込むべき普遍的な改善** であれば、テンプレートを更新し全案件に反映する方針を優先する。

## 6. 将来バージョン管理方針

- テンプレートのメジャーな仕様変更は **docs/process/** に Phase として PLAN / WORKLOG / REPORT を残す。
- README の「tugilo Standard Docker Infrastructure」のバージョン（v1.0 等）を更新し、変更内容を更新履歴に明記する。
- 既存プロジェクトは、テンプレートの変更を **取り込むかどうか** をプロジェクト単位で判断し、取り込む場合は make や bin をテンプレートから上書きコピーする運用を推奨する。
