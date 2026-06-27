# フィット＆ギャップ：1to1 実施後記録のマルチユーザー化（SPEC-020）

**調査日:** 2026-06-27 10:11 JST  
**要件 SSOT:** [ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md](ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md)（SPEC-020）  
**比較対象:** 現行実装（`www/`）、既存 SSOT（SPEC-010〜014・019）、`docs/meetings/1to1/` 運用

---

## 1. サマリ

| 領域 | Fit（既にある） | Gap（足りない） |
|------|----------------|-----------------|
| **DB 1to1 行** | `one_to_ones` + `notes` | `raw_summary`・`summary_source`・draft 列 |
| **プライバシー** | データは `owner_member_id` 付き | **API/UI で owner 強制なし**・admin が Owner 切替で他人分閲覧可 |
| **owner スコープ系機能** | 接触履歴・紹介・フラグ等も `owner_member_id` を持つ | `contact_memos` / `introductions` / `internal_referrals` / Dashboard 等も **認証外・任意 owner 指定** が残る |
| **権限ロール** | `users.religo_role` と `chapter_admin` middleware は存在 | 適用範囲がほぼ `/api/admin/users/{user}` のみ。業務 API 全体の role enforcement は未確立 |
| **入力** | Edit の `notes` 手入力・Zoom 要約取得 | **コピペ専用 UX**・Meet/My Notes 向け導線 |
| **AI** | 事前準備原稿・BYO key（SPEC-013） | **実施後要約の AI 校正** |
| **定例会** | `meeting_minutes` + admin import（SPEC-014） | 変更不要（意図的 Fit） |
| **ファイル運用** | `import-1to1-notes`・series-markdown API | メンバー向け DB 正・リポジトリ非依存 |

**結論:** ドメインモデルと Zoom/AI の基盤はかなり揃っている。一方で、1to1 だけでなく接触履歴・紹介・Dashboard など owner スコープ系機能全体に **認可境界の確立**が必要。実施後記録 UX（コピペ + AI 校正）はその上に載せる。

---

## 2. 機能別 Fit / Gap

### 2.1 保存先・データモデル

| 要件（SPEC-020） | 現状 | Fit/Gap |
|------------------|------|---------|
| 確定本文は DB（Markdown） | `one_to_ones.notes`（longtext） | **Fit** |
| 貼り付け原文を保持 | なし（`notes` のみ） | **Gap** — `raw_summary` 等の新規列 |
| 1回 = 1 `one_to_ones` 行 | DATA_MODEL §4.12・既存運用 | **Fit** |
| 相手共通シリーズ文脈 | `series-markdown` API・`contact_memos` | **Fit**（SPEC-019 P3 実装済み） |
| リポジトリ md を正とする | `docs/meetings/1to1/` + import CLI | **Gap** — メンバー運用では DB を正に切替 |
| マルチセッション import | SPEC-019 draft・parser 一部実装 | **部分 Fit** — CLI/UI とも未完了 |

**参照:** `www/database/migrations/2026_03_04_100004_create_one_to_ones_table.php`、`OneToOneSeriesMarkdownService`

---

### 2.2 プライバシー・認可

| 要件（SPEC-020） | 現状 | Fit/Gap |
|------------------|------|---------|
| 本人のみ 1to1 閲覧 | `GET /api/one-to-ones` は **認証なし**で呼べる。`owner_member_id` はクエリ任意 | **Gap（重大）** |
| show/update の owner チェック | `OneToOneController::show/update` に **owner 検証なし** | **Gap（重大）** |
| ログインユーザー = Owner 固定 | SPEC-003 グローバル Owner 選択。admin は **全 member に切替可** | **Gap** |
| Zoom 取込はユーザー単位 | `auth:sanctum` + `user_id` スコープ（`ZoomImportController`） | **Fit** |
| 事前準備・リファーラル AI | `owner_member_id` 一致チェックあり（`OneToOnePrepController` 等） | **Fit**（1to1 CRUD 本体には未適用） |
| acting user フォールバック | `ReligoActorContext` が user id 昇順先頭にフォールバック可 | **Gap** — 本番は `acting_user_fallback=false` 必須 |

**参照:** `www/routes/api.php` L237–245（one-to-ones は sanctum 外）、`ReligoActorContext.php`、`ADMIN_GLOBAL_OWNER_SELECTION.md`

---

### 2.2.1 Religo 権限構造の As-Is

