# Phase 321 PLAN — members に退会日（left_at）カラムを追加する

**作成:** 2026-10-27 16:46 JST  
**Phase Type:** implement（migration・Model・API・テスト・DATA_MODEL）  
**Branch:** `feature/phase321-members-left-at`  
**Related SSOT:** DATA_MODEL §4.2 members（`docs/SSOT/DATA_MODEL.md`）／SPEC-007 `MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md`（入退会の業務方針）／SPEC-008 `MEMBERS_DEDUPLICATION_RUNBOOK.md`（members 行は履歴として残す）

---

## Purpose

退会したメンバーを **DB 上で明示できるようにする**。現状は「名簿 CSV から消える」「open の役職レコードを閉じる」でしか退会を表現できず、`members.type=member` のまま残るため、名簿・1to1 相手検索・リード抽出に退会者が混ざる。2026-10-27 に西浦雅（2026-10-07 退会）の扱いで顕在化した。

## 背景

- `members` に退会日・在籍状態のカラムがない（Phase14 正規化以降も未追加）。
- 退会者の `members` 行は履歴（participants / one_to_ones / contact_memos の FK）として残す方針（SPEC-008）。削除はしない。
- 八田奈緒美（第222回 2026-09-15 で名簿から除外）も同様に `left_at` 未設定。日付は未確定。

---

## Scope

変更可能範囲は次のとおり。

- `www/database/migrations/2026_10_27_164600_add_left_at_to_members_table.php`（新規）
- `www/app/Models/Member.php`（fillable・cast・`scopeActiveMembers`）
- `www/app/Http/Controllers/Api/DragonFlyMemberController.php`（index の select・`exclude_left` フィルタ／update の `left_at` 受け付け）
- `www/app/Http/Requests/Api/IndexDragonFlyMembersRequest.php`（`exclude_left` 追加）
- `www/tests/Feature/Api/DragonFlyMemberLeftAtTest.php`（新規）
- `docs/SSOT/DATA_MODEL.md` §4.2
- `docs/INDEX.md` / `docs/dragonfly_progress.md` / `docs/process/PHASE_REGISTRY.md`
- `docs/process/phases/PHASE_321_members_left_at_{PLAN,WORKLOG,REPORT}.md`
- ローカル DB データ: 西浦雅 `members.id=12` に `left_at=2026-10-07` を設定（tinker）

対象外: React UI（Members 画面の退会表示・フィルタ UI は別 Phase）、`import-participants-csv` の自動退会判定（名簿から消えた＝退会とは限らないため人の判断を残す）、Dashboard / 1to1 リードの既定クエリ変更（`exclude_left` を opt-in で提供し、既定挙動は変えない）、本番 push（別途ユーザー判断）。

---

## 設計

| 項目 | 決定 |
|------|------|
| カラム名 | `left_at`（date, nullable, index）。`type` の直後 |
| 意味 | その日付をもって BNI DragonFly を退会。NULL は在籍（または入会前の visitor/guest） |
| 在籍判定 | `left_at IS NULL OR left_at > today` を「在籍」とする（将来日付の予約退会を許容） |
| Model | `Member::scopeActiveMembers()`／`isLeft()`。`left_at` は `date:Y-m-d` キャスト |
| API index | `select` に `left_at` を追加。`exclude_left=1` で在籍のみ（既定は従来どおり全件） |
| API update | `left_at` を `nullable|date` で受け付け。空文字・null でクリア |
| 退会時の役職 | 本 Phase では自動で閉じない（運用: 退会確定時に open の member_roles を手動で閉じる。将来 Phase で連動） |
| participants | 退会日以降の participants 行は本 Phase では触らない（第225回の西浦 regular 行は別判断） |

---

## DoD

- migration が up/down ともに通り、`members.left_at` が存在する。
- `PUT /api/dragonfly/members/{id}` で `left_at` を設定・クリアでき、`GET /api/dragonfly/members` のレスポンスに `left_at` が含まれる。
- `GET /api/dragonfly/members?exclude_left=1` で退会者が除外され、未指定時は従来どおり全件。
- 新規 Feature テストが green、`php artisan test` 全体が green。
- DATA_MODEL §4.2 に `left_at` と在籍判定を追記。
- ローカル DB で西浦雅 `left_at=2026-10-07`。
- INDEX / 進捗 / PHASE_REGISTRY を同期。REPORT に Merge Evidence（merge 実施後）。

---

## Tasks

1. migration 追加・`migrate`。
2. Member モデル（fillable / cast / scope / isLeft）。
3. API index（select・`exclude_left`）／update（`left_at`）／Request ルール。
4. Feature テスト作成・全体テスト。
5. DATA_MODEL §4.2 更新。
6. ローカル DB 西浦 `left_at` 設定。
7. INDEX・進捗・PHASE_REGISTRY・WORKLOG・REPORT。
8. develop へ merge → 1 push（ユーザー指示後）。
