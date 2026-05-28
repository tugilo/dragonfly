# Phase Meetings Participants PDF Upload Dialog Fix — PLAN

**Phase:** M7-P1 参加者PDF登録ダイアログ「ファイル選択が開かない」不具合の修正  
**作成日:** 2026-03-17  
**フェーズ種別:** implement  
**Related:** [PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_REPORT.md](PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_REPORT.md)

---

## 1. 背景

- M7-P1 で参加者PDF登録モーダルを実装したが、「PDFを選択」ボタンをクリックしてもファイル選択ダイアログが開かない事象が発生。
- 調査 Phase（PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_*）で原因を特定済み。

---

## 2. 原因

- 「PDFを選択」に react-admin の Button を `component="label"` で使用し、その子に `input type="file"` を配置していた。
- MUI ButtonBase は `component !== 'button'` のときに `role="button"` を付与するため、DOM が `<label role="button">` となる。
- `<label role="button">` では label のネイティブな「クリックで関連 input を起動する」動作が働かず、ファイル選択ダイアログが開かない。

---

## 3. 目的

- 調査結果に沿い、最小差分で不具合を解消する。
- 「PDFを選択」クリックでファイル選択ダイアログが開き、PDF 選択・アップロードが可能になるようにする。

---

## 4. スコープ

- **変更対象:** www/resources/js/admin/pages/MeetingsList.jsx の PDF モーダル部分のみ。
- **変更しない:** API、他コンポーネント、Drawer・メモ・一覧の既存挙動。pdfUploading / pdfFile / アップロード実行処理のロジック。

---

## 5. 修正方針

1. Button から `component="label"` を削除する。
2. `input type="file"` を Button の子から外し、DialogContent 内の別ノードに hidden で配置する。
3. file input に `ref`（例: `pdfInputRef`）を付ける。
4. 「PDFを選択」Button の `onClick` で `ref.current?.click()` を呼ぶ。
5. `onChange` は既存どおり `setPdfFile(e.target.files?.[0] ?? null)` を維持する。
6. 既存のファイル名表示・アップロードボタン活性条件は維持する。

---

## 6. 確認観点

- 「参加者PDF登録」モーダルで「PDFを選択」を押すとファイル選択ダイアログが開くこと。
- PDF を選ぶと state に反映され、ファイル名表示・アップロードボタンが有効になること。
- アップロード・ダウンロードの既存挙動に影響がないこと。
- Meetings 一覧・Drawer・メモ機能に影響がないこと。

---

## 7. DoD（Definition of Done）

- [x] useRef を追加し pdfInputRef を用意している。
- [x] 「PDFを選択」Button は component="label" を使わず、onClick で pdfInputRef.current?.click() を呼んでいる。
- [x] input type="file" は Button の外に ref と style={{ display: 'none' }} で配置している。
- [x] 既存の pdfFile / pdfUploading / アップロード処理を壊していない。
- [x] PLAN / WORKLOG / REPORT が揃っている。
- [x] ビルドが通る。
