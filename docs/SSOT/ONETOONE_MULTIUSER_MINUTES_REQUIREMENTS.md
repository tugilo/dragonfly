# SPEC-020 — 1to1 実施後記録のマルチユーザー化（要約取込・AI 校正・プライベート保存）

**Status:** draft（要件確定・実装未着手）  
**作成:** 2026-06-27 10:11 JST  
**起案:** 次廣淳（DragonFly / Religo 運用）  
**Related SSOT:**

| Spec | 内容 |
|------|------|
| [AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md](AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md)（SPEC-010） | ログインユーザーと `owner_member_id` の紐づけ・サーバ強制 |
| [ZOOM_ONETOONE_SYNC_REQUIREMENTS.md](ZOOM_ONETOONE_SYNC_REQUIREMENTS.md)（SPEC-012） | Zoom 予定・実施・要約取込（ユーザー単位 OAuth） |
| [ONETOONE_PREP_PROFILE_REQUIREMENTS.md](ONETOONE_PREP_PROFILE_REQUIREMENTS.md)（SPEC-013） | 事前準備・BYO AI key・原稿生成 |
| [ONETOONE_MULTI_SESSION_IMPORT_REQUIREMENTS.md](ONETOONE_MULTI_SESSION_IMPORT_REQUIREMENTS.md)（SPEC-019） | 1相手1ファイル・`### 【第N回】` と `one_to_ones` の対応 |
| [CHAPTER_MINUTES_REQUIREMENTS.md](CHAPTER_MINUTES_REQUIREMENTS.md)（SPEC-014） | 定例会議事録（管理者運用・別ドメイン） |
| [meetings/1to1/README.md](../meetings/1to1/README.md) | 現行 Markdown 運用・命名規約 |

> **位置づけ:** 現状、次廣が Cursor 上で Zoom / Meet / My Notes 等の要約を校正し `docs/meetings/1to1/*.md` を作成 → `dragonfly:import-1to1-notes` で DB 反映、という **単一オペレータ運用** になっている。本 Spec は **DragonFly メンバー各自が自分の 1to1 記録を Religo 上で登録できる** ようにするための要件。定例会・チーム MTG 議事録は当面 **管理者のみ**（本 Spec のスコープ外）。

---

## 1. 背景（As-Is）

| 項目 | 現状 |
|------|------|
| **記録作成** | 次廣が Cursor + AI で Markdown を作成・校正 |
| **ファイル保管** | `docs/meetings/1to1/1to1_*.md`（リポジトリ内・実質オペレータ専用） |
| **DB 反映** | Artisan `dragonfly:import-1to1-notes`（手動・管理者運用） |
| **1to1 本体** | `one_to_ones` 行（`owner_member_id` × `target_member_id` × 回）+ `notes`（当該回の本文） |
| **Zoom 連携** | ユーザー単位 OAuth・取り込み UI（`/zoom-import`）・要約取得ボタン（SPEC-012 実装済み） |
| **AI 利用** | **事前準備**原稿生成（SPEC-013）・リファーラル提案（SPEC-015）。**実施後要約の AI 校正は未実装** |
| **閲覧境界** | 管理画面はグローバル Owner 選択（SPEC-003）。**ログインユーザー固定のプライベート境界は未確立** |

### 1.1 課題

1. **ハードル:** メンバー全員に Cursor + Markdown 運用を求めるのは現実的でない。
2. **プライバシー:** 「誰といつ 1to1 したか」は本人以外（他メンバー・管理者含む）に見えてはならない。
3. **入力源の多様性:** Zoom 本体 / Google Meet 上の Zoom My Notes / 手書きメモなど、要約の出所が人によって異なる。
4. **運用分離:** 定例会議事録は 1 人が登録すればよい。121 だけマルチユーザー化すればよい。

---

## 2. 目的（To-Be）

| # | 目的 |
|---|------|
| G1 | 各メンバーが **自分の 1to1 実施記録**を Religo 上で登録・閲覧・編集できる |
| G2 | **誰といつ 1to1 したか**は登録者本人のみ閲覧可能（デフォルト `private`） |
| G3 | 要約の入力ハードルを下げる（**コピペ**を MVP、**API 取得**は拡張） |
| G4 | Religo 上で **AI 校正・Markdown 整形**し、DB に保存（下書き → 確認 → 確定） |
| G5 | 定例会・チーム MTG 議事録は **管理者運用のまま**（本 Spec では変更しない） |
| G6 | DragonFly 内テストに閉じず、**他チャプター・東京NEリージョン全体へ展開可能な設計**にする |

