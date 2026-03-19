# Phase M7-M2: members 基本情報更新候補 — WORKLOG

**Phase ID:** M7-M2

---

## なぜ members 差分を別フェーズに分けるか

- participants 差分（追加・更新・削除候補）は meeting スコープと BO 影響が中心。members はマスタであり、カテゴリーや役職履歴と結びつく。責務とリスクが異なるため API・UI も分離し、誤って apply と一体運用されないようにした。

## name / kana / category を対象にした理由

- M7-C4.5 で members 基本情報の第一歩として名前・かな・カテゴリーが優先。毎週名簿に載りやすく、Role History より安全にプレビューだけ提供できる。

## Role History を外した理由

- 要件 SSOT で役職履歴の自動更新は慎重扱い。本 Phase は「見える化」のみとし、member_roles / roles には一切触れない。

## unresolved_member の扱い

- `Member::where('name', $name)->first()` が null の行を、CSV 上の名前とカテゴリー表示ラベルとともに列挙。次フェーズで新規 member 作成や手動照合の入力に使える。

## 実装内容

- **MeetingCsvMemberDiffPreviewService:** `MeetingCsvPreviewService::preview` で rows 取得。有効行を名前で member 解決し、member_id ごとに最終行で kana / category_group / category を集約。`resolveCategoryIdReadOnly` は Import コマンドと同じ group/name の組み合わせだが `Category::where(...)->first()` のみ。`updated_member_basic`（名前・かな差分）、`category_changed`（category_master_resolved 付き）、`unresolved_member`、`summary` の 4 種カウントを返す。
- **MeetingCsvImportController::memberDiffPreview:** diff-preview と同様の import 取得・例外ハンドリング。
- **routes/api.php:** `GET .../csv-import/member-diff-preview`。
- **MeetingsList.jsx:** `fetchCsvMemberDiffPreview`、状態 3 つ、ボタン「member差分を確認」、Alert info/warning、3 テーブル＋ summary Chip。

## テスト内容

- 成功・かな差分・カテゴリー差分・同一カテゴリーで category_changed なし・未解決名前・マスタ未解決カテゴリー・404・422 の 8 本。

## 結果

- php artisan test 194 passed。npm run build 成功。DoD 達成。
