# PHASE_138_BNI_ENTRY_DESIGN PLAN

## Phase Type
docs

## Purpose

2026-05-26 DragonFly定例会（小中さんシェアストーリー）の学びを、Living Document §10 に「入口設計」として落とし込む。AIコミュニティ化ではなく、tugilo 既存思想（構造・時間・手段としてのAI）を維持したまま、小中さんとの差別化を明確にする。

## Related SSOT

- 本ファイル自体が SSOT（`BNI_Tsugihiro_Atsushi_Intro_Living_Document.md`）
- [chapter_weekly_20260526.md](../../meetings/chapter/chapter_weekly_20260526.md) — 定例会議事録

## Scope

docs フェーズとして `docs/**` のみ変更する。

## Target Files

- `docs/strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_138_BNI_ENTRY_DESIGN_PLAN.md`
- `docs/process/phases/PHASE_138_BNI_ENTRY_DESIGN_WORKLOG.md`
- `docs/process/phases/PHASE_138_BNI_ENTRY_DESIGN_REPORT.md`

## Implementation Strategy

1. §10.2 直後に **§10.3 小中さんの学びから見えたtugiloの入口設計** を新設する。
2. 既存 §10.3〜§10.6 は §10.4〜§10.7 に繰り下げ、内部リンクを更新する。
3. §10.2 の締めを §10.3 へ誘導する形に整理し、重複表現を削る。
4. §10.6（旧10.5）実践チェックリストに入口統一の3項目を追加する。
5. 変更ログ最上部に 2026-05-26 の追記を行う。

## Tasks

- [x] Phase 138 の PLAN / WORKLOG / REPORT を作成する
- [x] Living Document §10.3 を追加し §10.4〜§10.7 に繰り下げる
- [x] §10.6 チェックリストを更新する
- [x] INDEX・PHASE_REGISTRY・進捗を同期する

## DoD

- §10.3 に「入口設計」の本質・小中/tugilo差別化・結論が記載されている
- §10.6 チェックリストに指定3項目が追加されている
- 変更ログに 2026-05-26 の追記がある
- §10.4〜§10.7 への内部リンクが整合している
- docs INDEX と PHASE_REGISTRY と進捗が更新されている
- docs フェーズのためコード変更・テスト実行は不要
