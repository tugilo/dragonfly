# Phase M7-P5: 手動マッチングUI — WORKLOG

**Phase:** M7-P5  
**作成日:** 2026-03-17

---

## auto / manual の共存方針

- 表示・集計は CandidateMemberMatchService の enrich で一括算出。候補に match_source=manual かつ matched_member_id が保存されていればその member を matched として扱い、そうでなければ名前完全一致で auto 照合。手動解除後は matched_member_id / match_source を null にし、次回表示で auto または new に戻る。
- extracted_result.candidates には matched_member_id, matched_member_name, match_source（manual 時のみ）を保存。match_status は保存してもよいが enrich で上書きするため省略可能。

## matched_member_id をどこに持つかの判断

- extracted_result.candidates の各要素にそのまま持つ（A案）。既存の PUT candidates API を拡張し、candidates.*.matched_member_id / matched_member_name / match_source を受け取り保存。専用 API は作らず、保存時に member 存在チェック（exists:members,id）と Member::find で name を補完してから書き込んだ。

## member 検索 UI の選定理由

- 「member を選択」クリックで Dialog を開き、テキスト入力で q を送り GET /api/members/search を呼ぶ方式にした。Autocomplete は MUI の依存やフォーカス管理が重いため、シンプルな Dialog + 入力 + 結果ボタンリストにした。検索は memberSearchOpen かつ memberSearchQuery の useEffect で実行し、入力のたびに検索（デバウンスは未実装、必要なら後で追加）。

## 集計再計算の方針

- enrich 内で、手動マッチ（match_source=manual かつ matched_member_id 有効）も matched_count に含める。解除後は auto 判定に戻るため、集計は常に enrich の結果で上書きしている。

## 実装内容

- **MemberSearchController:** GET /api/members/search?q=... で name 部分一致、orderBy name、limit 15、id/name のみ返却。
- **UpdateParticipantImportCandidatesRequest:** candidates.*.matched_member_id (nullable, exists:members,id), matched_member_name, match_source (in:auto,manual) を追加。
- **MeetingParticipantImportController::updateCandidates:** 各候補で matched_member_id が渡された場合は Member::find で存在確認し、matched_member_name を DB から取得して candidate に保存。null の場合は matched_member_id/name/match_source を null で保存。
- **CandidateMemberMatchService::enrichCandidates:** match_source=manual かつ matched_member_id がある場合はその member を matched として使用し、なければ auto（名前完全一致）。手動指定で member が削除されていた場合は auto にフォールバック。
- **ApplyParticipantCandidatesService:** resolveMemberForCandidate を追加。candidate.matched_member_id があれば Member::find で取得、なければ従来の resolveOrCreateMember(name, type)。
- **MeetingsList.jsx:** 編集モードで editingCandidates に matched_member_id, matched_member_name, match_source を追加。照合列で手動選択済みなら member 名＋解除ボタン、未選択なら「member を選択」ボタン。ボタンクリックで member 検索 Dialog を表示し、fetchMemberSearch(q) で結果取得、選択でその行に matched_member_id/name, match_source=manual をセット。保存時は putParticipantImportCandidates の body に matched_member_id/name/match_source を含める。表示モードでは match_source に応じて Chip を「既存 member（自動）」「既存 member（手動）」「新規作成」で切り替え。

## テスト内容

- MemberSearchControllerTest: q 空で空配列、name 部分一致で id/name 返却、limit 15 以下であること。
- MeetingParticipantImportControllerTest: update で matched_member_id/name/match_source=manual を保存し、show で match_source=manual かつ matched_count に含まれること。apply で matched_member_id の member が participant に使われること。手動解除後（matched_member_id null）で show の集計が new に戻ること。

## 結果

- php artisan test 132 passed。npm run build 成功。既存 apply テストはすべて通過。
