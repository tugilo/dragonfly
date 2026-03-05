# Dashboard データ定義 SSOT

**目的:** Dashboard の数値・抽出条件・優先順位を一本化し、後続のブレを防ぐ。  
**実装の正:** コード（DashboardController / DashboardService）にあり、本ドキュメントは定義書。二重実装はしない。

---

## 1. 対象と前提

### owner_member_id
- **意味:** 「自分」を表すメンバー ID。Dashboard の stats / tasks / activity はすべて「このメンバーを owner として」集計する。
- **スコープ:** 現行は workspace 未適用（単一 workspace 前提）。将来 workspace スコープをかける場合は API と本 SSOT を同時に更新する。
- **暫定:** フロントでは「current user に紐づく owner_member_id」を返す API が無いため、**暫定で固定値 1** を使用（MembersList / MeetingDetailDrawer と同一）。E-4 候補で「ログインユーザー → owner_member_id」の正を検討する。

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

### kind と優先順位・件数上限
| 順序 | kind | 内容 | 件数上限 |
|------|------|------|----------|
| 1 | **stale_follow** | 未接触 30 日以上の target。フォロー推奨。 | 最大 2 件。1 件目は「1to1予定」、2 件目は「メモ追加」。 |
| 2 | **one_to_one_planned** | owner が予定している 1to1（status = planned、scheduled_at >= 今日 or null）。 | 1 件（最も直近の 1 件）。 |
| 3 | **meeting_memo_pending** | 次回例会（held_on >= 今日）または直近例会の「メモ未整理」案内。 | 1 件。 |

### メモ追加が disabled の理由
- 2 件目の stale_follow のアクション「メモ追加」は、**メモ追加 API を Dashboard から呼ぶ導線が未実装**のため、UI 上 disabled。Connections 等からはメモ追加可能。将来 Phase で Dashboard からメモモーダルを開く実装を入れる。

---

## 4. activity の定義（GET /api/dashboard/activity）

### kind 一覧
- **memo_added** — 接触メモ（contact_memos）の作成。
- **one_to_one_created** — 1to1 の登録（status が planned 等）。
- **one_to_one_completed** — 1to1 の実施完了（status = completed）。
- （将来）flag_changed / bo_assigned 等は API で返す場合に kind を追加する。

### 並び順・limit
- **並び順:** occurred_at の**新しい順**。メモと 1to1 を混在させて 1 本の時系列にしたうえでソート。
- **limit:** クエリパラメータ `limit`。範囲 1〜50、デフォルト 6。範囲外はデフォルトに補正。

---

## 5. 実装との紐づけ（証跡）

| 種別 | 場所 |
|------|------|
| **エンドポイント** | GET /api/dashboard/stats、GET /api/dashboard/tasks、GET /api/dashboard/activity |
| **Controller** | App\Http\Controllers\Religo\DashboardController |
| **Service** | App\Services\Religo\DashboardService（getStats / getTasks / getActivity） |
| **フロント** | www/resources/js/admin/pages/Dashboard.jsx（OWNER_MEMBER_ID 暫定 1、fetch で上記 3 エンドポイントを呼び出し） |
| **参照** | docs/SSOT/DASHBOARD_REQUIREMENTS.md（UI・モック合わせ）、docs/process/phases/PHASE_E3_DASHBOARD_UI_WORKLOG.md（owner/loading の暫定理由） |
