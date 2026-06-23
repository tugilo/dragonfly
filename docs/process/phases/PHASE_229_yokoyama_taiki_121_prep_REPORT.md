# Phase 229 REPORT: 横山太樹 121事前準備

## Summary

渡邊真大さん紹介による横山太樹さん（株式会社ARATAS / DragonFly ビジター）との **2026-06-19 JST 14:00〜** 初回 121 に向けて、ユーザー提供のビジター情報・アンケート・対応履歴、DragonFly 2026-06-09 定例会議事録、および公開HP確認をもとに事前準備ドキュメントを作成した。

成果物では、横山さんを「補助金・融資の人」と単純化せず、**元銀行員と税理士が並走する財務顧問**として整理した。1年以内に資金調達を検討している中小企業、製造業・設備投資・補助金活用、DragonFly への入会検討状況を、121で自然に確認できる構成にした。

## Deliverables

- `docs/meetings/1to1/1to1_yokoyama_taiki_aratas.md`
  - 直前用 5分メモ
  - 冒頭台本
  - 初回セッション設計
  - 基本プロフィール
  - ARATAS 公開HP要点
  - 紹介軸整理
  - 質問チェックリスト
  - tugilo 側の共有トーク
  - 紹介仮説
  - 会後お礼文案
- `docs/INDEX.md` への索引追加
- `docs/dragonfly_progress.md` への進捗追記
- `docs/process/PHASE_REGISTRY.md` への Phase 229 追記

## Decisions

- 横山さんの紹介軸は、補助金申請代行ではなく、銀行目線・税理士目線・事業計画・財務顧問を組み合わせた資金調達伴走として表現した。
- 対応履歴の「1年以内に資金調達を検討している中小企業」と、アンケートの「製造業関連のビジネスモデルをお持ちの方」を、121で具体化する最重要質問にした。
- ユーザー提供のHP URLは 404 だったため、公開検索で確認した `http://www.aratasmvdc.co.jp/` を補助情報として記載した。
- 6/9 定例会議事録に記録されていた「融資・補助金活用、決算書・事業計画づくり（全国対応）」と、次廣側フォロー候補「IT導入補助金との接続」を、121 の確認ポイントとして反映した。
- 入会検討については、DragonFly への勧誘を前面に出さず、複数チャプター見学中の意思決定基準と、横山さんが作りたいつながりを確認する構成にした。

## DoD Check

| Item | Result |
|------|--------|
| 横山さんの基本プロフィール・事業軸を整理 | OK |
| 14時の 121 で使える冒頭台本・質問を作成 | OK |
| 入会検討状況を自然に確認できる質問を作成 | OK |
| 紹介仮説・tugilo 側の接点を整理 | OK |
| INDEX / progress / phase registry を同期 | OK |
| テスト結果 | docs フェーズのためスキップ |

## Merge Evidence

| Item | Value |
|------|-------|
| merge commit id | 未実施（commit / merge 未依頼） |
| source branch | develop（commit / merge 未実施） |
| target branch | develop |
| phase id | 229 |
| phase type | docs |
| related ssot | SPEC-013 |
| test command | スキップ（docs フェーズ） |
| test result | スキップ（docs フェーズ） |
| changed files | `docs/meetings/1to1/1to1_yokoyama_taiki_aratas.md`, `docs/INDEX.md`, `docs/dragonfly_progress.md`, `docs/process/PHASE_REGISTRY.md`, `docs/process/phases/PHASE_229_yokoyama_taiki_121_prep_PLAN.md`, `docs/process/phases/PHASE_229_yokoyama_taiki_121_prep_WORKLOG.md`, `docs/process/phases/PHASE_229_yokoyama_taiki_121_prep_REPORT.md` |
| scope check | OK |
| ssot check | OK |
| dod check | OK |

## Notes

- Religo DB への 1to1 レコード登録は今回スコープ外。会後に Zoom 要約または手元メモを反映する際に必要に応じて登録する。
- 終了時刻、実施方法、Religo `one_to_ones.id` は TODO として残した。
- 参加情報では決済権「有」、対応履歴では「決裁者が横浜のシナジーチャプターにいる」と記載があるため、意思決定者の扱いは 121 で確認する。
