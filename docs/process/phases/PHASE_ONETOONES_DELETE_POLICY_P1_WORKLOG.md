# WORKLOG: ONETOONES-DELETE-POLICY-P1

## 判断と実装

### なぜ削除しないか

- 1 to 1 は **関係性の履歴**であり、予定の無効化も **記録として価値がある**。
- 物理削除は `contact_memos` の紐付け喪失・Dashboard / Members 集計・Activity の解釈を変える。
- **製品方針として DELETE を採用しない**と明文化する方が、運用・説明・保守に有利。

### `canceled` の定義

- **削除の代替語ではなく**、**「予定が無効になった事実」を残す正規状態**。
- 誤登録・重複の片方も当面 **`canceled` + notes** で運用。将来の重複警告は別 Phase。

### UI で調整した箇所

- **一覧:** `filterDefaultValues` に `exclude_canceled: true`。フィルタに **「キャンセルを一覧から除く」**（`BooleanInput`・alwaysOn）。サブタイトルで **削除しない方針**と **`canceled` の意味**を記載。
- **編集:** `状態` Select に **helperText**（`canceled` の意味・削除しない方針）。
- **dataProvider / `buildOneToOneStatsQuery`:** `exclude_canceled` をクエリに付与し、**一覧と stats のフィルタ文脈を一致**（ONETOONES-P4 の精神を維持）。

### 調整しなかった箇所

- **DELETE をわざわざ UI に「ありません」と書く専用バナー**は置かない（サブタイトル・編集 helper で足りる）。
- **クイック作成 Dialog** の文言は本 Phaseでは未変更（スコープ最小）。

### 重複・誤登録

- SSOT に **当面 `canceled` 運用・将来重複警告は別 Phase** と記載。

### merge

- （Merge Evidence 追記後に記載）
