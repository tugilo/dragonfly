# Phase 263 REPORT — Owner Enforcement（SPEC-020 Phase B）

**完了:** 2026-06-27 JST  
**Phase Type:** implement  
**Branch:** `feature/phase263-owner-enforcement`  
**Related SSOT:** SPEC-010、SPEC-020 §4.2 / §4.5 / §11.6 順位 3〜4 / §11.8 Phase B  
**Status:** completed  

---

## 実装サマリ

SPEC-020 P0-A 順位 3〜4（owner サーバ固定・route model owner 検証）を実装した。

1. **owner サーバ固定** — `ResolvesReligoOwner` を単一の正とし、`acting user の owner_member_id` を採用。`chapter_admin` のみ query/body の任意 owner を許可（グローバル Owner 選択維持）。一般 member の別 owner 指定は **403**。
2. **route model owner 検証** — `one_to_ones` の show/update/cancel/series-markdown/memos で owner 不一致を **403**（`assertOwnerMatchesActor`）。
3. **owner 固定の横展開** — `contact_memos`・`dashboard/*`・`dragonfly/flags`・`dragonfly/contacts/{t}/summary` の owner を acting user に固定。
4. **users/me owner 変更制限** — 一般 member は owner 設定済みなら別値変更を **403**（初回 null→設定のみ許可）。`chapter_admin` は変更可。

---

## DoD 達成状況

- [x] `resolveOwnerMemberId` が acting user owner を正とし、member 不一致で 403
- [x] `chapter_admin` は任意 owner 指定可（global owner 維持）
- [x] `one-to-ones` 等の詳細・更新・キャンセルで owner 不一致 403
- [x] `GET /api/one-to-ones` が member で自分 owner に固定
- [x] `PATCH /api/users/me` で member の owner 変更 403
- [x] `OwnerEnforcementTest` で検証
- [x] `php artisan test` 全 pass（559 passed）
- [x] React 変更なし → npm build スキップ

---

## Merge Evidence

merge commit id: （merge 後に追記）  
source branch: feature/phase263-owner-enforcement  
target branch: develop  
phase id: 263  
phase type: implement  
related ssot: SPEC-020 / SPEC-010  

test command: `php artisan test`  
test result: 559 passed (2078 assertions)  

changed files:
- www/app/Http/Controllers/Religo/Concerns/ResolvesReligoOwner.php
- www/app/Http/Controllers/Religo/DashboardController.php
- www/app/Http/Controllers/Religo/OneToOneController.php
- www/app/Http/Controllers/Religo/ContactMemoController.php
- www/app/Http/Controllers/Religo/UserController.php
- www/app/Http/Controllers/Api/DragonFlyContactFlagController.php
- www/app/Http/Controllers/Api/DragonFlyContactSummaryController.php
- www/tests/Feature/Religo/OwnerEnforcementTest.php（新規）
- www/tests/Feature/Religo/ReferralApiTest.php
- www/tests/Feature/Religo/DashboardApiTest.php
- www/tests/Feature/Religo/OneToOneCrossChapterHierarchyTest.php
- www/tests/Feature/Religo/OneToOneStatsTest.php
- docs/process/phases/PHASE_263_*、PHASE_REGISTRY.md、INDEX.md、dragonfly_progress.md

scope check: OK  
ssot check: OK（SPEC-020 §4.5 に準拠）  
dod check: OK
