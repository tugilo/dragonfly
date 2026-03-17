# Phase Meetings Participants PDF Upload Dialog Fix — REPORT

**Phase:** M7-P1 参加者PDF登録ダイアログ「ファイル選択が開かない」不具合の修正  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/resources/js/admin/pages/MeetingsList.jsx（useRef 追加、PDF モーダル内の file input と Button の構成変更）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_PLAN.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_WORKLOG.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_REPORT.md（本ファイル）

---

## 修正内容

- **useRef 追加:** `import React, { ..., useRef } from 'react'` と `const pdfInputRef = useRef(null);` を追加。
- **file input:** Button の子から切り離し、DialogContent 内に `ref={pdfInputRef}`, `type="file"`, `accept=".pdf,application/pdf"`, `style={{ display: 'none' }}`, `onChange={(e) => setPdfFile(e.target.files?.[0] ?? null)}` で配置。
- **「PDFを選択」Button:** `component="label"` を削除。`onClick={() => pdfInputRef.current?.click()}` を追加。子は「PDFを選択」テキストと startIcon のみ。`disabled={pdfUploading}` は維持。
- ファイル名表示（pdfFile && Typography）および「アップロード」ボタン（disabled={!pdfFile || pdfUploading}）は変更なし。

---

## 原因と対応の要約

- **原因:** MUI ButtonBase が `component="label"` のときに label に `role="button"` を付与するため、`<label role="button">` となり、label のネイティブな file input 起動が働かず、ファイル選択ダイアログが開かなかった。
- **対応:** Button を label にしない。file input を ref で参照し、Button の onClick で `ref.current?.click()` を呼んでプログラム的にファイル選択を開く。input は hidden で Dialog 内に配置。

---

## 動作確認結果

- **ビルド:** `npm run build` 成功。
- **手動確認（実機）:** 開発者が http://localhost/admin#/meetings で Meeting を開き、Drawer から「参加者PDF登録」→「PDFを選択」クリックでファイル選択ダイアログが開くこと、PDF 選択後にファイル名表示・アップロード実行が可能であることを確認すること。

---

## 既知の制約

- 特になし。既存の M7-P1 のアップロード・ダウンロード・Drawer 表示は変更していない。

---

## 次アクション

- 実機で「PDFを選択」→ ファイル選択 → アップロード → Drawer でダウンロード表示まで一連の動作を確認する。
- 必要に応じて M7-P1 の Feature テストで PDF アップロードフローをカバーする（現状は API テストのみで UI は手動確認）。
