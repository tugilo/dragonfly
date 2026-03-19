# PHASE_MEETINGS_UPDATE_IMPLEMENT — PLAN

**Phase ID:** MEETINGS_UPDATE_IMPLEMENT  
**種別:** implement  
**Related SSOT:** `DATA_MODEL.md` §4.6、`MEETINGS_CREATE_FIT_AND_GAP.md`、Phase `MEETINGS_CREATE_IMPLEMENT`  
**作成日:** 2026-03-19

---

## 背景

Meetings の **POST（新規作成）** は実装済み。編集は未実装のため、例会番号・開催日・名称の誤登録修正や次回予定の調整を API/UI から行えない。子データ（participants / CSV / PDF / memo / breakout）は `meeting_id` 不変のまま親の属性だけ更新する **最小の PATCH** を追加する。

## 今回のスコープ

- **`PATCH /api/meetings/{meetingId}`** — body: `number`, `held_on` 必須、`name` 任意（空・未指定は **`第{number}回定例会`**、create と同ロジック）
- **`UpdateMeetingRequest`** — `number` は `unique:meetings,number` **当該 id を ignore**
- **`MeetingController::update`** — 404 は meeting 不存在時。200 で **一覧1行と同形**（後述の `name` 含む）
- **`routes/api.php`** に PATCH 登録
- **一覧 API（GET index）** に **`name` を追加**（編集 Dialog の初期表示用。後方互換の追加フィールド）
- **`store` レスポンス** を `findMeetingForListPayload` 経由にし、index / PATCH / POST で **同一形状**
- **`MeetingsList.jsx`** — 行の Actions に「編集」、Dialog、**`patchMeeting`**、成功時 `refresh` + **stats 再取得**、開いている Drawer の meeting が同一 id なら **detail 再取得**
- **`dataProvider.js`** — `update` に `meetings` 分岐（PATCH）
- **Feature テスト**（ユーザー指定の観点 + 404）

## 非スコープ

- **DELETE**、楽観ロック、Policy / 認証新設
- **show / stats** の JSON 構造変更（**show は触らない**）
- 子テーブルの再計算・トリガ・cascade 変更
- 採番 API、CSV/PDF 連動仕様変更、Seeder/CLI、マイグレーション

## 事前調査結果（要点）

| 項目 | 結果 |
|------|------|
| `store` | `StoreMeetingRequest` + 既定 `name` + 201。レスポンスは固定 0/false（一覧と比べ `name` なし）。 |
| `index` | `id`, `number`, `held_on`, `breakout_count`, `has_memo`, `has_participant_pdf` のみ。**`name` なし** → 編集初期値のため **index に `name` 追加**（show は不変）。 |
| ルート | `{meetingId}` + `whereNumber`。PATCH を `show` と同パスに追加可。 |
| UI | `MeetingActionsField` が 📝メモ / 🗺BO。`stopPropagation` 済み。**編集ボタンを同 Stack に追加**。 |
| 認可 | 既存どおり API に追加 auth なし。 |
| `dataProvider` | categories/roles は PUT。meetings は **PATCH** で実装（仕様どおり）。 |

## 変更対象ファイル候補

| ファイル | 内容 |
|----------|------|
| `StoreMeetingRequest.php` | 非変更（ロジック重複は FormRequest 2 本で許容） |
| `UpdateMeetingRequest.php` | **新規** |
| `MeetingController.php` | `meetingToListRowPayload` / `findMeetingForListPayload`、`index`/`store` 整形、`update` |
| `routes/api.php` | `PATCH meetings/{meetingId}` |
| `MeetingControllerTest.php` | update 系 + index/store の `name` 整合 |
| `MeetingsList.jsx` | `patchMeeting`、編集 Dialog、Actions |
| `dataProvider.js` | `meetings` update |
| `DATA_MODEL.md` §4.6 | PATCH の一文 |
| Phase 3 ファイル、INDEX、REGISTRY、progress |

## API 仕様

**PATCH /api/meetings/{meetingId}**

| フィールド | ルール |
|------------|--------|
| number | required, integer, unique（自分の id を除く） |
| held_on | required, date（未来日可） |
| name | nullable, string, max:255。空文字は prepare で null → 既定名 |

**200** — index の1要素と同形（**`name` を含む**）:

`id`, `number`, `held_on`, `name`, `breakout_count`, `has_memo`, `has_participant_pdf`

**404** — `{"message":"Meeting not found."}`  
**422** — Laravel validation

**GET /api/meetings** の各要素にも **`name`** を追加（上記と同じキー集合）。

## UI 仕様

- 各行 Actions に **「編集」**（メモの左または隣）。クリックで Dialog（番号・開催日・名称・helper 文言は create と同型）。
- 送信成功: notify success、`refresh()`、`refetchStats()`、Dialog 閉じる。Drawer が同一 `id` なら `fetchMeetingDetail` で再取得。

## テスト方針

- `whereDate` で日付検証（create Phase と同様）
- 同一レコードで **number 変更なし** の更新が 422 にならないこと
- 他レコードと **number 衝突** で 422
- 未知 id → 404
- `number` / `held_on` 欠落 → 422

## update 時の業務ルール

- **id は不変**（URL の id）。`number` は変更可（外部参照は number ではなく id 前提のため、既存子データは維持）
- 既定 `name` は **更新後の number** に基づく
- show/stats のキー構造は変更しない

## DoD

- [x] 一覧から編集できる
- [x] `PATCH /api/meetings/{id}` が動作
- [x] 重複 number で 422、同一 number の維持で成功
- [x] name 空で既定名、未来日可
- [x] 一覧・統計・（該当時）Drawer 更新
- [x] `php artisan test` / `npm run build` 通過
- [x] PLAN / WORKLOG / REPORT、REGISTRY、INDEX、progress、DATA_MODEL 更新
