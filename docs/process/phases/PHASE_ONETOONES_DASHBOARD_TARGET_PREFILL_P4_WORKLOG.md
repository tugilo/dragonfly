# WORKLOG: ONETOONES_DASHBOARD_TARGET_PREFILL_P4

**Phase ID:** ONETOONES_DASHBOARD_TARGET_PREFILL_P4  
**ブランチ:** `feature/phase-onetoones-dashboard-target-prefill-p4`

---

## Step 1 — 現状調査

- **Create（`OneToOnesCreate.jsx`）:** 既に `useSearchParams` + `target_member_id` あり。検証が **全件** `GET /api/dragonfly/members` ベースだった。
- **Leads / Members / MemberShow:** 既に `?target_member_id=` 付きリンクあり。
- **Dashboard Tasks（stale 1 行目）:** `href` が `/one-to-ones/create` のみ → **相手 ID なし**。
- **Quick Create:** P3 で Form 共通化済み。URL prefill なし。

---

## Step 2 — URL クエリを正とした理由

- 再読み込み・共有・ブックマークに強い。
- Create 側に集約でき、Dashboard / Members はリンク生成のみでよい。

---

## Step 3 — Create 側の初期化

- `owner_member_id` 確定後（`ownerMemberIdFallback`）、`GET /api/dragonfly/members?owner_member_id=` で **scoped** 一覧を取得。
- `target_member_id` が **正の整数**かつ **owner と異なり**、かつ **scoped に含まれる**ときだけ `defaultValues` に含める。

---

## Step 4 — Dashboard / API

- `DashboardService::getTasks` の `stale_follow` で `i === 0` の `href` を  
  `/one-to-ones/create?target_member_id= . $tid` に変更。

---

## Step 5 — Quick Create

- `useSearchParams` で `target_member_id` を読み、オープン時のデータ取得と同じ **scoped** 検証で `prefillTargetId` を設定。
- `defaultValues.target_member_id` に反映（一覧は `#/one-to-ones?target_member_id=…` のクエリで利用可能）。

---

## Step 6 — テスト

- `DashboardApiTest::test_tasks_second_stale_row_has_member_show_deep_link` に、**1 行目**の `href` が `/one-to-ones/create?target_member_id=\d+` であることを追加。

---

## Step 7 — merge

- **競合:** なし。
- **merge commit id:** `9a4c07cf2157f38aa97b3703b8afbdd323ac2ba9`。
- **feature tip:** `1954174ba0e371752960487119a03d1ba4211aa3`。
