# PHASE_140_BNI_USAGE_STRATEGY_DOC

| 項目 | 内容 |
|------|------|
| 作成日時 | 2026-05-26 19:48:47 |
| 最終更新日時 | 2026-05-26 19:48:47 |
| Phase ID | PHASE_140_BNI_USAGE_STRATEGY_DOC |
| Phase種別 | docs |
| Related SSOT | SPEC-009（リファーラル記録）, SPEC-001（Religo システム全体仕様） |
| Status | completed |

## Summary

今後の BNI 活用方針を、既存の Living Document とは別の運用ドキュメントとして `docs/strategy/networking/BNI_Tugilo_Usage_Strategy.md` に整理した。

主な整理内容:

- BNIを「紹介獲得の場」ではなく、困りごと・入口・商品導線の PDCA ラボとして使う方針
- Track C（診断 → 1本化PoC → 伴走開発）と Track P（月額クラウド・定型パッケージ）の使い分け
- 小中さんカテゴリ（使って学ぶAIツールの情報発信）との棲み分け
- 週次運用、121で確認する質問、直近の意思決定事項

## DoD結果

- `BNI_Tugilo_Usage_Strategy.md` を新規作成: 完了
- 運用方針として読める構成: 完了
- 小中さんカテゴリとの被り防止を明示: 完了
- Track P / Track C の振り分けを整理: 完了
- `docs/INDEX.md` 更新: 完了
- `PHASE_REGISTRY.md` 更新: 完了

## Merge Evidence

merge commit id: 未実施（ユーザーから commit / merge / push の明示依頼なし）
source branch: develop
target branch: develop
phase id: 140
phase type: docs
related ssot: SPEC-009, SPEC-001

test command: linter diagnostics
test result: No linter errors found / docsフェーズのため `php artisan test` はスキップ

changed files:

```text
docs/INDEX.md
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_140_BNI_USAGE_STRATEGY_DOC_PLAN.md
docs/process/phases/PHASE_140_BNI_USAGE_STRATEGY_DOC_WORKLOG.md
docs/process/phases/PHASE_140_BNI_USAGE_STRATEGY_DOC_REPORT.md
docs/strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md
docs/strategy/networking/BNI_Tugilo_Usage_Strategy.md
```

scope check: OK
ssot check: OK
dod check: OK

## Notes

- 今回はドキュメント整理のみでコード変更なし。
- 開発者指示により、明示依頼のない commit / merge / push は行っていない。
