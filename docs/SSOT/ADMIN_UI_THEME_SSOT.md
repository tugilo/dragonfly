# Religo 管理画面 UI Theme SSOT

**目的:** MUI + ReactAdmin の見た目をコードで固定し、全ページの統一感を担保する。  
**適用:** www/resources/js/admin/theme/religoTheme.js で定義し、app.jsx の Admin に渡す。  
**更新方針:** テーマを変える場合は本 SSOT と religoTheme.js を同時に更新する。

---

## 1. Typography

| 用途 | variant | fontSize | fontWeight | lineHeight | 備考 |
|------|---------|----------|------------|-------------|------|
| ページタイトル | h6 | 1.25rem | 600 | 1.3 | Board（会の地図）など |
| カード見出し | subtitle1 | 1rem | 600 | 1.5 | BO1/BO2、Round 名 |
| 本文 | body2 | 0.875rem | 400 | 1.43 | 標準 |
| 補助・キャプション | caption | 0.75rem | 400 | 1.66 | ラベル、メタ情報 |

- フォントファミリは MUI デフォルト（Roboto 系）を維持。必要なら theme.typography.fontFamily で上書き。

---

## 2. Shape（角丸）

| コンポーネント | 基準 | 値 |
|----------------|------|-----|
| Card / Paper | borderRadius | 8px（MUI default の 1） |
| Button | borderRadius | 4px（MUI default） |
| Chip | borderRadius | 16px（pill 系） |
| TextField / InputBase | borderRadius | 4px |

- theme.shape.borderRadius は 1 単位（8px）を基準にし、Card は default のまま。細かい上書きは components で行う。

---

## 3. Spacing（余白・密度）

| 用途 | 値 | 備考 |
|------|-----|------|
| フォーム密度 | dense / size="small" | TextField・Autocomplete・Select は small を基本 |
| カード内余白 | p: 2（16px） | CardContent の padding |
| セクション間 | spacing(2) | Stack / Grid の gap |
| コンポーネント間 | gap: 1 または spacing(1) | Chip 同士、ボタンと入力 |

- theme.spacing は 8px 基準の MUI デフォルトを使用。

---

## 4. Components override（theme.components）

### 4.1 MuiCard

- defaultProps: variant="outlined" で枠を統一（任意）。
- styleOverrides: 必要なら elevation 0、border 1px、borderRadius 8。

### 4.2 MuiButton

- contained: 主要アクション（保存など）。色は primary。
- outlined: 補助アクション（キャンセル、＋ Round）。
- defaultProps: 特に size は指定しない（ページで size="small" を指定する方針で OK）。
- 無効時は disabled で透明度・ホバーなしを統一。

### 4.3 MuiTextField / MuiInputBase

- フォーム入力は size="small" を基本（density 向上）。
- フォーカスリングは MUI デフォルト（primary 色）を維持。

### 4.4 MuiChip

- size="small" を基本。アイコン余白は MUI デフォルト。
- 色: success（Saved）、warning（Unsaved）、info（Loading）。

### 4.5 MuiAlert

- severity ごとの見え方（success / warning / error / info）は MUI デフォルトを維持。
- 閉じるボタンは onClose で表示。エラーは「最上段」に表示する運用（Board の roundsError など）。

### 4.6 MuiAutocomplete

- 入力密度は renderInput 内で TextField size="small" を指定して統一。

---

## 5. ReactAdmin ルール

- **List / Create / Show**: 余白は theme spacing に合わせる。TopToolbar は右寄せで「保存」「キャンセル」などを配置。
- **TopToolbar**: 主要操作（保存）を右端にまとめ、補助（キャンセル）はその左。
- **保存/未保存/ローディング/エラー** の表示優先順位:
  1. エラー（Alert 最上段、閉じたら消す）
  2. ローディング（Chip または LoadingButton のスピナー）
  3. 未保存（Chip warning）
  4. 保存済み（Chip success ＋ Snackbar で短く通知）

---

## 6. CssBaseline

- 必ず有効化する。適用箇所は ReligoLayout または app.jsx のいずれか **一箇所のみ**（重複禁止）。

---

## 7. 参照

- [PHASE12T_RELIGO_ADMIN_THEME_SSOT_PLAN.md](../process/phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_PLAN.md)
- MUI Theme: https://mui.com/material-ui/customization/theming/
- ReactAdmin Theme: https://marmelab.com/react-admin/AppBar.html#theme
