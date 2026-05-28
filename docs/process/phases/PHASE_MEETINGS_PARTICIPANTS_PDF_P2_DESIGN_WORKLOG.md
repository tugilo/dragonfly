# Phase M7-P2-DESIGN: PDF解析・参加者抽出 — WORKLOG

**Phase:** M7-P2-DESIGN  
**作成日:** 2026-03-17

---

## 判断

- ユーザー指示どおり「実装しない、設計だけ」のため、コード・migration・API の実装は一切行わない。
- 既存の MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS と DATA_MODEL を参照し、P2 で必要な「PDF → テキスト抽出 → 名前抽出 → participants へのマッピング」の流れを 1 本の設計ドキュメントにまとめた。
- データは M7-P2-PREP で追加した parsed_at / parse_status を前提に、将来の extracted_text / extracted_result の案を記載。API は解析トリガー（POST parse）と取得の案のみ。
- 名前抽出は行単位・正規表現・区分の仮判定とし、実際の PDF サンプルで調整する旨をリスクとして明記した。

---

## 実施内容

- docs/design/MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md を新規作成。処理フロー・データ設計・API 案・名前抽出方針・技術選定・画面範囲・リスクを記載。
