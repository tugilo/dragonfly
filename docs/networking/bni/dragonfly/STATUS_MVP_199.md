# DragonFly MVP 第199回 実装状況

## 完了範囲

- **DB スキーマ:** members, meetings, participants, breakout_rooms, participant_breakout, breakout_memos（migration 導入済み、commit: b2daa3d）
- **第199回データ投入:** meetings(1), members(63), participants(63)。Seeder: `DragonFlyMeeting199Seeder`（commit: ca500e6）
- **Breakout 投入:** breakout_rooms(4), participant_breakout(63)。Seeder: `DragonFlyMeeting199BreakoutSeeder`。暫定割当は display_no 順で A/B/C/D に均等割当。
- **MVP API 完成:** 参加者一覧・同室者一覧・メモ upsert・メモ一覧（commit: 98cbb9c）。詳細は `api/DRAGONFLY_MVP_API_GUIDE.md` を参照。

---

## 未実装

- 認証
- 権限制御（Policy 等）
- UI（API のみ）
- テスト（単体・Feature テスト）

---

## 技術的注意点

- **bootstrap/app.php で api ルートを明示読み込みしている理由:** Laravel 11 のデフォルト `withRouting` では `web` と `commands` のみが読み込まれる。DragonFly API は `routes/api.php` に定義されているため、`api: __DIR__.'/../routes/api.php'` を追加し、プレフィックス `api` でルートを有効にしている。
- **display_no に依存して participant 解決していること:** Breakout Seeder および API 利用時、参加者（participant）の特定に `members.display_no` を用い、meeting 199 の `participants` と対応付けている。名前のみでの解決は行わず、display_no を優先する設計である。
