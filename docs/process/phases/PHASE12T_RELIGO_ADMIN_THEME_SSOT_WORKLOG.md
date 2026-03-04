# PHASE12T Religo Admin Theme SSOT + 適用 — WORKLOG

**Phase:** Admin Theme SSOT + 適用  
**作成日:** 2026-03-04

---

## Step 1: Phase ドキュメント・SSOT

- PHASE12T_RELIGO_ADMIN_THEME_SSOT_PLAN.md / WORKLOG.md / REPORT.md 作成。
- docs/SSOT/ADMIN_UI_THEME_SSOT.md 新規（Typography / Shape / Spacing / Components override / ReactAdmin ルール）。
- docs/INDEX.md の SSOT セクションに ADMIN_UI_THEME_SSOT.md を追加。
- docs/INDEX.md の phases 一覧に Phase12T の 3 ファイルを追加。
- docs/dragonfly_progress.md に Phase12T の 1 行を追加。

## Step 2: テーマ実装

- **実施済み（2026-03-04）**
- www/resources/js/admin/theme/religoTheme.js を新規作成（createTheme）。typography（h6/subtitle1/body2/caption）、shape.borderRadius: 8、components: MuiCard（outlined, borderRadius 8）、MuiButton（textTransform: none）、MuiTextField/MuiFormControl（outlined, size small, margin dense）、MuiInputBase（focus ring）、MuiChip（size small）、MuiAlert、MuiAutocomplete（size small）。
- app.jsx で `import { religoTheme } from './theme/religoTheme'` し、`<Admin theme={religoTheme} ... />` で適用（一箇所のみ）。
- ReligoLayout.jsx で `import { CssBaseline } from '@mui/material'` し、`<><CssBaseline /><Layout ... /></>` でベースラインを有効化。
- DragonFlyBoard.jsx: 未選択時に「例会を選択すると Round 割当を編集できます。」を表示。Round 編集 Card に「Round 割当」タイトル＋「Round 名を編集し、BO1/BO2 に…」キャプションを追加。保存ボタンは dirty 時 variant="contained"、保存済み時 variant="outlined" で強調を切り替え。

## Step 3: Board の微調整・手動スモーク（結果をここに書く）

- Meeting 選択: 上部 Card の選択状態が一目で分かる（未選択時に説明文）。
- 保存導線: Unsaved 時のみ保存ボタン強調、保存後 Snackbar ＋ Chip が Saved に戻る。
- 入力密度: size="small" 統一。
- エラー: Alert 最上段、閉じたら消える。
- 視線誘導: Round 編集 Card のタイトル/サブタイトルを Typography で階層化。

**手動スモーク結果（記入例）:**

- 画面全体が統一フォント・統一角丸・統一余白になったか: （OK/NG）
- Board: Meeting 選択 → Round → BO → 保存 → Snackbar → 再読み込みで維持: （OK/NG）
- Chip/ボタン/入力の密度が揃ったか: （OK/NG）
- サイドメニュー（ReligoMenu）がテーマで統一されているか: （OK/NG）

## Step 4: テスト・merge・REPORT

- php artisan test を実行し green を確認。
- 1 コミットで push → develop に merge → テスト → push。
- REPORT に変更ファイル一覧・Theme SSOT の要点・手動スモーク結果・テスト結果・取り込み証跡を記載。
