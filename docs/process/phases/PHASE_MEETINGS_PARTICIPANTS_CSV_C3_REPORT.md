# Phase M7-C3: 参加者CSVを participants / members に反映 — REPORT

**Phase ID:** M7-C3  
**完了日:** 2026-03-19

---

## 変更ファイル一覧

| ファイル | 変更内容 |
|----------|----------|
| www/database/migrations/2026_03_19_100000_add_imported_at_applied_count_to_meeting_csv_imports.php | 新規 |
| www/app/Models/MeetingCsvImport.php | imported_at, applied_count を fillable/casts に追加 |
| www/app/Services/Religo/ApplyMeetingCsvImportService.php | 新規 |
| www/app/Http/Controllers/Religo/MeetingCsvImportController.php | apply メソッド追加 |
| www/app/Http/Controllers/Religo/MeetingController.php | show の csv_import に imported_at, applied_count 追加 |
| www/routes/api.php | POST meetings/{meetingId}/csv-import/apply 追加 |
| www/resources/js/admin/pages/MeetingsList.jsx | postCsvImportApply、反映ボタン・確認ダイアログ・履歴表示 |
| www/tests/Feature/Religo/MeetingCsvImportControllerTest.php | apply 関連テスト 6 件追加 |
| www/tests/Feature/Religo/MeetingControllerTest.php | csv_import 期待値に imported_at, applied_count 追加 |
| docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C3_*.md | PLAN / WORKLOG / REPORT |

## 実装要約・追加した API / Service

- **Service:** `App\Services\Religo\ApplyMeetingCsvImportService::apply(Meeting, MeetingCsvImport): int` — 最新 CSV を preview で取得し、既存 participants を削除したうえで CSV 行から participants / members を再作成。種別は メンバー→regular, ビジター→visitor, ゲスト→guest, 代理出席→proxy。member は名前で検索 or 新規作成（name, type, name_kana）。imported_at / applied_count を保存。
- **API:** `POST /api/meetings/{meetingId}/csv-import/apply` — 紐づく最新 CSV を反映し、applied_count と message を返す。CSV 未登録は 404、データ行 0 件は 422。

## participants / members 反映ロジック

- 全置換: Participant::where('meeting_id', $meeting->id)->delete() ののち、CSV の各行について名前が空でなければ種別をマッピングし、Member::where('name', $name)->first() または Member::create で member を取得し、Participant::create で参加者を登録。introducer_member_id / attendant_member_id は null。未知の種別は行をスキップ。

## テスト結果

- **php artisan test:** 172 passed（677 assertions）。MeetingCsvImportControllerTest に apply 成功・422（0 行）・404（未登録）・既存 participants 全置換・種別マッピング・既存/新規 member の 6 件を追加。
- **npm run build:** 成功。

## 既知の制約

- 紹介者・アテンドは participants に null のまま。後続 Phase で名前解決を検討。
- 新規 member は name / type / name_kana のみ。category_id 等は未設定。

## 次の改善候補

- 紹介者・アテンドの名前解決と participant への設定。
- 新規 member の category / display_no の設定（CLI に寄せる）。
- CSV 編集 UI・差分比較は別 Phase。

## Merge Evidence

（develop 取り込み後に記入）

merge commit id:  
source branch: feature/phase-m7-c3-csv-apply  
target branch: develop  
phase id: M7-C3  
test result: 172 passed  
changed files: （上記一覧）
