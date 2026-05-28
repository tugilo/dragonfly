# Phase M7-M2: members 基本情報更新候補 — PLAN

**Phase ID:** M7-M2（ユーザー表記: M2 members 基本情報更新候補）  
**種別:** implement  
**Related SSOT:** MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md, MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md, MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md, PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_REPORT.md, PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_REPORT.md

---

## 背景

- D3 までで participants は差分更新・削除候補・BO 保護付き削除まで実装済み。
- 毎週名簿 CSV には名前・かな・カテゴリー等が含まれ、members マスタの更新候補になりうる。
- カテゴリーは変わりうるため無条件上書きは危険。M7-C4.5 で members はまず「更新候補表示」から始める方針。

## 目的

- CSV から見た member 基本情報の差分を可視化する。
- participants 反映とは別に、members マスタ更新候補を確認できるようにする。
- まずは候補表示に留め、自動更新は行わない（次フェーズで確定反映を想定）。

## スコープ

**やること**

1. CSV と既存 members の基本情報差分を取得する API を追加する。
2. 差分候補として名前 / よみがな / カテゴリーを扱う。
3. Drawer に members 更新候補プレビューを表示する。
4. カテゴリー変更候補に warning 表示を出す。
5. 反映前に members 差分を確認できる状態にする。

**やらないこと**

- Role History 更新、役職更新、introducer / attendant 更新。
- members 自動一括更新。
- categories の自動作成。
- PDF フローの members 差分。
- 監査ログ拡張。

## 変更対象ファイル

- www/app/Services/Religo/MeetingCsvMemberDiffPreviewService.php（新規）
- www/app/Http/Controllers/Religo/MeetingCsvImportController.php（memberDiffPreview）
- www/routes/api.php（GET member-diff-preview）
- www/resources/js/admin/pages/MeetingsList.jsx（member差分を確認・プレビュー UI）
- www/tests/Feature/Religo/MeetingCsvImportControllerTest.php
- docs/process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_*.md

## members 差分判定方針

- 有効 CSV 行（種別がメンバー等のマップ対象、名前非空）について `Member::where('name', $name)` で解決。No は使わない。
- 解決できた行のみ集約（同一名前は最終行で上書き）。
- 既存 Member の `name` / `name_kana` / `category_id` と CSV の名前・よみがな・大カテゴリー/カテゴリーを比較。
- カテゴリーは `categories` テーブルで **既存行のみ** 照合（`firstOrCreate` 禁止）。解決できず CSV にカテゴリー意図がある場合は `category_master_resolved: false` で返す。
- 解決できない名前は `unresolved_member` に列挙。

## カテゴリー warning 方針

- UI でカテゴリー変更セクションに Alert（warning）を表示。「毎週変わりうる」「マスタ未登録は categories に存在しない」と明示。
- API の `category_changed` 各要素に `category_master_resolved` を含める。

## UI 表示方針

- 「member差分を確認」ボタン（プレビュー row_count > 0 時）。
- summary: 基本情報更新 / カテゴリー変更 / 未解決 / 変更なし の件数 Chip。
- セクション: 基本情報更新候補・カテゴリー変更候補・未解決 member。
- 「この情報はまだ members に反映されません」「次フェーズで確定反映予定」の補助文言（Alert info）。

## テスト観点

- member-diff-preview 成功で構造が揃うこと。
- name_kana 差分が `updated_member_basic` に入ること。
- category 差分が `category_changed` に入ること（マスタ解決済み / 未解決）。
- 名前未解決が `unresolved_member` に入ること。
- 変更なし件数が summary に反映されること。
- CSV 未登録 404、データ行 0 件 422。

## DoD

- members 差分候補を見られる。
- name_kana / category 差分が分かる。
- category 変更に warning が出る。
- Role History に触れていない。
- participants / PDF フローを壊さない。
- php artisan test / npm run build が通る。
