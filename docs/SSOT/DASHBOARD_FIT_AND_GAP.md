# Dashboard フィット＆ギャップ（モック v2 → 実装）

**Phase ID:** ONETOONES_P7_DASHBOARD_FIT_AND_GAP（調査・SSOT 化）  
**目的:** ダッシュボードについて **モック `religo-admin-mock-v2.html` の `#/dashboard`（`#pg-dashboard`）を SSOT** とし、表示の**意味**（何を判断するか）・データ要件・現行実装との差分・埋め方を明文化する。  
**モック URL / ファイル:** http://localhost/mock/religo-admin-mock-v2.html ／ `www/public/mock/religo-admin-mock-v2.html`  
**実装:** `www/resources/js/admin/pages/Dashboard.jsx`、API `GET /api/dashboard/*`、`DashboardService`、`GET /api/dragonfly/members/one-to-one-status`

**関連 SSOT:**

- [DATA_MODEL.md](DATA_MODEL.md) — `members`, `contact_memos`, `one_to_ones`, `meetings`, `dragonfly_contact_flags` 等
- [DASHBOARD_DATA_SSOT.md](DASHBOARD_DATA_SSOT.md) — stats / tasks / activity の定義・owner_member_id
- [FIT_AND_GAP_MENU_HEADER.md](FIT_AND_GAP_MENU_HEADER.md) — シェル（サイドバー・AppBar）の v2 基準
- [MEETINGS_ARCHIVE_FIT_AND_GAP.md](MEETINGS_ARCHIVE_FIT_AND_GAP.md) — 例会まわりの調査（Dashboard の「次回例会」メタと整合する際の参照）

**注:** `docs/INDEX.md` に [DASHBOARD_REQUIREMENTS.md](DASHBOARD_REQUIREMENTS.md) へのリンクがあるが、現時点で repo 内に該当ファイルは未検出。**要件の実体は本書＋ DASHBOARD_DATA_SSOT.md とする**（INDEX の整合は別タスクで要確認）。

---

## §1 スコープ

| 含む | 含まない |
|------|----------|
| Dashboard **ページ本体**（`#pg-dashboard`） | グローバル AppBar の検索・通知・プロフィール（→ [FIT_AND_GAP_MENU_HEADER.md](FIT_AND_GAP_MENU_HEADER.md)） |
| 統計 4 枚・Tasks・クイックショートカット・最近の活動 | 他画面への遷移先の内部仕様 |

### §1.1 Dashboard の役割（実装ラベル・DASHBOARD-TASKS-ALIGNMENT-P1）

モックは主にレイアウト・情報の **並び** の SSOT。**製品上の役割**（KPI / Tasks / Activity / Leads の分担、Tasks が「今日限定」かどうか）は **[DASHBOARD_DATA_SSOT.md §0](DASHBOARD_DATA_SSOT.md)** を正とする。

- **要約:** Dashboard は **現状把握**（KPI）と **次アクション決定**（Tasks）のホーム。Activity は **最近の事実**、Leads は **1 to 1 候補の補助**。
- **Tasks の UI 見出し:** モックの「今日やること」に対し、実装は **「優先アクション（Tasks）」**（中身は厳密な「今日」ではない）。意図的な **意味上の Fit**（モックの固定文言と 1:1 ではない）。

---

## §2 モック構造

### 2.1 セクション一覧

| セクション名 | 内容 | UI要素 | 操作 |
|-------------|------|--------|------|
| ページヘッダ | 画面の目的の宣言・主要アクション | h1「Dashboard」、サブ「今日の活動・未アクション・KPI」、右に 2 ボタン | Connections へ遷移、1to1 追加（モーダル起動のモック） |
| KPI 統計（4） | 未アクションと今月の活動量の俯瞰 | `.stats` グリッド 4 列、各 `.stat` にアイコン・ラベル・主数値・補足 1 行 | なし（閲覧のみ） |
| 今日やること（Tasks） | 今日フォローすべき人・予定・例会まわりの催促（モック文言） | 左カラム上部 `.card`、縦リスト、種類別の背景・左ボーダー、アイコン | 1to1 予定 → `openModal('mol-1on1create')`、メモ追加 → `openMemoModal`、予定は Chip、例会 → `#/meetings`。**実装ラベルは「優先アクション」**（[DASHBOARD_DATA_SSOT §3](DASHBOARD_DATA_SSOT.md)）。 |
| クイックショートカット | よく使う画面へのワンクリック | 左カラム下部 `.card`、横並びボタン 4 つ | Connections / Members / 1to1 追加（モーダル）/ Meetings |
| 最近の活動 | 直近の記録を時系列で把握 | 右カラム `.card`、`.timeline` 縦リスト（ドット＋タイトル＋メタ） | なし（閲覧のみ・モックは行クリックなし） |

