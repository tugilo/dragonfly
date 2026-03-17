# Phase M7-P2-DESIGN: PDF解析・参加者抽出 — PLAN

**Phase:** M7-P2-DESIGN  
**Phase ID:** M7-P2-DESIGN  
**作成日:** 2026-03-17  
**フェーズ種別:** docs  
**Related:** [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md), [MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md](../../design/MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md)

---

## 1. 背景

- M7-P2-PREP で PDF 解析状態（parsed_at / parse_status）の基盤を用意した。次のステップである「PDF 解析・参加者抽出」の実装に先立ち、設計ドキュメントのみを作成する。

---

## 2. 目的

- PDF → テキスト抽出、名前抽出、participants へのマッピング方針を設計としてまとめる。
- **実装は行わない。** 設計ドキュメントの作成のみが本 Phase の成果物である。

---

## 3. スコープ

- **変更対象:** docs/ のみ。docs/design/MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md を新規作成。
- **変更しない:** コード・DB・API・UI。一切の実装変更は行わない。

---

## 4. 成果物

- **設計ドキュメント:** docs/design/MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md  
  - 処理フロー、データ設計（extracted_text / extracted_result の案）、API 案、名前抽出方針、技術選定の検討、画面の範囲、リスク・制約を記載。

---

## 5. DoD（Definition of Done）

- [x] 設計ドキュメントが存在し、P2 実装時に参照できる内容である。
- [x] PLAN / WORKLOG / REPORT が揃っている。
- [x] INDEX・PHASE_REGISTRY・dragonfly_progress を更新している。
- [x] テスト・ビルドは docs フェーズのためスキップ可。既存テストは変更していないため回帰なし。
