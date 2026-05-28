# PHASE MEMBERS-DEDUP-RUNBOOK-P0 — PLAN

## Phase ID

**MEMBERS-DEDUP-RUNBOOK-P0**

## Type

docs

## Related SSOT

- **SPEC-007:** [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](../../SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md)
- **SPEC-008（新規）:** [MEMBERS_DEDUPLICATION_RUNBOOK.md](../../SSOT/MEMBERS_DEDUPLICATION_RUNBOOK.md)

## Scope

- `docs/SSOT/`（SPEC-007 追記・SPEC-008 新規）
- `docs/02_specifications/SSOT_REGISTRY.md`
- `docs/INDEX.md` / `docs/dragonfly_progress.md`
- `docs/process/phases/*`（本 Phase の PLAN/WORKLOG/REPORT）
- `docs/process/PHASE_REGISTRY.md`

## Out of scope

- マージ機能のコード実装
- 同一人物の自動推定・本番データ直接更新

## Goal

1. `ImportParticipantsCsvCommand` および関連 Apply 系の **Member 合わせキー**をコード根拠で整理する。  
2. visitor/guest → member 化で起きうる **重複パターン**と **業務影響**を列挙する。  
3. **運用で防ぐ（A）** → **管理画面補助（B）** → **import 候補提示（C）** の段階案と難易度を文書化する。  
4. **マージ運用手順（概念）**を Runbook に落とす。

## DoD

- SPEC-008 Runbook が `docs/SSOT/` にあり、SSOT_REGISTRY・INDEX・進捗・PHASE_REGISTRY が更新されている。  
- SPEC-007 §3.3 が現行実装と矛盾しない。  
- REPORT に「重複発生条件・業務影響・推奨運用・将来案・難易度別選択肢」が記載されている。
