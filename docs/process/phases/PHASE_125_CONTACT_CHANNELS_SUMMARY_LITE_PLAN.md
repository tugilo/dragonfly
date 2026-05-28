# Phase 125 PLAN — Owner 基準の接触チャネル別記録（summary_lite）

- **Phase ID:** 125
- **種別:** implement
- **Related SSOT:** SPEC-002（CONTACT_LOGIC_ALIGNMENT）、DATA_MODEL §5

## 目的

グローバル Owner から見た各メンバーについて、**例会 BO 同席**・**1 to 1**・**接触メモ**ごとの **最終日時**を API で返し、Members 一覧で確認できるようにする。

## 方針

- **新テーブルは作らない。** `participant_breakout` / `one_to_ones` / `contact_memos` から **派生**（`MemberSummaryQuery::batchContactBreakdown`）。
- `GET /api/dragonfly/members?owner_member_id=&with_summary=1` の `summary_lite` に `last_bo_contact_at`・`last_one_to_one_contact_at`・`last_memo_contact_at` を追加。`last_contact_at` はチャネル別の合成 MAX（introduction は本クエリでは未含有）。

## Scope

- `www/app/Queries/Religo/MemberSummaryQuery.php`
- `www/app/Http/Controllers/Api/DragonFlyMemberController.php`
- `www/resources/js/admin/pages/MembersList.jsx`（最終接触列の補助行）
- テスト・SSOT（CONTACT_LOGIC_ALIGNMENT・DATA_MODEL）

## DoD

- Feature / Query テスト緑、`npm run build` 成功。
