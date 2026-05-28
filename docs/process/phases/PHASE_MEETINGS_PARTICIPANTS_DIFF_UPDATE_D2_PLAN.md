# Phase D2: participants 差分プレビューUI（名前解決ベース）— PLAN

**Phase ID:** D2（M7-D2）  
**Phase 名:** participants 差分プレビューUI（名前解決ベース）  
**種別:** implement  
**Related SSOT:** MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md, MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_REPORT.md

---

## 背景

- M1 で participants の差分更新（削除なし安全モード）は実装済み。反映後の件数でしか差分を確認できず、反映前に一覧で見えない。
- CSV の No は表示順であり識別キーに使えない。差分判定は「名前解決 → member_id ベース」に統一する。

## 目的

- CSV 反映前に、追加・更新・未掲載（残存）を一覧で確認できるようにする。
- 名前解決 → member_id ベースで差分判定し、No は識別に使わない。
- 反映前に「何が起きるか」を見える化する。今回は削除は行わず、未掲載 participant は残す前提。

## スコープ

**やること**

1. CSV 反映前の差分比較 API（GET .../csv-import/diff-preview）を追加する。
2. 追加・更新・未掲載を member_id ベースで算出する。
3. Drawer で差分プレビュー（summary + 3 セクション）を表示する。
4. 確認ダイアログの前段として差分を見てから反映できるようにする。
5. BO を持つ既存 participant（missing）には has_breakout を返し、UI で warning 表示する。

**やらないこと**

- 実削除、削除候補の削除実行、members 基本情報更新、Role History 更新、introducer/attendant 更新、差分結果の保存、PDF フローの差分プレビュー。

## 変更対象ファイル

- www/app/Services/Religo/MeetingCsvPreviewService.php（No 列を表示用に追加）
- www/app/Services/Religo/MeetingCsvDiffPreviewService.php（新規）
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php（diffPreview メソッド）
- www/routes/api.php（GET diff-preview）
- www/resources/js/admin/pages/MeetingsList.jsx（差分を確認ボタン・差分表示・確認ダイアログに summary 表示）
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php（diff-preview テスト）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_*.md

## 差分判定方針

- CSV 行から name を取得 → Member::where('name', $name)->first() で解決（作成はしない）。
- 得られた member_id をキーに既存 participants と比較。
- member_id が既存にない → added。既存にあり type が異なる → updated。既存にあり type も同じ → unchanged。
- 既存 participant にあり CSV にない member_id → missing（未掲載・残存）。has_breakout を付与。

## No をキーに使わない理由

- CSV の No は毎回変わりうる表示順・行番号であり、同一人物の識別には使えない。名前は同一 meeting 内で重複しうるが、participants は (meeting_id, member_id) UNIQUE のため、名前解決した member_id で一意に追加・更新・未掲載が決まる。No は表示用（source_no）としてのみ利用する。

## UI 表示方針

- CSV あり & row_count > 0 のとき「差分を確認」ボタンを表示。押下で diff-preview API を呼ぶ。
- Drawer 内に summary（追加 N / 更新 M / 変更なし U / 未掲載 K 件）と 3 セクション（追加・更新・未掲載）を Table で表示。
- 未掲載は「未掲載（残存）」「CSVにない既存 participant。今回は削除せず残ります」と表示。has_breakout のときは「BO あり」Chip で注意喚起。
- 反映ボタンは従来どおり。確認ダイアログに csvDiffData がある場合は summary 件数を表示。

## テスト観点

- diff-preview 成功で summary / added / updated / missing が返ること。
- member_id ベースで判定され、No は識別に使われないこと（同一名前で No が違っても 1 件）。
- CSV にない既存 participant が missing に入ること。
- BO 付き participant が missing のとき has_breakout が true になること。
- CSV 未登録で 404、rows 0 件で 422。

## DoD

- 反映前に差分を見られる。
- added / updated / missing が分かる。
- No をキーに使っていない。
- BO あり未掲載 participant を認識できる。
- 既存 apply / PDF フローを壊さない。
- php artisan test が通る。
- npm run build が通る。
