# PHASE_140_BNI_USAGE_STRATEGY_DOC

| 項目 | 内容 |
|------|------|
| 作成日時 | 2026-05-26 19:48:47 |
| 最終更新日時 | 2026-05-26 19:48:47 |
| Phase ID | PHASE_140_BNI_USAGE_STRATEGY_DOC |
| Phase種別 | docs |
| Related SSOT | SPEC-009（リファーラル記録）, SPEC-001（Religo システム全体仕様） |

## Task1 - BNI運用方針ドキュメント新規作成

- 状態: 完了
- 判断: 既存 Living Document は台本・素材・実験ログが肥大化しているため、今後の判断に使う文書は別ファイルに切り出す。BNI を「紹介の場」ではなく「困りごと・入口・商品導線の PDCA ラボ」として使う方針を先頭に置く。
- 実施: `docs/strategy/networking/BNI_Tugilo_Usage_Strategy.md` を新規作成し、目的・原則・週次運用・Track P/C・カテゴリ棲み分け・1to1確認事項を整理する。
- 確認: docs フェーズとしてコード変更なし。

## Task2 - INDEX / Phase Registry 更新

- 状態: 完了
- 判断: 新規 docs を追加したため、`docs/INDEX.md` に参照導線を追加する。DevOS の Phase 管理に合わせて `PHASE_REGISTRY.md` に Phase 140 を記録する。
- 実施: BNI 活動戦略セクションへ新規文書を追加し、Phase Registry に Phase 140 を追加。
- 確認: 変更範囲は `docs/**` のみ。

## セルフチェック

- SSOT_REGISTRYから仕様を参照したか: OK
- SSOTと矛盾していないか: OK（BNI運用ドキュメントであり既存SPECの実装仕様変更なし）
- Scope違反はないか: OK
- WORKLOGに判断理由を記録したか: OK