### 2.1 非目標

- 全メンバーへの `docs/meetings/1to1/*.md` リポジトリ書き込み権限の付与
- 1to1 記録の **メンバー間自動共有**（将来の明示共有は別 Spec）
- 管理者による全員分 1to1 の一覧閲覧（監査・法務要件が出た場合は別 Spec）
- Google Meet / My Notes 専用 API 連携（初版。Zoom Meeting Summary API も Meet 上の要約とは別物の可能性あり）
- 定例会・チーム MTG のマルチユーザー編集

---

## 3. スコープ分割（合意方針）

| ドメイン | マルチユーザー | 登録者 | 保存先 | 備考 |
|----------|----------------|--------|--------|------|
| **1to1 実施記録** | **Yes** | 各メンバー（本人） | DB（正） | 本 Spec |
| **定例会議事録** | No | 管理者（当面は次廣） | `meeting_minutes` + CLI import | SPEC-014 維持 |
| **チーム MTG 議事録** | No | 管理者 | 同上（SPEC-018 予定） | 本 Spec 外 |
| **1to1 事前準備原稿** | 将来 Yes（SPEC-013 拡張） | 各メンバー | 添付 + `notes`/メモ | 本 Spec と整合 |

### 3.1 展開スコープ（DragonFly → 他チャプター → 東京NE）

本 Spec は **DragonFly メンバー内テストを最初の運用単位**とするが、設計上は DragonFly 固有に閉じない。

| 段階 | 対象 | 目的 | 設計上の要件 |
|------|------|------|--------------|
| **Stage 1: DragonFly PoC** | DragonFly メンバー | 1to1 実施後記録・AI 校正・Zoom 取込の実運用検証 | 既存データを壊さず、次廣の現行運用と並行可能 |
| **Stage 2: 他チャプター展開** | 東京NE 内の別チャプター | チャプターごとの名簿・接触履歴・1to1 を分離 | `workspace_id` をテナント境界として扱い、DragonFly 固有名に依存しない |
| **Stage 3: 東京NEリージョン展開** | 複数チャプター横断 | リージョン内の複数チャプターで利用 | `regions` / `workspaces` 階層を前提に、権限を member / chapter_admin / region_admin（将来）へ拡張可能 |

**非交渉条件:**

- **個人データの境界:** 1to1・接触履歴・紹介・AI 原文は、チャプターやリージョンが広がっても **owner 本人のみ**を既定とする。
- **テナント境界:** Members / Meetings / Categories / Roles / Dashboard は、最低でも **workspace（チャプター）単位**で分離する。
- **命名:** UI や API の表層に `DragonFly` 固有名を残さず、Religo の一般機能として扱えるようにする。内部既存 API 名は移行期間のみ許容。
- **権限拡張:** 初版は `member` / `chapter_admin` でよいが、東京NE展開時に `region_admin` 相当を追加できる余地を残す。

---

## 4. プライバシー・認可要件（Must）

### 4.1 基本原則

- 1to1 実施記録は **`owner_member_id` = 登録者の `users.owner_member_id`** に紐づく。
- **閲覧・更新・削除（キャンセル）・要約取込・AI 校正**は、**当該 owner のログインユーザーのみ**許可する。
- **相手（`target_member_id`）** に自動公開しない。相手が Religo ユーザーでも、相手側の一覧には出さない。
- **chapter_admin** であっても、他ユーザーの 1to1 記録本文・相手・日時を **アプリ UI から閲覧しない**（初版）。

### 4.2 サーバ強制（SPEC-010 整合）

| 操作 | 要件 |
|------|------|
| `GET /api/one-to-ones` | 認証必須。`owner_member_id` は **常に acting user の owner に固定**（クエリ改ざん不可） |
| `GET/PATCH /api/one-to-ones/{id}` | `one_to_ones.owner_member_id === auth user owner` のみ 200。他は **403** |
| 要約取込・AI 校正 API | 同上 |
| `series-markdown` | 同一 owner × target の **自分のシリーズのみ** |

### 4.3 UI 要件

- グローバル Owner 選択（SPEC-003）は、一般ユーザーでは **自分の `owner_member_id` に固定**（切替不可）。
- `chapter_admin` の Owner 切替は、**1to1 記録画面では無効化**するか、1to1 系 API は常にログインユーザー owner にスコープする。

### 4.4 データ分類

| データ | 分類 | 備考 |
|--------|------|------|
| 相手名・日時・status | **個人接触履歴** | 本人のみ |
| `raw_summary`（貼り付け原文） | **個人** | AI 送信時も本人操作のみ |
| `polished_markdown` / `notes` | **個人** | Religo 内 Markdown 表示の正 |

