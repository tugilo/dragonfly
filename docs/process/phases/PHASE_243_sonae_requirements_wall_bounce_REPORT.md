# PHASE_243_sonae_requirements_wall_bounce REPORT

**作成日時:** 2026-06-24 18:22:02  
**最終更新日時:** 2026-06-24 18:35:01  
**Phase Type:** docs  
**Related SSOT:** SPEC-017  
**Status:** completed

---

## 概要

SONAE PoC 着手前の壁打ちで合意した要件を、[`SONAE_WALL_BOUNCE_DECISIONS.md`](../../SSOT/SONAE_WALL_BOUNCE_DECISIONS.md) と [`SONAE_REQUIREMENTS.md`](../../SSOT/SONAE_REQUIREMENTS.md) に反映した。実装（Phase 242）は本 Phase では行わない。

主な追記内容:

- Religo オプション、`sonae_members` 実行時正、JMA 9種、閾値 UI
- **LINE 紐付け済みメンバーのみ** Push 通知対象（パイロットフラグなし・段階展開）
- 被害あり定義（軽傷以上）、訓練回答率比較、導入5ステップ Runbook
- 訓練/本番同一回答 UI、飯田香さん確認事項 §16.1

---

## 変更ファイル

- `docs/SSOT/SONAE_WALL_BOUNCE_DECISIONS.md`（新規）
- `docs/SSOT/SONAE_REQUIREMENTS.md`
- `docs/02_specifications/SSOT_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_243_*`

---

## Merge Evidence

```
merge commit id: 7307a2df5eade22fa7c7f8372fc88402b22d64b4
source branch: feature/phase243-sonae-requirements-wall-bounce
target branch: develop
phase id: 243
phase type: docs
related ssot: SPEC-017

test command: スキップ（docsフェーズ）
test result: スキップ

changed files:
docs/02_specifications/SSOT_REGISTRY.md
docs/INDEX.md
docs/SSOT/SONAE_REQUIREMENTS.md
docs/SSOT/SONAE_WALL_BOUNCE_DECISIONS.md
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_243_sonae_requirements_wall_bounce_PLAN.md
docs/process/phases/PHASE_243_sonae_requirements_wall_bounce_REPORT.md
docs/process/phases/PHASE_243_sonae_requirements_wall_bounce_WORKLOG.md

scope check: OK
ssot check: OK
dod check: OK
```
