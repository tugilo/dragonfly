# PHASE_165_imanishi_ilc_consultation PLAN

## Phase Type
docs

## Purpose
今西さんからの「加盟店向け月次集計表作成を簡単に処理できないか」という相談を、AiLC 相談メモとして記録し、添付データの初期構造確認と対応方針を整理する。

## Background
`docs/consultations/ILC/` 配下には、チカラグループ・ファボローネの TSV、Excel、作業手順 PDF が配置されている。現状はシステム担当者が TSV を Excel に貼り付け、マクロ・数式・手作業転記を使って加盟店向け集計表を作成している可能性が高い。見せ方変更は許容されているため、既存 Excel 完全再現ではなく、TSV から集計ロジックを再構成できるかを検討する。

## Related SSOT
N/A（相談メモ・初期検証のみ。Religo の仕様・データモデル変更なし）

## Scope
docs のみ変更する。実装・DB変更・本格的な集計ツール作成は行わない。

## Target Files
- docs/consultations/ILC/README.md
- docs/consultations/ILC/consultation_imanishi_monthly_report_automation.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_165_imanishi_ilc_consultation_PLAN.md
- docs/process/phases/PHASE_165_imanishi_ilc_consultation_WORKLOG.md
- docs/process/phases/PHASE_165_imanishi_ilc_consultation_REPORT.md

## Implementation Strategy
相談者の文面は原文に近い形で残し、検証対象データの事実確認と、自動化可能性・追加確認事項・次アクションを整理する。TSV / Excel / PDF の初期確認は、今後の試作判断に必要な範囲に留める。

## Tasks
- [x] AiLC 相談メモを新規作成する
- [x] AiLC フォルダ README を作成する
- [x] TSV / Excel / 手順 PDF の初期構造を確認する
- [x] INDEX / progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する
- [x] 差分を確認する

## DoD
- 今西さんからの相談内容が `docs/consultations/ILC/` 配下に記録されている
- 対象データ・現状運用・自動化できそうな範囲が整理されている
- 追加確認事項と次アクションが明記されている
- `docs/INDEX.md` から AiLC 相談メモへ辿れる
- `docs/dragonfly_progress.md` と `docs/process/PHASE_REGISTRY.md` に Phase 165 が記録されている