### 4.5 owner スコープ系機能への横展開（Must）

1to1 実施記録だけを本人限定にしても、同じ `owner_member_id` を使う周辺機能から他ユーザーの接触状況が見えると、プライバシー要件は満たせない。そのため、本 Spec の認可方針は **1to1 に限定せず、owner スコープ系機能全体へ適用**する。

| 機能 | 対象データ | 要件 |
|------|------------|------|
| 接触履歴 | `contact_memos` | `owner_member_id` はログインユーザーの owner にサーバ側で固定。任意指定不可 |
| 1to1 | `one_to_ones` / `one_to_one_attachments` / 1to1 memos | 本 Spec §4.2 のとおり本人のみ |
| 外部紹介 | `introductions` | 自分 owner の紹介のみ閲覧・作成・更新 |
| 内部リファーラル | `internal_referrals` | 自分 owner の記録のみ閲覧・作成・更新 |
| 接触フラグ・サマリー | `dragonfly_contact_flags` / contact summary | 自分 owner のフラグ・サマリーのみ |
| Dashboard | stats / tasks / activity / weekly presentation | 自分 owner の集計のみ。クエリで他 owner を指定しても無視または 403 |

**実装方針:**

- owner スコープ系 API は原則 `auth:sanctum` 配下に置く。
- `owner_member_id` は request query/body ではなく **`auth()->user()->owner_member_id` を正**とする。
- 管理者向けに他 owner を見る必要がある場合は、一般画面とは別に **明示的な admin API** と監査前提の別 Spec を切る。
- `ReligoActorContext` の `acting_user_fallback` は開発用に限定し、本番では無効化する。

---

## 5. 入力要件

### 5.1 MVP: コピペ取込（Must）

| 項目 | 要件 |
|------|------|
| 入口 | 1to1 Edit または専用「実施後記録」パネル |
| 入力 | テキストエリアに Zoom / Meet / My Notes / 手書き要約を **貼り付け** |
| `source_type` | `paste` / `zoom_summary` / `meet_my_notes` / `manual` 等（enum・拡張可） |
| 保存 | 貼り付け時点で `raw_summary`（または draft）に保存。確定前は `status` または `draft` フラグで区別可 |
| ハードル | **Markdown 知識不要**。プレーンテキストでよい |

### 5.2 拡張: Zoom API 取得（Should・Phase 2 以降・**Zoom 連携ゲート**）

| 項目 | 要件 |
|------|------|
| Zoom Meeting Summary | **Zoom OAuth 連携済み**ユーザーが「要約取得」→ `raw_summary` に下書き投入（既存 `/api/zoom/imports/{id}/summary` の拡張・再利用） |
| Google Meet / My Notes | **専用 API が不安定なため MVP 外**。コピペで代替 |
| 権限 | **各ユーザーが自分の OAuth** で取得。管理者が全員分を代取りしない |
| **Zoom 連携** | `zoom_accounts`（OAuth トークン）が **有効に接続されているユーザーのみ**ボタン有効（SPEC-012・Phase 152 と同型） |
| 未連携時 | ボタン disabled + 「設定 → Zoom 連携」導線。**コピペ保存は可能** |
| タイミング | 要約生成完了まで `NOT_READY` 等を表示し再試行 or Webhook（SPEC-012 参照） |

**AI 校正（§6）と同じゲート方針:** 外部連携（Zoom OAuth / AI BYO key）は **本人が正しく設定した場合のみ** API 機能を有効化する。Religo 共通の Zoom アプリ資格情報で全員分を代取得しない。

**参照:** [ZOOM_ONETOONE_SYNC_REQUIREMENTS.md](ZOOM_ONETOONE_SYNC_REQUIREMENTS.md) §6（`user_zoom_credentials`・OAuth）、`POST /api/zoom/sync`・`GET /api/zoom/status`

---

## 5.3 外部連携のゲート方針（合意）

| 機能 | ゲート | 未設定時 |
|------|--------|----------|
| **要約コピペ保存** | なし（ログイン + owner のみ） | — |
| **Zoom 要約 API 取得** | Zoom OAuth 連携済み（`zoom_accounts` 有効） | コピペで代替 |
| **AI 校正** | `user_ai_credentials` 有効 | 手動編集・コピペのみ |

両方の API 連携は **ユーザー各自の契約・認可に帰属**し、Religo が共通キーで無償提供しない（初版）。

---

## 6. AI 校正モード（Should・BYO key ゲート）

