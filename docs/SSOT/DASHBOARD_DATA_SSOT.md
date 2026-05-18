# Dashboard データ定義 SSOT

**目的:** Dashboard の数値・抽出条件・優先順位を一本化し、後続のブレを防ぐ。  
**実装の正:** コード（DashboardController / DashboardService）にあり、本ドキュメントは定義書。二重実装はしない。

---

## 0. Dashboard の役割（製品上の位置づけ）

Religo の **Dashboard** は、**一覧の代替ではなく**、ログイン直後に **現状を把握し、「次にどの画面へ行き、何をするか」を判断するためのホーム** とする。

| 観点 | 中身 |
|------|------|
| **誰のため** | チャプターに参加する **ユーザー（owner_member_id が示すメンバー）**。自分の紹介・フォロー・例会参加の文脈が主。 |
| **開いた瞬間に分かるべきこと** | ① 要フォロー・今月の活動ペース（**KPI**）② **いま優先して進める具体行動（Tasks）** ③ **直近で起きたこと（Activity）** ④ 補助的に **1 to 1 の候補（Leads）**。 |
| **詳細画面との違い** | Members / Meetings / 1 to 1 などは **1 テーマの深掘り・操作**。Dashboard は **横断したサマリと優先度の入口** に留め、編集本体は各画面へ委ねる。 |
| **何を判断できれば十分か** | 「今日カレンダーのタスクを全部消化したか」ではなく、**次に触れるべき人・予定・例会に近いフォローはどれか** を 1 画面で掴めること。 |

### ブロックごとの役割分担

| ブロック | 役割 |
|----------|------|
| **KPI（4 統計）** | **状況把握** — 未接触規模・今月の 1 to 1 / メモのペースを数で示す。 |
| **Tasks** | **次に動くべき具体行動** — 厳密な「今日の ToDo」ではなく、**優先して手を付けるとよい行動**（長期未接触・予定 1 to 1・次回/直近例会への導線）。 |
| **Activity** | **最近何が起きたか** — メモ・1 to 1・つながりフラグ・BO 割当などの**時系列ログ**（判断の裏付け・思い出し）。 |
| **Leads（右列）** | **関係強化の候補** — 全会員× owner の 1 to 1 状況・want 等から **誰と次に会うか** を探す補助（Tasks とは役割分担）。 |

### workspace と Tasks / stale（**STALE-PEER-CHAPTER-P1**）

- **Tasks（meeting_follow_up 以外の stale 系）:** `getSummaryLiteBatch` 第 3 引数は **`null`**（Summary の last_contact はグローバルな同席・メモ・1to1 を合成）。  
- **stale peer の集合:** **`members.workspace_id` が owner と同一**かつ **`type` が guest / visitor 以外**のメンバー（自分除外）。会の在籍名簿に近い。**owner の `workspace_id` が null のときのみ**フォールバックで「自分以外の全メンバー」から guest・visitor を除外（所属未設定データ向け）。

#### stale の意味（owner 文脈）

- **定義:** 上記 peer ごとに `MemberSummaryQuery::batchLastContactAt`（`workspaceId = null`）の **last_contact_at**。候補には **例会 BO で同一 `breakout_room` に同席した日（`meetings.held_on`・`participant_breakout` 経由）**、**contact_memos.created_at**、**status ≠ canceled の one_to_ones** の **started_at / scheduled_at / created_at**（日時未設定の 1 to 1 登録も **created_at で接触あり**）などの最大値。これが **null または 30 日超過**なら未接触（stale）。
- **Dashboard の位置づけ:** **所属チャプター（owner の workspace）内**のフォロー優先度を見る指標。他チャプター所属メンバーは分母に含めない。

#### `ReligoActorContext::resolveWorkspaceIdForUser()` を stale の peer 列挙に使わない理由

- ユーザーの「所属 workspace」と **owner メンバーレコードの `workspace_id`** は通常一致するが、API は **owner メンバー行を単一情報源**とし、`stalePeerMemberIds` は **`members.workspace_id = owner_member.workspace_id`** で決める（ヘッダの workspace 選択とズレる場合は owner の所属を DB で直す）。

---

## 1. 対象と前提

