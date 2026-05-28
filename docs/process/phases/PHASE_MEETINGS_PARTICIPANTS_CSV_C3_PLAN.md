# Phase M7-C3: 参加者CSVを participants / members に反映 — PLAN

**Phase ID:** M7-C3  
**Phase 名:** 参加者CSVを participants / members に反映  
**種別:** implement  
**Related SSOT:** MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md, MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md, FIT_AND_GAP_MEETINGS.md

---

## 1. 背景

- C1 で CSV 保存、C2 でプレビューまで完了。当面の運用は ChatGPT 作成 CSV を優先したい。
- プレビュー確認した CSV を participants / members に反映し、実運用で使えるようにする。

## 2. 目的

- 保存済み CSV の内容を Meeting の参加者データとして確定反映する。
- CSV を「確定データ寄りの入口」として使えるようにする。
- PDF フローとは独立しつつ、同じ participants / members に反映する。

## 3. スコープ

### やること

- 保存済み CSV を participants に反映する API（全置換）
- 必要に応じて members を名前で解決 or 新規作成
- Meeting Drawer から反映実行（確認ダイアログ付き）
- 反映結果件数の表示
- meeting_csv_imports に imported_at / applied_count を追加し、show API で返す

### やらないこと

- 差分更新、CSV 編集 UI、introducer/attendant の高度照合 UI、PDF フロー統合、imported_by 本格対応、監査ログ別テーブル

## 4. 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| www/database/migrations/*_add_imported_at_applied_count_to_meeting_csv_imports.php | 新規 |
| www/app/Models/MeetingCsvImport.php | fillable / casts に imported_at, applied_count 追加 |
| www/app/Services/Religo/ApplyMeetingCsvImportService.php | 新規 |
| www/app/Http/Controllers/Religo/MeetingCsvImportController.php | apply メソッド追加 |
| www/app/Http/Controllers/Religo/MeetingController.php | show の csv_import に imported_at, applied_count 追加 |
| www/routes/api.php | POST meetings/{id}/csv-import/apply 追加 |
| www/resources/js/admin/pages/MeetingsList.jsx | 「participants に反映」ボタン・確認ダイアログ・apply API 呼び出し |
| www/tests/Feature/Religo/MeetingCsvImportControllerTest.php | apply 関連テスト追加 |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C3_*.md | PLAN / WORKLOG / REPORT |

## 5. 反映方針

- **全置換:** 対象 meeting_id の既存 participants を削除し、CSV の行から participants を再作成する。M7-P3 の candidates apply と同思想。

## 6. Member 解決方針

- 既存 ImportParticipantsCsvCommand の考え方に寄せる。名前（Member.name）完全一致があればその member を使用、なければ新規作成。
- 新規作成時: 最低限 name を保存。よみがな / category は取れれば設定、過剰な項目埋めはしない。紹介者・アテンドはこの Phase では participant に null のままとする。

## 7. 種別マッピング方針

- CSV「種別」→ participants.type: メンバー→regular, ビジター→visitor, ゲスト→guest, 代理出席→proxy（CLI TYPE_MAP に合わせる）。未知の種別は行スキップまたは regular に寄せるかは WORKLOG で記載。

## 8. テスト観点

- CSV 反映成功時 applied_count が返る、既存 participants が削除され CSV 行数分作成される。
- rows 0 件で 422、CSV 未登録で 404。
- 種別が participants.type に正しく変換される。
- member が既存一致なら紐づき、新規なら作成される。
- imported_at / applied_count が保存され、show API に含まれる。

## 9. DoD

- 保存済み CSV を participants に反映できる。
- 必要に応じて members を解決 / 作成できる。
- 既存 participants が全置換される。
- 反映前確認がある。
- 反映後の件数が分かる。
- PDF フローを壊さない。
- php artisan test が通る。npm run build が通る。
