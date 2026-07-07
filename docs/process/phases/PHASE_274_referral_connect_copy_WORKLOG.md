# Phase 274 WORKLOG: リファーラル提案 — 紹介文作成（つなぐ準備・コピペ）

tool: cursor-cloud-agent

## 2026-07-08 07:57 JST — PLAN / SPEC-022 作成

### 判断

- **課題の正:** リファーラル候補の列挙は実装済み（190–195）だが、LINE/Messenger 運用に必要な**了承依頼・グループ初回投稿**の文案は手作業。候補ごとに独立した導線が必要。
- **案2 採用:** 提案メタの `member_id` に依存せず、子モーダルで **A/B を手動指定**して生成する。Normalizer が `subject_should_meet` を出さない方針とも両立する。
- **MVP の境界:** コピペ支援まで。グループ作成・了承送信はアプリ外。文案の DB 永続化は P2。
- **Spec 分割:** 新規 **SPEC-022**（つなぐ準備）とし、SPEC-015/016 は入口のまま。COMMON §0.8 のつなぎ手線引き（B へ直接コンタクト禁止）は維持。

### 実施（docs）

- `docs/SSOT/CONNECTION_PREPARATION_REQUIREMENTS.md` 新規
- Phase 274 PLAN / WORKLOG / REPORT スタブ
- 実装は未着手（PLAN 完成後に feature ブランチで着手）

### 次（implement）

- `ReferralConnectCopyService` + AI プロンプト + API 2 本
- `ReferralConnectCopyDialog.jsx` + `ReferralSuggestionList` 行ボタン
- Feature test
