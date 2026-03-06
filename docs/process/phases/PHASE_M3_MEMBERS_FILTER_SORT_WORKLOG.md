# Phase M-3 Members 検索/フィルタ/ソート — WORKLOG

**Phase:** M-3  
**作成日:** 2026-03-06

---

## Step0: 棚卸し

### Step0-1: MembersList が呼んでいる resource / endpoint

- **Resource:** `members`（React Admin の List は `resource="members"` を利用している。app.jsx の Resource name="members" により getList('members', params) が呼ばれる。）
- **Endpoint:** dataProvider の `getList('members', params)` が叩く URL:  
  `/api/dragonfly/members?owner_member_id=${owner}&with_summary=1`  
- **結論:** 固定クエリのみ。`params.filter` / `params.sort` / `params.pagination` は**一切渡していない**。

### Step0-2: dataProvider.getList の params を確認

- **コード:** `www/resources/js/admin/dataProvider.js` の `resource === 'members'` の分岐。
- **渡しているもの:** `owner_member_id`（getOwnerMemberId(params)）、`with_summary=1` のみ。
- **渡していないもの:** `params.filter`（q, category_id, role_id, interested, want_1on1 等）、`params.sort`（field, order）、`params.pagination`。
- **結論:** 現状、List の Filter や sort を有効にしても API に伝わらない。

### Step0-3: Backend が受け取るクエリを確認

- **Controller:** `App\Http\Controllers\Api\DragonFlyMemberController::index(Request $request)`。
- **参照しているパラメータ:**  
  - `with_summary`（boolean / '1'）  
  - `owner_member_id`（int、必須でないが summary 付与時に必要）  
  - `workspace_id`（int、任意）
- **参照していないパラメータ:** q, category_id, group_name, role_id, interested, want_1on1, sort, order。
- **クエリビルダ:** `Member::query()->with('category')->with('memberRoles.role')->select(...)->orderBy('id')->get();`  
  → **全件取得・id 順固定**。フィルタ・ソートなし。
- **結論:** 現状の API では「今の API でできる」検索/フィルタ/ソートは**一つもない**。

### Step0-4: 「今の API でできる/できない」の確定

| 機能 | できる | できない | 備考 |
|------|--------|----------|------|
| 検索（q） | — | ○ | API 拡張が必要 |
| フィルタ（category_id） | — | ○ | API 拡張が必要 |
| フィルタ（group_name） | — | ○ | API 拡張が必要 |
| フィルタ（role_id） | — | ○ | API 拡張が必要 |
| フィルタ（interested / want_1on1） | — | ○ | API 拡張が必要（dragonfly_contact_flags 等） |
| ソート（display_no / name） | — | ○ | API 拡張が必要 |
| ソート（last_contact_at 等） | — | ○ | summary 由来のため初回は API 未対応可。GAP に記録。 |

**確定:** すべて「できない」。M-3b で UI のみ先行することは不可。**M-3c（API 拡張）を先に実施し、その後に M-3b（UI）** を実施する。

---

## Step1〜: 各 Phase での記録

### M-3c 実施内容（API 拡張）
- **Request:** `App\Http\Requests\Api\IndexDragonFlyMembersRequest` を作成。q, category_id, group_name, role_id, interested, want_1on1, sort（allowlist: id, display_no, name）, order（asc/desc）をバリデーション。
- **Controller:** `DragonFlyMemberController::index` を Request 型に変更し、上記クエリに応じて Member クエリに where / whereHas / whereExists / orderBy を適用。既存の with_summary バッチ処理は維持。
- **FeatureTest:** `Tests\Feature\Api\DragonFlyMembersIndexFilterSortTest` を追加。q で名前検索、sort=display_no&order=asc、interested=1 でフラグ絞り込みを検証。

### M-3b 実施内容（UI）
- **dataProvider:** getList('members') で params.filter（q, category_id, group_name, role_id, interested, want_1on1）と params.sort（field, order）を URL に乗せる。
- **MembersList:** filters に SearchInput（q）、ReferenceInput（category_id, role_id）、BooleanInput（interested, want_1on1）を追加。sort デフォルト display_no ASC。Datagrid の番号・名前列を sortable に設定。
- 二重 fetch なし。List の取得は dataProvider 経由のみ。