### 6.1 方針

- **実施後要約**を Religo 定型 Markdown（BNI / 1to1 向け構造）に整形する **「AI 校正」** を提供する。
- **事前準備の原稿生成（SPEC-013）とは別機能**とする（プロンプト・出力セクションが異なる）。

### 6.2 利用条件

| 条件 | 要件 |
|------|------|
| 認証 | ログイン済み |
| Owner 一致 | 当該 1to1 の owner のみ |
| **AI API キー** | `user_ai_credentials` が **有効に設定されているユーザーのみ**ボタン有効（SPEC-013 R9 と同型） |
| キー未設定時 | ボタン disabled + 「設定 → AI 連携で API キーを登録」導線。**手動編集・コピペ保存は可能** |

### 6.3 処理フロー

1. ユーザーが `raw_summary`（貼り付け or API 取得）を用意
2. **「AI で校正」** を実行（非同期可）
3. サーバが LLM に送信 → `polished_markdown` **下書き**を返却
4. ユーザーがプレビューで確認・手修正
5. **「保存」** で `one_to_ones.notes`（および必要なら `raw_summary` 列）に確定

### 6.4 AI 校正の出力イメージ（例）

- 実施日時・方法（オンライン/対面）
- 話題サマリー
- 相手ビジネス理解・紹介につながる点
- 決定事項・次アクション
- （任意）リファーラル示唆のメモ

テンプレート詳細は実装 Phase で `docs/meetings/1to1/_TEMPLATE.md` および既存議事録から抽出する。

### 6.5 コスト・責任

- API コストは **各ユーザーの BYO key** に帰属（SPEC-013 と同じ）
- Religo 共通キーでの無償提供は **初版スコープ外**

---

## 7. データモデル（案）

### 7.1 正の保存先: DB

| 概念 | 初版案 | 備考 |
|------|--------|------|
| 当該回の確定本文 | `one_to_ones.notes` | 既存列を継続利用（Markdown） |
| 貼り付け原文 | `one_to_ones.raw_summary`（**新規列**）または `one_to_one_minute_drafts` 子テーブル | 実装 Phase で選択 |
| 校正下書き | `one_to_ones.polished_draft`（新規・nullable）または draft テーブル | 確定前のみ |
| 入力元 | `one_to_ones.summary_source`（新規 enum） | `paste` / `zoom_api` / … |
| シリーズ共有文脈 | `contact_memos`（`one_to_one_id = null`） | SPEC-019 §4.5 維持 |

### 7.2 ファイル（`docs/meetings/1to1/`）

| 用途 | 方針 |
|------|------|
| 次廣の既存運用 | **移行期間は継続可**（import コマンドは管理者用バックフィルとして残す） |
| 一般メンバー | **書き込み不要**。DB が正 |
| エクスポート | 将来「Markdown ダウンロード」で代替（初版 Must ではない） |

### 7.3 `one_to_ones` 行の作成

- ユーザーは **相手（target）・日時**を指定して `planned` または `completed` を作成（既存 Create UX）。
- 実施後記録は **既存行への追記**が基本。新規 completed 行のクイック作成も可（既存 Quick Create 拡張）。

---

## 8. UX 要件（MVP）

### 8.1 画面

| 画面 | 要件 |
|------|------|
| 1to1 一覧 | **自分の行のみ**。相手名・日時・メモ有無 |
| 1to1 Edit | **「実施後記録」セクション**追加: 原文貼り付け → AI 校正（キーあり時）→ プレビュー → 保存 |
| 設定 | 既存 AI credentials（`/settings`）を流用 |
| Zoom 取込 | 既存 `/zoom-import` を一般ユーザー向けに開放（**Zoom OAuth 連携済みユーザーのみ**同期・要約取得可） |

### 8.2 下書きと確定

- AI 校正結果の **自動確定保存は禁止**（SPEC-013 R6 と同型）
- 離脱時の未保存警告（実装 Phase で検討）

---

## 9. 段階的リリース

| Phase | 内容 | 区分 |
|-------|------|------|
| **P0** | **メンバー展開ブロッカー解消**（§11.3〜§11.7）— API 認証・owner 固定・`religo_role` 別メニュー・`members.email` 整備 | **Must（先行）** |
| **MVP** | 認証 + owner スコープ強制、コピペ → `notes` 手動保存、一覧/編集は自分のみ | Must |
| **P1** | `raw_summary` 列・`summary_source`・実施後記録 UI セクション | Must |
| **P2** | AI 校正 API + UI（BYO key ゲート） | Should |
| **P3** | Zoom 要約取得を実施後記録フローに統合（既存 summary API 再利用） | Should |
| **P4** | Markdown エクスポート・SPEC-019 マルチセッション UI 連携 | Could |