### owner_member_id
- **意味:** 「自分」を表すメンバー ID。Dashboard の stats / tasks / activity はすべて「このメンバーを owner として」集計する。
- **スコープ:** 集計は引き続き **owner 軸**。`workspace_id`（`GET /api/users/me`）は **所属チャプター**を示す解決済み値で、BO 監査と同一式（WORKSPACE-SINGLE-CHAPTER-ASSUMPTION / [WORKSPACE_RESOLUTION_POLICY.md](WORKSPACE_RESOLUTION_POLICY.md)）。Dashboard の 3 API は **クエリに workspace を付けない**（BNI 単一チャプター運用・副作用防止）。将来 workspace スコープをかける場合は API と本 SSOT を同時に更新する。
- **決定順（E-4 で固定）:**  
  1. **クエリ** — リクエストに `owner_member_id` があればそれを使用（互換維持）。**管理画面 SPA はダッシュボード API 呼び出しにヘッダで選択中の owner を付与する**（複数ユーザー環境でアクター解決のフォールバックと取り違えないため）。  
  2. **ユーザー設定** — 無ければ現在ユーザーの `owner_member_id`（users.owner_member_id）を使用。GET /api/users/me で取得。応答の **`default_workspace_id`** は **所属 workspace**、`workspace_id` は **所属チャプターとしての解決済み ID**（[DATA_MODEL.md](DATA_MODEL.md)「Workspace と User の関係」）。PATCH /api/users/me で `owner_member_id` / `default_workspace_id` を更新可（いずれか必須）。**現在ユーザー（BO-AUDIT-P3）:** 認証時は `auth` の User、無認証時は **users.id 昇順先頭**。SSOT: [USER_ME_AND_ACTOR_RESOLUTION.md](USER_ME_AND_ACTOR_RESOLUTION.md)。  
  3. **未設定時** — 上記のいずれも無い（null）場合は **422 Unprocessable Entity** を返し、`message` で初回設定を促す。暫定の固定値 1 は使用しない。
- **解消済み:** 旧「暫定で固定値 1」は Phase E-4 で廃止し、上記の決定順に統一した。

### 所属チャプター（workspace）UI（BO-AUDIT-P5）

- **設定画面:** `GET /#/settings`（`ReligoSettings.jsx`）。`GET /api/workspaces` で一覧、`GET /api/users/me` の **`workspace_id`** を Select の初期値に使用（解決済み ID・一覧と整合）。保存は **`PATCH /api/users/me`** に `{ "default_workspace_id": <id> }`（所属 workspace のみ。サーバは `exists:workspaces`）。
- **ヘッダ:** `CustomAppBar` に **所属: {name}**（`me.workspace_id` + workspace 一覧で名称解決）。保存成功時はカスタムイベント `religo-workspace-changed` で再取得。
- **Dashboard ブロック:** `DashboardHeader` に **所属チャプター: {name}**（名前は `GET /api/workspaces` で解決）。リンクから `/settings` へ。

---

## 2. stats の定義（GET /api/dashboard/stats）

| キー | 定義 | 補足 |
|------|------|------|
| **stale_contacts_count** | owner から見て「未接触 30 日以上」の target メンバー数。 | **算出:** `MemberSummaryQuery::getSummaryLiteBatch($owner, peers, null)`（第 3 引数 **null**）。**peers** は **owner と同一 `members.workspace_id`・`type` ∉ {guest, visitor}（自分除外）**；owner の `workspace_id` が null のときのみ自分以外の全メンバーから guest・visitor を除外。未接触: 各 peer の `last_contact_at` が null または 30 日より前（`last_contact_at` の合成は `MemberSummaryQuery::batchLastContactAt`。**1 to 1 は canceled 以外を対象とし、started_at / scheduled_at が無い行も `created_at` を接触として含める**）。 |
| **monthly_one_to_one_count** | owner の「今月」の 1to1 **実施**回数（**主 KPI**）。 | `status = completed` かつ **実施日時の代理**が今月の開始〜終了（サーバー TZ）。**実施日時の代理**は `COALESCE(started_at, scheduled_at, updated_at)`（**started_at 優先**。議事録インポート等で `started_at` 未入力の完了行は `scheduled_at`、さもなくば更新日で当月判定）。予定のみ・キャンセルのみでは増えない。 |
| **one_to_one_total_count** | owner の 1to1 **登録総数**（全期間・全ステータス）。 | `one_to_ones` で `owner_member_id = owner` の行数。 |
| **one_to_one_planned_count** | owner の **予定**件数（全期間）。 | `status = planned`。 |
| **one_to_one_canceled_count** | owner の **キャンセル**件数（全期間）。 | `status = canceled`。 |
| **monthly_intro_memo_count** | **UI 表示名: リファーラル件数（今月）。** owner が「今月」記録した **紹介メモ（introduction）の件数**＝当分はリファーラル活動のプロキシ。 | 集計は `contact_memos` の `memo_type = introduction`、`created_at` が今月。`introductions` テーブルは [REFERRAL_RECORDING_REQUIREMENTS.md](REFERRAL_RECORDING_REQUIREMENTS.md)（SPEC-009）の **`introductions` 本格運用後に合算または置換**し得る。BO 含むは subtext の説明用。 |
| **monthly_meeting_memo_count** | owner が「今月」作成した例会メモ数。 | contact_memos の memo_type = meeting、created_at が今月。例会番号の扱いは表示用（例: 例会#247 含む）で subtext に記載。 |
| **subtexts** | UI の補足文言。 | stale: 要フォロー、**one_to_one:** 先月比（今月実施）、**one_to_one_inventory:** 登録総数・予定・キャンセルの内訳一行、intro / meeting: 同上。固定または将来 API で差し替え可。 |

