# Phase M7-M7: 未解決ガイド付き解決フロー WORKLOG

## 判断: なぜ unresolved 解決フローが必要か

- プレビューで「未解決件数」が分かっても、運用者が**次のアクション**を取れないと CSV 取り込みが完了しない。
- 表記ゆれ・マスタ未登録は毎週起きうるため、**ガイド付きの手動解決**が最小コストで効く。

## 判断: なぜ CSV 自体を変更しないか

- 原本 CSV は監査・再現性のため保持し、**アプリ側のマッピング**で解釈を上書きする方が安全。
- 複数回プレビューしても同じファイルから一貫して読める。

## 判断: なぜ resolution を import 単位で持つか

- 同じ CSV 文字列でも、**アップロードごと**の文脈で別メンバーに紐づける必要がある（差し替え CSV・取り違え防止）。
- `meeting_csv_import_id` + `resolution_type` + `source_value` でユニーク。

## mapped / created

- **mapped**: 既存マスタ ID を選択しただけ。`action_type` で区別し、後から監査しやすくした。
- **created**: 当 API が Member/Category/Role を作成し、同じく resolution に記録。プレビュー・apply は **resolved_id** さえ正しければ同じ経路で解決。

## 実装内容（要約）

- マイグレーション `meeting_csv_import_resolutions`。
- `MeetingCsvImportResolution::mapsForImport()` で preview/apply が参照するマップを構築。
- `MeetingCsvUnresolvedSummaryService` で CSV を読み、member/category/role ごとに open/resolved 一覧を生成。
- `MeetingCsvImportController`: `GET .../unresolved`, `POST .../resolutions`, `POST .../resolutions/create-{member,category,role}`。
- 検索: `GET /api/categories/search`, `GET /api/roles/search`（members は既存）。
- `ApplyMeetingCsvRoleDiffService`: `Role::where(name)` が無いとき resolution の role を参照（preview と整合）。
- UI: `MeetingsList.jsx` にダイアログ・検索・作成フォーム・再取得ボタン。
- `MeetingCsvImport` の重複 `use HasMany` を削除（PHP 致命エラー防止）。

## テスト

- `MeetingCsvImportControllerTest` に M7-M7 用ケースを追加（404、一覧、member 解決→member-diff、role 解決→role-diff、create 系、バリデーション 422）。
- 全件 `php artisan test`: 236 passed。
- `npm run build`: 成功。

## 結果

- DoD を満たす実装完了。develop への merge / Merge Evidence は人間の取り込みフローに委ねる。
