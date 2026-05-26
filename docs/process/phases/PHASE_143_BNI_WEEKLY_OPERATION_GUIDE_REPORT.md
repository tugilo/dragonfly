# PHASE_143_BNI_WEEKLY_OPERATION_GUIDE

| 項目 | 内容 |
|------|------|
| 作成日時 | 2026-05-26 20:03:29 |
| 最終更新日時 | 2026-05-26 20:03:29 |
| Phase ID | PHASE_143_BNI_WEEKLY_OPERATION_GUIDE |
| Phase種別 | docs |
| Related SSOT | SPEC-009（リファーラル記録）, SPEC-001（Religo システム全体仕様） |
| Status | completed |

## Summary

`BNI_Tugilo_Usage_Strategy.md` を、今後半年〜1年間の BNI 活動運用ガイドとして使えるように仕上げた。

主な変更:

- `BNI週間運用テンプレート` を追加
- 月曜（定例会前）・定例会当日・定例会後の運用項目を整理
- `パワーチーム成熟度` を追加
- 候補 → 構築中 → 実験中 → 稼働中 → コア の定義を追加
- `直近の意思決定事項` に BNI運用・パワーチーム成熟度管理・Living Document更新を追加
- 更新履歴に 2026-05-26 の変更ログを追加

## DoD結果

- `週次運用` の後に `BNI週間運用テンプレート` を追加: 完了
- `パワーチーム候補（育成中）` の下に `パワーチーム成熟度` を追加: 完了
- `直近の意思決定事項` に3項目追加: 完了
- 更新履歴に変更ログを追加: 完了
- `PHASE_REGISTRY.md` と `dragonfly_progress.md` を更新: 完了

## Merge Evidence

merge commit id: 未実施（ユーザーから commit / merge / push の明示依頼なし）
source branch: develop
target branch: develop
phase id: 143
phase type: docs
related ssot: SPEC-009, SPEC-001

test command: linter diagnostics / git diff --check
test result: linter errorsなし / `git diff --check` OK / docsフェーズのため `php artisan test` はスキップ

changed files:

```text
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_143_BNI_WEEKLY_OPERATION_GUIDE_PLAN.md
docs/process/phases/PHASE_143_BNI_WEEKLY_OPERATION_GUIDE_WORKLOG.md
docs/process/phases/PHASE_143_BNI_WEEKLY_OPERATION_GUIDE_REPORT.md
docs/strategy/networking/BNI_Tugilo_Usage_Strategy.md
```

scope check: OK
ssot check: OK
dod check: OK

## Notes

- 既存思想（人を増やす前に構造を変える、AIは手段、症状型リクエスト、tugilo=課題整理・設計・接続役、BNI=PDCAラボ、DragonFly=実行ネットワーク）は維持。
- 明示依頼のない commit / merge / push は行っていない。
