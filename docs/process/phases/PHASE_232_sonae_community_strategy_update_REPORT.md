# Phase 232 REPORT — SONAE Community 戦略反映

**作成:** 2026-06-23 16:37 JST  
**Phase Type:** docs  
**Related SSOT:** SPEC-017  
**Status:** docs 作成済み / commit・merge 未実施

---

## 実施内容

- `docs/SSOT/SONAE_REQUIREMENTS.md` を更新。
- `docs/proposals/sonae_bcp_proposal_iida_kaori.md` を更新。
- `docs/proposals/sonae_bcp_proposal_iida_kaori_genspark_slide_prompt.md` を更新。
- DragonFly向け20万円開発前提を、DragonFly BCPメンバーと使いながら育てる共創トライアルへ変更。
- SONAEをBNIチャプターだけでなく、小規模コミュニティ、遠隔地で離れて暮らす家族、仲間内でも使える一般サービス候補として整理。
- LINE公式アカウント方針を、団体別の独自LINE公式アカウント接続を主力、共通SONAE公式LINEを少人数・低頻度の入口用途とするモデルへ整理。
- LINE通数費用、公式LINEプラン費用、将来課金モデル案を要件定義へ追加。
- `SPEC-017` の説明を SSOT Registry で Community 展開方針に合わせて更新。
- INDEX、progress、Phase Registryを同期。

---

## 変更ファイル一覧

- `docs/SSOT/SONAE_REQUIREMENTS.md`
- `docs/proposals/sonae_bcp_proposal_iida_kaori.md`
- `docs/proposals/sonae_bcp_proposal_iida_kaori_genspark_slide_prompt.md`
- `docs/02_specifications/SSOT_REGISTRY.md`
- `docs/INDEX.md`
- `docs/dragonfly_progress.md`
- `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_232_sonae_community_strategy_update_PLAN.md`
- `docs/process/phases/PHASE_232_sonae_community_strategy_update_WORKLOG.md`
- `docs/process/phases/PHASE_232_sonae_community_strategy_update_REPORT.md`

---

## テスト結果

docs フェーズのためアプリケーションテストは未実行。

---

## DoD チェック

| 項目 | 結果 |
|------|------|
| SONAE要件定義に共創トライアル方針を反映 | OK |
| 一般サービス化の対象を小規模コミュニティ・家族・仲間へ拡張 | OK |
| LINE公式アカウント接続方針を整理 | OK |
| LINE通数コスト・外部費用を明記 | OK |
| 将来課金モデル案を追加 | OK |
| 飯田香さん向け提案書を共創トライアル版へ更新 | OK |
| Gensparkプロンプトを共創トライアル版へ更新 | OK |
| INDEX / progress / Phase Registry 同期 | OK |
| コード変更なし | OK |

---

## Merge Evidence

| 項目 | 内容 |
|------|------|
| merge commit id | 未実施（ユーザーから commit / merge 指示なし） |
| source branch | 未実施 |
| target branch | 未実施 |
| phase id | 232 |
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

- DragonFly BCPメンバーに共有する前に、DragonFly公式LINEの利用可否とLINE通数/プラン費用を確認する。
- 一般サービス化前に、SONAE名称の商標・同名サービス・ドメインを確認する。
- 共通SONAE公式LINEモデルを採用する場合は、通知回数上限と利用規約を別途設計する。
