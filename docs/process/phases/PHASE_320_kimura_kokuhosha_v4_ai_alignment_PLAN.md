# Phase 320 PLAN — 国宝社 v4（予定表 AI 必須範囲・見積点検・保守体制・専門家との認識合わせ）

**作成:** 2026-10-26 09:35 JST  
**Phase Type:** docs  
**Branch:** 作業ツリー未分離（`develop` 上。他案件の未コミット変更あり。本 Phase では commit・merge・push・外部送信を行わない）  
**Related SSOT:** `docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md`（第4回 2026-10-05、2026-10-14 専門家チェックリスト受領・AI 意向）、`docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha_requirements_20260529.md`、`docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha_requirements_20260826.md`、`docs/PROJECT_NAMING.md`  
**前 Phase:** [Phase 317](PHASE_317_kimura_kokuhosha_proposal_v3_PLAN.md)（v3 一式・10/14 変更点メモ・25観点回答案。in_progress のまま。本 Phase は v4 を別 Phase として切る）

---

## Purpose

助成金専門家（花村幸一氏）への説明と、tugilo が実際に提供する機能・費用・保守体制の整合を取る。v3（2026-10-10）と 10/14 変更点メモ（予定表への AI 組み込み）を基に **v4** を作り、次の 6 点を反映する。

1. 予定表の AI 必須範囲を「ルール（制約・検証）／AI（順番案・理由・自然言語の組み直し支援）／人（確定）」の三層で明確化。AI 停止時はルール提案へ切替。修正履歴は参考例として参照し、独自学習・自動精度向上とは区別。決定済み／未確定を分ける。
2. AI 連携の必須・任意見積の点検。旧 O4 → 必須への移動で二重計上が無いこと、AI 25万円に含める作業の具体化、M1／M6／M7 との担当範囲、O3 の再定義、既存基盤の再利用可否、人日・単価の未確定明記。290万円は概算のまま。
3. 別見積・任意範囲の明確化（PDF／Excel の AI 読取、過去データ整備、独自学習、実績自動収集は必須に入れない）。受領 PDF が画像のみである事実を踏まえ、主要1社 PDF 解析と OCR／AI 読取を区別。
4. AI 送信時のセキュリティを設計方針として具体化（実装済み・検証済みとは書かない）。学習不使用と保存なしの区別。OpenAI 公式ページの確認結果を記載。
5. 運営保守の継続体制（次廣確認: AI と管理の仕組みで特定個人に依存しない。別担当者が継続できる体制）を反映。協力者名・24時間対応・復旧時間保証・著作権譲渡・無償修正期間は創作しない。
6. 専門家側との認識差（AI が PDF を読む／過去実績から学習／4:4:2／8割使える／保守費想定なし／10月契約・11/2 着手）の点検と修正。

---

## Scope

### 新規

- `docs/proposals/kimura_kokuhosha_proposal_v4_20261026.md`
- `docs/proposals/kimura_kokuhosha_estimate_v4_20261026.md`
- `docs/proposals/kimura_kokuhosha_system_architecture_v4_20261026.md`
- `docs/proposals/kimura_kokuhosha_basic_design_v4_20261026.md`
- `docs/proposals/kimura_kokuhosha_specification_v4_20261026.md`
- `docs/proposals/kimura_kokuhosha_schedule_v4_20261026.md`
- `docs/proposals/kimura_kokuhosha_hearing_sheet_answers_20261026.md`（専門家「提案書ヒアリング」1-1〜11-1 と「開発会社の確認」No.1〜25 への tugilo 回答案。xlsx の md 版・v4 整合）
- `docs/proposals/kimura_kokuhosha_hearing_sheet_tugilo_answers_20261026.xlsx`（2026-10-26 回答案 xlsx の写し）
- `docs/proposals/kimura_kokuhosha_checklist_answers_20261026.{html,pdf}`（外部向け 25項目回答一覧の v4 版。10/14 版は履歴）
- `docs/proposals/木村さん用/助成金専門家_提案書ヒアリングシート_花村_20261013_v1.xlsx`（専門家の元シート。受領物）
- `docs/process/phases/PHASE_320_kimura_kokuhosha_v4_ai_alignment_{PLAN,WORKLOG,REPORT}.md`

