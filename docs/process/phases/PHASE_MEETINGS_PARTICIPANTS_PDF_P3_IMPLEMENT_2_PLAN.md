# Phase M7-P3-IMPLEMENT-2: 候補を participants に反映する確定フロー — PLAN

**Phase:** M7-P3-IMPLEMENT-2  
**Phase ID:** M7-P3-IMPLEMENT-2  
**作成日:** 2026-03-17  
**フェーズ種別:** implement  
**Related:** [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md), [PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_REPORT.md](PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_REPORT.md)

---

## 1. 背景

- M7-P3-IMPLEMENT-1 で候補の編集・保存まで完了。participants への反映は未実装。

---

## 2. 目的

- 編集済み候補（extracted_result.candidates）を participants に確定反映する。同一 meeting の既存 participants は全削除し、candidates から作り直す（全置換）。

---

## 3. スコープ

### やること

1. POST /api/meetings/{meetingId}/participants/import/apply を追加
2. candidates を participants に変換して保存（全置換）
3. type_hint → participants.type のマッピング（null/不明は regular）
4. member の解決: 名前一致で検索、未なら新規作成（必要最小限）
5. Drawer から「participants に反映」実行＋確認ダイアログ
6. 反映後の参加者表示が既存経路で確認できること
7. Feature テスト（成功・422・全置換・type 変換・member 作成）

### やらないこと

- introducer / attendant の編集
- member 照合の高度化・手動マッチング UI
- 差分更新・ロールバック UI
- import 側の imported_at / import_status（今回は見送り可）

---

## 4. 変更対象ファイル

- www/app/Services/Religo/ApplyParticipantCandidatesService.php（新規）
- www/app/Http/Controllers/Religo/MeetingParticipantImportController.php（apply アクション）
- www/routes/api.php
- www/resources/js/admin/pages/MeetingsList.jsx（反映ボタン・確認ダイアログ）
- www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_*.md
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md

---

## 5. participants 反映方針

- **全置換:** 当該 meeting_id の participants を一度すべて削除し、candidates から順に participant を create。同一 member が複数候補に含まれる場合は updateOrCreate(meeting_id, member_id) で 1 件にまとめる。
- **type 変換:** type_hint regular → regular, guest → guest, visitor → visitor, proxy → proxy, null/不明 → regular。
- introducer_member_id / attendant_member_id は今回 null のまま。

---

## 6. Member 作成/紐づけ方針

- 候補の name（trim）で Member::where('name', $name)->first() を検索。
- 見つかればその member_id で participant を作成。
- 見つからなければ Member::create で新規作成（name, type のみ必須。type は type_hint から変換: regular→member, guest→guest, visitor→visitor, proxy→member）。name_kana, category_id, display_no 等は null でよい。
- 既存 CSV 取込と同様に「名前で検索 or 新規作成」の最小方針とする。

---

## 7. テスト観点

- apply が成功し applied_count が返る
- import なし・parse_status が success でない・candidates 空で 422
- 既存 participants が削除され、candidates の件数分（同一 member は 1 件にまとまる前提）participants ができる
- type_hint が participants.type に正しく変換される
- 名前未登録の候補で Member が新規作成される
- 反映後、GET /api/meetings/{id} や Meeting#participants で参加者が見える

---

## 8. DoD

- [x] success の candidates を participants に反映できる
- [x] 既存 participants が全置換される
- [x] type_hint が正しく participants.type に変換される
- [x] member が未登録なら作成・紐づけされる
- [x] UI から反映実行・確認ダイアログ・反映後の確認ができる
- [x] php artisan test / npm run build が通る
- [x] PLAN / WORKLOG / REPORT と INDEX・REGISTRY・progress を更新している
