# Phase 232 PLAN — SONAE Community 戦略反映

**作成:** 2026-06-23 16:37 JST  
**Phase Type:** docs  
**Branch:** develop（既存未コミット変更あり。ユーザーから commit / merge 指示なし）  
**Related SSOT:** SPEC-017（SONAE 要件定義）  
**Status:** in_progress

---

## Purpose

これまでの議論を踏まえ、SONAE を「DragonFly向け20万円開発」ではなく、DragonFly BCP を最初の共創トライアルとして始め、将来的に小規模コミュニティ・離れて暮らす家族・仲間内でも使える一般サービスへ育てる方針に更新する。

特に、災害時のプッシュ通知は登録メンバー数に比例してLINE送信通数が増えるため、共通SONAE公式LINE一本に全グループを載せるのではなく、主力モデルを **各団体・コミュニティごとのLINE公式アカウント接続** として整理する。

---

## Scope

変更可能範囲:

- `docs/SSOT/SONAE_REQUIREMENTS.md`
- `docs/proposals/sonae_bcp_proposal_iida_kaori.md`
- `docs/proposals/sonae_bcp_proposal_iida_kaori_genspark_slide_prompt.md`
- `docs/02_specifications/SSOT_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_232_sonae_community_strategy_update_*.md`

変更しない範囲:

- `www/**`
- `infra/**`
- DB dump
- 既存議事録本文

---

## DoD

- SONAE要件定義に、DragonFly共創トライアル、一般サービス化、LINE公式アカウント接続方針、LINE通数コスト、課金モデル方針が反映されている。
- 飯田香さん向け提案書から「20万円で開発する」前提を外し、DragonFly BCPメンバーと使いながら育てる共創トライアルとして整理されている。
- Gensparkスライドプロンプトも同じ方針に更新されている。
- `docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md` が同期されている。
- コード変更を行わない。

---

## Tasks

1. `SONAE_REQUIREMENTS.md` の事業方針・LINE運用方針・課金方針を更新する。
2. 飯田香さん向け提案書を、共創トライアル・BCP担当者負担軽減中心に更新する。
3. Gensparkスライド生成プロンプトを、共創トライアル版に更新する。
4. INDEX / progress / Phase Registry / WORKLOG / REPORT を同期する。
