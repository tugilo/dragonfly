# Phase 278 PLAN: 静岡合同懇親会 参加者名簿作成

## Phase 情報

| 項目 | 内容 |
|------|------|
| Phase ID | 278 |
| Phase 種別 | docs |
| ブランチ | `main`（既存未コミット変更あり。ブランチ切替は未実施） |
| 開始 | 2026-07-08 19:43 JST |
| Status | completed |

## 背景・目的

Phase 277 で整理した [`bni_shizuoka_joint_social_roster_requirements.md`](../../requirements/bni_shizuoka_joint_social_roster_requirements.md) に従い、Google フォーム回答から A4 印刷用・スマホ閲覧用の参加者名簿を作成する。

## Related SSOT

- **SPEC-021** [REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md](../../SSOT/REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md)
- [bni_shizuoka_joint_social_roster_requirements.md](../../requirements/bni_shizuoka_joint_social_roster_requirements.md)

## Scope

### In

| 領域 | 対象 |
|------|------|
| 正規化 CSV | `docs/pdf/260709/bni_shizuoka_joint_social_roster_normalized.csv` |
| A4 印刷 HTML | `docs/pdf/260709/bni_shizuoka_joint_social_roster_print.html` |
| スマホ HTML | `docs/pdf/260709/bni_shizuoka_joint_social_roster_mobile.html` |
| 生成スクリプト | `docs/pdf/260709/generate_roster.py` |
| Phase docs | PLAN / WORKLOG / REPORT |
| Docs sync | INDEX / progress / PHASE_REGISTRY |

### Out

- Religo DB 取り込み
- Web アプリ実装
- Google Sheets 原本の編集

## Tasks

1. Google Sheets 抽出から正規化 CSV を作成する。
2. A4 横向き印刷用 HTML を生成する。
3. スマホ閲覧用 HTML を生成する。
4. 件数・並び順・個人情報注意書きを確認する。
5. INDEX / progress / PHASE_REGISTRY / REPORT を同期する。

## DoD

- [x] 正規化 CSV が `chapter_name, category, name, email, comment` を持つ。
- [x] チャプターは参加者数が多い順、チャプター内は参加者名順。
- [x] A4 印刷 HTML に指定5項目が表示される。
- [x] スマホ HTML がカード形式で同内容を表示する。
- [x] 個人情報・限定共有の注意書きがある。
- [x] INDEX / progress / PHASE_REGISTRY / REPORT が同期されている。