### 更新

- v3 6文書（`*_20261010.md`）: 先頭に「v4 に更新。本書は履歴」の案内を1行追加（本文は変えない）
- `docs/proposals/kimura_kokuhosha_v3_change_memo_ai_20261014.{md,html,pdf}`: 先頭に v4 への案内を追加し PDF を再出力
- `docs/proposals/kimura_kokuhosha_subsidy_consultant_checklist_response_20261014.md`: 先頭に v4・ヒアリングシート回答への案内を追加（本文は 10/14 時点の記録として残す）
- `docs/proposals/木村さん用/README.md`、`docs/proposals/README.md`、`docs/INDEX.md`、`docs/dragonfly_progress.md`、`docs/process/PHASE_REGISTRY.md`
- `docs/meetings/1to1/1to1_kimura_hidetsugu_kokuhosha.md`（サマリーに 2026-10-26 の方針・v4 リンク・アクション）

### 変更しない

- `www/**`（アプリ実装・DB 変更なし）、v3 スライド HTML／PDF（履歴）、提出用フォルダ（リポジトリ外）への新規コピーは行わない（送付物の確定は次廣）

---

## DoD

- v4 6文書が v3 の構成を保ったまま、Purpose 1〜6 を反映している。案・未確定・次廣判断・国宝社様確認・専門家確認・既存会社確認の区別が各文書で明記されている。
- 見積 v4: 必須 ¥2,900,000／任意 ¥1,100,000〜¥1,160,000／全部 ¥4,000,000〜¥4,060,000 が表・組み合わせ例・ROI・内訳割合で一致。AI 25万円の作業内訳と M1／M6／M7／S との分担表がある。人日・単価は「積算案・要確認」。
- 基本設計 v4: AI 層の三層構成・検証・切替・履歴参照・版管理・送信制御（許可リスト・ID 化・除去・停止）・鍵管理・ログ・異常時手順を「設計方針（実装・検証予定）」として記載。
- 仕様 v4: AI の入出力項目、自然言語指示の対象と曖昧時の確認、例外、検収案（合意前）を決定済み／未確定で分けて記載。
- スケジュール v4: 10月契約・11/2 着手を過去計画と明記し、発注可能時期を起点にした再調整案（複数シナリオ）と 2/28 支払完了の制約を示す。
- 専門家回答（25項目・ヒアリング 1-1〜11-1）が v4 と一致し、外部向け HTML／PDF を再出力している。
- 旧版（v3・10/14 メモ・10/14 回答一覧）に最新版への案内がある。INDEX・README・進捗・PHASE_REGISTRY・1to1 が同期している。
- docs フェーズのため Laravel テスト・React ビルド・db 系コマンドは実行しない。検証用一時ファイルは /tmp に置き削除する。

---

## Tasks

1. 既存変更・v4 の有無・受領 xlsx／回答案 xlsx・受領 PDF の性質（画像のみか）・既存 AI 基盤（`www/app/Services/Ai`）・OpenAI 公式データ取扱ページを確認する。
2. 見積 v4（点検結果・AI 作業内訳・分担・再利用・O3 再定義・価格判断）。
3. 提案書 v4（三層・別見積範囲・保守体制・専門家資料との認識合わせ）。
4. 構成図 v4（外部 AI API 経路・送信制御・鍵管理の位置）。
5. 基本設計 v4（AI 層・セキュリティ設計方針・納品物・継続体制）。
6. 仕様 v4（AI 入出力・自然言語指示・例外・検収案・管理画面）。
7. スケジュール v4（再調整シナリオ）。
8. ヒアリングシート回答 md と外部向け 25項目回答 HTML／PDF の v4 版。
9. 旧版への案内、README・INDEX・進捗・PHASE_REGISTRY・1to1 の同期。WORKLOG・REPORT。