---

## 10. 受け入れ条件（DoD・MVP）

- [ ] ユーザー A が登録した 1to1 は、ユーザー B の API / UI から **取得できない**（403）
- [ ] 一般ユーザーの Owner 選択は **固定**（自分の member のみ）
- [ ] 要約テキストを貼り付けて `notes` に保存できる
- [ ] `chapter_admin` が定例会議事録を従来どおり import / 閲覧できる（回帰なし）
- [ ] AI 校正は **API キー未設定ユーザーでは実行不可**（手動保存は可）
- [ ] Zoom 要約 API 取得は **OAuth 未連携ユーザーでは実行不可**（コピペは可）
- [ ] 一般メンバーが **他メンバーの接触履歴・1to1・紹介**を API / UI から閲覧できない
- [ ] 一般メンバーに **Meetings 編集・Categories/Roles 編集・Member マスタ編集**が露出しない

---

## 11. DragonFly メンバー展開の前提・ブロッカー

2026-06-27 時点のローカル DB 調査に基づく。**1to1 機能だけ実装しても、以下が未解決ならメンバー全員利用は不可。**

### 11.1 調査サマリ（As-Is）

| 指標 | 値 | 影響 |
|------|-----|------|
| `members` 総数 | 180 | — |
| `members.email` 登録済み | **3**（次廣・神保・遠藤） | 自己登録（SPEC-011）が **177 名で不可** |
| `users` 数 | **2** | マルチユーザー運用は未検証 |

### 11.2 Religo 権限構造の現状（As-Is）

現行実装の `religo_role` は存在するが、アプリ全体の認可境界としてはまだ成立していない。2026-06-27 10:50 JST 時点のコード確認では、以下の構造になっている。

| 領域 | 現状 | メンバー展開時の判断 |
|------|------|----------------------|
| ロール定義 | `users.religo_role` は `member` / `chapter_admin` の 2 種のみ | 初版は妥当。ただし東京NE展開時の `region_admin` は未定義 |
| ロール判定 | `EnsureReligoChapterAdmin` が `chapter_admin` のみ許可 | 仕組みはあるが適用範囲が狭い |
| 適用済み API | `PATCH /api/admin/users/{user}` のみ `religo.chapter_admin` 配下 | 他の管理系 API はロールで守られていない |
| 認証必須 API | Zoom 連携・AI credentials・1to1 prep / referral suggestions / SONAE など一部 | 本人スコープが成立している領域はある |
| 無認証 API | `one-to-ones` 本体、`contact-memos`、`introductions`、`internal-referrals`、Dashboard、Members / Categories / Roles / Meetings 編集など多数 | メンバー展開前に `auth:sanctum` 配下へ移す必要あり |
| acting user fallback | Bearer なしの場合、`users.id` 昇順先頭を acting user にできる（`RELIGO_ACTING_USER_FALLBACK=true` がデフォルト） | 本番・メンバー展開では禁止。Default ユーザーが個人 owner を持つ状態は特に危険 |
| `Default` ユーザー | ローカル DB に `religo_role=null` かつ次廣 owner と同じ `owner_member_id=37` のユーザーが存在 | fallback と組み合わさると未認証で次廣 owner として扱われるため、P0 で削除・無効化・owner 解除のいずれかが必要 |

**判定:** 現状の権限は「ロール列はあるが、業務 API 全体の認可境界としては未完成」。P0 では、UI の見た目より先に **API 認証必須化・fallback 無効化・owner サーバ固定・admin API 分離**を完了条件にする。

### 11.3 ブロッカー一覧

