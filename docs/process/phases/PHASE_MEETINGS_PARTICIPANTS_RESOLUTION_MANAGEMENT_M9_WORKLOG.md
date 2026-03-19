# WORKLOG: M9 — resolution 管理UIの強化 + 同名member運用補強

## 判断: なぜ resolution の見直し UI が必要か

運用では「誤って別 member にマップした」「表記ゆれ解決後に古い resolution が残る」ケースがあり、DB のマスタを消さずに **import 単位のマッピングだけ**を外し・付け替えできる必要がある。一覧が無いと現状把握とロールバックが困難。

## 判断: なぜマスタ削除と分けるか

`meeting_csv_import_resolutions` は **CSV 文字列 → マスタ ID** のオーバーレイであり、Member 等の削除は別ライフサイクル。混同すると誤削除や権限事故のリスクが増える。

## 判断: 同名警告をどこで出すか

`MeetingCsvMemberResolver::resolveExistingWithMeta` に集約し、**resolution 優先の後**に名前一致件数を数える。警告は **名前一致かつ 2 件以上**かつ **resolution 未使用**のときのみ。preview / unresolved / 各 diff / suggestions（member・open 行は該当時のみ）へ伝播。

## 判断: 再取得対象

`refreshCsvAfterResolution` を拡張し、`csvImport.has_csv` かつ（プレビュー/各 diff が既にロード済み **または** 未解決ダイアログ **または** 解決済み管理ダイアログが開いている）ときに該当 API を再フェッチ。未ロードのパネルまで毎回叩かない（不要な負荷・意図しない UI 展開を避ける）が、**開いているダイアログ**は常に最新化。

## 実装内容（要約）

- API: `GET/PUT/DELETE .../csv-import/resolutions`（詳細は REPORT）。
- Resolver: `resolveExistingWithMeta`、既存メソッドは委譲。
- 各サービス・preview エンドポイントに duplicate 系フィールド追加。
- MeetingsList: 「解決済みを確認」、テーブル操作、Alert、再マップで PUT。

## テスト・結果

- Feature: `MeetingCsvImportControllerTest` に M9 用 7 ケース（一覧・404・旧 import での DELETE 404・解除後の名前解決復帰と duplicate・PUT 再マップと member-diff・PUT 422・preview duplicate）。
- Unit: `MeetingCsvMemberResolverTest` に duplicate meta 2 ケース。
- `php artisan test`: **259 passed**。`npm run build`: **成功**。