**レイアウト:** メインは **2 カラム** — `grid-template-columns: 1fr 340px`（左に Tasks＋ショートカット、右に活動）。その上に **全幅の 4 統計**。

### 2.2 詳細（セクションごと）

#### ■ ページヘッダ

- **表示項目:** タイトル、1 行説明、primary「🗺 Connectionsへ」、outline「＋ 1to1追加」
- **データ内容:** なし（固定文言）
- **操作:** 画面遷移（hash ルーティング）、モックでは 1to1 はモーダル起動

#### ■ KPI 統計（4 枚）

| # | ラベル（意味） | モック主数値（例） | 補足行（意味） |
|---|----------------|-------------------|----------------|
| 1 | 未接触（30日以上）— *要フォロー優先度の件数* | 4（warn 色） | 要フォロー |
| 2 | 今月の1to1回数 — *実施ペース* | 7 | 先月比 +2 |
| 3 | 紹介メモ数（今月）— *紹介系メモの活動量* | 12 | BO含む |
| 4 | 例会メモ数（今月）— *例会メモの活動量* | 31 | 例会#247 含む |

- **操作:** なし

#### ■ 今日やること（Tasks）

- **表示項目:** 行ごとにアイコン、相手名または例会タイトル、説明文（日数・文脈）、右側 CTA（ボタン / Chip）
- **データ内容（モックが示す意味）:**
  1. **Stale 1:** 特定メンバー名、N 日未接触 → 1to1 を検討、CTA「1to1予定」
  2. **Stale 2:** 別メンバー、未接触 → フォローアップ要、CTA「メモ追加」
  3. **Planned 1to1:** 相手名＋本日時刻＋メモ一行、状態 Chip「予定」
  4. **例会メモ:** 次回例会番号・メモ未整理、次回までの日数感、CTA「Meetingsへ」
- **操作:** 1to1 作成モーダル、メモ追加モーダル、Meetings 一覧へ

#### ■ クイックショートカット

- **表示項目:** 4 ボタン（Connections / Members / ＋1to1 / 例会一覧）
- **操作:** 各画面へ遷移（または 1to1 モーダル）

#### ■ 最近の活動

- **表示項目:** 各項：種類を表す絵文字ドット、1 行タイトル（誰に何をした／何をした）、メタ（抜粋・日付・相対時間）
- **データ内容（モック例が含む**意味**）:** メモ追加、1to1 登録、**例会 BO 割当保存**、**1to1 完了**、**interested フラグ変更**、メモ追加…
- **操作:** なし

---

## §3 データ要件

| セクション | データ内容 | テーブル / ソース | ロジック |
|------------|------------|-------------------|----------|
| KPI① 未接触30日+ | owner 以外のメンバーで、最終接触が null または 30 日前より古い件数 | `members` + **派生** `last_contact_at`（MemberSummaryQuery / ContactSummary 系） | count；owner 自身除外。基準日はサーバー now |
| KPI② 今月1to1回数 | owner の今月 **completed** 件数 | `one_to_ones` | `status=completed` かつ `started_at` が当月範囲 |
| KPI③ 紹介メモ（今月） | owner が今月作成した紹介メモ件数 | `contact_memos` | `memo_type=introduction`・`created_at` 当月 |
| KPI④ 例会メモ（今月） | owner が今月作成した例会メモ件数 | `contact_memos` | `memo_type=meeting`・当月。補足「例会#247」は **表示用コピー** であり DB の必須項目ではない（要確認：動的に直近例会番号を出すか） |
| KPI 補足（先月比等） | 前月との差分・割合 | 同上 KPI②③④＋未接触割合（P7-2） | **P7-2 で動的化済**（`GET /api/dashboard/stats` の `subtexts`） |
| Tasks stale×2 | 未接触 30 日以上の target から最大 2 件 | 同上 `last_contact_at` + `members` | 日数表示、1 件目 href 1to1 作成、2 件目はモックはメモ追加 |
| Tasks 予定1to1 | 直近の planned | `one_to_ones` + `members`（target） | `scheduled_at` 当日以降 or null、並び最上位 1 件など（SSOT: DASHBOARD_DATA_SSOT） |
| Tasks 例会メモ | 次回 `held_on >= today` の例会、なければ直近 | `meetings` | タイトルに例会番号。**P7-2:** meta は `held_on` から「本日 / あとN日 / 次回未登録…」を動的算出 |
| 活動フィード | メモ・1to1・**BO 割当**・**フラグ変更** 等の時系列 | `contact_memos`, `one_to_ones`, **`dragonfly_contact_flags`**, **`bo_assignment_audit_logs`** | occurred_at 降順、limit N。BO は **BO-AUDIT-P1**（`BO_AUDIT_LOG_DESIGN.md`）。CSV apply ログは含めない |
| （実装のみ）1to1リード一覧 | 全会員×owner の 1to1 実施状況・want_1on1 | `one_to_ones`, `dragonfly_contact_flags`, `members` | `MemberOneToOneLeadService::indexForOwner`。**モック Dashboard には無い** |

