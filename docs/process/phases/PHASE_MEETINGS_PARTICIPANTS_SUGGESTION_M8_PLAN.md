# Phase M8: 参加者CSV — あいまい一致 + 候補提示 PLAN

| 項目 | 内容 |
|------|------|
| Phase ID | **M8** |
| 種別 | implement |
| 関連 SSOT | [MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md) |
| 参照 | [PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_REPORT.md](PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_REPORT.md)、[PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_REPORT.md](PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_REPORT.md) |

## 背景

- M7-M7 で unresolved のガイド付き解決（resolutions + 検索 + 新規作成）は実装済み。
- 解決は **source_value とマスタの完全一致** が前提のため、表記ゆれ（スペース・中点・全半角・かな）があると毎回手入力・検索頼みになり運用負荷が高い。
- M7-FINAL-CHECK で、プレビューと apply の名前 / resolution 優先の差異などに注意しつつ、**未解決の解消を楽にする次フェーズ**として候補提示が望ましい。

## 目的

- unresolved の **member / category / role** について、既存マスタから **スコア付き候補**を返し、UI で「これを使う」→ 既存 **resolution 登録 API** で確定できるようにする。
- **自動確定はしない**（決定は常に人）。
- 既存の **検索・新規作成** と共存し、preview / apply の **resolution 優先解決**は変更しない。

## スコープ（やる / やらない）

**やる**

1. ルールベースの正規化・スコアリング（member / category / role で共通化可能な比較ロジック）。
2. `CsvResolutionSuggestionService` と `GET .../csv-import/unresolved-suggestions`。
3. `MeetingsList.jsx` の未解決ダイアログに「候補を表示」→ 上位候補 + 「これを使う」（既存 `POST .../resolutions`）。
4. Unit / Feature テスト、`php artisan test` / `npm run build`。

**やらない（明示）**

- 自動 resolution 登録、ML、PDF フロー、候補の永続キャッシュ、形態素解析、resolution 変更履歴。

## 推薦ロジック方針

- 完全一致 → 高スコア（100）、正規化一致（90）、かな一致（member・70 前後）、前方一致・部分一致（より低いスコア）。
- 同一 ID は最高スコアのみ。結果はスコア降順、上位 **5 件**。
- `match_reason` は UI 表示・並びの補助（`exact_match`, `normalized_match`, `kana_match`, `prefix_match`, `partial_match`）。

## 正規化方針

- 比較専用。CSV / DB の元文字列は変更しない。
- trim、空白正規化、中点類・ピリオド等の除去、連続空白の縮約後にスペース除去、可能ならカタカナ→ひらがな（intl Transliterator）、英字は小文字化。

## API

- `GET /api/meetings/{meetingId}/csv-import/unresolved-suggestions`
- レスポンス: `unresolved_member` / `unresolved_category` / `unresolved_role` は **status が open の行のみ**（各要素に `source_value` と `suggestions[]`: `id`, `label`, `score`, `match_reason`）。

## 変更対象ファイル

- `www/app/Services/Religo/CsvResolutionSuggestionService.php`（新規）
- `www/app/Http/Controllers/Religo/MeetingCsvImportController.php`
- `www/routes/api.php`
- `www/resources/js/admin/pages/MeetingsList.jsx`
- `www/tests/Unit/Religo/CsvResolutionSuggestionServiceTest.php`（新規）
- `www/tests/Feature/Religo/MeetingCsvImportControllerTest.php`
- 本 PLAN / WORKLOG / REPORT

## UI 方針

- member / category / role 各テーブルで未解決行に **「候補を表示 / 隠す」**。
- 初回トグルで suggestions API を 1 回取得し共有。候補はスコア降順、ラベル・スコア・理由・「これを使う」。
- 候補が無い場合は従来どおり検索・新規作成へ誘導。

## テスト観点

- 正規化・かな・category 中点ゆれ・role・スコア順・unresolved なしは空配列
- 候補経由で resolution 登録後、member-diff-preview で unresolved が解消されること

## DoD

- [x] open unresolved にスコア付き候補を返せる
- [x] 候補から resolution 登録でき、preview 系が従来どおり再取得で反映される
- [x] 既存検索と共存
- [x] `php artisan test` / `npm run build` 成功
- [x] PLAN / WORKLOG / REPORT・REGISTRY・INDEX・進捗・SSOT メモ更新

## モック比較

- 本 Phase は CSV 運用補助のため、**モック差分の必須比較対象外**（既存 Drawer のダイアログ拡張のみ）。
