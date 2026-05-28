# WORKLOG: DASHBOARD-P7-2

## KPI subtext（F1）

- **未接触:** 固定「要フォロー」だけでは説明が弱いため、**自分以外メンバー数に対する件数・割合**を `sprintf` で一行にまとめた（`30日超未接触 a / b 人（約 p%）・要フォロー`）。前月の stale 件数は集計コストが高いため見送り。
- **今月 1to1 / 紹介メモ / 例会メモ:** それぞれ **前月同日暦の月初〜月末**で件数を取り、`buildMoMCountSubtext` で「先月 n 件・増/減 d」または「先月も n 件（変化なし）」に統一。
- **例会メモの追加行:** 前月比に加え、`meetings.number` 最大の行を「直近登録 例会#N」として付与（モックの「#247 含む」に相当する**説明用**文言）。

## 次回例会「あとN日」（F2）

- **次回の定義:** `held_on >= 今日`（日付文字列）の最小 `held_on`。**無い場合**は直近過去の 1 件にフォールバック（従来どおり）し、meta は **「次回例会は未登録（直近 #N・終了済み）」**。
- **日数:** `now()->startOfDay()` と `Carbon::parse(held_on)->startOfDay()` の `diffInDays(..., false)`。0 → **本日開催**、正 → **次回例会まであとN日**。
- **タイムゾーン:** アプリの `now()` に依存（サーバ timezone = アプリ設定）。

## Tasks メモ導線（F3）

- **採用:** **案A — deep link**。2 件目 stale の `action.href` を `/members/{target_member_id}/show`、`disabled` を `false` に変更。React Admin の `Link` と同じパス形式（P7-1 の `/one-to-ones/create` と整合）。
- **見送り:** メモ専用モーダル（API・state が増えるため）。

## Activity 拡張（F4）

- **`flag_changed`:** `dragonfly_contact_flags` を `owner_member_id` で絞り、`updated_at` 降順で取得し memos / 1to1 とマージ。`meta` は `関心あり`・`1to1希望`・（`extra_status` 非空なら）`メモあり`。
- **`memo_introduction`:** `contact_memos.memo_type === introduction` のみ kind を分離。タイトルは「〜 に紹介メモ」。低コストでモックの「紹介系」と整合。
- **見送り:** `bo_assigned`（永続イベントの SSOT が無い）、Member プロフィール更新全般（ノイズ）。

## P7-1 からの変更 / 非変更

- **変えた:** `DashboardService` の stats/tasks/activity ペイロード、フロントの `ACTIVITY_ICONS`・Activity キャプション・TASKS_FALLBACK のメモ href。
- **変えていない:** KPI 4 枚のレイアウト、Tasks の色分け、Leads 右列、panel 分割全体。

## merge

- **競合:** なし（記載時点）。