---

## §4 現行実装

| セクション | 実装状況 | 備考 |
|------------|----------|------|
| ページヘッダ | **実装済** | モック同文言。追加で **Owner セレクタ**（E-4）：`users.owner_member_id` と連携 |
| Owner 初回設定 | **モックに無し・実装のみ** | 未設定時カード「オーナーを設定してください」＋メンバー選択。422 回避のための製品要件 |
| KPI 統計 4 | **実装済** | `GET /api/dashboard/stats`。**DASHBOARD-P7-2:** `subtexts` は先月比・未接触割合・直近例会番号など**動的**。フォールバック定数あり（API 失敗時） |
| 1to1 リードパネル | **実装済・モックに無し** | `GET /api/dragonfly/members/one-to-one-status`。Tasks の**上**に配置。全ターゲットの状況＋`1to1作成` リンク |
| Tasks | **実装済** | `GET /api/dashboard/tasks`。kind 別スタイルはモックに準拠。**DASHBOARD-P7-2:** 2 件目「メモ追加」は **`/members/:id/show` deep link**（**有効**。SSOT と一致）。**DASHBOARD-TASKS-ALIGNMENT-P1/P2:** 見出し「優先アクション」、**`meeting_follow_up`** は **直近開催済み例会の例会メモ未記録時のみ**（`contact_memos`・一覧 has_memo と同型）。**STALE-WORKSPACE-SCOPE-P1:** **`stale_follow`** は **`getSummaryLiteBatch(..., null)`**（所属 workspace での peer 絞り込みは **未実装・理由は DASHBOARD_DATA_SSOT §0**）。**MEMBER-SUMMARY-WORKSPACE-NULL-P1:** Members 一覧 `summary_lite`（`workspace_id` 指定時）の Query は **DATA_MODEL §5.1** の **OR NULL** に整合（Dashboard 本体は未変更）。 |
| クイックショートカット | **実装済** | React Router の `/connections` 等（モック hash とパスは異なるが導線同等） |
| 最近の活動 | **実装済** | `GET /api/dashboard/activity` は memos + 1to1 + `flag_changed` + **`bo_assigned`**（`bo_assignment_audit_logs`・BO-AUDIT-P1）。SSOT: `BO_AUDIT_LOG_DESIGN.md` |
| ローディング・空状態 | **実装済（P7-3）** | 初回・オーナー変更後の再取得でパネル単位 **Skeleton**。空配列 API を正しく表示。オーナー未設定・0 件・KPI 取得失敗を区別。凡例データ（旧フェールバック）は表示しない |
| モックのモーダル（1to1 / メモ） | **未** | 実装は **ページ遷移**（`/one-to-ones/create`）が中心。メモは Dashboard 直書き不可 |

**補足:** [FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) §2 は **P7-3 で API 連携・空状態・ローディング**まで反映済み。

---

## §5 Fit & Gap

| セクション | モック（意味） | 実装 | Gap | 優先度 |
|------------|----------------|------|-----|--------|
| ヘッダ CTA | Connections + 1to1 追加 | 同種＋Owner セレクタ | Owner UI はモック外の追加要件 | P2（仕様どおり維持） |
| KPI 数値 | 実データに基づく件数 | API 集計 + **動的 subtext**（P7-2） | 未接触の**前月比**は未 | P2 |
| KPI 体験 | 統計のみ | 統計＋（別枠）リード一覧 | **リード一覧はモックに無い**（製品強化か要否判断） | P2 |
| Tasks 件数・内容 | 最大 4 系統の型 | 同ロジック + **メモ deep link**（P7-2） | モックはメモ**モーダル**、実装は **Member Show 遷移** | P2 |
| Tasks 例会メモ行 | 「あとN日」動的 | **`held_on` 基準で動的**（P7-2） | — | — |
| クイックショートカット | 4 ボタン | 4 ボタン | **Fit** | — |
| 活動 | 6 種イベント混在タイムライン | メモ＋1to1＋フラグ＋**BO 割当（監査ログ）**（BO-AUDIT-P1） | レガシー `breakout-assignments` API は監査未接続 | P3 |
| インタラクション | メモ・1to1 をモーダル | 主にルーティング | **Dashboard 完結のメモ追加** なし | P2 |

