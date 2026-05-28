# PLAN: ONETOONES-P2（1 to 1 一覧・統計カード＋表示品質）

| 項目 | 内容 |
|------|------|
| Phase ID | **ONETOONES-P2** |
| 種別 | implement |
| Related SSOT | `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` §6、ONETOONES-P1 REPORT |
| 前提 | P1 完了（フィルタ・q・件数・メモ Dialog・編集・GET/PATCH） |
| ブランチ（想定） | `feature/phase-onetoones-p2-stats-display` |

## 1. 背景

- P1 で一覧の実用性は向上したが、モック比では **統計帯・サブタイトル・ステータス英語表示・Meeting 数値のみ** などが残っていた。
- 本 Phase は **一覧を開いた瞬間の理解** と **列の視認性** に絞る。完全一致 UI は目標としない。

## 2. 対象範囲

1. **統計4カード:** 予定中 / 完了（今月）/ キャンセル（今月）/ want_1on1 ON  
2. **サブタイトル:** モック趣旨どおり「予定・実施・キャンセル履歴の管理」  
3. **ステータス:** 日本語ラベル＋chip 風（API の `status` 値は変更しない）  
4. **例会列:** `#番号 — YYYY-MM-DD` 形式（バックエンドで `meeting_label` 等を付与）  

## 3. 現状整理

- 統計 API なし。index は `meeting_id` のみ。`status` は TextField 生表示。

## 4. 実装方針

### 統計（別 API・一覧フィルタ非連動）

- `GET /api/one-to-ones/stats?owner_member_id=`（必須）`&workspace_id=`（任意）
- **ルート順:** `one-to-ones/stats` を `{oneToOne}` より **上** に定義
- **定義（`OneToOneStatsService` の phpdoc と REPORT に一致）:**
  - `planned_count`: `status = planned`、owner（＋任意 workspace）で **期間なし**
  - `completed_this_month_count`: `status = completed`、かつ `COALESCE(ended_at, started_at, scheduled_at)` が **app.timezone の当月内**（非 NULL）
  - `canceled_this_month_count`: `status = canceled`、かつ `COALESCE(updated_at, ended_at, started_at, scheduled_at)` が **当月内**（キャンセル時期の近似）
  - `want_1on1_on_count`: `dragonfly_contact_flags` で `owner_member_id` 一致かつ `want_1on1 = true` の行数（**対象メンバー数**。workspace は未スコープ）
- 応答に `period`（timezone, month_start, month_end）を含め検証可能にする

### 一覧 JSON（後方互換）

- `meeting_number`, `meeting_held_on`, `meeting_label` を追加（既存キーは維持）
- `formatRecord` 共通化。`POST /api/one-to-ones` も同形で返却

### フロント

- Dashboard に近い **4 カードグリッド**（レスポンシブ）
- Owner は List の `filterValues.owner_member_id`（未設定時は 1）で stats を再取得
- サブタイトルはフィルタツールバー直下・統計の上

## 5. テスト観点

- stats: 422（owner 欠如）、集計の境界（Carbon::setTestNow）
- index: `meeting_label` が期待形式
- 全件 `php artisan test`・`npm run build`

## 6. DoD

- [x] 統計4カード表示・定義が説明可能
- [x] サブタイトル表示
- [x] ステータス日本語 chip（未知キーはフォールバック）
- [x] 例会列が `#n — date` 相当
- [x] P1 導線の回帰
- [x] PLAN / WORKLOG / REPORT・REGISTRY・進捗・INDEX・FIT_AND_GAP 更新
