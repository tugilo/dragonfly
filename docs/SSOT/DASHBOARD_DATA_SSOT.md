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

### workspace と Tasks（DASHBOARD-TASKS-ALIGNMENT-P1）

- **Tasks の生成には `workspace_id` を渡さない**（`getSummaryLiteBatch` の第 3 引数は `null`）。**owner 軸のまま**とする。
- **理由:** 現行の主軸は owner；チャプター別 stale の絞り込みは影響範囲が広く、本フェーズのスコープ外。将来 `workspace_id` を渡す場合は API・本 SSOT・タスク分析書を同時更新する。

---

## 1. 対象と前提

### owner_member_id
- **意味:** 「自分」を表すメンバー ID。Dashboard の stats / tasks / activity はすべて「このメンバーを owner として」集計する。
- **スコープ:** 集計は引き続き **owner 軸**。`workspace_id`（`GET /api/users/me`）は **所属チャプター**を示す解決済み値で、BO 監査と同一式（WORKSPACE-SINGLE-CHAPTER-ASSUMPTION / [WORKSPACE_RESOLUTION_POLICY.md](WORKSPACE_RESOLUTION_POLICY.md)）。Dashboard の 3 API は **クエリに workspace を付けない**（BNI 単一チャプター運用・副作用防止）。将来 workspace スコープをかける場合は API と本 SSOT を同時に更新する。
- **決定順（E-4 で固定）:**  
  1. **クエリ** — リクエストに `owner_member_id` があればそれを使用（互換維持）。  
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
| **stale_contacts_count** | owner から見て「未接触 30 日以上」の target メンバー数。 | 未接触の定義: MemberSummaryQuery の last_contact_at が null、または last_contact_at が「基準日時の 30 日前」より前。基準日時はサーバー now()。除外条件: owner 本人は集計対象外。 |
| **monthly_one_to_one_count** | owner の「今月」の 1to1 実施回数。 | status = completed、started_at が今月の開始日時〜終了日時（サーバー TZ）。 |
| **monthly_intro_memo_count** | owner が「今月」作成した紹介メモ数。 | contact_memos の memo_type = introduction、created_at が今月。BO 含むは subtext の説明用。 |
| **monthly_meeting_memo_count** | owner が「今月」作成した例会メモ数。 | contact_memos の memo_type = meeting、created_at が今月。例会番号の扱いは表示用（例: 例会#247 含む）で subtext に記載。 |
| **subtexts** | UI の補足文言。 | stale: 要フォロー、one_to_one: 先月比 +2、intro: BO含む、meeting: 例会#247 含む。固定または将来 API で差し替え可。 |

---

## 3. tasks の定義（GET /api/dashboard/tasks）

### Tasks の見出しと意味（UI）

- 画面上のラベルは **「優先アクション（Tasks）」**。**カレンダー上の「今日」だけ**に限定したタスクリスト**ではない**（stale は 30 日超未接触、予定 1 to 1 は今日以降または日時未設定、**meeting_follow_up** は **直近開催済み例会**で **例会メモ（contact_memos）未記録のときのみ**（DASHBOARD-TASKS-ALIGNMENT-P2））。
- **採らない案:** 見出し「今日やること」に合わせて **実装を今日限定に絞る**こと。優先フォロー・直近例会の動きまで落とすと Dashboard の役割が弱まるため、**案A（見出し・説明を実際の意味に寄せる）を採用**（DASHBOARD-TASKS-ALIGNMENT-P1）。

### kind と優先順位・件数上限
| 順序 | kind | 内容 | 件数上限 |
|------|------|------|----------|
| 1 | **stale_follow** | `last_contact_at` が null または **30 日より前**の target（**厳密な「今日」ではなく「要フォロー」**）。Dashboard に出す理由: 関係が途切れそうな相手への **優先アクション** を置くため。 | 最大 2 件（一覧上の優先表示。**全件は KPI の未接触件数**を参照）。1 件目 CTA「1to1予定」→ `/one-to-ones/create`、2 件目「メモ追加」→ **`/members/{id}/show`**（Member 詳細でメモ・関係を更新）。 |
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
- **memo_introduction** — メモ更新による紹介ラインの追加・変更。
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
