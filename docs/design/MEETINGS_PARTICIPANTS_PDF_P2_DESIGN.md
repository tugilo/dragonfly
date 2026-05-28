# Meetings 参加者PDF P2: PDF解析・参加者抽出 — 設計

**作成日:** 2026-03-17  
**Phase:** M7-P2-DESIGN（設計のみ・未実装）  
**関連:** [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](../SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md), [DATA_MODEL.md](../SSOT/DATA_MODEL.md)

---

## 1. 目的

- 例会参加者PDFをアップロード済みの `meeting_participant_imports` を対象に、**PDF → テキスト抽出 → 名前抽出 → 参加者候補の構造化**までを行うための設計をまとめる。
- 本 Phase では実装は行わず、将来の P2 実装時の仕様・データ・API・画面のたたき台とする。

---

## 2. 前提

- **P1 完了済み:** 1 Meeting = 1 PDF で `meeting_participant_imports` に保存済み。`parsed_at` / `parse_status` は M7-P2-PREP で追加済み。
- **PDF 形式:** テキストが埋め込まれた PDF を前提とする。スキャン PDF（OCR 必要）は第一歩の対象外。
- **運用:** 抽出結果は「候補」とし、確定は人が行う（B案）。自動で `participants` を上書きしない。

---

## 3. 処理フロー（概要）

```
[アップロード済み PDF]
    → テキスト抽出（ライブラリ: 例 pdftotext / Smalot PdfParser / 他）
    → 名前候補の抽出（正規表現・行単位・表組みの想定）
    → 区分の推定（メンバー／ビジター／ゲスト／代理）— 任意・PDF レイアウトに依存
    → meeting_participant_imports に「抽出結果」を保存（JSON 等）
    → parse_status = success / failed, parsed_at を更新
```

- **失敗時:** テキスト抽出失敗・パース異常の場合は `parse_status = failed` とし、`parsed_at` は null のままでもよい（または失敗した日時を入れるかは仕様で決定）。

---

## 4. データ設計

### 4.1 既存テーブル（M7-P2-PREP 済み）

- **meeting_participant_imports**
  - 既存: id, meeting_id, file_path, original_filename, status, timestamps
  - 追加済み: parsed_at (nullable), parse_status (pending / success / failed)

### 4.2 追加検討カラム（P2 実装時）

| カラム | 型 | 説明 |
|--------|-----|------|
| extracted_text | TEXT nullable | PDF から取り出した生テキスト（デバッグ・再解析用）。 |
| extracted_result | JSON nullable | 参加者候補の構造化データ（下記の候補リスト）。 |

**extracted_result の JSON 構造（案）:**

```json
{
  "candidates": [
    {
      "line_index": 1,
      "name": "山田 太郎",
      "name_kana": null,
      "type_hint": "regular",
      "source_snippet": "山田 太郎 メンバー"
    }
  ],
  "meta": {
    "extracted_at": "2026-03-17T12:00:00+09:00",
    "page_count": 1,
    "line_count": 42
  }
}
```

- **type_hint:** regular / guest / proxy / visitor 等。PDF 上の表記に合わせて仮で付与。確定前はあくまで「候補」。
- **member_id:** 未マッチの場合は null。P4（members 照合）で設定する想定。

### 4.3 participants との関係

- **participants**（DATA_MODEL §4.7）: meeting_id, member_id, type, introducer_member_id, attendant_member_id
- P2 では「抽出結果」を `extracted_result` に保存するのみ。**participants への反映は P3（確認・登録確定）で行う。**
- 名前 → member のマッチングは P4 で扱う。P2 では名前文字列のリストまでを抽出する設計でよい。

---

## 5. API 設計（案）

### 5.1 解析のトリガー

- **POST /api/meetings/{meetingId}/participant-import/parse**  
  - 対象: 当該 meeting に紐づく `meeting_participant_imports` が 1 件存在し、`parse_status = pending` であること。
  - 処理: ストレージから PDF を読み取り、テキスト抽出 → 名前抽出 → extracted_text / extracted_result を保存し、parse_status を success または failed に更新。parsed_at を設定。
  - レスポンス: participant_import の現在状態（parse_status, parsed_at, extracted_result の要約または全文）。

### 5.2 取得

- **GET /api/meetings/{id}** の `participant_import` に、M7-P2-PREP で追加済みの `parse_status`, `parsed_at` に加え、P2 で追加する場合は `extracted_result`（または要約）を返すかは実装時に決定。

---

## 6. 名前抽出の方針

- **行単位・ブロック単位:** PDF のテキストはレイアウトに依存するため、まずは「1 行 1 名」または「表のセル」を想定したパースを検討。
- **正規表現:** 日本語名（姓 名、姓名の間にスペース等）を想定したパターン。BNI のメンバー表の実際のサンプルで調整する。
- **区分の判定:** PDF 上に「メンバー」「ビジター」「ゲスト」「代理」などのラベルがあれば、その行または隣接セルから type_hint を付与。なければ一律 regular でもよい。
- **失敗・部分成功:** 全ページが画像の場合はテキスト抽出が空になり得る。その場合は parse_status = failed とし、extracted_text が空である旨を保持する。

---

## 7. 技術選定（検討事項）

- **PHP での PDF テキスト抽出:**  
  - Smalot/PdfParser, setasign/fpdi, pdftotext（poppler-utils）の exec など。サーバ環境にバイナリを入れたくない場合は PHP 純粋のライブラリを選ぶ。
- **キュー:** 解析が重い場合は、POST でジョブを投入し、非同期で解析して parse_status を更新する方式を検討。第一歩は同期的でも可。

---

## 8. 画面（P2 の範囲）

- **Meeting 詳細 Drawer:**  
  - 参加者PDFブロックに「解析する」ボタンを追加。解析後に「参加者候補を確認」リンクで P3 の確認画面へ。
- **参加者候補一覧（P3 で詳細化）:**  
  - extracted_result.candidates を表形式で表示。編集・削除・種別変更は P3。P2 では「解析結果を表示するだけ」でも可。

---

## 9. リスク・制約

- PDF のレイアウトが変わると抽出が崩れる。実際のサンプルで検証すること。
- テキスト埋め込みのない PDF は対象外（OCR は別 Phase）。
- 本設計は「たたき台」であり、実装 Phase でサンプル PDF を確認のうえ調整する。

---

## 10. 参照

- [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](../SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md) — 要件・業務フロー・Phase 案
- [DATA_MODEL.md](../SSOT/DATA_MODEL.md) — participants, members
- M7-P2-PREP: meeting_participant_imports の parsed_at / parse_status
