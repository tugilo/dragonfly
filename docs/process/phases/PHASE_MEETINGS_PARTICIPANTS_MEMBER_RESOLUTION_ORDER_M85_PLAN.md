# Phase M8.5: 参加者CSV — member 解決順の統一 PLAN

| 項目 | 内容 |
|------|------|
| Phase ID | **M8.5** |
| 種別 | implement（整合性是正・新機能なし） |
| 関連 SSOT | [MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md) |
| 参照 | [PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_REPORT.md](PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_REPORT.md)、[PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_REPORT.md](PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_REPORT.md)、[PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_REPORT.md](PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_REPORT.md) |

## 背景

- M7-FINAL-CHECK で、**participants apply** は member を **resolution → 名前一致 → 新規** と解決する一方、**diff / member / role プレビュー**と **unresolved 集計**は **名前一致 → resolution** だった。
- DB に **同名の Member が複数**あり、resolution が **名前一致で先に返る行以外**を指す場合、プレビューと apply の **member_id が食い違う**可能性があった。

## 目的

- **CSV 上の名前文字列**から Member を決める順序を、**preview 系・unresolved・apply**で **同一**にする。
- **resolution（人が明示した解決）を常に最優先**し、プレビューで見た対象と apply の対象を一致させる。

## スコープ

**やる**

1. 統一順序: **① resolutions（member）② `Member::where('name', CSV名)` ③ プレビューは unresolved のみ／apply のみ新規作成**。
2. 共通化: `MeetingCsvMemberResolver`（既に M8 で追加した `resolveExistingForCsvName` を M8.5 で全呼び出し元に利用）。
3. 競合シナリオの Feature / Unit テスト。
4. SSOT・FINAL_CHECK REPORT の追記・更新。

**やらない**

- category / role の解決順変更、resolution 仕様変更、UI 大幅変更、あいまい一致・PDF の変更。

## 変更対象ファイル

- `www/app/Services/Religo/MeetingCsvMemberResolver.php`（既存・利用範囲拡大）
- `www/app/Services/Religo/ApplyMeetingCsvImportService.php`
- `www/app/Services/Religo/MeetingCsvDiffPreviewService.php`
- `www/app/Services/Religo/MeetingCsvMemberDiffPreviewService.php`
- `www/app/Services/Religo/MeetingCsvRoleDiffPreviewService.php`
- `www/app/Services/Religo/MeetingCsvUnresolvedSummaryService.php`
- `www/tests/Feature/Religo/MeetingCsvImportControllerTest.php`
- `www/tests/Unit/Religo/MeetingCsvMemberResolverTest.php`（新規）
- `docs/SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md`
- `docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_REPORT.md`
- 本 PLAN / WORKLOG / REPORT、`docs/process/PHASE_REGISTRY.md`、`docs/INDEX.md`、`docs/dragonfly_progress.md`

## テスト観点

- 同名 2 件 + resolution が **後ろの id** を指す → diff / member / role preview / unresolved / apply すべて **その id**。
- resolution なし → 従来どおり名前一致。
- `php artisan test` / `npm run build`

## DoD

- [x] preview 系と apply で member 解決順が一致
- [x] resolution が最優先
- [x] 競合 Feature / Unit テスト
- [x] テスト・ビルド成功
- [x] ドキュメント更新

## モック比較

- 対象外（バックエンド整合性）。
