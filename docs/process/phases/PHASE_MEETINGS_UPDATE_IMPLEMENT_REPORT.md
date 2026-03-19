# PHASE_MEETINGS_UPDATE_IMPLEMENT — REPORT

**Phase ID:** MEETINGS_UPDATE_IMPLEMENT  
**種別:** implement  
**ステータス:** completed  
**日付:** 2026-03-19

---

## 実施内容サマリ

既存例会の **`number` / `held_on` / `name` のみ** を `PATCH /api/meetings/{id}` で更新可能にした。バリデーション・既定 `name` は create と同型。レスポンスは **GET 一覧の1行と同一キー**（`name` を含む）に揃えたため、`GET /api/meetings` と `POST /api/meetings` の行形状も拡張・統一した。UI は一覧 Actions に「編集」と Dialog を追加し、成功時に一覧・統計・（同一 id の）Drawer 詳細を更新する。

## 変更ファイル一覧

- `www/app/Http/Requests/Religo/UpdateMeetingRequest.php`（新規）
- `www/app/Http/Controllers/Religo/MeetingController.php`
- `www/routes/api.php`
- `www/tests/Feature/Religo/MeetingControllerTest.php`
- `www/resources/js/admin/pages/MeetingsList.jsx`
- `www/resources/js/admin/dataProvider.js`
- `docs/SSOT/DATA_MODEL.md`
- `docs/SSOT/MEETINGS_CREATE_FIT_AND_GAP.md`
- `docs/process/phases/PHASE_MEETINGS_UPDATE_IMPLEMENT_{PLAN,WORKLOG,REPORT}.md`
- `docs/INDEX.md`, `docs/process/PHASE_REGISTRY.md`, `docs/dragonfly_progress.md`

## API / UI でできるようになったこと

- **PATCH** `number`（他行と重複不可・自 id は除外）, `held_on`（未来可）, `name`（空で既定 `第{n}回定例会`）
- **404** 未知 id、**422** バリデーション
- **200** 応答: `id`, `number`, `held_on`, `name`, `breakout_count`, `has_memo`, `has_participant_pdf`
- **GET 一覧** も同じキー集合（`name` 追加）
- **一覧の「編集」** → Dialog → 保存で refresh + stats + 開いていれば detail 再取得

## テスト結果

- `php artisan test` — 全件パス（272 tests）
- `npm run build` — 成功

## 残課題

- **DELETE**（子データとの整合・運用方針）は未実装。
- `number` 変更時に **外部が number で参照している**箇所があれば別途整理が必要（現行子データは `meeting_id` 前提）。

## 次 Phase 候補

- Meetings **削除** API/UI と削除ポリシー（cascade / 禁止条件）の SSOT 化。
- （任意）show の `meeting` に `name` を載せ、Drawer タイトルと完全一致させる。

---

## Merge Evidence

develop 取り込み後に merge commit id・ブランチ・テスト結果を追記すること。

**test command:** `php artisan test`  
**scope check:** OK  
**ssot check:** OK