**優先度凡例:** P1＝モックの「判断材料」に直結、P2＝導線・拡張・整合。

---

## §6 実装方針

- **案A（モック厳密）**  
  - リードパネルを Dashboard から外すか「設定で非表示」にし、Tasks 直上をモックと同一にする。  
  - activity API に BO 割当・フラグ変更イベントを追加（監査ログテーブル無しなら **要確認**：どの操作を「イベント」として記録するか）。  
  - Tasks のメモ追加をモーダルまたは Member 詳細 deep link で成立させる。

- **案B（モック＝レイアウト SSOT、リードは Religo 拡張として維持）**  
  - モックに無いリード一覧は **FIT として文書化**（本書）。  
  - Gap は活動の網羅性・subtext 動的化・メモ導線に集中させる。

- **案C（ハイブリッド）**  
  - 見た目は v2 に合わせつつ、リードを折りたたみ or 「1to1」関連として Tasks の下に移動し、モックの「今日やること」と役割の重なりを整理する。

**推奨:** **案B または C**。E-4 Owner とリード一覧は運用上の価値が大きく、**モックが無い＝不要とは断定しない**。一方で **活動フィードの意味** はモックの SSOT に寄せ、BO/フラグを入れるなら DATA_MODEL 上の更新イベント定義を先に固める（無理に合成ログを盛らず、**MVP は contact_memos / one_to_ones のみと宣言** も可）。

---

## §7 次Phase

| ID | 内容 |
|----|------|
| **P7-1** | **UI 構築** — モック v2 の余白・2 カラム・カードトーンに寄せた調整。リードパネルと Tasks の順序・見出しの整理（案C ならここで決定） |
| **P7-2** | **データ連携（実装済・DASHBOARD-P7-2）** — subtext 動的化、例会日数、メモ deep link、activity に `flag_changed` / `memo_introduction`。BO 活動は別途 |
| **P7-3** | **仕上げ（実装済・DASHBOARD-P7-3）** — 空状態・ローディング（Skeleton）、SSOT 整合、BO 活動の要件化（実装見送り）。`FIT_AND_GAP_MOCK_VS_UI` §2 更新 |

### P7-1 実装メモ（コード）

- **実施:** `DASHBOARD-P7-1` — `www/resources/js/admin/pages/dashboard/*` に panel 分割、**左列:** Tasks → Shortcuts → **Activity**、**右列（340px）:** Leads 補助（sticky・スクロール制限）。モック v2 と異なり Activity を左主列に移したのは仕様（主従整理・Leads を右補助に固定）。
- **ドキュメント:** `docs/process/phases/PHASE_DASHBOARD_P7_1_UI_*.md`

### P7-2 実装メモ（コード）

- **実施:** `DASHBOARD-P7-2` — `DashboardService` で stats subtexts・例会 meta・Tasks href・activity を拡張。UI は `dashboardConstants.js`・`DashboardActivityPanel` のキャプション程度。
- **ドキュメント:** `docs/process/phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_*.md`

### P7-3 実装メモ（コード）

- **実施:** `DASHBOARD-P7-3` — `Dashboard.jsx` で `bootLoading` / `panelsRefreshing`、`loadDashboard` の空配列を正しく反映。`DashboardKpiGrid` / `Tasks` / `Activity` / `Leads` に Skeleton と `DASHBOARD_MSG` 空状態。`@mui/icons-material` の `InfoOutlined` で統一感。
- **ドキュメント:** `docs/process/phases/PHASE_DASHBOARD_P7_3_FINISHING_*.md`

---

## §8 オープン（要確認）

1. **`bo_assigned`（BO-AUDIT-P1 完了）:** `bo_assignment_audit_logs` と `BoAssignmentAuditLogWriter`。主発生源は `PUT .../breakouts` と `PUT .../breakout-rounds`。詳細は `docs/SSOT/BO_AUDIT_LOG_DESIGN.md`。レガシー DragonFly `breakout-assignments` の監査は **未**。  
2. **例会 Tasks のメタ:** P7-2 で `held_on` 暦日差に統一。祝日・当日の細則は必要なら別記。  
3. **`DASHBOARD_REQUIREMENTS.md`:** INDEX とコードコメントが参照するがファイル未検出 — 削除・統合・復活のどれか。  
4. **リードパネル:** モック非掲載の機能を Dashboard に置き続けるか、別画面へ移すか。

---

*作成: ONETOONES_P7_DASHBOARD_FIT_AND_GAP（ドキュメントのみ）。*
