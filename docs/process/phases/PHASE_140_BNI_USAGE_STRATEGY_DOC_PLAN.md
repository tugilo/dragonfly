# PHASE_140_BNI_USAGE_STRATEGY_DOC

| 項目 | 内容 |
|------|------|
| 作成日時 | 2026-05-26 19:48:47 |
| 最終更新日時 | 2026-05-26 19:48:47 |
| Phase ID | PHASE_140_BNI_USAGE_STRATEGY_DOC |
| Phase種別 | docs |
| Branch | develop |
| Related SSOT | SPEC-009（リファーラル記録）, SPEC-001（Religo システム全体仕様） |

## 目的

今後の BNI 活用方針を、既存の `BNI_Tsugihiro_Atsushi_Intro_Living_Document.md` から切り出し、tugilo としての運用判断・カテゴリ棲み分け・Track P/C の使い分けを別ドキュメントとして参照できるようにする。

## Scope

変更可能:

- `docs/strategy/networking/**`
- `docs/INDEX.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_140_BNI_USAGE_STRATEGY_DOC_*.md`

変更禁止:

- `app/**`
- `resources/**`
- `routes/**`
- `database/**`
- `www/**`
- `package.json`
- `composer.json`

## DoD

- `docs/strategy/networking/BNI_Tugilo_Usage_Strategy.md` を新規作成する
- 今後の BNI 利用方針を、単なる台本ではなく運用方針として読める構成にする
- 小中さんカテゴリとの被り防止を明示する
- Track P（Product）/ Track C（Custom）を BNI 紹介後の振り分けとして整理する
- `docs/INDEX.md` に新規ドキュメントを追加する
- `PHASE_REGISTRY.md` に Phase 140 を記録する

## 作業方針

- 既存 Living Document の §10〜§11 を SSOT 的な素材として参照し、重複しすぎない形で「運用版」に再構成する
- 25秒・BO・121 の台本詳細は Living Document に残し、新規文書では「いつ何を使うか」を整理する
- 小中さんとのカテゴリ境界は、BNI 内での紹介精度と関係性を守る安全装置として独立項目にする
