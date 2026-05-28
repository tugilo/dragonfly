# Phase Meetings Participants PDF Upload Dialog — 不具合調査 PLAN

**Phase:** M7-P1 参加者PDF登録ダイアログ ファイル選択が開かない事象の原因調査  
**作成日:** 2026-03-17  
**フェーズ種別:** docs（調査のみ。実装修正は別 Phase で実施可）

---

## 1. 背景

- M7-P1 で「参加者PDF登録」モーダルを実装済み。Drawer から「参加者PDF登録」でモーダルを開き、PDF を選択してアップロードする流れ。
- 実装後、モーダル内の「PDFを選択」アイコンボタンをクリックしてもファイル選択ダイアログが開かず、PDF を選べないという不具合が報告されている。

---

## 2. 現象

- **画面:** http://localhost/admin#/meetings
- **操作:** Meeting の行をクリックして Drawer を開く → 「参加者PDF登録」をクリックしてモーダルを開く
- **期待:** 「PDFを選択」ボタン（CloudUploadIcon 付き）をクリックするとファイル選択ダイアログが開く
- **実際:** ボタンは表示されるが、クリックしてもファイル選択ダイアログが開かない。PDF を選択できずアップロードに進めない

---

## 3. 調査目的

- **目的:** 実装修正の前に「なぜファイル選択が開かないのか」を特定する。推測ではなく該当コードを確認して原因を絞り込む。
- **範囲:** 調査および原因の文書化まで。修正は最小方針を提示するが、広範囲なリファクタは行わない。

---

## 4. 調査対象ファイル

| ファイル | 確認内容 |
|----------|----------|
| www/resources/js/admin/pages/MeetingsList.jsx | PDF 登録モーダル・ファイル選択 UI・Button と input type="file" の関係 |
| react-admin の Button 利用 | 本画面で Button が react-admin 由来か MUI 由来か |
| @mui/material ButtonBase | component="label" 時の role や type の付与 |

---

## 5. 確認観点

1. **ファイル選択 UI の実装方法**  
   input type="file" の有無、hidden input を label/button で開く構成か、ref + click() か、htmlFor と id の対応、disabled の有無、input の DOM 上の存在。
2. **クリックイベント**  
   アップロードアイコンボタンの onClick、stopPropagation/preventDefault の有無、button type / component 指定の影響、MUI Button / label の利用方法。
3. **モーダル / Dialog 特有**  
   Dialog 内での hidden file input の動作、Portal / focus trap / z-index による阻害、input が Dialog 外に出ていないか。
4. **state / disabled 制御**  
   ファイル選択を開くボタンが disabled になっていないか、pdfUploading 等で file picker が抑止されていないか。
5. **実装と UI の不整合**  
   仕様とイベント実装の一致。

---

## 6. DoD（Definition of Done）

- [x] 該当コードの構造を文書化したこと
- [x] 原因候補を列挙し、最有力原因を特定したこと
- [x] 最小修正方針と修正対象（ファイル・箇所）を明示したこと
- [x] PLAN / WORKLOG / REPORT が揃っていること
