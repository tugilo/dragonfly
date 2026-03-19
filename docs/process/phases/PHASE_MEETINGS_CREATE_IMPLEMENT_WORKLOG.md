# PHASE_MEETINGS_CREATE_IMPLEMENT — WORKLOG

**Phase ID:** MEETINGS_CREATE_IMPLEMENT  
**日付:** 2026-03-19

---

## 実際に確認した既存コード

- `MeetingController`: `index` が返す一覧行の形（`id`, `number`, `held_on`, `breakout_count`, `has_memo`, `has_participant_pdf`）。
- `routes/api.php`: meetings は GET のみだった。`meetings/stats` は `{meetingId}` より前に定義済み。
- `StoreOneToOneRequest`: `authorize: true`、バリデーション配列形式。
- `bootstrap/app.php`: API に追加の auth ミドルウェアなし。
- `ImportParticipantsCsvCommand::resolveMeeting`: 既定名 `第{$meetingNumber}回定例会`。
- `MeetingsList.jsx`: `memo` / `pdf` と同様の `fetch` + MUI `Dialog` + `useRefresh` / `useNotify`。
- `dataProvider.js`: `one-to-ones` の `create` が `fetch` + エラー JSON を参照。

## 変更したファイル

| ファイル | 内容 |
|----------|------|
| `app/Http/Requests/Religo/StoreMeetingRequest.php` | 新規。`number` unique、`held_on` date、`name` nullable max 255。空 `name` → `prepareForValidation` で null。 |
| `app/Http/Controllers/Religo/MeetingController.php` | `store`。既定名適用後 `Meeting::create`。201 + 一覧行同形（新規は BO/PDF/メモ 0/false）。 |
| `routes/api.php` | `POST /meetings`。 |
| `tests/Feature/Religo/MeetingControllerTest.php` | store 成功・明示 name・空 name・未来日・重複 422・必須欠落。DB 検証は `whereDate` で日付比較。 |
| `resources/js/admin/pages/MeetingsList.jsx` | `postMeeting`、`MeetingsListTopActions`（Dialog）、`refetchStats` + `useEffect`。 |
| `resources/js/admin/dataProvider.js` | `meetings` の `create`。 |
| `docs/SSOT/DATA_MODEL.md` §4.6 | `POST /api/meetings` の一文。 |
| `docs/process/phases/PHASE_MEETINGS_CREATE_IMPLEMENT_*.md` | PLAN / 本 WORKLOG / REPORT |
| `docs/INDEX.md`, `PHASE_REGISTRY.md`, `dragonfly_progress.md` | 更新 |

## 変更理由

- **FormRequest 分離:** 既存 Religo の `StoreOneToOneRequest` と同パターンでテストしやすく、ルールを一箇所に集約。
- **レスポンスを一覧行と同形:** Drawer や一覧の前提フィールドを変えず、フロントは `refresh()` のみで足りる。
- **TopToolbar にボタン:** 調査・PLAN で合意した「案A・一覧から」の導線。モックに無いが Fit&Gap で許容。
- **stats 再取得:** 統計カードの総例会数が作成直後に更新されるよう `onMeetingCreated` で `refetchStats`。
- **dataProvider.create:** react-admin の慣習に合わせ、将来 `Create` リソースを足しても同じ API に届くようにした。

## 迷った点と採用判断

- **number の下限:** SSOT にダミー `0` の記述があるため `min:1` は付けず、`integer` + `unique` のみ。
- **held_on の「今日より前」制限:** 要件どおり付けない（過去の例会登録もあり得る）。
- **認可:** Policy を新設するとスコープ拡大になるため、既存 meetings GET と同じく **ミドルウェアなし** を踏襲（非変更理由）。

## 非変更にした箇所と理由

- **edit / delete / PATCH:** スコープ外。子テーブルとの整合は別 Phase。
- **Seeder / CLI / マイグレーション:** スコープ外。
- **`GET /meetings` のクエリ:** 変更なし。新規行は通常の一覧クエリで取得される。
- **react-admin Resource に Create を追加しない:** 一覧 Dialog で完結させ、ルーティング変更を避けた。

## テスト実施結果

- `php artisan test --filter=MeetingControllerTest`: 全通過（store 追加後、日付は `assertDatabaseHas` の厳密一致でコケたため `whereDate` に変更）。
- `php artisan test`（全件）: 通過。
- `npm run build`: 通過。
