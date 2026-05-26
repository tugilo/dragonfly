# PHASE_145_BNI_MONTHLY_FOCUS_CANDIDATES

| 項目 | 内容 |
|------|------|
| 作成日時 | 2026-05-26 20:08:12 |
| 最終更新日時 | 2026-05-26 20:08:12 |
| Phase ID | PHASE_145_BNI_MONTHLY_FOCUS_CANDIDATES |
| Phase種別 | docs |
| Related SSOT | SPEC-009（リファーラル記録）, SPEC-001（Religo システム全体仕様） |
| Status | completed |

## Summary

`BNI_Tugilo_Usage_Strategy.md` に、毎月3〜5人だけ集中する `今月の重点パワーチーム候補` を追加した。

主な変更:

- `今月の重点パワーチーム候補` を追加
- 小中さん・深澤さん・採用連携候補の例を追加
- 今月目的・次アクション・状態を管理する表を追加
- 目的は人数ではなく「今月どこに時間を使うか」を決めること、と明記
- 更新履歴に 2026-05-26 の変更ログを追加

## DoD結果

- `パワーチーム候補（育成中）` の後に `今月の重点パワーチーム候補` を追加: 完了
- 毎月3〜5人だけ設定する方針を明記: 完了
- 小中さん・深澤さん・採用連携候補の例を追加: 完了
- 目的は人数ではなく行動優先順位決定と明記: 完了
- 更新履歴に変更ログを追加: 完了
- `PHASE_REGISTRY.md` と `dragonfly_progress.md` を更新: 完了

## Merge Evidence

merge commit id: 未実施（ユーザーから commit / merge / push の明示依頼なし）
source branch: develop
target branch: develop
phase id: 145
phase type: docs
related ssot: SPEC-009, SPEC-001

test command: linter diagnostics / git diff --check
test result: linter errorsなし / `git diff --check` OK / docsフェーズのため `php artisan test` はスキップ

changed files:

```text
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_145_BNI_MONTHLY_FOCUS_CANDIDATES_PLAN.md
docs/process/phases/PHASE_145_BNI_MONTHLY_FOCUS_CANDIDATES_WORKLOG.md
docs/process/phases/PHASE_145_BNI_MONTHLY_FOCUS_CANDIDATES_REPORT.md
docs/strategy/networking/BNI_Tugilo_Usage_Strategy.md
```

scope check: OK
ssot check: OK
dod check: OK

## Notes

- 既存のパワーチーム候補表・成熟度管理は維持。
- 明示依頼のない commit / merge / push は行っていない。
