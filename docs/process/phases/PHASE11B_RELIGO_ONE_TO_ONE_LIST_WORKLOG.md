# PHASE11B Religo 1 to 1 独立一覧 — WORKLOG

**Phase:** 1 to 1 一覧・登録  
**作成日:** 2026-03-04

---

## Step 1: ブランチ・PLAN

- develop から `feature/phase11b-one-to-one-list-v1` を作成。
- PHASE11B_RELIGO_ONE_TO_ONE_LIST_PLAN.md を作成。

## Step 2: GET /api/one-to-ones

- IndexOneToOnesRequest（クエリバリデーション）。
- OneToOneController::index、Service または Query で取得・ソート・フィルタ。owner/target 名を含める。
- ルート GET /api/one-to-ones 追加。

## Step 3: OneToOneIndexTest

- workspace + members + one_to_ones を seed。GET 200、並び順、status フィルタを検証。

## Step 4: ReactAdmin List/Create

- dataProvider: getList('one-to-ones'), create('one-to-ones')。
- OneToOnesList（フィルタ・列）、OneToOnesCreate（workspace 自動、Autocomplete、meeting_id 任意）。プレースホルダーを差し替え。

## Step 5: docs・merge

- INDEX / dragonfly_progress / REPORT 更新。1 コミット push → develop --no-ff merge → test → push。