| # | 区分 | 問題 | 現状 | メンバー展開時の影響 | 対応方針 |
|---|------|------|------|---------------------|----------|
| B1 | **セキュリティ** | 主要 API が `auth:sanctum` 外 | `one-to-ones`・`contact-memos`・`introductions`・`dashboard/*`・`dragonfly/members` PUT 等 | UI ログインを迂回して **直接 API 呼び出し可能** | owner スコープ系 API を sanctum 配下へ。本番は `RELIGO_ACTING_USER_FALLBACK=false` |
| B2 | **プライバシー** | `owner_member_id` をクライアント指定 | query/body で任意 owner を渡せる | **他人の接触履歴・1to1・紹介・Dashboard**を閲覧可能 | §4.5 のサーバ owner 固定 |
| B3 | **プライバシー** | `PATCH /api/users/me` で owner 変更可 | 任意の `members.id` を `owner_member_id` に設定可能 | ヘッダー Owner 切替で **他人視点の全データ**にアクセス | 一般ユーザーは PATCH owner 禁止。`religo_role=member` は固定 |
| B4 | **権限設計** | `religo_role` の実効範囲が狭い | `chapter_admin` 判定は `/api/admin/users/{user}` ほぼ 1 本のみ | 一般 member でも管理系 API を直接呼べる | admin 系 API に `religo.chapter_admin` を適用し、member API と分離 |
| B5 | **UI** | グローバル Owner 選択 | 全メンバー（180 名）を Select 表示 | 「自分」ではなく **任意メンバー視点**で操作できる | 一般ユーザーは Owner 表示のみ（切替不可） |
| B6 | **マスタ編集** | Member 編集 API/UI 無制限 | `PUT /api/dragonfly/members/{id}` に認可なし。`MemberEdit` が全員に開放 | **他メンバーの氏名・メール・カテゴリ・役職**を改ざん可能 | `chapter_admin` のみ編集可 |
| B7 | **マスタ編集** | Categories / Roles CRUD 無制限 | `/api/categories`・`/api/roles` に認可なし | チャプター共通マスタを **一般メンバーが破壊可能** | 閲覧のみ or admin 限定 |
| B8 | **運用** | Meetings 管理 API 無制限 | 例会作成・更新・CSV 取込・BO 割当等が sanctum 外 | 定例会運用データを **一般メンバーが改ざん可能** | 閲覧は全員可、**編集は chapter_admin のみ**（SPEC-014 方針と整合） |
| B9 | **オンボーディング** | `members.email` 未整備 | 180 名中 3 名のみ | 初回登録（SPEC-011）が使えない | 名簿整備 or 管理者招待フローを先行 |
| B10 | **UX** | 1to1 Create の Owner 欄 | 「別メンバーで記録する場合のみ変更」と表示。全 member を選択可 | 誤操作・なりすまし記録の温床 | owner 固定 + `ownerInputDisabled` を既定 |
| B11 | **製品範囲** | SONAE・Member merge が全員メニューに表示 | SONAE API は sanctum 内だが UI は無条件表示。merge は別トークン | 無関係機能が多く **迷う・誤操作** | member 向けメニューから非表示 |
| B12 | **製品範囲** | Members / Connections の接触情報 | `with_summary=1` で **選択 owner の** last_memo 等を表示 | owner 切替と組み合わせると **他人のメモ断片**が見える | B2・B3 解消後も、一般 member は **自分 owner の summary のみ** |
| B13 | **テナント化** | DragonFly 固有 API / UI 名 | `/api/dragonfly/*`・`DragonFlyMemberController`・メニュー/文言に DragonFly 固有名が残る | 他チャプター展開時に **Religo 汎用機能として説明しにくい** | API/内部名の移行計画を作る（互換 alias 可） |
| B14 | **テナント化** | workspace / region 境界の未統一 | Dashboard・Members summary・meetings などで workspace の扱いが機能ごとに異なる | 他チャプターや東京NE全体で **データ混在・集計不一致**が起きる | workspace を最小テナント境界、region は上位集計境界として整理 |
| B15 | **権限設計** | `region_admin` 相当が未定義 | 現状は `member` / `chapter_admin` 中心 | 東京NEリージョン運用で **誰が複数チャプターを管理できるか**未定 | 将来 role とスコープ（workspace/region）を別 Spec で定義 |
| B16 | **セキュリティ** | `Default` ユーザーが個人 owner を持つ | `religo_role=null` だが `owner_member_id=37` として解決され得る | fallback 時に **次廣 owner のデータへ未認証アクセス**する経路になる | P0 で削除・無効化・owner 解除、または fallback 完全停止 |

### 11.4 メンバー向けに開放してよい機能（初版案）

| 機能 | 一般 member | chapter_admin |
|------|-------------|---------------|
| Dashboard（自分の KPI・Activity・1to1 リード） | Yes | Yes |
| 1to1（自分の記録・コピペ・Zoom/AI は連携済みのみ） | Yes | Yes |
| Members 一覧（チャプター名簿・**自分の**接触フラグ・メモ） | Yes（編集は No） | Yes |
| Connections（BO 閲覧） | 要検討（閲覧のみ可） | Yes |
| Meetings 議事録閲覧 | Yes | Yes |
| Meetings 編集・CSV・BO 編集 | No | Yes |
| Categories / Roles / Member 編集 | No | Yes |
| SONAE / Member merge | No | 要検討 |
| Zoom 取込・AI 設定 | Yes（本人連携のみ） | Yes |

