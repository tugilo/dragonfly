# Phase 321 WORKLOG — members に退会日（left_at）カラムを追加する

tool: cursor-agent  
**開始:** 2026-10-27 16:46 JST  
**Branch:** `feature/phase321-members-left-at`

---

## Task 1–3: migration / Model / API

- 状態: 完了
- 判断:
  - カラム名は `left_at`（date）。`status` 列（active/left）ではなく日付にした。退会「したか」だけでなく「いつ」が必要で、将来日付（予約退会）も表せるため。`type` は入会種別の履歴として残し、退会で書き換えない。
  - 在籍判定は `left_at IS NULL OR left_at > today`。退会当日は退会扱い。
  - API index の既定挙動は **変えない**（全件）。`exclude_left=1` を opt-in で追加。Dashboard・1to1 リード・Connections 等の既存クエリに影響を出さないため。UI 側で「退会者を隠す」を入れるのは別 Phase。
  - update は既存の `ncast_profile_url` / `email` と同じ「キーが来たときだけ検証・反映」方式。`date_format:Y-m-d` で `2026/10/07` のような表記を 422 にする。
  - `import-participants-csv` は `left_at` を自動設定しない。名簿 PDF から消える理由は退会以外（欠席・リージョン枠の変動・CSV 作成漏れ）もあるため、人の確認を残す。
- 実施: migration（index 付き）、`Member::$fillable` / `casts(date:Y-m-d)` / `isLeft()` / `scopeActiveMembers()`、Controller index select＋`exclude_left`、update `left_at`、Request ルール。

## Task 4: テスト

- 状態: 完了
- 判断: 既存 `DragonFlyMemberNcastProfileUrlTest` と同形式（RefreshDatabase・chapter_admin）。将来日付が在籍扱いになることと、`isLeft($asOf)` の時点指定を明示的にテスト。
- 実施: `tests/Feature/Api/DragonFlyMemberLeftAtTest.php` 5 テスト / 22 assertions green。全体 **625 passed（2304 assertions）**。
- Pint: `DragonFlyMemberController.php` に `concat_space` 等の指摘があるが、`git stash` で確認したところ develop 時点から存在する既存指摘。本 Phase では触らない。

## Task 5: DATA_MODEL

- 状態: 完了
- 実施: §4.2 主要カラムに `left_at`、インデックスに `left_at`、「退会の表現（Phase 321）」段落を追加（type は変えない／役職は手動で閉じる／CSV 取込は自動設定しない）。

## Task 6: ローカル DB データ

- 状態: 完了
- 実施: `members.id=12` 西浦雅 `left_at=2026-10-07`（ユーザー確認 2026-10-27 16:42 JST）。`isLeft()=true`。type=member 97 行中、在籍 96。
- 保留: 八田奈緒美 `members.id=165` は退会日未確定のため `left_at` 未設定（第222回 2026-09-15 名簿で除外済み。日付が分かり次第設定）。

## Task 7: docs 同期

- 状態: 完了
- 実施: INDEX（Phase 321 3 ファイル）・進捗・PHASE_REGISTRY（321 in_progress）・REPORT。

## Task 8: merge / push

- 状態: 未実施（ユーザー指示待ち）。commit も未実施。