2026-06-27 10:50 JST 時点の確認では、Religo の権限は「列と middleware はあるが、アプリ全体へはまだ適用されていない」状態。

| 項目 | 現行実装 | Fit/Gap |
|------|----------|---------|
| ロール定義 | `User::RELIGO_ROLE_MEMBER = member` / `User::RELIGO_ROLE_CHAPTER_ADMIN = chapter_admin` | **部分 Fit** — 初版ロールとしては十分 |
| `region_admin` | 未定義 | **Gap（将来）** — 東京NE展開時に別 Spec が必要 |
| admin middleware | `EnsureReligoChapterAdmin` が `actingUser()->religo_role` を判定 | **Fit** — 仕組みは存在 |
| 適用済み route | `Route::middleware('religo.chapter_admin')->prefix('admin')` 配下の `PATCH /api/admin/users/{user}` | **Gap** — 適用範囲が狭すぎる |
| 認証済み本人スコープ | Zoom / AI credentials / 1to1 prep / referral suggestions は `auth:sanctum` 配下 | **Fit** |
| 無認証業務 API | 1to1 CRUD、接触履歴、紹介、Dashboard、Members / Categories / Roles / Meetings 編集など | **Gap（重大）** |
| acting user fallback | `RELIGO_ACTING_USER_FALLBACK=true` では未認証時に users 先頭行へ fallback | **Gap（重大）** |
| Default user | ローカル DB に `religo_role=null` かつ次廣 owner と同じ `owner_member_id=37` の user が存在 | **Gap（重大）** — fallback と結合すると未認証で個人 owner として扱われ得る |

**実装上の意味:** P0 は UI role 分岐から始めるのではなく、まず API 側で「未認証を拒否する」「本人 owner 以外を拒否する」「admin 操作を `chapter_admin` のみにする」を確定する必要がある。

---

### 2.2.2 owner スコープ系機能全体の認可 Gap（横展開）

SPEC-020 §4.5 のとおり、1to1 以外にも `owner_member_id` を軸にした個人接触データが存在する。現状はデータモデル上は owner を持つが、API 境界はマルチユーザー前提として不十分。

| 機能 | ルート / 実装 | 現状 | Fit/Gap |
|------|--------------|------|---------|
| 接触履歴 | `GET/POST /api/contact-memos` / `ContactMemoController` | `owner_member_id` は request 指定。`auth:sanctum` 外 | **Gap（重大）** |
| 外部紹介 | `GET/POST/PATCH /api/introductions` / `IntroductionController` | `resolveOwnerMemberId()` は query 優先。`auth:sanctum` 外 | **Gap** |
| 内部リファーラル | `/api/internal-referrals` / `InternalReferralController` | owner フィルタはあるが認証境界なし | **Gap** |
| 接触フラグ | `/api/dragonfly/flags` / `DragonFlyContactFlagController` | query/body の `owner_member_id` に依存 | **Gap** |
| 接触サマリー | `/api/dragonfly/contacts/{target}/summary` | query の `owner_member_id` に依存 | **Gap** |
| Dashboard | `/api/dashboard/*` / `DashboardController` | `owner_member_id` query が acting user より優先 | **Gap** |
| Zoom 取込 | `/api/zoom/*` | `auth:sanctum` + `user_id` スコープ | **Fit** |
| AI 設定・1to1 prep | `/api/ai/credentials` / `/api/one-to-ones/{id}/prep/*` | `auth:sanctum` + owner 一致チェック | **Fit** |

**必要な共通対応:**

1. owner スコープ系 API を `auth:sanctum` 配下へ移す。
2. `owner_member_id` は query/body を信用せず、`auth()->user()->owner_member_id` からサーバ側で解決する。
3. route model binding で取得した行は `owner_member_id` 一致を必ず検証し、不一致は 403。
4. `ReligoActorContext` の fallback は本番で無効化する。

---

### 2.3 入力（コピペ・API）

