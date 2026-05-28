# Phase M7-M6: 監査ログ / 基準日指定 — WORKLOG

## なぜ監査ログが必要か

- 週次運用で participants / members / roles を別操作で更新するため、「いつどの操作で何件動いたか」を後から説明できるようにする。import テーブルの集計だけでは種別が分かれない。

## なぜ effective_date を追加するか

- 実際の役職交代は例会日基準のことが多く、**実行日（今日）で term を切ると履歴が運用とずれる**。明示指定と例会日デフォルトで整合を取る。

## today / meeting.held_on / manual の優先順位判断

- **明示指定を最優先**（過去日・未来日の扱いは運用側判断、バリデーションは `date` のみ）。
- 未指定は **例会日** を既定にし、毎週同じ CSV を開いてそのまま反映しても「その例会の名簿」に沿う。
- **held_on が null** のデータが将来入った場合に備え **today** を最終フォールバック（現状 DB は NOT NULL）。

## 各 apply_type のログ内容

- **participants:** added/updated/deleted/protected、applied_count、meta に missing_count・delete_missing。
- **members:** applied_count＝基本+カテゴリ、skipped_count＝未解決名+未解決カテゴリの合算、meta に内訳。
- **roles:** applied_on＝effective_date、meta に changed/csv_only/closed/skipped と effective_date_source。

## 実装内容

- マイグレーション `meeting_csv_apply_logs`、Writer 静的メソッド、Controller 成功後のみ呼び出し。
- Meeting show と `GET apply-logs` で同じ `toApiArray()` / `summaryLabel()` を利用。

## テスト内容

- role apply の日付期待を **各 Meeting の held_on** に同期（デフォルト解決の変更に追随）。
- 指定日付オーバーライド、ログ作成・422 非作成、apply-logs API。

## 結果

- `php artisan test` 227 passed、`npm run build` 成功。
