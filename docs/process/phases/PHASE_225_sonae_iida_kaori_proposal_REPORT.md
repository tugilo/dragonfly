# Phase 225 REPORT — SONAE 飯田香さん向け提案書

**作成:** 2026-06-18 20:01 JST  
**Phase Type:** docs  
**Related SSOT:** SPEC-017  
**Status:** docs 作成済み / commit・merge 未実施

---

## 実施内容

- `docs/proposals/sonae_bcp_proposal_iida_kaori.md` を新規作成。
- `docs/SSOT/SONAE_REQUIREMENTS.md` の要件定義を、飯田香さん・BCP担当・役員向けに分かりやすい提案書へ再構成。
- 技術詳細ではなく、DragonFly での災害時・訓練時の使い方、BCP担当が把握できること、20万円 MVP の範囲を中心に整理。
- 飯田香さんに確認してもらいたい論点として、公式LINE利用、対象メンバー、発報条件、訓練頻度、閲覧権限を明記。
- `docs/proposals/sonae_bcp_proposal_iida_kaori_genspark_slide_prompt.md` を新規作成。
- Gensparkで提案書を10〜12枚のPowerPoint向けスライドへ変換できるよう、スライド構成、デザイン方針、禁止事項、強調メッセージを整理。
- 2026-06-19 に `docs/proposals/sonae_bcp_proposal_iida_kaori.md` を最新のSONAE提案内容に合わせて全面更新。
- BCP担当の人力依存、半期交代による属人化、SONAEを「人を支える運営の土台」とする考え方、気象庁情報による自動発報、チャプターごとの独立性、DragonFly MVP価格 200,000円（税別）を反映。
- Gensparkスライド生成プロンプトも最新構成へ更新。
- 2026-06-19 に `docs/proposals/sonae_proposal3.pdf` を最新PDF提案書として確認し、INDEXへ追加。
- PDFの16枚構成に合わせ、Gensparkスライド生成プロンプトを16枚構成へ調整。

---

## 変更ファイル一覧

- `docs/proposals/sonae_bcp_proposal_iida_kaori.md`
- `docs/proposals/sonae_bcp_proposal_iida_kaori_genspark_slide_prompt.md`
- `docs/proposals/sonae_proposal3.pdf`
- `docs/process/phases/PHASE_225_sonae_iida_kaori_proposal_PLAN.md`
- `docs/process/phases/PHASE_225_sonae_iida_kaori_proposal_WORKLOG.md`
- `docs/process/phases/PHASE_225_sonae_iida_kaori_proposal_REPORT.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`

---

## テスト結果

docs フェーズのためアプリケーションテストは未実行。

---

## DoD チェック

| 項目 | 結果 |
|------|------|
| 飯田香さん向け提案書を `docs/proposals/` に作成 | OK |
| 非エンジニアにも分かる表現に変換 | OK |
| DragonFly 向け20万円 MVP の範囲を明記 | OK |
| 初期範囲に含めないものを明記 | OK |
| BCP担当・役員が次に決めることを明記 | OK |
| Genspark向けスライド生成プロンプトを作成 | OK |
| 最新SONAE提案思想を反映 | OK |
| チャプターごとの独立性を明記 | OK |
| 最新PDF v3をINDEXに追加 | OK |
| GensparkプロンプトをPDF同等の16枚構成へ調整 | OK |
| INDEX / progress / Phase Registry 同期 | OK |
| コード変更なし | OK |

---

## Merge Evidence

| 項目 | 内容 |
|------|------|
| merge commit id | 未実施（ユーザーから commit / merge 指示なし） |
| source branch | 未実施 |
| target branch | 未実施 |
| phase id | 225 |
| phase type | docs |
| related ssot | SPEC-017 |
| test command | docs フェーズのため未実行 |
| test result | スキップ |
| changed files | 上記「変更ファイル一覧」参照 |
| scope check | OK |
| ssot check | OK |
| dod check | OK |

---

## 残タスク

- 飯田香さんへ共有する前に、金額表記の税込/税別、DragonFly 公式LINEの利用可否、初回訓練日を確認する。
- ユーザー確認後、必要に応じて commit / merge / push を実施する。
