# 接触履歴・日数・1to1リード判定の精査（要件整理）

**目的:** Dashboard / Members における「未接触日数」「次の 1to1 候補」の表示が、利用者の感覚（例: 3/17 例会から参加）とずれる事象について、**現行実装の定義**を明示し、**ギャップと対応の方向性**を整理する。  
**ステータス:** 調査・要件整理（実装変更は別 Phase で扱う）。  
**関連 SSOT:** [DATA_MODEL.md](DATA_MODEL.md) §4.12.1、`MemberSummaryQuery`、`MemberOneToOneLeadService`、`DashboardService`、[DASHBOARD_DATA_SSOT.md](DASHBOARD_DATA_SSOT.md)。

---

## 1. 観測された現象（ユーザー報告）

| # | 現象 | ユーザー期待のイメージ |
|---|------|------------------------|
| A | Dashboard の優先アクション等で **「999日間未接触」** のような表示になる | 3/17 の例会から参加しているので、**その日付を起点にした日数**、または「未接触ではない」に近い表示 |
| B | 「次の 1to1 候補」で **1 to 1 を記録したのに「実施済記録なし」** のように見える | 記録した内容が **実施済み**として反映されている |

---

## 2. 本資料のゴール

1. **仕様上の正**（コードと既存 SSOT）を一文ずつ対応づける。
2. 現象 A・B が **バグなのか、定義どおりなのか** を切り分ける材料を揃える。
3. **対応方法の候補**（データ整備 / 表示改善 / 仕様変更）を、Phase 化しやすい形で列挙する。

---

## 3. 現行ロジックの整理

### 3.1 「最終接触日時」`last_contact_at`（Members の summary-lite・Dashboard stale の土台）

**実装:** `App\Queries\Religo\MemberSummaryQuery::batchLastContactAt`（Dashboard stale は `getSummaryLiteBatch(..., null)`）。

**各 target メンバーについて、次の候補日時の最大値**を `last_contact_at` とする（合成・単一 SQL ではない）。

| ソース | 条件 | 備考 |
|--------|------|------|
| **同席（BO）** | `participant_breakout` 経由で **owner と target が同一 breakout_room** におり、例会 `meetings.held_on` が取れる | **定例会に「出席」しただけでは入らない**。同室（BO）として DB に載っている必要がある。 |
| **接触メモ** | `contact_memos`・owner→target・`created_at` | workspace 指定時は `(workspace_id = X OR NULL)`（Members 一覧）。Dashboard は `null` で workspace 列フィルタなし。 |
| **1 to 1** | `one_to_ones`・`status != canceled`・`started_at` または `scheduled_at` | **予定（scheduled）も日付候補に含まれる**。 |

**重要:** `last_contact_at` が **1 件も構成されない**場合は **null** になる。

### 3.2 Dashboard Tasks「○日間未接触」と **999**

**実装:** `DashboardService::getTasks` の `stale_follow` 行。

- `last_contact_at` がある場合: `Carbon::parse(last_contact_at)->diffInDays(now())` で日数表示。
- **`last_contact_at` が null の場合:** 表示用日数に **999 を固定代入**している（「未接触の長さ」を数値化できないためのプレースホルダ）。

```165:170:www/app/Services/Religo/DashboardService.php
                if (isset($batch[$tid]['last_contact_at']) && $batch[$tid]['last_contact_at']) {
                    $days = (int) Carbon::parse($batch[$tid]['last_contact_at'])->diffInDays(now());
                } else {
                    $days = 999;
                }
```

**結論（現象 A）:** 「999」は **「実際に 999 日空いている」ではなく、「接触の起点日時がシステム上まったく無い」** ことを示す実装上の値に近い。

### 3.3 「次の 1to1 候補」`one_to_one_status`（実施ベース）

**実装:** `App\Services\Religo\MemberOneToOneLeadService::indexForOwner`。  
**API:** `GET /api/dragonfly/members/one-to-one-status?owner_member_id=`

| 値 | 意味（DATA_MODEL §4.12.1 と一致） |
|----|-----------------------------------|
| **none** | 当該 owner→target に **`status = completed` の 1 to 1 が 0 件** |
| **needs_action** | completed が 1 件以上かつ、最終 completed の代表日時が **閾値より前**（既定 30 日・`religo.one_to_one_lead_needs_action_days`） |
| **ok** | 最終 completed が閾値以内 |

**代表日時:** 各行の completed について `MAX(COALESCE(ended_at, started_at, scheduled_at))`。

**`planned` / `canceled` は「実施」に含めない**（コードコメント・SSOT 明示どおり）。

