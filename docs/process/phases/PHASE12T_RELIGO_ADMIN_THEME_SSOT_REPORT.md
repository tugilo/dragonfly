# PHASE12T Religo Admin Theme SSOT + 適用 — REPORT

**Phase:** Admin Theme SSOT + 適用  
**完了日:** 2026-03-04

---

## 実施内容

- Religo 管理画面の Theme を 1 箇所（religoTheme.js）に集約し、app.jsx で Admin に渡して全ページに適用。CssBaseline を ReligoLayout で有効化。
- docs/SSOT/ADMIN_UI_THEME_SSOT.md で Typography / Shape / Spacing / Components override / ReactAdmin ルールを固定。
- Board は Phase12S 構造を維持しつつ、Meeting 未選択時の説明文・保存導線の強調・Typography 階層のみ微調整。

## 変更ファイル一覧

- docs/process/phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_PLAN.md（新規）
- docs/process/phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_WORKLOG.md（新規）
- docs/process/phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_REPORT.md（新規）
- docs/SSOT/ADMIN_UI_THEME_SSOT.md（新規）
- docs/INDEX.md（SSOT リンク・Phase12T 3 件追加）
- docs/dragonfly_progress.md（Phase12T 1 行追加）
- www/resources/js/admin/theme/religoTheme.js（新規）
- www/resources/js/admin/app.jsx（religoTheme  import と Admin theme 適用）
- www/resources/js/admin/ReligoLayout.jsx（CssBaseline 追加）
- www/resources/js/admin/pages/DragonFlyBoard.jsx（未選択時説明文・Round 割当 Typography 階層・保存ボタン variant 切り替え）

## Theme SSOT の要点（固定した項目）

- **Typography**: h6 / subtitle1 / body2 / caption のサイズ・fontWeight・lineHeight。fontFamily はシステムフォント＋Roboto。
- **Shape**: borderRadius 8（Card 等）。
- **Components**: MuiCard（outlined, borderRadius 8）、MuiButton（textTransform none）、MuiTextField/MuiFormControl（outlined, size small, margin dense）、MuiChip（size small）、MuiAutocomplete（size small）、MuiAlert。MuiInputBase のフォーカスリングは borderWidth 1 を維持。
- **CssBaseline**: ReligoLayout で一箇所のみ有効化。
- **適用**: app.jsx の Admin に theme={religoTheme} で一箇所のみ。

## 手動スモーク結果

（Step 3 で記入：画面全体の統一感・Board フロー・Chip/ボタン/入力密度・サイドメニュー）

## テスト結果

- `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` — **27 passed (125 assertions)**

## DoD

- [x] Theme が 1 箇所に集約され、ReligoLayout（または app.jsx）で必ず適用される
- [x] Typography / shape / components override が定義され、Board 含む全ページに反映される
- [x] CssBaseline / density / focus ring / button variant が統一される
- [ ] 手動スモーク観点が明記され、結果が WORKLOG に記載される（実施者が記入）
- [x] 既存テスト（php artisan test）が green

## 取り込み証跡

| 項目 | 内容 |
|------|------|
| **merge commit id** | （merge 後に記入） |
| **merge 元ブランチ名** | feature/phase12t-admin-theme-ssot-v1 |
| **変更ファイル一覧** | （merge 後に記入） |
| **テスト結果** | （passed 数） |
