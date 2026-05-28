# PHASE_MEETINGS_CREATE_IMPLEMENT — PLAN

**Phase ID:** MEETINGS_CREATE_IMPLEMENT  
**種別:** implement  
**Related SSOT:** `DATA_MODEL.md` §4.6、`MEETINGS_CREATE_FIT_AND_GAP.md`、調査 Phase `MEETINGS_CREATE_FIT_AND_GAP_CHECK`  
**作成日:** 2026-03-19

---

## 背景

Meetings は一覧・Drawer・メモ・CSV/PDF・同期まで実装済みだが、`meetings` 行を管理画面から追加する API/UI がなかった。調査 Phase の推奨どおり、**案A の第1段**として `POST /api/meetings` と一覧の最小作成 UI を追加する。

## 今回のスコープ

- `POST /api/meetings`（`number`, `held_on` 必須、`name` 任意）
- `name` 未指定・空文字時は `第{number}回定例会`（`ImportParticipantsCsvCommand::resolveMeeting` と同型）
- `number` は手入力、`unique:meetings,number` 違反時は **422**
- `held_on` は **未来日を許容**（`date` ルールのみ。`after_or_equal:today` は付けない）
- レスポンスは **一覧1行と同形**（`id`, `number`, `held_on`, `breakout_count`, `has_memo`, `has_participant_pdf`）＋ **201**
- `MeetingsList` の TopToolbar に「＋ 新規例会」＋ Dialog（最小フォーム）
- 作成成功後 `useRefresh()` と統計カード用の stats 再取得
- `StoreMeetingRequest`（`authorize: true` — 既存 Religo FormRequest に合わせる）
- `dataProvider.create` に `meetings` を追加（react-admin 流儀・将来 Create 画面用）
- Feature テスト（成功・デフォルト name・重複 422・バリデーション）

## 非スコープ（明示的にやらない）

- edit / update / delete
- `meetings` マイグレーション変更
- number 自動採番 API
- CSV アップロード時の meeting 自動作成
- Seeder / CLI の変更
- Policy / 認可の新設（既存 API と同様、**認証ミドルウェアなし**のまま踏襲）

## 事前調査結果（実装前確認）

| 項目 | 結果 |
|------|------|
| `MeetingController` | `index` / `stats` / `show` のみ。一覧行は `breakout_count`, `has_memo`, `has_participant_pdf` を付与。 |
| `routes/api.php` | `GET /meetings`, `GET /meetings/stats`, `GET /meetings/{id}` …。**POST meetings なし**。`POST` は `GET /meetings/{id}` より前に定義する必要はない（`{id}` は数値制約）。 |
| react-admin | `Resource name="meetings"` は `list` のみ。 |
| `MeetingsList.jsx` | `MeetingsListActions` が `TopToolbar` + Connections のみ。`memo` / `pdf` と同様 `fetch` + `Dialog` パターンで拡張。 |
| 認可 | `bootstrap/app.php` で API に追加の auth なし。`StoreOneToOneRequest::authorize` は `true`。**踏襲**。 |
| `dataProvider.js` | `one-to-ones` / `categories` / `roles` に `create` あり。`meetings` は未実装。 |
| DB | `number` UNIQUE unsignedInteger, `held_on` date, `name` varchar 255 nullable。 |
| CLI 整合 | `第{$meetingNumber}回定例会`（`ImportParticipantsCsvCommand`）。 |

## 変更対象ファイル候補

| ファイル | 変更内容 |
|----------|----------|
| `www/app/Http/Requests/Religo/StoreMeetingRequest.php` | **新規** |
| `www/app/Http/Controllers/Religo/MeetingController.php` | `store` 追加、一覧行と同形レスポンス組み立て |
| `www/routes/api.php` | `Route::post('/meetings', ...)` |
| `www/tests/Feature/Religo/MeetingControllerTest.php` | store 系テスト追加 |
| `www/resources/js/admin/pages/MeetingsList.jsx` | `postMeeting`、`MeetingsListTopActions`、作成 Dialog |
| `www/resources/js/admin/dataProvider.js` | `meetings` の `create` |
| `docs/SSOT/DATA_MODEL.md` §4.6 | 管理画面からの新規作成 API の一文追記 |
| `docs/process/phases/PHASE_MEETINGS_CREATE_IMPLEMENT_*.md` | PLAN / WORKLOG / REPORT |
| `docs/INDEX.md`, `PHASE_REGISTRY.md`, `dragonfly_progress.md` | 更新 |

## API 仕様

**POST /api/meetings**

Request JSON:

| フィールド | ルール |
|------------|--------|
| number | required, integer, unique:meetings,number |
| held_on | required, date（形式 Y-m-d 等 Laravel `date` が受理する値） |
| name | optional, string, max:255。空文字はサーバで null 扱いしデフォルト名を適用 |

Response **201**:

```json
{
  "id": 1,
  "number": 250,
  "held_on": "2026-12-01",
  "breakout_count": 0,
  "has_memo": false,
  "has_participant_pdf": false
}
```

422: Laravel 標準の validation error JSON。

## UI 仕様

- TopToolbar: 「＋ 新規例会」ボタン（既存 Connections ボタンの左または隣）
- Dialog: number（数値）、held_on（`type="date"`）、name（任意、placeholder / helper で「未入力時は 第N回定例会」）
- 成功: `notify` success、`refresh()`、stats 再取得、Dialog 閉じる
- 失敗: `notify` error（422 時は `errors.number` 等を可能なら要約）

## テスト方針

- `RefreshDatabase`
- POST 成功 → DB に `name` がデフォルト
- POST で `name` 明示 → そのまま保存
- 同一 `number` で 2 回目 → 422
- `number` / `held_on` 欠落 → 422

## DoD

- [x] 管理画面から新規例会を作成できる
- [x] `POST /api/meetings` が動作し、201 で一覧行形式が返る
- [x] `number` 重複で 422
- [x] `name` 未指定・空で `第{n}回定例会`
- [x] `held_on` 未来日で保存可能
- [x] 一覧・統計が作成後に更新される
- [x] `php artisan test` 通過
- [x] `npm run build` 通過
- [x] PLAN / WORKLOG / REPORT・REGISTRY・INDEX・progress・DATA_MODEL 必要箇所更新
