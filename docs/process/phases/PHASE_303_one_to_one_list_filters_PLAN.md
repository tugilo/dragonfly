# Phase 303 — 1to1 一覧フィルターバー（常時表示・相手チャプター／カテゴリ／自他チャプター）

**Phase ID:** 303  
**Type:** implement  
**Status:** completed  
**Branch:** `feature/phase303-one-to-one-list-filters`  
**作成:** 2026-09-02 09:53 JST

## Purpose

1to1 一覧にフィルターを付ける。

**現状の問題:** `OneToOnesList.jsx` は `filters={[<OneToOnesListFilters/>]}`（配列の中に `<Filter>` ラッパー）で react-admin に渡しており、かつカスタム `actions` に `FilterButton` が無いため、**定義済みのフィルター（検索・相手・状態・期間・キャンセル除外）が画面に一切描画されていない**（DOM 上にも存在しないことをブラウザで確認）。

**要望（2026-09-02）:** 「一覧画面にフィルターをつけたい」。直前 Phase 302 の文脈（チャプター・名前・カテゴリーで相手を探したい）を踏まえ、Members 一覧と同じ**常時表示のフィルターバー**として実装し、相手の**チャプター**・**カテゴリ**・**自／他チャプター**でも絞れるようにする（SPEC-006 R2「一覧で自チャプター相手のみ等のフィルタ」の実装）。

## Related SSOT

- SPEC-006 [ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md](../../SSOT/ONETOONES_CROSS_CHAPTER_REQUIREMENTS.md) R2（一覧フィルタ・将来 → 本 Phase で実装）
- SPEC-021 [REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md](../../SSOT/REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md)／[Fit&Gap G12](../../SSOT/FIT_AND_GAP_REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1.md)
- ONETOONES-P4（stats は一覧と同一 filter で集計）— `OneToOneIndexService::applyIndexFilters` を index / stats 共通で使う既存方針を維持
- ONETOONES-DELETE-POLICY-P1（`exclude_canceled` 既定 ON）

## Scope

| 領域 | ファイル |
|------|----------|
| API | `www/app/Http/Requests/Religo/IndexOneToOnesRequest.php`, `OneToOneStatsRequest.php`, `www/app/Services/Religo/OneToOneIndexService.php`（`applyIndexFilters`） |
| UI | `www/resources/js/admin/pages/OneToOnesList.jsx`（フィルターバー新設・旧 `Filter` 撤去）, `www/resources/js/admin/dataProvider.js`（one-to-ones getList のパラメータ） |
| Tests | `www/tests/Feature/Religo/OneToOneIndexTargetFiltersTest.php`（新規） |
| Docs | Phase 303 3ファイル、SPEC-006 R2、Fit&Gap G12、PHASE_REGISTRY、INDEX、progress |

`package.json` / `composer.json` は変更しない。

## 設計

### API: `GET /api/one-to-ones` / `GET /api/one-to-ones/stats` 追加 filter（既存は不変）

| パラメータ | 型 | 内容 |
|-----------|----|------|
| `target_workspace_id` | integer（exists:workspaces） | 相手の所属チャプター |
| `target_group_name` | string ≤100 | 相手の大カテゴリ |
| `target_category_id` | integer（exists:categories） | 相手のカテゴリ |
| `cross_chapter` | boolean | `1`: 他チャプター相手のみ（`is_cross_chapter` と同じ定義: 記録 workspace と相手 workspace が両方非 NULL かつ異なる）／`0`: 自チャプター相手（上記以外） |

`q` は既存どおり相手名・メモ。加えて相手の `name_kana` も対象にする（小改善）。

### UI: `OneToOnesFilterBar`（常時表示・Members の `MembersFilterBar` と同系）

- 配置: 説明文の下・統計カードの上。`useListContext().setFilters` で react-admin の filterValues を更新（URL 同期・stats カードも同じ filterValues を参照済み）
- 項目: 検索（相手名・かな・メモ／debounce 300ms・IME 対応）／自・他チャプター（すべて／自／他 トグル）／相手チャプター（`GET /api/workspaces`）／大カテゴリ／カテゴリ（`categories`・大カテゴリ選択で絞込）／状態／期間 from・to／キャンセルを除く
- 適用中フィルターを Chip で表示し、個別解除・「クリア」（クリア後は既定 `exclude_canceled: true` に戻す）
- 旧 `OneToOnesListFilters`（`<Filter>`）と `filters` prop は撤去

## DoD

- [x] 一覧にフィルターバーが表示され、各フィルターで一覧・統計カード・件数が連動する（ローカルで 他チャプター → 129→32 件・予定中 10→2、相手チャプター DIANA → 3 件を確認）
- [x] `target_workspace_id` / `target_group_name` / `target_category_id` / `cross_chapter=1|0` が index と stats の両方で機能する（Feature テスト 10 件）
- [x] 既存フィルター（q / status / from / to / exclude_canceled / target_member_id）の挙動が変わらない（`OneToOneIndexTest` / `OneToOneStatsTest` 通過）
- [x] `php artisan test` 全通過（615 passed）、`npm run build` 成功
- [x] SPEC-006 R2・Fit&Gap G12・INDEX・progress・PHASE_REGISTRY 更新

## Tasks

1. Request 2 本と `applyIndexFilters` に新 filter を追加
2. Feature テスト追加
3. `OneToOnesFilterBar` 実装・dataProvider / stats クエリにパラメータ追加・旧 Filter 撤去
4. build・test・ブラウザ確認
5. Docs 更新 → develop merge → Merge Evidence

## モック比較

モック比較: [docs/SSOT/MOCK_UI_VERIFICATION.md](../../SSOT/MOCK_UI_VERIFICATION.md) に従う。1to1 一覧はモックに該当画面なし（Phase 272 / 302 と同様）。差分は SPEC-021 Fit&Gap に記録する。
