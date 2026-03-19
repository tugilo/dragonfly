# Phase D2: participants 差分プレビューUI（名前解決ベース）— REPORT

**Phase ID:** D2（M7-D2）  
**完了日:** 2026-03-19

---

## 変更ファイル一覧

- www/app/Services/Religo/MeetingCsvPreviewService.php（No 列を表示用に追加）
- www/app/Services/Religo/MeetingCsvDiffPreviewService.php（新規）
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php（diffPreview メソッド追加）
- www/routes/api.php（GET diff-preview ルート追加）
- www/resources/js/admin/pages/MeetingsList.jsx（差分を確認ボタン・差分プレビュー表示・確認ダイアログに summary）
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php（diff-preview テスト 7 件・preview headers 数 10 に変更）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_PLAN.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_WORKLOG.md
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_REPORT.md（本ファイル）

---

## 実装要約

- 反映前に CSV と既存 participants の差分を取得する API（GET .../csv-import/diff-preview）を追加。名前解決のみ行い Member は作成しない。member_id ベースで added / updated / unchanged / missing を算出し、missing には has_breakout を付与。Drawer に「差分を確認」ボタンと差分プレビュー（summary + 3 セクション）を実装。未掲載は「未掲載（残存）」「CSVにない既存 participant。今回は削除せず残ります」と表示。BO ありは Chip で表示。

## 追加した API / Service

- **GET /api/meetings/{meetingId}/csv-import/diff-preview**  
  最新 CSV と既存 participants の差分を返す。レスポンス: summary（added_count, updated_count, unchanged_count, missing_count）, added[], updated[], missing[]。missing 各要素に has_breakout を含む。
- **MeetingCsvDiffPreviewService**  
  diffPreview(Meeting, MeetingCsvImport)。preview で rows 取得 → 名前で Member 解決（既存のみ）→ member_id ベースで差分算出。No は source_no として表示用のみ。

## 差分プレビュー UI

- 参加者CSV ブロックで、CSV ありかつ row_count > 0 のとき「差分を確認」ボタンを表示。押下で diff-preview を取得し、summary（追加/更新/変更なし/未掲載の件数 Chip）と、追加・更新・未掲載の 3 セクションを Table で表示。種別は participantTypeLabel でメンバー/ビジター/ゲスト/代理に変換。確認ダイアログでは csvDiffData がある場合に summary 件数を表示。

## テスト結果

- MeetingCsvImportControllerTest 25 件すべて成功（diff-preview 関連 7 件追加）。全体 181 passed (733 assertions)。npm run build 成功。

## 既知の制約

- 差分プレビューは「取得」のたびに API を呼ぶ。結果の保存は行わない。
- 新規 member になる行は added に member_id: null で含まれる。反映時に初めて member が作成される。

## 次の改善候補

- 削除候補の表示・実削除オプション（BO ありは削除しない制御）。
- members 基本情報更新・Role History 連携（M7-C4.5 に沿った別 Phase）。
- PDF フローの差分プレビュー。

---

## Merge Evidence

（develop 取り込み後に記入）

merge commit id:  
source branch: feature/phase-d2-diff-preview  
target branch: develop  
phase id: D2 (M7-D2)  
phase type: implement  

test command: php artisan test  
test result: 181 passed  

changed files: 上記 9 ファイル + INDEX + PHASE_REGISTRY + dragonfly_progress  

scope check: OK  
ssot check: OK  
dod check: OK  
