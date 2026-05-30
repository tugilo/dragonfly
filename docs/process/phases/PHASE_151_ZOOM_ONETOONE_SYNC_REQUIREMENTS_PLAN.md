# PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS PLAN

## Phase Type
docs

## Purpose
Zoom と Religo の 1 to 1 連携（予定の自動起票・実施済み要約取得・実績時刻反映・相手の正規化）の **要件を整理した SSOT** を新規作成する。実装はしない。

## Background
- 1 to 1 は多くが Zoom で実施され、要約は手作業で `docs/meetings/1to1/` に貼り、`one_to_ones` には別途手入力している（二重・三重入力）。
- 議事録 md の多くで開始・終了時刻が `TODO`（Zoom 側に実績があるのに未転記）。
- ユーザー要望: ①Zoom の今後の予定から Religo の 1 to 1 予定を作る、②実施済み 1 to 1 の Zoom 要約を取得、③相手が Religo 未登録のことがあるため取り込み前に手動正規化が要る可能性。

## Related SSOT
- SPEC-012 Zoom 連携による 1 to 1 予定・実施・要約取り込み（本 Phase で新規作成）
- SPEC-006 ONETOONES_CROSS_CHAPTER_REQUIREMENTS（相手が他チャプター/未登録）
- SPEC-007 MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY（guest/visitor）
- SPEC-008 MEMBERS_DEDUPLICATION_RUNBOOK（正規化・重複・MemberMergeService）
- DATA_MODEL.md §4.12 one_to_ones

## Scope
docs のみ。`docs/SSOT/`・`docs/02_specifications/`・`docs/process/`・`docs/INDEX.md`・`docs/dragonfly_progress.md`。アプリコード・DB は変更しない。

## Target Files
- docs/SSOT/ZOOM_ONETOONE_SYNC_REQUIREMENTS.md（新規）
- docs/02_specifications/SSOT_REGISTRY.md（SPEC-012 追加）
- docs/process/phases/PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS_PLAN.md（本書）
- docs/process/phases/PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS_WORKLOG.md
- docs/process/phases/PHASE_151_ZOOM_ONETOONE_SYNC_REQUIREMENTS_REPORT.md
- docs/process/PHASE_REGISTRY.md（Phase 151 追記）
- docs/INDEX.md（SSOT・Phase 追記）
- docs/dragonfly_progress.md（進捗追記）

## Implementation Strategy
既存の Meetings 参加者 CSV 取込（M7/M8 系）のメンバー解決・候補提示・手動マッチング・反映ログのパターンを Zoom 取り込みに流用する前提で、要件・段階・リスクを整理する。実装は段階1（読取取り込み）→段階2（要約）→段階3（Webhook 自動化）の順を推奨として記載する。

## Tasks
- [ ] SSOT 要件本体 ZOOM_ONETOONE_SYNC_REQUIREMENTS.md を作成
- [ ] SSOT_REGISTRY.md に SPEC-012 を登録
- [ ] PHASE_REGISTRY.md に Phase 151 を追記
- [ ] docs/INDEX.md に SSOT・Phase ドキュメントを追記
- [ ] dragonfly_progress.md に進捗を追記

## DoD
- ユーザー提示の 3 要件を機能要件に展開し、補強要件（実績時刻・1to1 判定・重複防止・半自動フロー・Owner 連携）を含む SSOT が存在する。
- 相手未登録時の正規化フローが定義されている。
- SSOT_REGISTRY・PHASE_REGISTRY・INDEX・進捗が同期されている。
- docs フェーズのためテストは対象外。
