# PHASE_164_member_consultations_folder PLAN

## Phase Type
docs

## Purpose
メンバーから受ける細かい相談事を、1to1議事録や提案書とは分けて蓄積し、調査・検討・次アクションに整理できるドキュメント置き場を作る。

## Background
BNI/Religo 運用の中で、正式な案件化前の小さな相談を受けることがある。これまでは 1to1 ファイルや提案書に混在しやすかったため、相談単位で「何ができるか」を検討する中間置き場が必要になった。

## Related SSOT
N/A（docs 運用整理のみ。Religo の仕様・データモデル変更なし）

## Scope
docs のみ変更する。実装・DB変更・SSOT追加は行わない。

## Target Files
- docs/consultations/README.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- docs/process/PHASE_REGISTRY.md
- docs/process/phases/PHASE_164_member_consultations_folder_PLAN.md
- docs/process/phases/PHASE_164_member_consultations_folder_WORKLOG.md
- docs/process/phases/PHASE_164_member_consultations_folder_REPORT.md

## Implementation Strategy
新規ディレクトリは `docs/consultations/` とし、1to1 の関係履歴、proposals の共有資料、SSOT の確定仕様と役割を明確に分ける。README には用途、置くもの・置かないもの、命名規約、推奨フォーマット、運用ルールを記載する。

## Tasks
- [x] メンバー相談用ディレクトリを作成する
- [x] 運用 README を作成する
- [x] INDEX / progress / PHASE_REGISTRY を更新する
- [x] WORKLOG / REPORT を作成する
- [x] 差分を確認する

## DoD
- `docs/consultations/README.md` で相談メモの用途と運用方法が分かる
- 1to1、提案書、SSOT との置き場の違いが明記されている
- ファイル命名と推奨フォーマットが定義されている
- `docs/INDEX.md` から新規 README に辿れる
- `docs/dragonfly_progress.md` と `docs/process/PHASE_REGISTRY.md` に Phase 164 が記録されている