| 要件（SPEC-020） | 現状 | Fit/Gap |
|------------------|------|---------|
| 要約コピペ UI | Edit フォームの `notes` テキスト（汎用） | **部分 Fit** — 専用「実施後記録」UX・`source_type` なし |
| Zoom 要約 API | `POST /api/zoom/imports/{id}/summary` → `notes` 反映。**OAuth 連携済みユーザーのみ**（既存 `auth:sanctum` + `zoom_accounts`） | **Fit**（ゲート方針は SPEC-020 §5.3 と一致） |
| Meet / My Notes API | 未実装 | **Gap** — コピペで代替（要件どおり MVP 外） |
| 下書き → 確定フロー | Zoom 要約は即 `notes` 反映可。draft 状態なし | **部分 Gap** |
| 管理者 CLI import | `dragonfly:import-1to1-notes` | **Fit**（次廣・移行用）。メンバー向けでは使わない |

**参照:** `ZoomImport.jsx`（要約取得ボタン）、`ImportOneToOneNotesCommand.php`

---

### 2.4 AI 校正

| 要件（SPEC-020） | 現状 | Fit/Gap |
|------------------|------|---------|
| BYO API key | `user_ai_credentials` + `/api/ai/credentials` | **Fit** |
| Zoom OAuth 連携ゲート | `zoom_accounts` + `/api/zoom/status`・未連携時 422 | **Fit**（実施後記録 UI への接続は Gap） |
| キー未設定時は AI 無効 | 事前準備・リファーラルで実装済み | **Fit**（実施後校正に未接続） |
| 実施後要約の AI 整形 | なし | **Gap** |
| 事前準備 AI 原稿 | `POST .../prep/generate`（SPEC-013） | **Fit**（別用途） |
| 自動確定禁止 | 事前準備は下書き表示 | **Fit** — 実施後も同方針で実装要 |

**参照:** `OneToOnePrepController.php`、`UserAiCredential.php`

---

### 2.5 定例会・チーム MTG（スコープ外の確認）

| 要件（SPEC-020） | 現状 | Fit/Gap |
|------------------|------|---------|
| 定例会は管理者のみ | `meeting_minutes` + `import-chapter-minutes`、Meetings UI 閲覧 | **Fit**（意図どおり） |
| メンバー全員が議事録編集 | 非目標・未実装 | **Fit** |
| チーム MTG | SPEC-018 draft | **Fit**（別トラック） |

---

### 2.6 UI / ナビゲーション

| 要件（SPEC-020） | 現状 | Fit/Gap |
|------------------|------|---------|
| 自分の 1to1 一覧 | `OneToOnesList` + `owner_member_id` フィルタ（クライアント） | **部分 Fit** — サーバ強制なし |
| メモモーダル（シリーズ全文） | SPEC-019 P3・`MarkdownView` | **Fit** |
| Zoom 取込画面 | `/zoom-import`（認証ユーザー） | **Fit** — メンバーへの案内・権限説明が必要 |
| 実施後記録セクション | なし（事前準備ブロックのみ Edit に存在） | **Gap** |

**参照:** `OneToOnesList.jsx`、`OneToOnesEdit.jsx`（`OneToOnePrepPanel`）

---

## 3. 既存 SSOT との関係

| SSOT | SPEC-020 との関係 |
|------|-------------------|
| SPEC-010 | **要実装:** サーバ owner 強制・一般ユーザー Owner 固定。1to1 だけでなく接触履歴・紹介・Dashboard へ横展開 |
| SPEC-012 | Zoom 要約取得は **再利用**。Meet 第三者会議は API 対象外の可能性 |
| SPEC-013 | BYO key・下書き方針を **実施後校正に横展開** |
| SPEC-014 | **変更なし**（定例会は管理者） |
| SPEC-019 | シリーズ表示は Fit。import CLI 拡張は次廣移行と並行可 |
| SPEC-003 | 一般ユーザーでは Owner 切替 **無効化**が SPEC-020 と整合 |
| SPEC-006 / workspace 階層 | 他チャプター・東京NE展開時は `workspace` / `region` 境界が必須。DragonFly PoC に閉じない |

---

## 4. 推奨実装順（Gap 解消）

