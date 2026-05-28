# PHASE12T Religo Admin Theme SSOT + 適用 — PLAN

**Phase:** Religo 管理画面の Theme と Layout 規約を SSOT 化し、全ページに統一感を適用  
**作成日:** 2026-03-04  
**SSOT:** 本 PLAN、[docs/SSOT/ADMIN_UI_THEME_SSOT.md](../../SSOT/ADMIN_UI_THEME_SSOT.md)

---

## 1. 目的

- MUI らしさを **Theme** と **Layout 規約** で固定し、ページ間の統一感を担保する。
- Board を含む全ページで「迷わない・速い」操作感を出す。
- 「Board だけ頑張ってる」状態を終わらせ、**全画面の“見た目の OS”** を先に作る。

## 2. スコープロック（絶対条件）

- 既存の API / DB / テスト仕様は変えない（UI テーマ・レイアウトのみ）。
- Board の機能は維持（Round/BO/メモ導線など）。
- 変更対象は **admin フロント（www/resources/js/admin/）と docs のみ**。
- 追加の npm パッケージは原則なし（@mui/lab は既入り前提）。
- 1 ブランチで実装 → 1 コミットで push → develop に merge（PR なし運用）。

## 3. 成果物

| 成果物 | 内容 |
|--------|------|
| docs/SSOT/ADMIN_UI_THEME_SSOT.md | Typography / Shape / Spacing / Components override / ReactAdmin ルールの SSOT |
| www/resources/js/admin/theme/religoTheme.js | createTheme で 1 箇所に集約 |
| ReligoLayout.jsx または app.jsx | theme 適用・CssBaseline を **一箇所のみ** で固定 |

## 4. Theme で固定する項目（SSOT と一致）

- **Typography**: 見出し/本文/補助のサイズ階層、fontWeight、行間
- **Shape**: borderRadius（Card / Chip / Button の丸み）
- **Spacing**: フォーム密度（dense 基準）、セクション間 gap
- **Components override**: MuiCard / MuiButton / MuiTextField / MuiInputBase / MuiChip / MuiAlert / MuiAutocomplete
- **CssBaseline** を有効化
- **ReactAdmin**: List / Create / Show の余白基準、TopToolbar の操作配置、「保存/未保存/ローディング/エラー」の表示優先順位

## 5. Board の Theme 適用後の微調整（Phase12S 構造は維持）

- Meeting 選択: 上部 Card の「選択状態」が一目で分かる（未選択時に説明文）。
- 保存導線: Unsaved Chip が出ている時だけ保存ボタンを強調。保存後に Snackbar（success）＋ Chip が Saved に確実に戻る。
- 入力密度: Autocomplete / TextField は `size="small"` を基準に統一。
- エラー表示: Alert は最上段に固定し、閉じたら消える（現状踏襲）。
- 視線誘導: Round 編集 Card のタイトル/サブタイトル（Round 名/注意）を Typography で階層化。
- **機能追加はしない。** “UI の OS 化” が目的。

## 6. 手動スモーク観点（WORKLOG Step 3 に結果を書く）

- 画面全体が「統一フォント・統一角丸・統一余白」になったか
- Board: Meeting 選択 → Round → BO → 保存 → Snackbar → 再読み込みで維持
- Chip / ボタン / 入力の密度が揃って“ダサい”部分が消えているか
- サイドメニュー（ReligoMenu）の見た目もテーマで自然に統一されているか

## 7. DoD

- [ ] Theme が 1 箇所に集約され、ReligoLayout（または app.jsx）で必ず適用される
- [ ] Typography / shape / components override が定義され、Board 含む全ページに反映される
- [ ] CssBaseline / density / focus ring / button variant が統一される
- [ ] 手動スモーク観点が明記され、結果が WORKLOG に記載される
- [ ] 既存テスト（php artisan test）が green

## 8. Git

- ブランチ: `feature/phase12t-admin-theme-ssot-v1`
- コミット: 1 コミット（docs + theme + 適用 + 微調整）
- コミットメッセージ案: `ui: establish Religo admin theme SSOT and apply globally`

## 9. 次の Phase 候補

Phase12T で“見た目の OS”が揃ったら、Phase12U（Board IA の再設計）が効く。  
「左：メンバー検索/選択」「中央：Round/BO 割当」「右：選択メンバーの関係ログ（メモ/1to1/紹介）」の 3 ペイン化は機能増になるため Phase を分ける。
