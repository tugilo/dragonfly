---
name: mock-ui-verify
description: Compare Religo admin UI against mock SSOT after UI changes in dragonfly. Use for implement phases touching www/resources/js admin pages. Records gaps in FIT_AND_GAP doc.
---

# モック UI 比較

## SSOT

- 検証手順: `docs/SSOT/MOCK_UI_VERIFICATION.md`
- 差分記録: `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md`
- モック URL: `http://localhost/mock/religo-admin-mock.html`
- 実体: `www/public/mock/religo-admin-mock.html`

## PLAN 必須記載

```
モック比較: docs/SSOT/MOCK_UI_VERIFICATION.md に従う
```

## 手順

1. 対象画面をモックと実 UI で **同一操作** 比較
2. レイアウト・ラベル・導線・空状態の差分を洗い出す
3. 意図的な差分は理由を WORKLOG に記載
4. 非意図の差分は修正するか FIT_AND_GAP に記録

## Members 以外の画面

モックが単一 HTML に無い画面は **FIT_AND_GAP の「モック」列を正** として扱う。

## 完了条件

- 対象画面の比較を実施
- 差分を FIT_AND_GAP に追記（または「差分なし」を REPORT に記載）

## ビルド

比較前に `/react-build` を実行し、最新ビルドを反映する。