| 順 | 優先度 | 内容 | 理由 |
|----|--------|------|------|
| 1 | **P0-A** | `RELIGO_ACTING_USER_FALLBACK=false` 前提化 + Default ユーザー処理 | 未認証時に users 先頭行へ fallback する経路を先に閉じる |
| 2 | **P0-A** | owner スコープ系 API 全体を `auth:sanctum` 配下へ移す | ログイン UI 迂回を止める。全機能の前提 |
| 3 | **P0-A** | `owner_member_id` をサーバ側で固定 | query/body 改ざんと Owner なりすましを止める。`PATCH /users/me` で owner / workspace を一般 user が変えられないようにする |
| 4 | **P0-A** | route model binding 行の owner 一致チェック（不一致 403） | 詳細・更新・メモ追記の横断防御 |
| 5 | **P0-A** | admin API へ `religo.chapter_admin` を適用 | role 列を実効権限にし、一般 member の直接 API 操作を拒否する |
| 6 | **P0-B** | `religo_role` による UI 分離 | 一般 member に管理機能を出さない |
| 7 | **P0-B** | 一般ユーザーの Owner 固定 UI | 誤閲覧・なりすまし操作を防ぐ |
| 8 | **P0-B** | Member / Categories / Roles / Meetings 編集 UI を admin 限定 | マスタ・例会データの破壊を防ぐ |
| 9 | **P0-C** | `members.email` 整備または招待フロー | 180 名中 177 名が自己登録できない問題を解消 |
| 10 | **P0-C** | 一般 member のメニュー整理 | SONAE / merge / 管理系 Settings を隠し、誤操作を減らす |
| 11 | **MVP** | Edit に「実施後記録」: コピペ → `notes` 保存 | メンバーが最初に使える価値 |
| 12 | **P1** | `raw_summary` / `summary_source` 追加 | 原文と校正後 Markdown を分離 |
| 13 | **P2** | `POST .../minutes/polish`（BYO key）+ プレビュー UI | AI 校正 |
| 14 | **P3** | Zoom 要約取得を実施後記録フローに統合 | OAuth 連携済みユーザー向け拡張 |
| 15 | **P4** | multi-workspace / region 展開設計 | DragonFly 固有名・workspace/region 境界・region_admin 拡張を整理 |

**最小リリース条件:** DragonFly メンバーへ試験展開する場合でも、**順位 1〜10 は先行必須**。順位 11 以降は P0 完了後に段階的に出す。他チャプター・東京NEリージョン展開前には **順位 15** も必須。

### 4.1 フェーズ別実装計画案

| Phase 案 | 対象順位 | 主な変更 | 検証 |
|----------|----------|----------|------|
| Phase A: Auth Boundary Hardening | 1〜2 | `ReligoActorContext` fallback 本番無効化、Default ユーザー処理、owner スコープ系 route の `auth:sanctum` 化 | 未認証 401/403、ログイン済み本人は従来データ閲覧可 |
| Phase B: Owner Enforcement | 3〜4 | owner 解決の共通化、query/body owner 無視、route model owner 検証 | 他 owner 指定が無視/403、1to1・接触履歴・紹介・Dashboard の owner 境界 test |
| Phase C: Admin API Role Enforcement | 5 | Member / Categories / Roles / Meetings 編集 API に `chapter_admin` 強制 | member は編集 403、chapter_admin は従来操作可 |
| Phase D: Member UI Separation | 6〜8 / 10 | メニュー・ルート・Owner selector・編集画面の role 分岐 | React build、member UI に管理導線なし |
| Phase E: Onboarding Preparation | 9 | email 整備方針 or 招待フロー設計/実装 | 試験配布対象ユーザーがログインできる |
| Phase F: 1to1 Minutes MVP | 11 | 実施後記録セクション、コピペ → `notes` 保存 | 自分の 1to1 のみ保存・閲覧・編集可 |
| Phase G: Raw Summary Data Model | 12 | `raw_summary` / `summary_source` 追加 | 原文と確定 Markdown が分離保存される |
| Phase H: AI Polish | 13 | BYO key gate 付き AI 校正 API/UI | key ありのみ実行、未設定は手動保存 |
| Phase I: Zoom Summary Integration | 14 | Zoom 要約取得を実施後記録下書きへ接続 | OAuth 連携済みのみ取得可 |
| Phase J: Multi-workspace / Region Design | 15 | 汎用 API 名、workspace/region、`region_admin` Spec | 他チャプター展開前の設計判断が文書化される |

---

## 5. リスク・注意

1. **既存データ:** `one_to_ones` には次廣（`owner_member_id=37` 等）の履歴が多数。認可導入後も **本人は従来どおり閲覧**できること。
2. **admin 運用:** 次廣の Cursor → md → import 運用は **移行期間並行**可能。他メンバーには DB 直接登録を案内。
3. **Zoom コメント誤記:** `ZoomImportController`  docblock に `chapter_admin` とあるがルートは `auth:sanctum` のみ — **実装はユーザー単位で正しい**（コメント修正候補）。
4. **テスト:** `OneToOneIndexTest` 等は owner フィルタ前提。認可ミドルウェア追加時に **403 ケース**を追加する。
5. **横断回帰:** 接触履歴・紹介・Dashboard は現行 UI が `owner_member_id` query に依存している可能性がある。サーバ owner 固定に合わせて React 側の不要 query を整理する。

