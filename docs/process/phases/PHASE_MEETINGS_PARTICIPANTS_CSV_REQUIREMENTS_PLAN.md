# Phase M7-P11-REQUIREMENTS: ChatGPT作成CSVのアップロード連携 要件整理 — PLAN

**Phase:** M7-P11-REQUIREMENTS  
**Phase Type:** docs（要件整理のみ・実装なし）  
**作成日:** 2026-03-17

---

## 1. 背景

M7 系で PDF 解析〜候補編集〜反映まで実装済みだが、PDF 解析だけで CSV 相当の精度にするには調整コストが高い。ChatGPT で PDF から CSV を作成する運用は実績があり、当面は CSV を「正」として取り込み、members / participants と連携する方式を採用したい。そのための要件整理を先行して行う。

## 2. 目的

- ChatGPT 等で作成した CSV をアップロードし、Meeting に紐づけて members / participants と連携する方式の要件を整理する。
- 業務フロー・画面・データ・CSV 仕様・既存構造との連携・リスク・実装フェーズをたたき台としてまとめる。実装は行わない。

## 3. 調査対象

- docs/SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md
- docs/design/MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_* (P3〜P10)
- docs/SSOT/DATA_MODEL.md（members, participants）
- 既存 ImportParticipantsCsvCommand、ImportParticipantsCsvCommandTest
- サンプル CSV: dragonfly_201_20260317_all_csv.txt
- docs/networking/bni/dragonfly/REQUIREMENTS_MEMBERS_CSV_200.md

## 4. 整理観点

- CSV 取込の目的と PDF との棲み分け
- 業務フロー案（A/B/C）の比較と推奨
- 画面要件（導線・プレビュー・既存PDFブロックとの関係）
- データ要件（保存先・PDF と CSV のテーブル分離・反映履歴）
- CSV 仕様（必須列・種別・紹介者・アテンド・形式）
- 既存 members/participants/Meeting との連携、CLI 共通化
- リスク・論点（誤り・表記ゆれ・二重管理・優先ルール）
- 実装フェーズ案（C1〜C5）

## 5. 成果物

- docs/SSOT/MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md（要件整理本体）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_PLAN.md（本ファイル）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_REPORT.md

## 6. DoD

- [x] 要件整理ドキュメント（MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md）が作成されている
- [x] 業務フロー案 A/B/C の比較と推奨が記載されている
- [x] 画面・データ・CSV 仕様・既存連携・リスク・フェーズ案が整理されている
- [x] 推奨方針と今後の確認事項が明示されている
- [x] PLAN / WORKLOG / REPORT が作成され、INDEX・REGISTRY・progress が更新されている