---

## 3. tasks の定義（GET /api/dashboard/tasks）

### Tasks の見出しと意味（UI）

- 画面上のラベルは **「優先アクション（Tasks）」**。**カレンダー上の「今日」だけ**に限定したタスクリスト**ではない**（stale は 30 日超未接触、予定 1 to 1 は今日以降または日時未設定、**meeting_follow_up** は **直近開催済み例会**で **例会メモ（contact_memos）未記録のときのみ**（DASHBOARD-TASKS-ALIGNMENT-P2））。
- **採らない案:** 見出し「今日やること」に合わせて **実装を今日限定に絞る**こと。優先フォロー・直近例会の動きまで落とすと Dashboard の役割が弱まるため、**案A（見出し・説明を実際の意味に寄せる）を採用**（DASHBOARD-TASKS-ALIGNMENT-P1）。

### kind と優先順位・件数上限
| 順序 | kind | 内容 | 件数上限 |
|------|------|------|----------|
| 1 | **stale_follow** | `last_contact_at` が null または **30 日より前**の target（**厳密な「今日」ではなく「要フォロー」**）。対象 peer は **所属チャプター内かつ guest・visitor 以外（owner と同一 `members.workspace_id`）**。**`last_contact_at` は `getSummaryLiteBatch(..., null)`** で算出。 | 最大 2 件（一覧上の優先表示。**全件は KPI の未接触件数**を参照）。1 件目 CTA「1to1予定」→ **`/one-to-ones/create?target_member_id={member_id}`**（ONETOONES_DASHBOARD_TARGET_PREFILL_P4）、2 件目「メモ追加」→ **`/members/{id}/show`**（Member 詳細でメモ・関係を更新）。 |
| 2 | **one_to_one_planned** | owner の **planned** で、`scheduled_at` が **今日の暦日以降**または **null**（日時未設定の予定も可）。**意味:** すでに予定に載せた 1 to 1 を Dashboard で再認識し、当日・直近の実行を促す。並びは `scheduled_at` 昇順で先頭 1 件。 | 1 件。CTA は Chip「予定」（ href なし・仕様どおり）。 |
| 3 | **meeting_follow_up** | **直近開催済み例会** 1 件を対象とする。`held_on` の暦日が **今日以前**（`whereDate(held_on, <= today)`・サーバー TZ）の例会のうち、**最も新しい `held_on`**（同順 `id` DESC）。**表示条件:** 当該 `meetings.id` に対し、**例会メモが未記録**のときのみタスク化する。 **記録済みの定義:** `contact_memos` に **`meeting_id` = 当該例会 id かつ `memo_type` = `meeting` かつ `body` が null / 空文字でない**行が **1 件以上**存在すること（**Meeting 一覧の has_memo / `MeetingMemoController` と同型**。**owner_member_id は判定に使わない** — 例会メモは会議単位の 1 本 UI）。**未記録**なら CTA「Meetingsへ」→ `/meetings`。 | 最高 1 件（条件を満たすときのみ）。会議が存在しない／未来日のみの例会暦なら **出さない**。 |

### stale_follow 2 件目「メモ追加」の disabled

- **方針（P1）:** **disabled にしない。** **Member Show への deep link** が有効で、SSOT・実装・UX を **有効導線に統一**する（誤誘導にならない）。

### データ取得元（トレース）
- Tasks の **UI → API → Service → DB** の対応は **[DASHBOARD_TASK_SOURCE_ANALYSIS.md](DASHBOARD_TASK_SOURCE_ANALYSIS.md)** を正とする（DASHBOARD-TASK-SOURCE-TRACE）。