**UI 文言:** `none` のとき補助表示で **「実施済記録なし」**（`religoOneToOneLeadLabels.js`）— これは **「completed レコードが無い」** の意味であり、「メモや予定が無い」とは限らない。

**結論（現象 B）:** 1 to 1 を **予定（planned）として保存しただけ**では、`one_to_one_status` は **none のまま**（実施済記録なし表示）になるのは **現行定義どおり**。

---

## 4. 現象とロジックの突合

### 4.1 「3/17 例会から参加」なのに 999 日・未接触に見える

**あり得る要因（複合しうる）:**

1. **同席データが無い**  
   3/17 の例会で owner と相手が **同じ BO ルームとして `participant_breakout` に入っていない**（CSV 未取込・別 meeting_id・BO 未登録など）→ `last_contact_at` の BO 由来が付かない。

2. **メモ・1to1 の日付が無い**  
   その相手に対する `contact_memos` が無い、かつ **planned でも scheduled_at が null** など、候補日時が 1 つも立たない。

3. **peer 集合が「全会員」**  
   Dashboard stale は **owner 以外の全 `members`** が対象（DASHBOARD_DATA_SSOT §0）。**まだ一度も関係データが無い相手**は `last_contact_at` null になりやすい。

→ **「例会に出た」こと自体**は、Religo の **現在の last_contact 定義では自動的には入らない**（会議出席は `participants` だが、`batchLastContactAt` は **BO 同席・メモ・1to1** のみ）。

### 4.2 記録したが「実施済記録なし」

**あり得る要因:**

1. **`status` が `completed` になっていない**（予定のまま、または UI 上で完了にしていない）。
2. **別 owner 文脈**で保存している（`owner_member_id` が Dashboard のオーナーと一致していない）。
3. **別 target** に紐づいている（相手メンバー ID がリード行と一致していない）。

---

## 5. ギャップ（利用者感覚 vs システム定義）

| 観点 | 利用者の感覚 | 現行システム |
|------|----------------|--------------|
| 参加起点 | 初めて例会に出た日から「接触の起点」がある | 起点は **BO 同席・メモ・1to1（予定含む）** のみ |
| 999 | 異常に長い未接触 | **「日数不明（記録なし）」** に近い内部表現 |
| 1to1 記録 | 保存すれば「実施した」に近い | **completed のみ**がリード「実施済」系に効く |

---

## 6. 対応方針の候補（優先度は別途合意）

### 6.1 短期（確認・データ）

- **3/17 例会の meeting / participants / breakout が DB に揃っているか**確認する。
- 問題の相手について **`last_contact_at` の構成要素**（BO / メモ / 1to1）を DB で追う。
- 1 to 1 行の **`status`・`started_at` / `ended_at`** を確認する（リードは completed 依存）。

### 6.2 中期（表示・UX・小さな実装）

- **999 の廃止:** null のときは **「接触起点なし」**「記録を追加すると日数が表示されます」等に変更（数値を出さない）。
- **Dashboard / Leads のヘルプ文言強化:** 「実施済 = status 完了」「例会出席のみではカウントされない場合がある」へのリンク（SSOT 抜粋）。
- **保存フロー:** 実施後は **completed + 実施日時** まで誘導（既存 Create/Edit と整合）。

### 6.3 長期（仕様・モデル）

- **「初参加日」や「初めて同じ例会にいた日」**を `members` または派生で持ち、**stale の下限**や「新メンバー」表示に使う（要設計）。
- **出席（participant）を last_contact の補助**に含めるかどうか（DATA_MODEL・パフォーマンス・誤カウントの検討）。

---

## 7. 次のアクション（提案）

| 種別 | 内容 |
|------|------|
| 調査タスク | 該当ユーザー・相手 member_id で `MemberSummaryQuery` 相当のデータを SQL でトレース |
| Phase 候補 | 「999 表示の撤廃とコピー整理」「初参加日の扱い」「participant を接触に含めるか」は別 PLAN で分割推奨 |
| SSOT 更新 | 本書の結論が固まったら [DASHBOARD_DATA_SSOT.md](DASHBOARD_DATA_SSOT.md) / [DATA_MODEL.md](DATA_MODEL.md) に **利用者向け一文**を追記 |

---

## 8. 参照実装一覧

| 領域 | 主なクラス / ファイル |
|------|-------------------------|
| last_contact | `MemberSummaryQuery::batchLastContactAt` |
| Dashboard stale / 999 | `DashboardService::getTasks` |
| 1to1 リード | `MemberOneToOneLeadService`, `config/religo.php` |
| UI ラベル | `www/resources/js/admin/religoOneToOneLeadLabels.js` |
