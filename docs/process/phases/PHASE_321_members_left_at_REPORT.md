# Phase 321 REPORT — members に退会日（left_at）カラムを追加する

**作成:** 2026-10-27 16:46 JST  
**Phase Type:** implement  
**Status:** completed（2026-11-06 10:46 JST develop へ merge）

---

## 実施内容

- `members.left_at`（date, nullable, index）を追加。NULL＝在籍、`left_at <= today`＝退会済み、将来日付＝予約退会（在籍扱い）。
- `Member::isLeft()` / `scopeActiveMembers()` を追加。
- `GET /api/dragonfly/members` のレスポンスに `left_at` を含め、`exclude_left=1` で退会者を除外（既定は全件・既存挙動不変）。
- `PUT /api/dragonfly/members/{id}` で `left_at` を設定・クリア（`Y-m-d`、不正は 422）。
- DATA_MODEL §4.2 に `left_at` と退会の表現方針を追記。
- ローカル DB: 西浦雅 `members.id=12` に `left_at=2026-10-07`。

## 変更ファイル一覧

- `www/database/migrations/2026_10_27_164600_add_left_at_to_members_table.php`（新規）
- `www/app/Models/Member.php`
- `www/app/Http/Controllers/Api/DragonFlyMemberController.php`
- `www/app/Http/Requests/Api/IndexDragonFlyMembersRequest.php`
- `www/tests/Feature/Api/DragonFlyMemberLeftAtTest.php`（新規）
- `docs/SSOT/DATA_MODEL.md`
- `docs/INDEX.md` / `docs/dragonfly_progress.md` / `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_321_members_left_at_{PLAN,WORKLOG,REPORT}.md`

## テスト結果

- `php artisan test --filter=DragonFlyMemberLeftAtTest`: 5 passed / 22 assertions
- `php artisan test`: **625 passed（2304 assertions）** 2026-10-27 16:50 JST
- React 変更なし（`npm run build` 不要）

## DoDチェック

- [x] migration up 済み（`members.left_at` 存在）。down は `dropIndex` → `dropColumn`
- [x] PUT で設定・クリア、GET に `left_at`
- [x] `exclude_left=1` で退会者除外、未指定は全件
- [x] 新規テスト green・全体 green
- [x] DATA_MODEL §4.2 更新
- [x] 西浦雅 `left_at=2026-10-07`
- [x] INDEX / 進捗 / PHASE_REGISTRY 同期
- [x] Merge Evidence

## 残課題（別 Phase）

- Members 画面（React）に退会日の表示・編集・「退会者を隠す」トグル
- Dashboard / 1to1 リード / Connections 名簿の既定クエリで `activeMembers()` を使うか（現状は全件）
- 退会確定時に open の `member_roles` を自動で閉じる連動
- 八田奈緒美 `members.id=165` の退会日確定と設定
- 第225回（2026-10-13）participants に残る西浦の regular 行の扱い

---

## Merge Evidence

merge commit id: 27b87db511ff70d6faaf0065ca021cbf88be68ef  
source branch: feature/phase321-members-left-at  
target branch: develop  
phase id: 321  
phase type: implement  
related ssot: DATA_MODEL §4.2 / SPEC-007 / SPEC-008

test command: php artisan test  
test result: 625 passed（2304 assertions）2026-11-06 10:46 JST merge 後に develop で再実行

changed files（feature commit `b1b061a`）:

- docs/SSOT/DATA_MODEL.md
- docs/process/phases/PHASE_321_members_left_at_{PLAN,WORKLOG,REPORT}.md
- www/app/Http/Controllers/Api/DragonFlyMemberController.php
- www/app/Http/Requests/Api/IndexDragonFlyMembersRequest.php
- www/app/Models/Member.php
- www/database/migrations/2026_10_27_164600_add_left_at_to_members_table.php
- www/tests/Feature/Api/DragonFlyMemberLeftAtTest.php

INDEX / 進捗 / PHASE_REGISTRY の更新は `feature/docs-sync-20261106` に含めた（複数 Phase の行が同じファイルにあるため）。

scope check: OK  
ssot check: UPDATE DONE（DATA_MODEL §4.2）  
dod check: OK
