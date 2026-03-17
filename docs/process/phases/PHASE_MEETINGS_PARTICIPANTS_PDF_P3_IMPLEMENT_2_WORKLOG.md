# Phase M7-P3-IMPLEMENT-2: 候補を participants に反映する確定フロー — WORKLOG

**Phase:** M7-P3-IMPLEMENT-2  
**作成日:** 2026-03-17

---

## 全置換を採用した理由

- 差分更新は「既存 participant のどれを残すか」「候補のどの行が新規か」の判定が複雑になる。初期実装では「当該 meeting の participants を全削除し、candidates から作り直す」全置換にした。CSV 取込も実質的に updateOrCreate で上書きしており、同じ meeting に対して「候補で一括置き換え」するイメージで揃えた。

---

## type_hint → participants.type 変換ルール

- regular → regular、guest → guest、visitor → visitor、proxy → proxy。null および type_hint が未設定・不正値の場合は regular とした。DATA_MODEL の participants.type 値域（regular / guest / proxy / absent）に合わせ、visitor も既存 CSV 取込と同様に participants に持たせた。

---

## member 未一致時の扱い

- 候補の name（trim 済み）で Member::where('name', $name)->first() を検索。見つかればその member_id で participant を登録。見つからなければ Member::create で新規作成し、name と type（type_hint から変換: regular→member, guest→guest, visitor→visitor, proxy→member）を設定。name_kana, category_id, display_no, introducer_member_id, attendant_member_id は null。既存 CSV 取込の「名前で検索 or 新規作成」の最小方針に合わせた。同一名が複数候補にある場合は updateOrCreate(meeting_id, member_id) により 1 件にまとめ、applied_count は最終的な participants 件数で返すようにした。

---

## 実装内容

- **ApplyParticipantCandidatesService:** apply(Meeting, MeetingParticipantImport) で candidates を取得し、name が空の行を除外。Participant::where('meeting_id')->delete() のあと、各候補について resolveOrCreateMember(name, memberType) で member を取得または作成し、Participant::updateOrCreate(meeting_id, member_id) で type 等を設定。返却は Participant::where('meeting_id')->count()。
- **MeetingParticipantImportController::apply:** Meeting / import の存在、parse_status === success、candidates が 1 件以上あることを確認し、サービスを呼んで applied_count と message を返す。それ以外は 404/422。
- **Route:** POST /api/meetings/{meetingId}/participants/import/apply を追加。
- **UI:** parseSuccess かつ candidates.length >= 1 のとき「participants に反映」ボタンを表示。クリックで確認ダイアログ（「この Meeting の参加者を候補で上書きします。既存の参加者データは削除されます。よろしいですか？」）を表示し、確認後に POST apply を実行。成功時は onDetailRefresh() と window.alert で「N件を participants に反映しました。」を表示。
- **Tests:** apply 成功・既存 participants 全置換・import なし 422・parse_status が success でないとき 422・candidates 空 422・member 新規作成と type_hint マッピングを検証。

---

## テスト内容

- test_apply_success_replaces_participants_and_returns_applied_count
- test_apply_replaces_existing_participants
- test_apply_returns_422_when_no_import
- test_apply_returns_422_when_parse_status_not_success
- test_apply_returns_422_when_candidates_empty
- test_apply_creates_member_when_not_found_and_maps_type_hint

---

## 結果

- php artisan test 123 passed。npm run build 成功。participants が全置換され、type_hint が participants.type に正しく変換され、未登録名は Member が新規作成されることを確認した。

---

## 今後差分更新にする場合の論点

- 既存 participants のうち「候補に含まれる member」は更新、「含まれない member」は削除、「候補のみにいる member」は新規追加、といったルールが必要。
- BO 割当（participant_breakout）との整合や、introducer/attendant を既存から引き継ぐかどうかの仕様も決める必要がある。今回は全置換で切り出した。