---

## 6. DragonFly メンバー展開時の問題点（2026-06-27 調査）

SPEC-020 §11 と対応。1to1 以外も含め、**現状のままメンバーに配布すると問題になる箇所**。

### 6.1 重大（セキュリティ・プライバシー）

| ID | 領域 | 現状 | メンバー利用時の問題 |
|----|------|------|---------------------|
| G1 | **API 認証** | 大半の Religo API が `auth:sanctum` 外（`routes/api.php` L194〜） | ログイン UI を迂回し **curl 等で全 API 操作可能** |
| G2 | **acting user フォールバック** | `RELIGO_ACTING_USER_FALLBACK` デフォルト `true` | 未認証時に **users 先頭行**が acting user になる |
| G3 | **owner なりすまし** | `PATCH /api/users/me` で任意 `owner_member_id` | 他人の 1to1・接触履歴・紹介・Dashboard を **正規 API で閲覧** |
| G4 | **owner クエリ改ざん** | `contact-memos`・`introductions`・`dashboard/*`・`dragonfly/flags` 等 | `?owner_member_id=` 指定で **他人データ取得** |
| G5 | **1to1 CRUD** | `OneToOneController` に owner 検証なし | 他人の `one_to_ones` を **ID 指定で show/update** 可能 |
| G5b | **Default user** | `religo_role=null` かつ次廣 owner と同じ `owner_member_id=37` の user が存在 | fallback 時に **次廣 owner の個人データへ未認証アクセス**する経路になる |

**参照:** `UserController::updateMe`、`ContactMemoController`、`IntroductionController`（`ResolvesReligoOwner` は query 優先）、`ReligoActorContext`

### 6.2 高（権限・マスタ破壊）

| ID | 領域 | 現状 | メンバー利用時の問題 |
|----|------|------|---------------------|
| G6 | **UI role 分岐なし** | `religo_role` を React が参照しない | **全メニュー**（Meetings 編集・Categories・SONAE・merge 等）が表示される |
| G7 | **Member マスタ編集** | `PUT /api/dragonfly/members/{id}` 無認可 + `MemberEdit` 全員可 | 他メンバーの **名前・email・カテゴリ・役職**を変更可能 |
| G8 | **Categories / Roles** | CRUD API 無認可 | チャプター共通マスタの **作成・削除**が可能 |
| G9 | **Meetings 運用** | 例会 store/update・CSV import・BO 割当 API 無認可 | 定例会データ・参加者・BO の **破壊的操作**が可能 |
| G10 | **グローバル Owner UI** | `CustomAppBar` が全 member を Select | 意図せず **他人視点**で Members / Dashboard を操作 |
| G10b | **API role enforcement 不足** | `religo.chapter_admin` は `/api/admin/users/{user}` ほぼ 1 本のみ | UI を隠しても一般 member が管理 API を直接呼べる |

**参照:** `ReligoMenu.jsx`、`MemberEdit.jsx`、`MeetingController`、`CustomAppBar.jsx`

### 6.3 中（オンボーディング・UX・製品範囲）

| ID | 領域 | 現状 | メンバー利用時の問題 |
|----|------|------|---------------------|
| G11 | **自己登録** | `members.email` 登録 **3 / 180**（2026-06-27 DB） | SPEC-011 登録が **ほぼ全員使えない** |
| G12 | **users 実績** | `users` **2 件**のみ | マルチユーザー挙動の **テスト・運用実績なし** |
| G13 | **1to1 Owner 欄** | Create で全 member から Owner 選択可 | なりすまし記録・混乱（`OneToOneFormFields` L57–67） |
| G14 | **メニュー過多** | SONAE 全画面・Member merge・Zoom 等が同列 | 一般 member に **不要・危険な導線**が露出 |
| G15 | **Members 接触情報** | `summary_lite.last_memo` は owner スコープだが owner 切替と連動 | G3/G4 未修正時は **他人のメモ断片**が見える |
| G16 | **所属 workspace 変更** | `PATCH /api/users/me` で `default_workspace_id` 変更可 | チャプター所属の **意図しない切替**（要 admin 制限検討） |
| G17 | **DragonFly 固有 API 名** | `/api/dragonfly/*`・`DragonFlyMemberController` が中心 | 他チャプター展開時に Religo 汎用機能として扱いにくい |
| G18 | **workspace / region 境界** | Dashboard・Members summary・Meetings で workspace の使い方が揺れる | 他チャプター・東京NE全体でデータ混在や集計不一致のリスク |
| G19 | **リージョン権限** | `region_admin` 相当が未定義 | 東京NE全体で管理するユーザー権限が設計できていない |

