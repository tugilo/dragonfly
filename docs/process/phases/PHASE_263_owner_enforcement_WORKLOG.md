# Phase 263 WORKLOG — Owner Enforcement

**Branch:** `feature/phase263-owner-enforcement`

---

## 判断ログ

### owner 解決の中心化
- 既存に `ResolvesReligoOwner` trait と `DashboardController` 内の重複実装があった。**trait を単一の正**とし、Dashboard も trait を使うよう統一。
- enforce 方式は `abort(403)` を trait 内で投げる方式を採用。各呼び出し側の `int|false` 既存分岐（未設定→422）を壊さず、不一致のみ 403 を上乗せできるため。

### admin 例外
- SPEC-003 のグローバル Owner 選択（chapter_admin がヘッダーで任意 owner に切替）を維持する必要があるため、`chapter_admin` は query/body の任意 owner を許可。
- 一般 `member` は「未指定→自分 owner」「自分 owner 一致→可」「別 owner→403」。

### route model owner 検証
- `one_to_ones` 詳細/更新/cancel/series/memos は `assertOwnerMatchesActor($oneToOne->owner_member_id)` で member 不一致を 403。admin は通す。
- `introductions` / `internal_referrals` は既存が「不一致→404（存在秘匿）」。member の別 owner query は trait で 403 になるため、未指定時の route model 不一致は既存 404 を維持（情報秘匿の観点で妥当）。

### users/me owner 変更制限
- `member` は `owner_member_id` が既に設定済みの場合、別値への変更を 403。初回（null→設定）はオンボーディングとして許可。
- `default_workspace_id` は本 Phase では従来どおり可（チャプター管理化は onboarding Phase で扱う）。

---

## 実装メモ

### 変更ファイル（実装）
- `Concerns/ResolvesReligoOwner.php`: enforce 方式 + `assertOwnerMatchesActor` + `actorIsChapterAdmin` を追加。
- `DashboardController.php`: ローカル resolve を削除し trait に統一。
- `OneToOneController.php`: index/stats を `scopeFiltersToOwner` で owner 固定、store で owner 上書き、show/update/cancel/series/memos に `assertOwnerMatchesActor`。
- `ContactMemoController.php`: index/store を trait で owner 固定。
- `Api/DragonFlyContactFlagController.php` / `Api/DragonFlyContactSummaryController.php`: owner を trait で解決し固定。
- `UserController.php`: member の owner 変更（設定済み→別値）を 403。

### テスト調整の判断
- 既存テストのうち「acting user owner と別 owner を query/body で指定」していたものは、**ドメインロジック検証が目的**のため acting user を `chapter_admin` に変更（owner 指定可）。
  - `ReferralApiTest`（クロス owner の party/workspace/patch 検証）
  - `DashboardApiTest` の owner-not-found 404 系（存在しない owner 指定 → admin なら 404 到達）
  - `OneToOneCrossChapterHierarchyTest`（クロスチャプター表示）
  - `OneToOneStatsTest::stats_without_owner_aggregates_like_index`（owner 未固定 admin で全件集計）
- 新規 `OwnerEnforcementTest` で member の 403・owner 固定・admin 例外・users/me owner 変更制限を検証。

### テスト結果
- `php artisan test`: **559 passed (2078 assertions)**。
- React 変更なしのため npm build スキップ。
