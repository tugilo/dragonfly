# Phase 278 REPORT: 静岡合同懇親会 参加者名簿作成

## Summary

2026-07-08 19:44 JST — Google フォーム回答 43名を正規化し、A4 印刷用 HTML/PDF・スマホ閲覧用 HTML・正規化 CSV を `docs/pdf/260709/` に生成した。

## Deliverables

| ファイル | 内容 |
|----------|------|
| [bni_shizuoka_joint_social_roster_normalized.csv](../../pdf/260709/bni_shizuoka_joint_social_roster_normalized.csv) | 正規化 CSV（43名） |
| [bni_shizuoka_joint_social_roster_print.html](../../pdf/260709/bni_shizuoka_joint_social_roster_print.html) | A4 横向き印刷用 |
| [bni_shizuoka_joint_social_roster_print.pdf](../../pdf/260709/bni_shizuoka_joint_social_roster_print.pdf) | A4 印刷用 PDF（Chrome headless 生成） |
| [bni_shizuoka_joint_social_roster_mobile.html](../../pdf/260709/bni_shizuoka_joint_social_roster_mobile.html) | スマホ閲覧用 |
| [generate_roster.py](../../pdf/260709/generate_roster.py) | 再生成スクリプト |
| [source_form_responses.md](../../pdf/260709/source_form_responses.md) | Google Sheets 抽出原本 |

## Current Status

completed（develop merge 済み 2026-07-08 19:48 JST）

## Decisions

- フォーム分岐: `所属チャプター != その他` は E=chapter, F=category, H=comment。`その他` は F=実チャプター, G=category, I=comment。
- チャプター表記ゆれは自動統合しない（例: インフィニティー はそのまま）。
- A4 は横向き HTML を正式成果物とし、Chrome headless で PDF も生成。
- スマホ版は `<details>` 折りたたみ + カード、`mailto:` リンク、`noindex` メタ付き。

## 生成結果

- 参加者数: **43名**
- チャプター数: **17**
- チャプター順（参加者数降順）: DragonFly 8 → インフィニティー 6 → アクセル 4 → インテグラル 4 → EduTechエデュテック 3 → クロノス 3 → 浜松やらまいか 3 → ENISHI 2 → ZETA 2 → 各1名チャプター 8

## 確認候補（表記ゆれ・未統合）

- `インフィニティー` — SPEC-021 では `インフィニティ` 表記も存在。今回はフォーム回答どおり。
- 後藤聡美行 — カテゴリ列に長文（本来カテゴリか会社名か要確認）が入っているが、フォーム回答をそのまま反映。

## DoD Check

| Item | Result |
|------|--------|
| 正規化 CSV | OK — 43行 |
| チャプター参加者数降順 | OK |
| チャプター内名前順 | OK |
| A4 5項目表示 | OK |
| スマホ同内容 | OK |
| 個人情報注意書き | OK |
| INDEX / progress / PHASE_REGISTRY | OK |

## Test Results

docs フェーズのためコードテストは対象外。

## Merge Evidence

```
merge commit id: b3d11ffeb474aca2e8fb795be09c9d5e441f3f55
source branch: feature/phase278-shizuoka-joint-social-roster-outputs
target branch: develop
phase id: 278
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
