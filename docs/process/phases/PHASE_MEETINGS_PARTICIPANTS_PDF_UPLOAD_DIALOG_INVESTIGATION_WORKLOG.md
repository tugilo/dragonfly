# Phase Meetings Participants PDF Upload Dialog — 不具合調査 WORKLOG

**Phase:** M7-P1 参加者PDF登録ダイアログ ファイル選択が開かない事象の原因調査  
**作成日:** 2026-03-17

---

## 確認した実装箇所

### MeetingsList.jsx（596–623 行付近）

- **PDF モーダル:** `<Dialog open={pdfModalOpen} ...>` で「参加者PDF登録」モーダルを表示。
- **ファイル選択 UI:**
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
- **構成:** MUI/react-admin の `Button` に `component="label"` を指定し、その子要素として `input type="file"` を置いている。つまり「label として振る舞う Button の内側に file input がある」形。
- **Button の import 元:** `import { ..., Button, ... } from 'react-admin'`。react-admin の Button は内部で MUI Button を利用しており、`component="label"` は MUI ButtonBase に渡る。

### MUI ButtonBase の挙動（node_modules/@mui/material/ButtonBase/ButtonBase.js）

- `component` が `'button'` 以外（例: `'label'`）のとき、次の分岐に入る（231–241 行付近）:
  ```javascript
  } else {
    if (!other.href && !other.to) {
      buttonProps.role = 'button';  // ← ここで role="button" が付与される
    }
    if (disabled) {
      buttonProps['aria-disabled'] = disabled;
    }
  }
  ```
- したがって `component="label"` で描画すると、DOM 上は `<label role="button" ...>` となる。

---

## 原因候補

1. **（最有力）label に role="button" が付与されている**  
   MUI ButtonBase が `component !== 'button'` のときに `role="button"` を付ける。`<label role="button">` になると、ブラウザやアクセシビリティツリー上で「ボタン」として扱われ、**label の本来の挙動（クリックで関連するフォームコントロールを起動する）が発動しない**可能性が高い。  
   MUI の Issue（#22141, #42807 等）でも、Button + component="label" + file input の組み合わせでファイルピッカーが開かない事象が報告されている。

2. **input が Button の子でかつ hidden のため、クリックが input に届いていない**  
   label 内の input であれば、label のクリックで input が活性化するはず。しかし role="button" により label が「ボタン」扱いになると、クリックが input の起動に使われない可能性がある。

3. **Dialog の focus trap や Portal の影響**  
   Dialog 内のフォーカス管理で、クリックが別要素に取られている可能性はあるが、ボタンは表示されておりクリック自体はできているようなので、優先度は低い。

4. **pdfUploading による disabled**  
   初回表示時は pdfUploading は false のため、ファイル選択ボタンは disabled になっていない。該当しない。

5. **htmlFor と id の未使用**  
   現状は「label の子として input を置く」方式のため、htmlFor/id は必須ではない。ただし label が role="button" で label として機能していない場合、htmlFor で紐づけても role のせいで同じ問題が残る可能性がある。

---

## 切り分け内容

- **Button の component と role:** ButtonBase のソースで、`component="label"` のときに `role="button"` が明示的にセットされていることを確認した。
- **他画面の file input:** 同じコードベース内で他に `type="file"` と Button component="label" の組み合わせがあるかは未確認。本事象に必要なのは「本モーダルで開かない原因」の特定のため、上記で足りる。
- **ブラウザ差:** 事象報告は「クリックしても開かない」とのこと。Safari/Chrome 等で role="button" 付き label がフォームコントロールを起動しない挙動は知られている。

---

## 判断理由

- **最有力原因を「label への role="button" 付与」とした理由:**  
  1) 該当コードで `component="label"` を使用していること。  
  2) MUI ButtonBase のソースで、button 以外の component に対して `role="button"` を付与していること。  
  3) 仕様上、`<label role="button">` は「ボタン」として扱われ、label のデフォルトの「クリックで関連 input を起動する」動作が期待できなくなること。  
  4) 同様の事象が MUI の Issue で報告されていること。  
  以上から、推測ではなくコードと仕様に基づいて原因と判断した。

---

## 必要な最小修正案

- **方針:** file input を「label の子」に頼らず、**プログラムからクリックさせる**方式に変更する。  
  - file input には `ref` を付与し、DOM 上は非表示のまま（例: `display: none` または `visibility: hidden`）Dialog 内に配置する。  
  - 「PDFを選択」は `Button` のまま **component="label" を使わない**（通常の button として描画）。  
  - Button の `onClick` で `ref.current?.click()` を呼び、file input のネイティブクリックを発火させる。  
- **変更箇所:** `MeetingsList.jsx` の PDF モーダル内のみ。  
  - `useRef` で file input 用の ref を追加（例: `pdfInputRef`）。  
  - 「PDFを選択」Button から `component="label"` を削除し、`onClick={() => pdfInputRef.current?.click()}` を追加。  
  - `input type="file"` を Button の子から切り離し、同一 DialogContent 内の別ノード（例: Box で囲むか単独）に移動し、`ref={pdfInputRef}` と `style={{ display: 'none' }}`（または `hidden` のまま）を付与。  
- **影響範囲:** 参加者PDF登録モーダル内のファイル選択 UI のみ。他コンポーネント・API・state は変更不要。
