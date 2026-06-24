# Phase 241 WORKLOG — SONAE PoC 提案同期

tool: cursor

**作成:** 2026-06-24 12:55 JST  
**Phase Type:** docs  
**Related SSOT:** SPEC-017

---

## 判断ログ

### 1. 最新PDFをPoC版の正とする

ユーザーから `docs/proposals/sonae_proposal.pdf` が最新PDFとして提示された。PDFでは、SONAEを「DragonFlyをモデルにした安否確認の仕組みづくり PoC 提案」と位置づけ、tugiloのPoCとしてDragonFlyを最初のモデルチャプターにする方針が明記されている。

そのため、これまでの「20万円MVP」「共創トライアル」という表現を、最新PDFと揃えて **PoC（Proof of Concept / 実証実験）** に統一した。

### 2. 開発費・利用料請求なしを明記

PDFでは「本PoCにおいて、DragonFlyへの開発費・利用料のご請求はありません」と明記されている。提案書MarkdownとGensparkプロンプトにも同じ方針を反映した。

ただし、DragonFly公式LINE側の通数・プラン費用は外部費用として別途確認が必要なため、提案書側では「別途確認」として残した。

### 3. PoC範囲と対象外をPDFに合わせる

「MVP範囲」は「PoCで作る範囲」に変更し、通知・回答・集計・訓練の4カテゴリは維持した。対象外も「PoCには含めないもの」として、メール通知、SMS通知、自動再送、GPS、課金・請求、複雑な権限、Jアラート、停電情報、独自アプリ化、デザイン作り込みを維持した。

---

## 変更した主な内容

- `SONAE_REQUIREMENTS.md`
  - DragonFly共創トライアル表現を DragonFly PoC へ更新
  - 20万円開発費前提を削除
  - PoCでは開発費・利用料請求なしと明記
  - MVP表記をPoC表記へ統一
- `sonae_bcp_proposal_iida_kaori.md`
  - 共創MVP / 共創トライアル表現をPoCへ変更
  - 「PoCで作る範囲」「PoCのかたち」へ章名を更新
  - 開発費・利用料請求なしを明記
- `sonae_bcp_proposal_iida_kaori_genspark_slide_prompt.md`
  - PoC版スライド生成用に更新
  - DragonFlyをモデルチャプターにしたPoCとして表現するよう指示
- `INDEX` / `dragonfly_progress` / `PHASE_REGISTRY` / `SSOT_REGISTRY`
  - 最新PDF `sonae_proposal.pdf` とPhase 241を同期

---

## Scope Check

docs フェーズとして `docs/**` のみ変更。コード・DB・infra 変更なし。
