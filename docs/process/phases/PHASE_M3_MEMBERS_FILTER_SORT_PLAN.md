# Phase M-3 Members 検索/フィルタ/ソート — PLAN

**Phase:** M-3（tugilo式 Members Gap 解消 Runner）  
**作成日:** 2026-03-06  
**SSOT:** [MEMBERS_REQUIREMENTS.md](../../../SSOT/MEMBERS_REQUIREMENTS.md) §4、[FIT_AND_GAP_MOCK_VS_UI.md](../../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4

---

## 1. 目的

- Members 画面の要件にある**検索・フィルタ・ソート**を実現する。
- まず「既存 API で可能か」を棚卸しし、**UI のみで済むなら UI だけで完結**する。
- API が不足する場合は**新 API は作らず**、既存 `GET /api/dragonfly/members` の query 対応を**最小拡張**する。
- 既存の正: fetch + Accept: application/json、axios/apiClient 禁止、二重 fetch 禁止、既存 Controller/Service 流儀、FeatureTest 追加。

---

## 2. 実現方式

| 方式 | 内容 |
|------|------|
| **① UI のみ** | dataProvider が既に API に filter/sort を渡しており、API が解釈している場合。その前提で React Admin の List Filter / sort を追加する。 |
| **② API 最小拡張** | 既存 `GET /api/dragonfly/members` に query パラメータを追加する。新 endpoint は作らない。Controller/Request/Service の既存流儀に合わせる。 |

---

## 3. 既存 API 対応の判定（棚卸し結果）

| 項目 | パラメータ例 | 既存 API の対応 | 判定 |
|------|--------------|----------------|------|
| **q（free text）** | q=田中 | 未実装。Controller は `Request` のみで q を参照していない。 | **要 API 拡張** |
| **検索対象** | name / display_no / name_kana | 同上。 | **要 API 拡張** |
| **フィルタ: category_id** | category_id=2 | 未実装。 | **要 API 拡張** |
| **フィルタ: group_name（大カテゴリ）** | group_name=IT | 未実装。 | **要 API 拡張** |
| **フィルタ: role_id** | role_id=1 | 未実装。 | **要 API 拡張** |
| **フィルタ: interested** | interested=1 | 未実装。dragonfly_contact_flags との結合が必要。 | **要 API 拡張** |
| **フィルタ: want_1on1** | want_1on1=1 | 未実装。同上。 | **要 API 拡張** |
| **ソート: display_no** | sort=display_no&order=asc | 未実装。現在は `orderBy('id')` 固定。 | **要 API 拡張** |
| **ソート: name** | sort=name&order=asc | 未実装。 | **要 API 拡張** |
| **ソート: last_contact_at** | sort=last_contact_at | summary_lite 由来のため DB 側でソートするには結合が重い。初回は **API では未対応** とし、クライアント側ソートまたは将来拡張とする。 | **GAP 記録** |
| **既存パラメータ** | owner_member_id, with_summary, workspace_id | 対応済み。 | 変更なし |

**結論:** 現状、**検索・フィルタ・ソートのいずれも API 未対応**。dataProvider も `params.filter` / `params.sort` を members 用に URL に載せていない。したがって **M-3c（API 拡張）を先に実施し、続けて M-3b（UI）** で dataProvider と List Filter を追加する。

---

## 4. DoD

- **UI で指定した条件が実データに反映される**（URL の query で確認できる）。
- API 未対応の項目は「未実装」として GAP に記録し、**効かない UI を出さない**（偽装しない）。
- 1 Phase = 1 commit = 1 push。develop 取り込みは --no-ff。merge 後に php artisan test と npm run build を実行。

---

## 5. 成果物

| Phase | 成果物 |
|-------|--------|
| **M-3a** | PHASE_M3_MEMBERS_FILTER_SORT_PLAN.md / WORKLOG.md / REPORT.md、INDEX 追記。 |
| **M-3c** | 既存 DragonFlyMemberController::index の query 対応（q, category_id, group_name, role_id, interested, want_1on1, sort, order）。Request クラスまたは Controller 内バリデーション。FeatureTest 追加。 |
| **M-3b** | dataProvider.getList('members') で params.filter / params.sort を URL に乗せる。MembersList に React Admin の filters を追加（検索・カテゴリ・役職・フラグ・ソート）。 |

---

## 6. Git

| Phase | ブランチ | 備考 |
|-------|----------|------|
| M-3a | feature/m3a-members-filter-sort-docs | docs のみ commit/push → develop --no-ff merge → test/build → push |
| M-3c | feature/m3c-members-filter-sort-api | Backend のみ。1 commit → develop merge → test/build → push |
| M-3b | feature/m3b-members-filter-sort-ui | Front のみ。1 commit → develop merge → test/build → push |
