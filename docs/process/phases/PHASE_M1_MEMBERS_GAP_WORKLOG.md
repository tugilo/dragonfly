# Phase M-1 Members Gap — WORKLOG（Docs）

**Phase:** M-1  
**作成日:** 2026-03-06

---

## Step0: 現状の Members API の返却値確認（one_to_one_count があるか）

- **確認結果:** GET /api/dragonfly/members?owner_member_id=&with_summary=1 は、DragonFlyMemberController で summary_lite を同梱している。
- MemberSummaryQuery および Controller の `$arr['summary_lite']` に **one_to_one_count** を含めている（www/app/Http/Controllers/Api/DragonFlyMemberController.php, www/app/Queries/Religo/MemberSummaryQuery.php）。
- テスト: www/tests/Feature/Api/DragonFlyMembersListSummaryTest.php で `$lite['one_to_one_count']` の存在と int であることを検証済み。
- **結論:** API は既に one_to_one_count を返している。M-2 は **UI のみ**（Datagrid に列追加 + record.summary_lite.one_to_one_count を表示）で完結可能。

---

## Step1: UI 反映の方針（列追加 or summary_lite 参照）

- **方針:** MembersList.jsx の Datagrid に「1to1回数」列を追加する。
- **データソース:** record.summary_lite?.one_to_one_count（optional chaining で安全に参照）。既存の SameRoomCountField / LastContactField / LastMemoField と同様の FunctionField で実装。
- **並び位置:** same_room_count（同室回数）の直後とする（関係系の並び）。
- **サブタイトル:** List の title を React ノードにし、モック文言「仕事 / 役職 / 関係性を把握し、1to1とメモで接点を増やす」を追加。
- **interested / want_1on1:** 表示のみ。Chip またはアイコンで「Interested」「1on1」を表示。値が無ければ何も出さない（任意）。

---

## Step2〜: 各 Phase で記録

- **M-2:** WORKLOG は PHASE_M2_* で別途作成するか、本 WORKLOG に M-2 実施分を追記する。
- **M-3 / M-4:** 同様に Phase ごとに記録枠を確保。

（M-1 は docs のみのため、Step0・Step1 で棚卸しと方針を固定済み。）
