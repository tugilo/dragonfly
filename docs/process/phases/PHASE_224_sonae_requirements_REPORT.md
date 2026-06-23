# Phase 224 REPORT — SONAE 要件定義

**作成:** 2026-06-18 18:00 JST  
**Phase Type:** docs  
**Related SSOT:** SPEC-017  
**Status:** docs 作成済み / commit・merge 未実施

---

## 実施内容

- `docs/SSOT/SONAE_REQUIREMENTS.md` を新規作成。
- SONAE を Religo 拡張モジュールかつ単体利用可能な BNI チャプター向け災害安否確認サービスとして定義。
- DragonFly 向け 20万円 MVP の範囲を、通知・回答・集計・訓練に絞って整理。
- 気象庁情報はシステム全体で一度取得し、`AlertEvent` を各チャプター条件で判定する構造に整理。
- LINE 公式アカウントはチャプターごとに分離し、各チャプターの公式 LINE から通知する仕様に整理。
- ER 設計案として、organizations / chapters / users / members / line_accounts / alert_events / alert_notifications / safety_responses 等を定義。
- `SPEC-017` として SSOT Registry に登録。
- `docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md` と同期。

---

## 変更ファイル一覧

- `docs/SSOT/SONAE_REQUIREMENTS.md`
- `docs/process/phases/PHASE_224_sonae_requirements_PLAN.md`
- `docs/process/phases/PHASE_224_sonae_requirements_WORKLOG.md`
- `docs/process/phases/PHASE_224_sonae_requirements_REPORT.md`
- `docs/02_specifications/SSOT_REGISTRY.md`
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
| SONAE 要件定義書を Markdown で作成 | OK |
| 機能一覧を含む | OK |
| MVP 範囲を含む | OK |
| 画面一覧を含む | OK |
| データベース設計案を含む | OK |
| 通知フローを含む | OK |
| 気象庁連携仕様を含む | OK |
| LINE 連携仕様を含む | OK |
| 権限設計を含む | OK |
| 今後の拡張案を含む | OK |
| 概算見積もり用の開発スコープを含む | OK |
| コード変更なし | OK |

---

## Merge Evidence

| 項目 | 内容 |
|------|------|
| merge commit id | 未実施（ユーザーから commit / merge 指示なし） |
| source branch | 未実施 |
| target branch | 未実施 |
| phase id | 224 |
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

- ユーザー確認後、必要に応じて Phase 224 の commit / merge / push を実施する。
- 実装フェーズ開始時は、気象庁データソースの取得形式・対象 API・更新頻度を再確認する。
