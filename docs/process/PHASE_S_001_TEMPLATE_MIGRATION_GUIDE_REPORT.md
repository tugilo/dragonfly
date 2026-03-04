# PHASE_S_001_TEMPLATE_MIGRATION_GUIDE_REPORT.md

## 作成ファイル一覧

| ファイル | 説明 |
|----------|------|
| docs/process/PHASE_S_001_TEMPLATE_MIGRATION_GUIDE_PLAN.md | 背景・目的・対象/非対象・絶対遵守・成果物・DoD。 |
| docs/process/PHASE_TEMPLATE_MIGRATION_GUIDE.md | 公式移行ガイド本体（移行パターン・ポート・DB・doctor・DoD・禁止事項）。 |
| docs/process/PHASE_S_001_TEMPLATE_MIGRATION_GUIDE_WORKLOG.md | 実施ログ。 |
| docs/process/PHASE_S_001_TEMPLATE_MIGRATION_GUIDE_REPORT.md | 本ファイル。 |
| docs/INDEX.md | process 一覧に上記 4 ドキュメントを追加。 |

## 移行パターン整理結果

| パターン | 対象 | 主な手順 |
|----------|------|----------|
| **A: 最小移行** | 既存がほぼ template と同じ | バックアップ → template の infra/bin/Makefile コピー → project.env 作成 → make doctor → 差分メモ。 |
| **B: 標準移行** | healthcheck 未実装・固定ポート・Apache 内包 | 既存停止 → template 構成へ置換 → APP_PORT 8000 系へ → PORT_GUARD=true で make setup → make doctor → 機能確認。 |
| **C: 例外移行** | 本番専用・queue/scheduler/certbot・特殊ネットワーク | template をベースにし、差分を GLOBAL_DIFF_MATRIX に追記。例外承認フローに従い理由を docs に記録。 |

## 差分吸収方針

- **ポート**: 80 維持なら PORT_GUARD=false。標準へ寄せるなら 8000 系 + PORT_GUARD=true。ガイドに表で明示。
- **DB**: dump 取得・volume 名・文字コードを移行前に確認する手順をガイドに記載。template 標準は utf8mb4_unicode_ci。
- **本番専用**: 開発用は template のまま、本番用は別 compose で維持する構成を推奨。差分は GLOBAL_DIFF_MATRIX と progress に記録。

## 既存 4 案件への適用想定

| 案件 | 推奨パターン | 補足 |
|------|--------------|------|
| **protectlab** | B または C | Apache 内包・mailpit。標準移行で nginx+php-fpm に寄せるか、例外として Apache を維持し差分をマトリクスに追記。 |
| **tsuboi** | A | ほぼ template に近い。最小移行で template をコピーし、pgadmin 等の追加要件だけ docs で管理。 |
| **muraconet** | C | 本番専用・scheduler/queue/certbot。template を開発用ベースとし、本番用 compose は別ファイルで維持。差分を GLOBAL_DIFF_MATRIX に追記。 |
| **dandreez** | B | 固定ポート・healthcheck なし。標準移行で template に置換し、PORT_GUARD でポートを整理。 |

## 次フェーズ候補

- **各案件での実際の移行実行**: 本ガイドに沿って protectlab / tsuboi / muraconet / dandreez のいずれかから順次移行し、progress に結果を記録する。
- **移行チェックリストのテンプレート化**: `docs/_progress.project.md` や .cursorrules に「移行時は MIGRATION_GUIDE を参照すること」を追記し、AI（Cursor）がガイドを参照しやすくする。
- **GLOBAL_DIFF_MATRIX の更新**: 移行完了ごとにマトリクスの「移行時の対応」列を実績で更新する。

## DoD

- [x] MIGRATION_GUIDE 作成済み
- [x] 3 パターン（A/B/C）定義済み
- [x] doctor による確認手順を記載済み
- [x] INDEX 更新済み
- [x] 1 commit

## commit ID

`f1ff9cb`