---

## 4. activity の定義（GET /api/dashboard/activity）

### kind 一覧
- **memo_added** — 接触メモ（contact_memos）の作成。
- **one_to_one_created** — 1to1 の登録（status が planned 等）。
- **one_to_one_completed** — 1to1 の実施完了（status = completed）。
- **flag_changed** — Connections のフラグ変更（member_flags）。
- **memo_introduction** — 紹介メモ（`memo_type = introduction`）の作成。Activity 上は「〈相手〉へのリファーラル記録」。
- **bo_assigned** — BO（ブレイクアウト）割当の保存（`bo_assignment_audit_logs`・owner 軸）。meta は保存経路により「BO1/BO2」「複数Round」または「DragonFly MVP・セッション…」など（`BO_AUDIT_LOG_DESIGN.md`）。

### 並び順・limit
- **並び順:** occurred_at の**新しい順**。メモと 1to1 を混在させて 1 本の時系列にしたうえでソート。
- **limit:** クエリパラメータ `limit`。範囲 1〜50、デフォルト 6。範囲外はデフォルトに補正。

---

## 5. 実装との紐づけ（証跡）

| 種別 | 場所 |
|------|------|
| **エンドポイント** | GET /api/dashboard/stats、GET /api/dashboard/tasks、GET /api/dashboard/activity。Owner 設定: GET /api/users/me、PATCH /api/users/me |
| **Controller** | App\Http\Controllers\Religo\DashboardController、App\Http\Controllers\Religo\UserController（showMe / updateMe） |
| **Service** | App\Services\Religo\DashboardService（getStats / getTasks / getActivity） |
| **フロント** | www/resources/js/admin/pages/Dashboard.jsx（GET /api/users/me で owner 取得。**BO-AUDIT-P5:** `workspace_id` と `GET /api/workspaces` で **所属チャプター名**を DashboardHeader に表示。`/settings` で `default_workspace_id` を編集可）。Dashboard API への workspace クエリは付与しない。未設定時は「オーナーを設定してください」ブロック＋members Select。設定済み時は右上 Owner セレクタで変更時自動保存。fetch で dashboard 3 エンドポイントを呼び出し |
| **設定 UI** | www/resources/js/admin/pages/ReligoSettings.jsx、`app.jsx` の `CustomRoutes`、`CustomAppBar.jsx`、`ReligoMenu.jsx`（/settings） |
| **参照** | docs/SSOT/DASHBOARD_REQUIREMENTS.md（UI・モック合わせ）、docs/process/phases/PHASE_E4_OWNER_SETTINGS_PLAN.md（E-4 スコープ） |

---

## 6. 実数検証（Raw SQL と `DashboardService` の対応）

**目的:** KPI（`GET /api/dashboard/stats`）が「曖昧な数」ではなく **定義どおりの集計**になっていることを、DB 直の集計と突き合わせて確認する。

**実装の正:** `App\Services\Religo\DashboardService`（`getStats` / `countStaleContacts`）。本節は **照合用の SQL テンプレート** と **自動検証** の入口。

**命名メモ:** コード上のメソッドは **`getStats`**（旧称の `getSummary` ではない）。

### 6.1 前提（owner・タイムゾーン・削除）

| 項目 | 内容 |
|------|------|
| **owner** | すべて `owner_member_id = :owner`（stats の数値 KPI は owner 軸）。 |
| **「今月」** | `config('app.timezone')` 上の `now()` で月初〜月末（`DashboardService` は `startOfMonth()`〜`endOfMonth()->endOfDay()`）。**MySQL の `NOW()` だけ**と比較すると TZ ずれの可能性あり → **アプリと同じ境界を使うこと**。 |
| **soft delete** | `one_to_ones` / `contact_memos` は **現行スキーマで `deleted_at` なし**（モデルにも SoftDeletes なし）。将来追加したら SSOT・検証サービスを同時更新。 |
| **stale** | **単一 SELECT では表現しない。** `MemberSummaryQuery::getSummaryLiteBatch(..., null)` の **`last_contact_at`**（同席・メモ・1to1・フラグ由来の合成）と **30 日閾値** による。検証は **`countStaleContacts` と `getStats` の一致** で担保（§6.3）。 |

### 6.2 照合用 SQL（`:owner` を対象 owner に置換）

**今月の 1to1 完了数（`monthly_one_to_one_count`）**

