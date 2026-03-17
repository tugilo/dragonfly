# Phase Meetings Participants PDF Requirements — PLAN

**Phase:** Meetings 参加者PDF取込 要件整理  
**Phase ID:** M7  
**作成日:** 2026-03-17  
**フェーズ種別:** docs  
**Related SSOT:** SPEC-001（Religo システム全体）、[DATA_MODEL.md](../../SSOT/DATA_MODEL.md)、[FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md)

---

## 1. 背景

- 毎回、例会前日に PDF でメンバー表が送られてきており、現状は人がその PDF を見て参加者情報を把握している。
- Meetings 画面には一覧・詳細 Drawer・メモ編集・BO 編集・統計などが実装済み。ここに「その回の参加者PDF」を登録し、可能なら PDF から参加者一覧を抽出して participants に反映したいという要件が上がっている。
- 実装に進む前に、tugilo 式で要件整理・設計のたたき台をまとめ、業務フロー・画面・データ・Phase 分割・リスクを整理する必要がある。

---

## 2. 目的

- **主目的:** Meetings に対して「例会参加者PDF」を起点に参加者情報を登録・管理するための要件整理たたき台を作成する。
- **副目的:** 実装 Phase に進むかどうか、どの案で進めるかの判断材料をそろえる。実装は行わない。

---

## 3. 調査対象

- 既存 Meetings 機能（一覧・詳細・メモ・BO・API・データモデル）
- 既存 participants / members 構造（Participant, Member, ImportParticipantsCsvCommand, MeetingAttendeesService）
- 既存 CSV 取込の種別・項目（メンバー／ビジター／ゲスト／代理出席、紹介者・アテンド等）
- モック・FIT&GAP で定義されている Meetings 周りの導線

---

## 4. 整理観点

- **要件定義のたたき台:** 実現したいこと、ユーザー、操作導線、PDF の扱い、抽出結果の確認・修正、Meeting と参加者の紐づけ、既存データ構造への乗せ方、失敗時・自動抽出の限界と運用。
- **業務フロー案:** A（PDF 添付保存のみ）、B（PDF 解析→人が確認して登録）、C（自動寄せ・エラー時のみ手修正）の比較。
- **画面要件案:** 一覧／Drawer からの導線、PDF アップロード、抽出結果確認、登録確定、原本 PDF の表示・ダウンロード要否。
- **データ要件案:** meeting に紐づく取込データ、保存すべきもの、participants との関係、中間テーブル・冪等性・再取込の考え方。
- **実装フェーズ案:** P1（PDF 保存）→ P2（抽出表示）→ P3（確認・反映）→ P4（member 照合）→ P5（運用改善）の段階分割。
- **リスク・論点:** PDF 形式崩れ、OCR 要否、名前の揺れ、区分判定、完全自動化の危険性、人の確認をどこまで残すか。

---

## 5. 成果物

| 成果物 | 説明 |
|--------|------|
| docs/SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md | 要件整理たたき台（機能概要・背景・ユースケース・業務フロー A/B/C・画面・データ・Phase 案・リスク・推奨方針・確認事項） |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_PLAN.md | 本 PLAN |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_WORKLOG.md | 調査内容・検討した選択肢・判断理由の WORKLOG |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_REPORT.md | 作成ドキュメント一覧・要約・推奨方針・次に進む場合の REPORT |

---

## 6. スコープ

- **変更可能:** docs/** のみ。.cursorrules / .cursor は参照のみ。コード・DB・routes は変更しない。
- **変更しない:** www/ 以下の実装。実装 Phase は今回の成果物を参照して別 Phase で行う。

---

## 7. DoD（Definition of Done）

- [x] 要件整理ドキュメント（MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md）が作成され、1〜10 の節がすべて記載されていること。
- [x] 業務フロー A案・B案・C案が比較され、推奨方針が明記されていること。
- [x] 画面要件・データ要件・実装フェーズ案（P1〜P5）がたたき台として整理されていること。
- [x] リスク・論点と今後の確認事項が整理されていること。
- [x] PLAN / WORKLOG / REPORT の 3 ファイルが作成され、PLAN に背景・目的・調査対象・整理観点・成果物・DoD が含まれていること。
- [x] WORKLOG に既存 Meetings 機能の確認・追加要件の整理・検討した選択肢・判断理由・まとめが含まれていること。
- [x] REPORT に作成ドキュメント一覧・要件整理の要約・推奨方針・次に進むなら何をやるかが含まれていること。
- [x] docs/INDEX.md に本 Phase の成果物が追記されていること。
