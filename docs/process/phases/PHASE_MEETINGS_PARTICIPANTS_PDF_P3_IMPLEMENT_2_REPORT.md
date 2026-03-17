# Phase M7-P3-IMPLEMENT-2: 候補を participants に反映する確定フロー — REPORT

**Phase:** M7-P3-IMPLEMENT-2  
**完了日:** 2026-03-17

---

## 変更ファイル一覧

- www/app/Services/Religo/ApplyParticipantCandidatesService.php（新規）
- www/app/Http/Controllers/Religo/MeetingParticipantImportController.php（apply アクション、ApplyParticipantCandidatesService 注入）
- www/routes/api.php（POST .../participants/import/apply）
- www/resources/js/admin/pages/MeetingsList.jsx（postParticipantImportApply、反映ボタン、確認ダイアログ）
- www/tests/Feature/Religo/MeetingParticipantImportControllerTest.php（apply 関連 6 本追加）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_PLAN.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_WORKLOG.md（新規）
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_REPORT.md（本ファイル）
- docs/INDEX.md, docs/process/PHASE_REGISTRY.md, docs/dragonfly_progress.md（追記）

---

## 実装要約

- POST /api/meetings/{meetingId}/participants/import/apply で解析候補を participants に反映。当該 meeting の participants を全削除したうえで、candidates から participant を 1 件ずつ作成（同一 member は updateOrCreate で 1 件に集約）。type_hint を participants.type（regular/guest/visitor/proxy、null は regular）に変換。member は名前で検索し、未登録なら Member を新規作成（name, type のみ必須、他は null）。ApplyParticipantCandidatesService にロジックを集約。
- Drawer で解析成功かつ候補 1 件以上のとき「participants に反映」ボタンを表示。クリックで確認ダイアログを表示し、確認後に apply API を呼び、成功時に詳細再取得と「N件を participants に反映しました。」の alert を表示。

---

## 追加した API

- **POST /api/meetings/{meetingId}/participants/import/apply**  
  - 条件: 当該 meeting に participant_import が存在し、parse_status === success、candidates が 1 件以上。  
  - 処理: 当該 meeting の participants を全削除し、candidates から participants を再作成（member は名前で検索 or 新規作成）。  
  - レスポンス: `{ "applied_count": N, "message": "participants を更新しました" }`。  
  - 失敗時: import なし・parse_status が success でない・candidates 空で 422、Meeting なしで 404。

---

## participants 反映ロジック

- 全置換: Participant::where('meeting_id', $meeting->id)->delete() のあと、candidates（name が空でないもの）を走査。
- 各候補: type_hint → participant type（regular/guest/visitor/proxy、null→regular）と member type（regular→member, guest→guest, visitor→visitor, proxy→member）を変換。resolveOrCreateMember(name, memberType) で Member を取得または新規作成。Participant::updateOrCreate(meeting_id, member_id) で type を設定、introducer/attendant は null。applied_count は最終的な participants 件数。

---

## テスト結果

- php artisan test: **123 passed**
- npm run build: **成功**

---

## 既知の制約

- introducer_member_id / attendant_member_id は未設定（null）。BO 割当は既存のまま（participant 削除で participant_breakout は cascade で削除される想定のため、反映後は BO 割当は空になる可能性あり。要確認）。
- member は「名前完全一致で検索 or 新規作成」のみ。よみがな・カテゴリ・display_no は未設定。
- 差分更新・ロールバックは未実装。

---

## 次の改善候補

- introducer / attendant の設定
- member 照合の高度化（名前のゆらぎ、既存 member の選択 UI）
- 差分更新オプション
- 反映履歴（imported_at 等）の記録
