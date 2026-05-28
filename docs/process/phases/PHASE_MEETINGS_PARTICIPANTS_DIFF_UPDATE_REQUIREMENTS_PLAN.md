# Phase M7-C4-REQUIREMENTS: participants 差分更新 要件整理 — PLAN

**Phase ID:** M7-C4-REQUIREMENTS  
**Phase 名:** participants 差分更新 要件整理  
**種別:** docs  
**Related SSOT:** MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md, MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md, DATA_MODEL.md

---

## 背景

- M7-C3 では CSV 反映時に participants を全削除してから CSV で再作成している（全置換）。
- 既存 participant に紐づく BO（participant_breakout）は cascadeOnDelete のため、反映時に消える。手動調整や BO 割当を保護したい。

## 目的

- CSV 反映を「全置換」から「差分更新」に切り替える場合の、業務フロー・データルール・更新ルール・BO 影響を整理する。
- 実装は行わず、要件整理・設計たたき台に徹する。

## 調査対象

- 現状の全置換方式（ApplyMeetingCsvImportService, C3 REPORT）
- participants / participant_breakout の関係（DATA_MODEL）
- PDF 側の apply・BO・履歴（P3/P4/P5/P6 REPORT）
- 差分判定キー・更新ルール案（A/B/C）
- BO 保護・UI/UX・データ要件

## 整理観点

1. 現状方式の整理（何が起きるか・何が消えるか・危険な場面・単純な理由）
2. 守りたいデータ（participant, BO, introducer/attendant, 手動マッチ, 履歴）
3. 差分判定キー（member_id / 名前 / 名前+種別等の比較と第一候補）
4. 差分更新ルール案 A/B/C（メリット・デメリット・BO 影響・実装コスト）
5. BO 影響（削除時の cascade、更新時は残る、BO ありは削除禁止の要否、両立方針）
6. UI/UX 要件（差分プレビュー、色分け、warning、確認ダイアログ、安全モード）
7. データ要件（participant 追加項目、前回スナップショット、ログ、rollback）
8. 実装フェーズ案（D1〜D5）
9. 推奨方針と今後の確認事項

## 成果物

- docs/SSOT/MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md（要件整理本体）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_PLAN.md（本ファイル）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_REPORT.md

## DoD

- 上記 4 ファイルが作成されていること。
- 現状方式・守りたいデータ・差分判定キー・案 A/B/C・BO 影響・UI/UX・データ・フェーズ案・推奨方針が一通り記載されていること。
- INDEX / PHASE_REGISTRY が更新されていること。
