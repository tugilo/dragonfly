# Phase 303 WORKLOG

tool: cursor

## 判断メモ

- **原因の切り分け:** 要望は「フィルターをつけたい」だが、コード上は既にフィルター定義があった。ブラウザの DOM を確認し、`filters={[<OneToOnesListFilters/>]}`（配列内に `<Filter>` ラッパー）＋ カスタム `actions` に `FilterButton` 無し、という組み合わせで **一切描画されていない**ことを確認。react-admin 標準の FilterButton 方式に直すのではなく、Members 一覧で実績のある **常時表示フィルターバー**（`useListContext().setFilters`）に置き換える。1to1 は「絞って探す」操作が主なので隠しフィルターより常時表示が適切。
- **新 filter は相手（target）側の属性:** `workspace_id` filter は既に「記録 workspace」を指すため、相手のチャプターは `target_workspace_id` と命名して衝突を避ける。カテゴリも `target_group_name` / `target_category_id`。
- **`cross_chapter` の定義:** API の `is_cross_chapter`（記録 workspace と相手 workspace が両方非 NULL かつ異なる）と完全に同じ条件で WHERE を組む。`0` はその否定（記録 workspace NULL／相手 workspace NULL／同一）で、レガシー行（workspace NULL）は自チャプター側に含める。
- **index / stats を同一 WHERE に:** 既存方針（ONETOONES-P4）どおり `applyIndexFilters` に集約し、stats カードが一覧とズレないようにする。Request も 2 本とも同じルールを追加。
- **旧「相手」Select は撤去:** owner の全メンバーを Select に流し込む旧 `TargetMemberFilterSelect` は候補が多すぎて実用性が低く、検索欄（相手名・かな）で代替できる。URL に `target_member_id` が残っている場合だけ「相手ID: n」Chip を出して解除できるようにした（Connections 等からの導線互換）。
- **フィルタ値は文字列で保持:** URL（react-admin の `filter=` JSON）との往復で型が揺れないよう、Select の値は文字列 id で保持し、API 送信時にそのまま渡す。`cross_chapter` は `'1'` / `'0'` のみ送信。
- **クリアの既定値:** 「フィルターをクリア」は空ではなく `{ exclude_canceled: true }`（ONETOONES-DELETE-POLICY-P1 の既定）へ戻す。
- **検証:** Feature テスト 10 件（`OneToOneIndexTargetFiltersTest`）＋既存 index/stats テスト通過、全体 615 passed。ブラウザで 他チャプター トグル（129→32 件・予定中 10→2）、相手チャプター DIANA（3 件）、Chip・URL 同期を確認。
