# Phase Meetings Participants PDF Upload Dialog Fix — WORKLOG

**Phase:** M7-P1 参加者PDF登録ダイアログ「ファイル選択が開かない」不具合の修正  
**作成日:** 2026-03-17

---

## 変更前の構造

```jsx
<Button
  variant="outlined"
  component="label"
  startIcon={<CloudUploadIcon />}
  disabled={pdfUploading}
  sx={{ mt: 1 }}
>
  PDFを選択
  <input
    type="file"
    accept=".pdf,application/pdf"
    hidden
    onChange={(e) => setPdfFile(e.target.files?.[0] ?? null)}
  />
</Button>
```

- Button が `component="label"` で描画され、MUI ButtonBase により `role="button"` が付与される。
- input は label の子として配置。label のネイティブ挙動が role のせいで働かず、クリックでファイルダイアログが開かない。

---

## 最小修正の内容

1. **React の import に useRef を追加。**
2. **state 群の直後に `const pdfInputRef = useRef(null);` を追加。**
3. **PDF モーダル内:**
   - `input type="file"` を Button の子から切り離し、DialogContent 内の先頭（説明文の直後）に配置。
   - input に `ref={pdfInputRef}` と `style={{ display: 'none' }}` を付与。`accept` と `onChange` は変更なし。
   - Button から `component="label"` を削除。
   - Button に `onClick={() => pdfInputRef.current?.click()}` を追加。
   - Button の子から input を削除し、表示テキスト「PDFを選択」のみにする。

---

## なぜこの修正で直るのか

- Button は通常の button として描画されるため、`role="button"` 付きの label にならない。
- クリック時に `pdfInputRef.current?.click()` で hidden の file input のネイティブ click を発火させるため、ブラウザのファイル選択ダイアログが開く。
- file input の `onChange` は従来どおりなので、選択されたファイルは `setPdfFile` で state に反映され、ファイル名表示・アップロードボタン活性制御はそのまま動作する。

---

## 影響範囲

- **変更ファイル:** MeetingsList.jsx のみ。
- **変更箇所:** import（useRef 追加）、state 付近（pdfInputRef 追加）、PDF モーダル内の「PDFを選択」UI 部分のみ。
- **影響しない:** 他画面、API、Drawer・メモ・一覧、アップロード実行ロジック・ダウンロード。

---

## 確認結果

- コード変更後、`npm run build` でビルドが通ることを確認。
- 手動確認: モーダルで「PDFを選択」クリック → ファイル選択ダイアログが開くこと、PDF 選択後にファイル名表示・アップロード可能になることは、実機で確認すること（REPORT に記載）。