### 11.5 優先順位の考え方

優先順位は「被害の大きさ」「他作業の前提になるか」「メンバー展開の成立条件か」で決める。**1to1 実施後記録そのものより、P0 認可・権限分離が先**である。

| 優先度 | 判断基準 |
|--------|----------|
| **P0-A / 最優先** | 未認証・他人 owner・ロール無視により、直ちに他人データ閲覧・改ざんにつながる。全機能の前提になる |
| **P0-B / 高** | UI 上の誤操作・権限混在・マスタ破壊につながる。P0-A の API 防御後に操作面を閉じる |
| **P0-C / 中** | メンバー展開の運用成立に必要。ただし P0-A/B の後でよい |
| **MVP 以降** | セキュリティ境界ができた後に提供する製品価値 |

### 11.6 優先順位付きロードマップ

| 順位 | 優先度 | 対象 | 対応する問題 | 目的 / 完了条件 |
|------|--------|------|--------------|-----------------|
| **1** | **P0-A** | 未認証 fallback 停止・Default ユーザー処理 | B1 / B16 | 本番・メンバー展開で `RELIGO_ACTING_USER_FALLBACK=false`。`Default` ユーザーの個人 owner 紐付けを削除・無効化・解除する |
| **2** | **P0-A** | API 認証境界 | B1 | owner スコープ系 API と管理系変更 API を `auth:sanctum` 配下へ移す |
| **3** | **P0-A** | owner サーバ固定 | B2 / B3 / B12 | query/body の `owner_member_id` を信用せず、`auth()->user()->owner_member_id` だけを正にする。一般 user の `owner_member_id` / `default_workspace_id` 変更は禁止 |
| **4** | **P0-A** | route model owner 検証 | B1 / B2 | `one_to_ones`・`contact_memos`・`introductions` 等の詳細/更新で owner 不一致は 403 |
| **5** | **P0-A** | admin API の `religo_role` 強制 | B4 / B6 / B7 / B8 | Member / Categories / Roles / Meetings 編集などを `chapter_admin` のみ許可。一般 member は直接 API でも 403 |
| **6** | **P0-B** | `religo_role` による UI 分離 | B4 / B11 | `member` と `chapter_admin` のメニュー・ルート表示を分ける |
| **7** | **P0-B** | 一般ユーザーの Owner 固定 UI | B5 / B10 | 一般 member は Owner Select を表示専用にし、1to1 Create でも owner 変更不可 |
| **8** | **P0-B** | マスタ・例会編集 UI の admin 限定 | B6 / B7 / B8 | Member / Categories / Roles / Meetings 編集画面を `chapter_admin` のみ表示 |
| **9** | **P0-C** | オンボーディング整備 | B9 | `members.email` を整備するか、管理者招待/仮アカウント発行フローを用意 |
| **10** | **P0-C** | メニュー整理 | B11 | 一般 member から SONAE / Member merge / 管理系 Settings を非表示 |
| **11** | **MVP** | 1to1 実施後記録 | 本 Spec G1〜G5 | コピペ → `notes` 保存、自分の 1to1 のみ一覧・編集 |
| **12** | **P1** | `raw_summary` / `summary_source` | §7 | 原文と整形後 Markdown を分けて保持 |
| **13** | **P2** | AI 校正 | §6 | BYO key 設定者のみ校正ボタン有効 |
| **14** | **P3** | Zoom 要約取得統合 | §5.2 | OAuth 連携済みユーザーのみ要約取得 |
| **15** | **P4** | multi-workspace / region 展開設計 | B13 / B14 / B15 / G6 | DragonFly 固有名を薄め、workspace/region 境界・region_admin 拡張を設計 |

### 11.7 最小リリース案

DragonFly メンバーに小さく試してもらう場合でも、最低限 **順位 1〜10 までは先行必須**。順位 11 以降が、実際にメンバーへ価値として見せる機能である。

他チャプター・東京NEリージョンへ展開する前には、**順位 15** を追加で完了させること。DragonFly PoC 中は既存の `/api/dragonfly/*` を互換維持してよいが、新規設計は `workspace` / `region` を前提にする。

### 11.8 フェーズ分割案（実装計画のたたき台）