### 6.4 問題なし／意図どおり（参考）

| 領域 | 現状 | 判定 |
|------|------|------|
| Zoom / AI credentials | `auth:sanctum` + ユーザー単位 | **Fit** — 本人連携のみ |
| 1to1 prep / referral AI | owner 一致チェック | **Fit** — CRUD 本体に未適用 |
| Member merge API | `X-Religo-Member-Merge-Token` 必須 | **Fit**（UI 露出は G14） |
| `/admin/*` user 管理 | `religo.chapter_admin` | **Fit** |
| 定例会議事録閲覧 | `meeting_minutes` 閲覧 API | **Fit** — 編集制限は G9 |

### 6.5 メンバー展開前の推奨順（P0）

1. G2・G5b（fallback 停止 + Default ユーザー処理）
2. G1・G3〜G5（API 認証 + owner 固定 + owner 不一致 403）
3. G7〜G9・G10b（admin API の `chapter_admin` 強制）
4. G6・G10（UI role + Owner 固定）
5. G11（email 整備 or 招待）
6. G13〜G14（1to1 UX・メニュー整理）
7. その後 SPEC-020 MVP（1to1 実施後記録）

### 6.6 他チャプター・東京NE展開前の追加 Gap

DragonFly 内テストは PoC として妥当だが、他チャプター・東京NEリージョンへ広げるには、以下を追加で整理する必要がある。

| 項目 | 現状 | 展開前に必要なこと |
|------|------|-------------------|
| API 名 | `/api/dragonfly/*` が多数 | 新規 API は `workspace` / `members` など汎用名へ。既存は互換 alias として残す方針を検討 |
| テナント境界 | `workspace_id` は存在するが、機能ごとの使い方が異なる | workspace をチャプター境界、region を上位境界として統一 |
| Dashboard | stale / summary の workspace スコープに過去議論あり | チャプター内 KPI とリージョン横断 KPI を分ける |
| マスタ | Categories / Roles がチャプター固有かリージョン共通か未整理 | 東京NE全体展開前にスコープを定義 |
| 権限 | `member` / `chapter_admin` 中心 | 将来の `region_admin` と操作可能 workspace 範囲を別 Spec 化 |
| 名簿 | DragonFly の `members` 前提 | 他チャプター名簿取込・重複・同一人物の複数 workspace 所属を整理 |

**判定:** DragonFly PoC では互換維持でよい。ただし、設計判断は常に **workspace / region 展開を妨げない形**にする。

---

## 7. 変更履歴

| 日時 (JST) | 内容 |
|------------|------|
| 2026-06-27 10:11 | 初版（SPEC-020 要件に対する As-Is 実装比較） |
| 2026-06-27 10:12 | Zoom OAuth ゲートを Fit として明記（AI BYO key と同型） |
| 2026-06-27 10:30 | 接触履歴・紹介・内部リファーラル・Dashboard など owner スコープ系機能全体の認可 Gap を追記（現 §2.2.2） |
| 2026-06-27 10:31 | §6 DragonFly メンバー展開時の問題点調査（API 無認可・role 未使用・email 3/180・マスタ編集露出等） |
| 2026-06-27 10:36 | §4 推奨実装順を P0-A/B/C と当時の順位 1〜12 に整理 |
| 2026-06-27 10:37 | 他チャプター・東京NEリージョン展開前の Gap（DragonFly 固有 API、workspace/region 境界、region_admin）を追記 |
| 2026-06-27 10:50 | Religo 権限構造 As-Is（ロール定義・middleware 適用範囲・未認証 fallback・Default user risk）を §2.2.1 に追記し、推奨順を順位 1〜15 とフェーズ別実装計画案へ再整理 |
