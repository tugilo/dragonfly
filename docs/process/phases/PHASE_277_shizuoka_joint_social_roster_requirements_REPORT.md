# Phase 277 REPORT: 静岡合同懇親会 参加者名簿要件整理

## Summary

2026-07-08 18:22 JST — 東京 NE リージョンの静岡メンバーと静岡リアルチャプターの合同懇親会向けに、Google フォーム回答から A4 印刷用・スマホ閲覧用の参加者名簿を作る要件を整理した。

## Deliverables

- [bni_shizuoka_joint_social_roster_requirements.md](../../requirements/bni_shizuoka_joint_social_roster_requirements.md)
- [PHASE_277_shizuoka_joint_social_roster_requirements_PLAN.md](PHASE_277_shizuoka_joint_social_roster_requirements_PLAN.md)
- [PHASE_277_shizuoka_joint_social_roster_requirements_WORKLOG.md](PHASE_277_shizuoka_joint_social_roster_requirements_WORKLOG.md)

## Current Status

completed（develop merge 済み 2026-07-08 19:48 JST）

## Decisions

- A4 印刷版は、参加者数が多いチャプター順、チャプター内は参加者名順とする。
- 表示項目はユーザー指定どおり「チャプター名・カテゴリ名・名前・メールアドレス・一言」とし、会社名は確認事項に残す。
- `所属チャプター = その他` の行は、`その他チャプター名` を実効チャプター名として扱う。
- スマホ閲覧は、PDF 共有ではなくレスポンシブ HTML を第一候補とする。
- メールアドレスを含むため、公開範囲・公開期限を確認事項として明示する。

## DoD Check

| Item | Result |
|------|--------|
| 入力元 Google Sheets と対象イベントを明記 | OK |
| A4 印刷用の表示項目・並び順・レイアウト方針 | OK |
| スマホ閲覧用の方式候補と推奨案 | OK |
| `その他` チャプター行の扱い | OK |
| 個人情報の公開範囲 | OK |
| 未確認事項 TODO | OK |
| INDEX / progress / PHASE_REGISTRY 同期 | OK |

## Test Results

docs フェーズのためコードテストは対象外。

## Merge Evidence

```
merge commit id: b3d11ffeb474aca2e8fb795be09c9d5e441f3f55
source branch: feature/phase278-shizuoka-joint-social-roster-outputs
target branch: develop
phase id: 277
phase type: docs
related ssot: SPEC-021
test command: スキップ（docs フェーズ）
test result: スキップ（docs フェーズ）
changed files:
docs/INDEX.md
docs/dragonfly_progress.md
docs/process/PHASE_REGISTRY.md
docs/process/phases/PHASE_277_shizuoka_joint_social_roster_requirements_PLAN.md
docs/process/phases/PHASE_277_shizuoka_joint_social_roster_requirements_REPORT.md
docs/process/phases/PHASE_277_shizuoka_joint_social_roster_requirements_WORKLOG.md
docs/process/phases/PHASE_278_shizuoka_joint_social_roster_outputs_PLAN.md
docs/process/phases/PHASE_278_shizuoka_joint_social_roster_outputs_REPORT.md
docs/process/phases/PHASE_278_shizuoka_joint_social_roster_outputs_WORKLOG.md
docs/pdf/260709/bni_shizuoka_joint_social_roster_mobile.html
docs/pdf/260709/bni_shizuoka_joint_social_roster_normalized.csv
docs/pdf/260709/bni_shizuoka_joint_social_roster_print.html
docs/pdf/260709/bni_shizuoka_joint_social_roster_print.pdf
docs/pdf/260709/generate_roster.py
docs/pdf/260709/source_form_responses.md
docs/requirements/bni_shizuoka_joint_social_roster_requirements.md
scope check: OK
ssot check: OK
dod check: OK
```