| 実装 Phase 案 | 対象順位 | 種別 | スコープ | DoD |
|---------------|----------|------|----------|-----|
| **Phase A: Auth Boundary Hardening** | 1〜2 | implement | `routes/api.php`、認証 middleware、`ReligoActorContext`、Default ユーザー処理 migration/command | 未認証で owner スコープ系 API が 401/403。fallback は本番無効。既存ログインユーザーは従来データを閲覧可 |
| **Phase B: Owner Enforcement** | 3〜4 | implement | owner 解決 trait / FormRequest / Controllers / Service / Feature tests | `owner_member_id` query/body 改ざん不可。route model owner 不一致は 403。接触履歴・1to1・紹介・Dashboard が本人 owner 固定 |
| **Phase C: Role Enforcement for Admin APIs** | 5 | implement | Members / Categories / Roles / Meetings 編集 API、admin middleware 適用、Feature tests | 一般 member は編集系 API 403。`chapter_admin` は従来運用可能 |
| **Phase D: Member UI Separation** | 6〜8 / 10 | implement | React menu / routes / Owner selector / 1to1 create form / admin-only screens | 一般 member には管理メニュー・Owner 切替・編集画面が出ない。React build OK |
| **Phase E: Onboarding Preparation** | 9 | docs / implement | `members.email` 整備方針、招待フロー、登録 UI/API 必要差分 | DragonFly メンバー試験配布対象のアカウント作成方法が確定 |
| **Phase F: 1to1 Minutes MVP** | 11 | implement | 1to1 Edit の実施後記録セクション、`notes` 保存、本人一覧/編集 | メンバーがコピペで自分の 1to1 実施後記録を保存できる |
| **Phase G: Raw Summary Data Model** | 12 | implement | migration / Model / API / UI | `raw_summary` と `summary_source` を保持し、確定 Markdown と分離 |
| **Phase H: AI Polish** | 13 | implement | AI 校正 API / prompt / preview UI / BYO key gate | key 設定者のみ AI 校正可能。未設定者は手動編集可 |
| **Phase I: Zoom Summary Integration** | 14 | implement | Zoom summary import と実施後記録 UI の接続 | OAuth 連携済みユーザーのみ要約取得し、実施後記録の下書きへ投入 |
| **Phase J: Multi-workspace / Region Design** | 15 | docs / refactor | 汎用 API 名、workspace/region 境界、`region_admin` Spec | 他チャプター・東京NE展開前の設計が確定 |

---

## 12. Open Questions

| # | 質問 | 暫定 |
|---|------|------|
| Q1 | `raw_summary` を `one_to_ones` 列にするか子テーブルか | 列追加で開始（シンプル） |
| Q2 | 既存 `docs/meetings/1to1/` を他メンバー分も import する移行 | 次廣分は現行維持。他メンバーは新規 DB 登録のみ |
| Q3 | `religo_role` の一般メンバー定義（`member` vs 未設定） | SPEC-010 Phase で確定 |
| Q4 | Meet 上 Zoom 要約の API 化 | MVP 外・コピペ |

| Q5 | Connections / Members 一覧を一般 member にどこまで開放するか | 閲覧可・**自分 owner の接触情報のみ**（B12） |
| Q6 | 東京NEリージョン展開時の `region_admin` 権限 | 別 Spec で定義。初版は `member` / `chapter_admin` のみ |
| Q7 | `/api/dragonfly/*` の汎用 API 名への移行 | PoC では互換維持。展開前に alias / rename 計画を作る |

---

## 13. 変更履歴

| 日時 (JST) | 内容 |
|------------|------|
| 2026-06-27 10:11 | 初版作成（次廣要件・マルチユーザー 1to1・AI 校正 BYO key・定例会は管理者維持） |
| 2026-06-27 10:12 | Zoom 要約 API も **OAuth 連携済みユーザーのみ**（AI BYO key と同型ゲート）を §5.2・§5.3 に明記 |
| 2026-06-27 10:30 | 接触履歴・紹介・内部リファーラル・Dashboard など **owner スコープ系機能全体**への認可方針を §4.5 に追記 |
| 2026-06-27 10:31 | §11 DragonFly メンバー展開ブロッカー調査（API 無認可・role 未使用・email 3/180 等）を追記 |
| 2026-06-27 10:36 | 優先順位（P0-A/B/C、当時の順位 1〜12、最小リリース案）を追記 |
| 2026-06-27 10:37 | 他チャプター・東京NEリージョン展開を見据えた Stage 1〜3、workspace/region 境界、DragonFly 固有名の移行課題を追記 |
| 2026-06-27 10:50 | Religo 権限構造の現状（`religo_role` 2種・実効チェック範囲・無認証 fallback・Default ユーザー risk）を §11.2 に追記し、優先順位を順位 1〜15 とフェーズ分割案へ再整理 |
