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

## 2026-07-08 08:02 JST — implement 完了

### 判断

- **API 構成:** `ReferralConnectCopyService` が 121/定例会の suggestion を共通処理。`ReferralConnectCopyAiService` は既存 `AiClientFactory` パターンに合わせ JSON blocks を返す。
- **ブロック出し分け:** サーバ側で `direction` / `party_b_member_id` の有無により許可 key を決定し、AI 応答をフィルタ（SPEC §3.2 表に準拠）。
- **`via_connector` 既存ボタン:** 「紹介をお願い」遷移は outlined「1 to 1」に降格。「紹介文を作成」が主導線（`connector_request` ブロック）。
- **`introductions` マッピング:** MVP では文案生成は `introductions` を自動作成しない（SPEC §7）。相互接続の 1 件 vs 2 件は P2 で確定。
- **初期値:** PHP `ReferralConnectCopyPartyDefaults` と JS `deriveDefaultParties` を同一ロジックで二重実装（UI 即時表示用）。

### 実施（implement）

| 領域 | ファイル |
|------|----------|
| API | `GenerateReferralConnectCopyRequest`, `ReferralConnectCopyService`, `ReferralConnectCopyAiService`, `ReferralConnectCopyCorpusBuilder`, `ReferralConnectCopyPartyDefaults` |
| Controller | `OneToOneReferralSuggestionController::generateConnectCopy`, `MeetingReferralSuggestionController::generateConnectCopy` |
| Routes | `POST .../generate-connect-copy` ×2 |
| UI | `ReferralConnectCopyDialog.jsx`, `ReferralSuggestionList.jsx`（行ボタン）, `referralSuggestionApi.js` |
| Test | `ReferralConnectCopyTest`, `ReferralConnectCopyPartyDefaultsTest` |

### 検証

- `npm run build` — 成功（cloud agent 環境・ホスト）
- `php artisan test` — Docker 未利用のため未実施（ローカル merge 前にコンテナで実行必須）