実装は **`status = 'completed'` かつ `COALESCE(started_at, scheduled_at, updated_at)` が今月**（`held_on` 列は使わない）。

```sql
-- アプリと同じ月初・月末をバインドする（Carbon で算出した文字列をそのまま使うのが確実）
SELECT COUNT(*) AS cnt
FROM one_to_ones
WHERE owner_member_id = :owner
  AND status = 'completed'
  AND COALESCE(started_at, scheduled_at, updated_at) BETWEEN :month_start AND :month_end;
```

**1to1 登録総数・予定・キャンセル（`one_to_one_total_count` / `one_to_one_planned_count` / `one_to_one_canceled_count`）**

```sql
SELECT COUNT(*) AS cnt FROM one_to_ones WHERE owner_member_id = :owner;

SELECT COUNT(*) AS cnt FROM one_to_ones WHERE owner_member_id = :owner AND status = 'planned';

SELECT COUNT(*) AS cnt FROM one_to_ones WHERE owner_member_id = :owner AND status = 'canceled';
```

**今月のリファーラル件数 / `monthly_intro_memo_count`（紹介メモ＝introduction でカウント）**

```sql
SELECT COUNT(*) AS cnt
FROM contact_memos
WHERE owner_member_id = :owner
  AND memo_type = 'introduction'
  AND created_at BETWEEN :month_start AND :month_end;
```

**今月の例会メモ数（`monthly_meeting_memo_count`）**

```sql
SELECT COUNT(*) AS cnt
FROM contact_memos
WHERE owner_member_id = :owner
  AND memo_type = 'meeting'
  AND created_at BETWEEN :month_start AND :month_end;
```

**未接触件数（`stale_contacts_count`）**

- **定義の内訳:** [§0](#0-dashboard-の役割製品上の位置づけ)・`MemberSummaryQuery::batchLastContactAt`（`workspaceId = null`）。
- **検証観点:** `last_contact_at IS NULL OR last_contact_at < (now - 30 days)` を **所属チャプター内 peer 全員**（owner と同一 `members.workspace_id`・**guest / visitor 除外**・自分除外）に対して数えた件数 = `DashboardService::countStaleContacts($owner)` = `getStats()['stale_contacts_count']`。

### 6.3 自動検証（推奨）

| 手段 | 説明 |
|------|------|
| **Artisan** | `php artisan dashboard:verify-summary {owner_member_id}` — `DB::table` の件数と `getStats` の差分を表示。exit `0` = 一致。 |
| **HTTP（local のみ）** | `GET /api/debug/dashboard-summary?owner_member_id={id}` — JSON で `db_raw` / `service` / `diff` / `all_match`。**`APP_ENV=local` のときだけ** `routes/api.php` に登録される。 |

実装: `App\Services\Religo\DashboardSummaryVerificationService`。

### 6.4 手動チェックリスト（そのままコピペ可）

| # | 指標 | SQL / 手順 | Service（比較先） | 一致 |
|---|------|--------------|-------------------|------|
| 1 | 今月の 1to1 | §6.2 `one_to_ones` | `getStats` → `monthly_one_to_one_count` | OK / NG |
| 2 | 今月のリファーラル件数 | セクション 6.2 `contact_memos` introduction | `monthly_intro_memo_count` | OK / NG |
| 3 | 今月の例会メモ | §6.2 `contact_memos` meeting | `monthly_meeting_memo_count` | OK / NG |
| 4 | 未接触（stale） | `dashboard:verify-summary` または `countStaleContacts` = `getStats` の stale | `stale_contacts_count` | OK / NG |
| 5 | 1to1 登録総数 | §6.2 `COUNT(*)` | `one_to_one_total_count` | OK / NG |
| 6 | 1to1 予定 | §6.2 `status=planned` | `one_to_one_planned_count` | OK / NG |
| 7 | 1to1 キャンセル | §6.2 `status=canceled` | `one_to_one_canceled_count` | OK / NG |

**Tasks（`getTasks`）** は件数 KPI ではなく **優先行動のリスト** のため、別紙 [DASHBOARD_TASK_SOURCE_ANALYSIS.md](DASHBOARD_TASK_SOURCE_ANALYSIS.md)・§3 を正とする。

**補足（stale_follow の「999日間未接触」）:** `last_contact_at` が null のとき API は表示用に **999** を代入する（実日数ではない）。**UI 上の読み替え・利用者向け説明**は [CONTACT_LOGIC_ALIGNMENT.md](CONTACT_LOGIC_ALIGNMENT.md) を参照。
