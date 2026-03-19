# Phase M8: 参加者CSV — あいまい一致 + 候補提示 WORKLOG

## 方針判断

### 自動確定しない理由

- 表記ゆれの正解は文脈依存で、誤マッピングは participants / members / role へ伝播する。**スコアは並び順のヒント**に留め、確定は必ず人の明示操作（「これを使う」→ 既存 resolutions API）とした。

### スコア付き候補にする理由

- 複数ヒット時に運用者が比較しやすくするため。閾値での機械カットはせず、上位 N 件を提示し、人が選ぶ。

### 正規化の範囲

- 軽量な文字列正規化に限定（空白・中点・かな揺れ・大文字小文字）。**異体字・旧字体の統一**や形態素解析はスコープ外とし、将来フェーズに委ねる。

### member / category / role の共通化

- `scoreNamePair` + `normalizeForCompare` + `sortAndLimit` で比較・スコア・重複排除を共通化。member のみ `name_kana` と CSV かなの突合を追加。

## 実装内容

- **CsvResolutionSuggestionService**: `suggestMembers` / `suggestCategories` / `suggestRoles`、`TOP_LIMIT = 5`、`match_reason` 定数。
- **MeetingCsvImportController::unresolvedSuggestions**: `MeetingCsvUnresolvedSummaryService::summarize` の open 行のみに suggestions を付与。
- **routes/api.php**: `GET meetings/{id}/csv-import/unresolved-suggestions`。
- **MeetingsList.jsx**: `fetchCsvUnresolvedSuggestions`、`csvSugFor` / `toggleCsvSuggestions` / `applySuggestionResolution`、member / category / role 各行に候補 UI。解決後は `refreshCsvAfterResolution` で従来どおり再取得。

## テスト

- **Unit** `CsvResolutionSuggestionServiceTest`: 正規化、かな、category 中点、role 全角スペース、スコア順、空入力。
- **Feature** `MeetingCsvImportControllerTest`: suggestions 404、全解決時空配列、open 行のスコア付き返却、resolution 後 member-diff-preview の unresolved 0。

## 結果

- `php artisan test`: 247 passed（実施時点）。
- `npm run build`: 成功（実施時点）。
