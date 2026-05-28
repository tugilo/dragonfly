# Phase Meetings Participants PDF Upload Dialog — 不具合調査 REPORT

**Phase:** M7-P1 参加者PDF登録ダイアログ ファイル選択が開かない事象の原因調査  
**完了日:** 2026-03-17

---

## 調査対象ファイル

| ファイル | 確認内容 |
|----------|----------|
| www/resources/js/admin/pages/MeetingsList.jsx | PDF 登録モーダル（596–623 行付近）。Button component="label" と input type="file" の構造 |
| www/node_modules/@mui/material/ButtonBase/ButtonBase.js | component が 'button' 以外のときに付与される props（231–241 行: role="button" の付与） |

---

## 原因要約

- モーダル内では「PDFを選択」に **react-admin の Button** を使い、**component="label"** でラベルとして描画し、**その子要素に input type="file"** を置いている。
- react-admin の Button は MUI ButtonBase を使うため、**component="label"** を指定すると ButtonBase 側で **role="button"** が付与され、DOM は **`<label role="button" ...>`** になる。
- **`<label role="button">`** はアクセシビリティ上「ボタン」として扱われ、**label の本来の「クリックで関連するフォームコントロールを起動する」挙動が働かなくなる**。その結果、クリックしてもファイル選択ダイアログが開かない。

---

## 最有力原因

**MUI ButtonBase が component="label" のときに label 要素に role="button" を付与しており、そのため label のネイティブな「クリックで子の input を起動する」動作が失われていること。**

根拠: ButtonBase.js の else 節で `buttonProps.role = 'button'` が設定されていること、および MUI の既存 Issue（file input + Button component="label" でダイアログが開かない報告）と一致する。

---

## 最小修正方針

- **file input を label の子にしない:** Button は **component="label" をやめ**、通常の button として描画する。
- **ref で programmatic click:** file input に **ref** を付け、Dialog 内の別ノードに **非表示**で配置する。「PDFを選択」Button の **onClick** で **ref.current?.click()** を呼び、ファイル選択ダイアログを開く。
- **変更するファイル:** `www/resources/js/admin/pages/MeetingsList.jsx` のみ。  
  - 追加: file input 用の `useRef`（例: `pdfInputRef`）。  
  - 変更: 「PDFを選択」Button から `component="label"` を削除し、`onClick={() => pdfInputRef.current?.click()}` を追加。  
  - 変更: `input type="file"` を Button の子から外し、同一 DialogContent 内に `ref={pdfInputRef}` と `style={{ display: 'none' }}` で配置。

---

## 次アクション

1. **実装修正:** 上記の最小修正を MeetingsList.jsx に適用し、ローカルで「参加者PDF登録」モーダルからファイル選択ダイアログが開くことを確認する。
2. **回帰確認:** 既存の Meetings 一覧・Drawer・メモ・他ボタンに影響がないことを確認する。必要なら M7-P1 の既存テストを再実行する。
3. **証跡:** 修正を実施した場合は、本調査の REPORT または M7-P1 の WORKLOG に「ファイル選択が開かない事象は ButtonBase の role="button" が原因。ref + onClick で解消」と追記する。
