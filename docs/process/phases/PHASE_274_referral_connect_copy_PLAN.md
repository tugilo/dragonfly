# Phase 274 PLAN: リファーラル提案 — 紹介文作成（つなぐ準備・コピペ）

## Phase 情報

| 項目 | 内容 |
|------|------|
| Phase ID | 274 |
| Phase 種別 | implement |
| ブランチ | `feature/phase274-referral-connect-copy` |
| 開始 | 2026-07-08 07:57 JST |
| Status | completed（develop merge 27a6449） |

## 背景・目的

リファーラル提案では複数候補が列挙されるが、現状は `summary` / `rationale` の表示と `introductions` 登録までで、**LINE / Messenger 用の了承依頼・相互紹介文**は毎回手書きである。

BNI 運用では、(1) 双方へ了承を取り、(2) グループ作成、(3) 初回投稿で相互紹介、の順が標準（1to1 議事録の Messenger 運用メモ参照）。

**本 Phase:** 提案**各行**に「紹介文を作成」ボタンを置き、押下後の子モーダルで **A/B を手動指定（案2）** し、履歴ベースの文案を生成して**コピペ**できるようにする。

## Related SSOT

- **SPEC-022** [CONNECTION_PREPARATION_REQUIREMENTS.md](../../SSOT/CONNECTION_PREPARATION_REQUIREMENTS.md)（本機能の正）
- **SPEC-015** [ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md](../../SSOT/ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md)（121 入口）
- **SPEC-016** [CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md](../../SSOT/CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md)（定例会入口）
- **SPEC-009** [REFERRAL_RECORDING_REQUIREMENTS.md](../../SSOT/REFERRAL_RECORDING_REQUIREMENTS.md)（採用して登録）
- [REFERRAL_SUGGESTION_COMMON.md](../../SSOT/REFERRAL_SUGGESTION_COMMON.md) §0.8（つなぎ手・Givers Gain 線引き）
- [REFERRAL_SUGGESTION_PHASE_ROADMAP.md](REFERRAL_SUGGESTION_PHASE_ROADMAP.md)

**モック比較:** 専用モックなし。既存リファーラル提案 Dialog の延長。参考: [MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md) 1to1 行アクション。

## Scope

### In

| 領域 | ファイル（想定） |
|------|------------------|
| SSOT | `docs/SSOT/CONNECTION_PREPARATION_REQUIREMENTS.md`、COMMON 参照 1 行、`SSOT_REGISTRY.md` |
| API | `routes/api.php`、`OneToOneReferralSuggestionController` / `MeetingReferralSuggestionController` に `generateConnectCopy`、`ReferralConnectCopyService`、`ReferralConnectCopyAiService`（名称は WORKLOG で確定） |
| UI | `ReferralSuggestionList.jsx`、`ReferralConnectCopyDialog.jsx`（新規）、`referralSuggestionApi.js` |
| Tests | Feature: 認可・バリデーション・block 構造。Unit: 初期値マッピング（任意） |
| docs | Phase 274 三点セット、INDEX、progress、PHASE_REGISTRY |

### Out

- LINE / Messenger API・グループ自動作成
- 文案・了承の DB 永続化
- `subject_should_meet` を AI が自動出力するよう Normalizer 変更（案2 で不要）
- Phase 193 レポート UI

## Tasks

1. **docs** — SPEC-022 確定・Registry・Phase 三点セット（本コミット）
2. **API** — `generate-connect-copy` 2 エンドポイント + コーパス組み立て + AI プロンプト
3. **UI** — 行ボタン + 子モーダル（A/B 指定・タブ・コピー・了承チェック）
4. **既存ボタン整理** — `via_connector` の「紹介をお願い」遷移を子モーダルへ統合
5. **test + build** — Feature test、npm build
6. **merge** — develop merge、Merge Evidence

## DoD

- [ ] SPEC-022 が SSOT_REGISTRY に active 登録されている
- [ ] 提案各行に独立した「紹介文を作成」ボタンがある
- [ ] 子モーダルで A（必須）/ B（member または label）を指定でき、提案から初期値が入る
- [ ] `POST .../generate-connect-copy` が blocks を返し、コピーボタンでクリップボードに入る
- [ ] `via_connector` で `connector_request` ブロックが出る
- [ ] 双方メンバー指定時に `consent_*` + `group_opening` が出る
- [ ] AI 未設定時は既存同様に設定画面へ誘導
- [ ] `php artisan test` 全通過
- [ ] `npm run build` 成功（JS 変更後）
- [ ] INDEX / progress / PHASE_REGISTRY / REPORT Merge Evidence

## 判断メモ（案2 採用）

- 提案行は**きっかけ**のみ。つなぐ相手はユーザーがモーダルで確定する。
- `ReferralSuggestionPayloadNormalizer` が同章 `subject_should_meet` を弾いても、ユーザーが A/B を指定すれば文案生成可能。
- 社外 B は `party_b_label` のみで足りる。

## Open（WORKLOG で確定）

- [ ] 相互接続完了時の `introductions` 1 件 vs 2 件のマッピング
- [ ] `via_connector` 時に `group_opening` を出す条件（双方メンバー時のみで確定予定）
