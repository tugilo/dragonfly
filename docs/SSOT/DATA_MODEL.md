# Religo 会の地図（Relationship Map）データモデル — SSOT

**目的:** Religo（DragonFly）の「会の地図」を構成するデータモデルを SSOT として確定する。  
**Cursor の実装基準:** 本ドキュメントに書かれている内容を実装の正とする。  
**前提:** 命名は [PROJECT_NAMING.md](../PROJECT_NAMING.md) に従う（Religo＝プロダクト名、DragonFly＝チャプター名、dragonfly＝リポジトリ名）。  
**作成日:** 2026-03-04

---

## 1. Overview

### 1.1 Religo の目的

**Religo の目的は「BNI メンバーの関係を構造化した会の地図を作ること」である。** DragonFly は BNI チャプター名であり、本データモデルは Religo（プロダクト）の SSOT とする。

会の地図は、次の **5 分岐**の関係をデータとして蓄積するモデルとする（うち **内部取引**は TYFCB 相当で `internal_referrals`）。

| 関係 | 意味 | 主なデータ |
|------|------|------------|
| **会った** | いつ・どの定例会で会ったか | meetings, participants |
| **話した** | 同室・接触・メモ | breakout_rooms, participant_breakout, contact_memos |
| **1 to 1** | BNI の「1 to 1」の予定と履歴 | one_to_ones |
| **紹介（外部）** | 誰を誰に紹介したか（つなぎ） | introductions |
| **内部取引（TYFCB）** | チャプター内メンバー間の成立ビジネス | internal_referrals |

### 1.2 会の地図の関係データ（8 要素）

会の地図を構成する正式な要素は以下とする。

| # | 要素 | テーブル | 説明 |
|---|------|----------|------|
| 1 | 誰がいるか | members | 会にいる人。 |
| 2 | いつ会ったか | meetings | 定例会（回番号・日付）。 |
| 2a | 議事録 | meeting_minutes | チャプター定例会の全体記録（Markdown・file→DB）。SPEC-014。 |
| 3 | 同室履歴 | breakout_rooms, participant_breakout | どの meeting で誰と同室だったか。 |
| 4 | 接触履歴 | contact_memos | 例会メモ・1 to 1 メモ・紹介メモ・雑談メモなど。 |
| 5 | 1 to 1 | one_to_ones | BNI の「1 to 1」の予定と実施履歴。 |
| 6 | 興味関心 | dragonfly_contact_flags | owner→target のフラグ（interested / want_1on1 / extra_status）。 |
| 7 | 紹介（外部） | introductions | 紹介の記録（from / to／SPEC-009 外部リファーラル）。 |
| 8 | 内部リファーラル（TYFCB） | internal_referrals | メンバー同士の購入・契約の記録（SPEC-009）。`last_contact_at` 非由来。 |

Religo では BNI 正式用語に合わせて「1 to 1」を扱う。表記: UI/文章は "1 to 1"、テーブル名は one_to_ones、memo_type の値は one_to_one。1 to 1 は「予定」「実施」「キャンセル」を持つイベントとして扱う。**同一ペアで複数回実施する前提とし、各 `one_to_ones` 行の `notes` には当該回で話した内容（その回の記録・つながり）を保存する。** 追加の時系列追記が必要な場合は `contact_memos`（`memo_type = one_to_one`, `one_to_one_id`）を併用する。

**owner** は「自分（利用者）」を意味する。個人利用では `owner_member_id` ＝ 自分。将来 multi-user 化しても破綻しないよう owner を軸にする。**ログイン認証を導入した場合のユーザー↔Owner バインドと API 側の検証要件は [AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md](AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md)（SPEC-010） を正とする。**

**接触履歴が無い状態の表現:** 同室・メモ・1 to 1 のいずれも無くても、dragonfly_contact_flags（interested / want_1on1）で「会ったことはないが興味がある」「1 to 1 したい」という状態を表現できる。last_contact_at が NULL かつ flags が ON の組み合わせで「会ったことないが興味ある」と解釈する。

---

## Workspace と User の関係

Religo は **BNI（Business Network International）運用**を前提としており、

- **ユーザー（会員）は 1 チャプターにのみ所属可能**である、というプロダクト前提に立つ（BNI の会員ルールに整合）。
- **チャプター ≒ workspace**（Religo 内では 1 チャプターを 1 `workspaces` 行として表す）。

したがって本システムでは:

**👉 1 user = 1 workspace（原則）**

とする。

`users.default_workspace_id` は **DB 上のカラム名は「default」のまま**（破壊的リネームは行わない）だが、意味論上は「デフォルト」ではなく **ユーザーが所属する workspace（所属チャプター）** として扱う。

**user ⇄ workspace の多対多**や、**1 ユーザーが複数チャプターをまたぐ要件**は **現フェーズでは採用しない（スコープ外）**。将来別途要件が生じた場合は、本 SSOT を先に更新してから実装する。

---

## 2. Entities

| 記号 | エンティティ | テーブル名 | 備考 |
|------|--------------|------------|------|
| A | workspace | workspaces | 会／チャプター単位。**BNI 前提では 1 チャプター = 1 行。** （`WORKSPACE-SINGLE-CHAPTER-ASSUMPTION` SSOT 参照） |
| B | members | members | 誰がいるか。会にいる人。 |
| B1 | categories | categories | カテゴリマスタ（大カテゴリ／実カテゴリ）。members が参照。 |
| B2 | roles | roles | 役職マスタ。member_roles が参照。 |
| B3 | member_roles | member_roles | 役職履歴（term_start / term_end）。members × roles。 |
| C | meetings | meetings | いつ会ったか。定例会（回番号・日付）。 |
| C1 | meeting_minutes | meeting_minutes | 定例会議事録（Meeting 1:1・Markdown 本文）。SPEC-014。 |
| D | participants | participants | meeting 参加者の紐付け（meeting × member）。 |
| E | breakout_rooms | breakout_rooms | 同室履歴の単位。1 回の meeting 内の部屋。 |
| F | breakout_participants | participant_breakout | 同室履歴の紐付け。部屋と参加者（既存テーブル名は participant_breakout）。 |
| G | contact_flags | dragonfly_contact_flags | 興味関心。owner→target のフラグ。 |
| H | contact_memos | contact_memos | 接触履歴。owner→target のメモ（例会・1 to 1・紹介・雑談など）。 |
| I | one_to_ones | one_to_ones | 1 to 1。BNI の「1 to 1」の予定と履歴。 |
| J | introductions | introductions | 紹介。外部リファーラル（つなぎ）。 |
| K | internal_referrals | internal_referrals | 内部リファーラル（TYFCB 相当）。 |

---

## 3. Relationships

- **workspace 1:N members**
  1 つの workspace に複数の members が属する（`members.workspace_id`）。

- **workspace 1:N meetings**  
  1 つの workspace に複数の meetings が属する。※ 現行では `meetings` に workspace_id なし。将来追加。

- **user（Laravel `users`）→ 所属 workspace（BO-AUDIT-P4・WORKSPACE-SINGLE-CHAPTER-ASSUMPTION）**  
  `users.default_workspace_id` → `workspaces.id`（nullable, nullOnDelete）。**意味論上はユーザーの所属チャプター（所属 workspace）**。カラム名は歴史的に `default_workspace_id` のまま。解決順・フォールバックは [WORKSPACE_RESOLUTION_POLICY.md](WORKSPACE_RESOLUTION_POLICY.md)。

- **users.religo_role（SPEC-010）**  
  Religo の **アプリ内ロール**（例: `member`, `chapter_admin`）。BNI の職歴 `roles` / `member_roles` とは別。nullable の既存行は `GET /api/users/me` では `member` として返す。更新は **chapter_admin** が `PATCH /api/admin/users/{user}` で行う（ミドルウェア `religo.chapter_admin`）。

- **meeting 1:N participants**  
  1 回の meeting に複数の participants（参加者）がいる。participant は member を参照する。

- **meeting 1:N breakout_rooms**  
  1 回の meeting に複数の breakout_rooms（同室グループ）がある。

- **breakout_room N:M participants**（実装: participant_breakout）  
  1 つの breakout_room に複数の participants が紐づく。participant は member に至る。テーブル `participant_breakout` が participant と breakout_room を多対多で結ぶ。

- **member → category（Phase14 正規化済み）**  
  members.category_id → categories.id（nullable）。**members.category（文字列）は廃止済み。** カテゴリは categories マスタで管理する。

- **member → 役職履歴（Phase14 正規化済み）**  
  **members.role_notes（文字列）は廃止済み。** 役職は roles（マスタ）と member_roles（履歴: term_start, term_end）で管理する。member 1:N member_roles N:1 role。「現在の役職」は member_roles のうち term_end IS NULL かつ term_start <= 今日 の行に対応する role とする。「去年のプレジデントは誰？」などは member_roles を term_start/term_end で絞って照会する。

- **owner → target の関係データ**  
  - **dragonfly_contact_flags:** owner_member_id → target_member_id で 1 行。interested / want_1on1 / extra_status を保持。  
  - **contact_memos:** owner_member_id → target_member_id のメモ。meeting_id / one_to_one_id は任意。memo_type で種別（例会・1 to 1・紹介・その他）を区別。  
  - **one_to_ones:** owner_member_id → target_member_id の「1 to 1」予定・履歴。1 件の one_to_one に複数の contact_memos を紐付け可能。  
  - **introductions:** owner_member_id, from_member_id, to_member_id で紹介を記録。`referral_kind` は **当面 `external` のみ**（列の意味論的デフォルト・拡張用）。  
  - **internal_referrals:** **TYFCB 相当。** `owner_member_id`（記録者＝買い手または売り手と同一）, `buyer_member_id`, `seller_member_id`。`last_contact_at`・Introduction Hint・`introduction_count` には **含めない**（SPEC-009）。

- **one_to_ones 1:N contact_memos**  
  当該回の主たる記録は **`one_to_ones.notes`** に書く。**追加の**追記・分割メモを時系列で残す場合に、contact_memos（memo_type = one_to_one, one_to_one_id 設定）を任意で紐付ける。

---

## 4. Table Definitions

### 4.0.1 countries（国マスタ）

| 項目 | 内容 |
|------|------|
| **目的** | 地理・組織階層の最上位（例: 日本）。 |
| **外部キー** | なし |
| **ユニーク制約** | **name** |
| **主要カラム** | id, name (string), timestamps |

### 4.0.2 regions（リージョンマスタ）

| 項目 | 内容 |
|------|------|
| **目的** | 国直下の区分（例: BNI 東京NEリージョン）。**Country > Region > Workspace（チャプター）** の中間。 |
| **外部キー** | **country_id → countries.id**（cascadeOnDelete） |
| **ユニーク制約** | **(country_id, name)** |
| **主要カラム** | id, country_id, name (string), timestamps |

### 4.1 workspaces

| 項目 | 内容 |
|------|------|
| **目的** | 会／チャプターやプロジェクト単位のコンテキスト。個人利用でも 1 workspace で拡張できる土台。**BNI ではチャプター ≒ 1 workspace。** 上位に **region_id** で Region / Country を辿れる（階層の土台・nullable）。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | **region_id → regions.id（nullable, nullOnDelete）** |
| **ユニーク制約** | 特になし（必要に応じて name 等を後から追加可） |
| **主要カラム** | id, name (string), slug (string, nullable), **region_id (nullable)**, timestamps |
| **インデックス** | slug にユニークまたは検索用インデックスを検討 |

※ created_at / updated_at は Laravel 標準で付与する前提。

---

### 4.1a users（Laravel・Religo 管理画面ユーザー）

| 項目 | 内容 |
|------|------|
| **目的** | 管理画面のログインユーザー。`owner_member_id` で Dashboard / Religo の「自分」メンバーと紐づく。 |
| **主キー** | id（Laravel 既定） |
| **外部キー（Religo 拡張）** | `owner_member_id` → `members.id`（nullable）。**`default_workspace_id` → `workspaces.id`（nullable, nullOnDelete）** — **所属 workspace**（カラム名は `default_*` のまま）。 |
| **主要カラム（Religo 関連）** | `owner_member_id`, **`default_workspace_id`**（いずれも nullable） |
| **補足** | BNI 前提では **1 user = 1 workspace**。完全な認可・別プロダクト向けマルチテナント UI は未着手。`/api/users/me`・BO 監査の workspace は [USER_ME_AND_ACTOR_RESOLUTION.md](USER_ME_AND_ACTOR_RESOLUTION.md) / [WORKSPACE_RESOLUTION_POLICY.md](WORKSPACE_RESOLUTION_POLICY.md)。 |

---

### 4.2 members（Phase14 正規化済み）

| 項目 | 内容 |
|------|------|
| **目的** | 誰がいるか。会にいる人。名前・カテゴリ（FK）・紹介元等を保持。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | **category_id → categories.id (nullable)**。introducer_member_id → members.id (nullable), attendant_member_id → members.id (nullable)。**workspace_id → workspaces.id（nullable）** — 所属チャプター。 |
| **ユニーク制約** | なし |
| **主要カラム** | id, name, name_kana (nullable), **category_id (nullable)**, **workspace_id (nullable)** — 所属チャプター, type, display_no (nullable), **ncast_profile_url (nullable, string 2048)** — Nキャスの自己紹介ページ URL, **weekly_presentation_body (nullable, text)** — ウィークリープレゼン原稿（SPEC-004・Dashboard 表示用）, **start_dash_presentation_body (nullable, text)** — スタートダッシュプレゼン原稿（SPEC-004・Dashboard 表示用）, introducer_member_id, attendant_member_id, timestamps |
| **インデックス** | type, category_id, introducer_member_id, attendant_member_id |

**廃止済みカラム（Phase14 で正規化・削除）:**  
- **members.category（文字列）** → 廃止。カテゴリは **categories** マスタを参照（category_id）する。  
- **members.role_notes（文字列）** → 廃止。役職は **roles**（マスタ）と **member_roles**（履歴）で管理する。

**members.type の値域（SSOT 確定・実装で迷わない最小セット）:** active（在籍）, inactive（休会・退会等）, guest（ゲスト参加者）。BNI 運用では member / visitor / guest 等も用いる場合がある。一覧・指標で「除外する type」を決める場合はこの値域を参照する。

---

### 4.3 categories（Phase14・カテゴリマスタ）

| 項目 | 内容 |
|------|------|
| **目的** | メンバーのカテゴリマスタ。大カテゴリ（group_name）と実カテゴリ（name＝本人の実業務）を保持。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | なし |
| **ユニーク制約** | なし（(group_name, name) のユニークは運用で必要に応じて検討） |
| **主要カラム** | id, group_name (string), name (string), timestamps |
| **インデックス** | group_name, name |

**概念整理:**  
- **group_name** ＝ 大カテゴリ（例: 建設・不動産、IT、士業・コンサル）。  
- **name** ＝ 実カテゴリ（本人の実業務。例: 解体工事、Web制作）。同一 group に複数 name があり得る。  
表示時は「group_name / name」のように併記する（group_name と name が同一の場合は group_name のみで可）。

---

### 4.4 roles（Phase14・役職マスタ）

| 項目 | 内容 |
|------|------|
| **目的** | BNI 役職のマスタ（プレジデント、バイスプレジデント、書記兼会計、WEBマスター等）。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | なし |
| **ユニーク制約** | なし（name のユニークは運用で必要に応じて検討） |
| **主要カラム** | id, name (string), description (nullable), timestamps |
| **インデックス** | name |

---

### 4.5 member_roles（Phase14・役職履歴）

| 項目 | 内容 |
|------|------|
| **目的** | メンバーの役職履歴。半年ごとの役職交代を term_start / term_end で管理する。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | member_id → members.id (cascadeOnDelete), role_id → roles.id (cascadeOnDelete) |
| **ユニーク制約** | なし（同一 member で複数期間の役職があり得る） |
| **主要カラム** | id, member_id, role_id, term_start (date, nullable), term_end (date, nullable), timestamps |
| **インデックス** | (member_id, term_start) |

**current_role（現在の役職）の定義（SSOT・実装に合わせる）:**  
member_roles のうち **term_end IS NULL** かつ **term_start <= 今日** の行について、対応する role の name を「現在の役職」とする。複数該当する場合は term_start 降順の先頭 1 件を用いる。

**履歴照会:** 「去年のプレジデントは誰？」などは、role_id で役職を指定し、from / to で期間（term_start / term_end の範囲）を絞って member_roles を検索すればよい。

---

### 4.6 meetings（既存・変更しない）

| 項目 | 内容 |
|------|------|
| **目的** | いつ会ったか。定例会。回番号と開催日を保持。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | なし。将来 workspace_id → workspaces.id を追加可。 |
| **ユニーク制約** | number UNIQUE |
| **主要カラム** | id, number (unsignedInteger), held_on (date), name (nullable), timestamps |
| **インデックス** | held_on, number |

**管理画面からの新規作成（Religo API）:** `POST /api/meetings` で `number`（必須・`meetings.number` と UNIQUE）、`held_on`（必須・日付、未来日可）、`name`（任意・最大 255）。`name` が未指定または空のときは **`第{number}回定例会`** とする（参加者 CSV CLI の `firstOrCreate` と同型）。認可は当該 API 群と同様（現行は追加の認証ミドルウェアなし）。

**管理画面からの更新（Religo API）:** `PATCH /api/meetings/{id}` で `number` / `held_on` / `name` のみ更新可（body ルールは POST と同型・`number` の UNIQUE は当該 id を除く）。`name` 未指定・空のときの既定名も POST と同じ。**削除は別 Phase。** `GET /api/meetings` の一覧要素および POST/PATCH のレスポンスは同一形状（`id`, `number`, `held_on`, `name`, `breakout_count`, `has_memo`, `has_participant_pdf`, **`has_minutes`**）。

**議事録（SPEC-014）:** チャプター定例会の全体記録は **`meeting_minutes`**（本 meeting と 1:1）。`contact_memos`（`memo_type=meeting`）の個人メモとは別。取り込みは `dragonfly:import-chapter-minutes`。詳細は [CHAPTER_MINUTES_REQUIREMENTS.md](CHAPTER_MINUTES_REQUIREMENTS.md) / [MEETING_DOMAIN_IA.md](MEETING_DOMAIN_IA.md)。

**number / held_on が不明な場合のルール（実装規約）:** 現行スキーマでは number は UNIQUE のため、番号が不明な過去回は「ダミー番号（例: 0。他と衝突しない値）を使用する」か、将来 number を nullable にする migration を実施するまで許容しない。held_on が NULL の meeting は、last_contact_at や last_same_room_meeting の算出では「その meeting の held_on は存在しない」として扱い、同室のみで寄与する場合は datetime 変換の対象から外す（NULL として無視する）。

---

### 4.6a meeting_minutes（SPEC-014・Phase 180）

| 項目 | 内容 |
|------|------|
| **目的** | チャプター定例会の議事録（Markdown 全文）。`docs/meetings/chapter/` から file→DB 取り込み。会全体の記録（owner→target ではない）。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | **meeting_id → meetings.id (unique, cascadeOnDelete)** |
| **ユニーク制約** | **meeting_id UNIQUE**（1 meeting = 1 議事録） |
| **主要カラム** | id, meeting_id, **body_markdown (longText)**, **source_path (string)**, doc_type (nullable), session_date (date, nullable), session_time_jst (nullable), session_time_note (text, nullable), format (nullable), source (nullable), **front_matter (json, nullable)**, **imported_at (timestamp)**, timestamps |
| **インデックス** | meeting_id |

**source of truth:** リポジトリ内 Markdown。DB は取り込みコピー。管理画面からの編集 API は提供しない（読み取りのみ）。

---

### 4.7 participants（既存・変更しない）

| 項目 | 内容 |
|------|------|
| **目的** | その meeting に誰が参加したかの紐付け。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | meeting_id → meetings.id (cascadeOnDelete), member_id → members.id (restrictOnDelete), introducer_member_id, attendant_member_id (nullable) |
| **ユニーク制約** | (meeting_id, member_id) UNIQUE |
| **主要カラム** | id, meeting_id, member_id, type, introducer_member_id, attendant_member_id (nullable), timestamps |
| **インデックス** | meeting_id, member_id, type |

**participants.type の値域（SSOT 確定・実装で迷わない最小セット）:** regular（通常参加）, absent（欠席扱い・記録上は参加だが実質欠席）, guest（ゲスト）, proxy（代理参加。将来拡張で member_id が「本人」か「実参加者」かは Future extensions に記載）。**same_room_count / last_same_room_meeting の算出では、type が absent または proxy の participant は同室判定から除外する。** すなわち、owner または target がその meeting で type = absent / proxy のときは、その meeting は same_room_count に含めず、last_same_room_meeting の候補にも含めない。regular / guest は同室に含める。

---

### 4.8 breakout_rooms（既存・変更しない）

| 項目 | 内容 |
|------|------|
| **目的** | 同室履歴の単位。1 回の meeting 内の部屋。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | meeting_id → meetings.id (cascadeOnDelete) |
| **ユニーク制約** | (meeting_id, room_label) UNIQUE |
| **主要カラム** | id, meeting_id, room_label, sort_order (nullable), timestamps |
| **インデックス** | meeting_id, sort_order |

**部屋名変更・席替え時の推奨:** 同一 meeting 内で「論理的に同じ部屋」の名前だけが変わった場合は、**同一 breakout_room 行の room_label を更新する**ことを推奨する。新規 breakout_room 行を追加すると same_room_count の単位（meeting あたり 1 回）は維持されるが、データの一貫性のため 1 論理部屋＝1 行に保つ。

---

### 4.9 breakout_participants（テーブル名: participant_breakout）（既存・変更しない）

| 項目 | 内容 |
|------|------|
| **目的** | 同室履歴の紐付け。どの参加者がどの同室にいたか。participant 経由で member に至る。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | participant_id → participants.id (cascadeOnDelete), breakout_room_id → breakout_rooms.id (cascadeOnDelete) |
| **ユニーク制約** | (participant_id, breakout_room_id) UNIQUE |
| **主要カラム** | id, participant_id, breakout_room_id, timestamps |
| **インデックス** | participant_id, breakout_room_id |

---

### 4.10 contact_flags（テーブル名: dragonfly_contact_flags）（既存・変更しない）

| 項目 | 内容 |
|------|------|
| **目的** | 興味関心。owner→target の「今の状態」を 1 行で保持。interested / want_1on1 / extra_status。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | owner_member_id → members.id (restrictOnDelete), target_member_id → members.id (restrictOnDelete), **workspace_id → workspaces.id (nullable, nullOnDelete)**（追加 migration で付与） |
| **ユニーク制約** | (owner_member_id, target_member_id) UNIQUE（維持）。将来は (workspace_id, owner_member_id, target_member_id) のユニークを検討。 |
| **主要カラム** | id, **workspace_id (nullable)**, owner_member_id, target_member_id, interested (boolean, default false), want_1on1 (boolean, default false), extra_status (json, nullable), timestamps |
| **インデックス** | owner_member_id, interested, want_1on1, **workspace_id** |

---

### 4.11 contact_memos（接触履歴・拡張定義）

接触履歴として、例会メモ・1 to 1 メモ・紹介メモ・雑談メモなどを扱う。

| 項目 | 内容 |
|------|------|
| **目的** | 接触履歴。owner→target のメモ。種別は memo_type で区別。one_to_one に紐づく場合は 1 to 1 の会話内容を履歴保存。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | owner_member_id → members.id (restrictOnDelete), target_member_id → members.id (restrictOnDelete), meeting_id → meetings.id (nullable, nullOnDelete), one_to_one_id → one_to_ones.id (nullable, nullOnDelete), **workspace_id → workspaces.id (nullable, nullOnDelete)**（追加 migration で付与） |
| **ユニーク制約** | なし（1 owner–target で複数メモ可） |
| **主要カラム** | id, **workspace_id (nullable)**, owner_member_id, target_member_id, meeting_id (nullable), **one_to_one_id (nullable)**, **memo_type (string, 下記)**, body (text, nullable), timestamps |
| **インデックス** | (owner_member_id, target_member_id, created_at), meeting_id, one_to_one_id, **workspace_id** |

**memo_type**（必須または default あり）:

| 値 | 意味 |
|----|------|
| meeting | 例会メモ |
| one_to_one | 1 to 1 メモ（one_to_one_id と併用） |
| introduction | 紹介メモ |
| other | 雑談メモ・その他 |

**soft delete:** まずは無し。論理削除が必要になったら `deleted_at` を追加する。

---

### 4.12 one_to_ones（新規）

BNI の「1 to 1」の予定と履歴を保存するテーブル。BNI では「1 to 1」が正式用語のため、テーブル名は **one_to_ones** とする。

| 項目 | 内容 |
|------|------|
| **目的** | 1 to 1。BNI の「1 to 1」の予定と実施履歴。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | workspace_id → workspaces.id (nullable。現行は未導入のため nullable 可), owner_member_id → members.id (restrictOnDelete), target_member_id → members.id (restrictOnDelete), meeting_id → meetings.id (nullable, nullOnDelete) |
| **ユニーク制約** | なし（同一ペアで複数回の 1 to 1 があり得る）。重複予定を避けるため (owner_member_id, target_member_id, scheduled_at) のユニークは将来検討とし、今回はインデックスのみ。 |
| **主要カラム** | id, workspace_id (nullable), owner_member_id, target_member_id, scheduled_at (datetime, nullable), started_at (datetime, nullable), ended_at (datetime, nullable), status (string: planned / completed / canceled), meeting_id (nullable), **zoom_meeting_id (string, nullable)**, **zoom_meeting_uuid (string, nullable)**, **external_source (string, 既定 `manual`)**, **cancel_reason (string, nullable)** — Phase 185 以降, **cancel_remark (text, nullable)**, **canceled_at (datetime, nullable)**, notes (text, nullable), timestamps |
| **インデックス** | (owner_member_id, target_member_id), scheduled_at, zoom_meeting_id, zoom_meeting_uuid |

**Zoom 連携カラム（SPEC-012 / Phase 152）:** `zoom_meeting_id` / `zoom_meeting_uuid` は Zoom 突合キー（再取り込みの二重登録防止）。`external_source` は取得元（`manual` / `zoom`）。手入力は `manual` 既定。詳細は [ZOOM_ONETOONE_SYNC_REQUIREMENTS.md](ZOOM_ONETOONE_SYNC_REQUIREMENTS.md)。

**`workspace_id` の意味（SPEC-006 解釈 A）:** 作成 API では必須だが、意味は **記録コンテキスト（通常はオーナー側の所属チャプターに対応する workspaces.id）**。`target_member` が他チャプター所属でもよい（クロスチャプター 1 to 1）。§5.1 参照。

**notes の位置づけ（実装・UX・ONETOONES-P3・補足）:** `one_to_ones` は **1 行が 1 回の 1 to 1**（同一オーナー×ターゲットでも予定・実施が複数行あり得る）。`one_to_ones.notes` には **その回で話した内容**（議題・決定・次アクションを含めてよい）を保存し、**回をまたいだ文脈のつながり**は「前回の行の `notes` → 今回の行の `notes`」で追う。**追加で**時系列に追記したいブロックだけを `contact_memos`（`memo_type = one_to_one`, `one_to_one_id`）に分けて残す運用も可（ONETOONES-P4）。

**API（ONETOONES-P4・管理画面用）:**

- `GET /api/one-to-ones/{id}/memos` — 当該 1 to 1 の `contact_memos` を新しい順。
- `POST /api/one-to-ones/{id}/memos` — `body` のみ必須。サーバ側で `owner_member_id` / `target_member_id` / `workspace_id` を 1 to 1 から複製し `memo_type = one_to_one` で作成。
- **`POST /api/one-to-ones/{id}/cancel`** — **予定キャンセル専用**（Phase 185 以降・[ONETOONES_CANCEL_FIT_AND_GAP.md](ONETOONES_CANCEL_FIT_AND_GAP.md) §10.1）。body: `{ cancel_reason, cancel_remark? }`。サーバ側で `status=canceled`・`canceled_at=now()` を設定。**`status=planned` のみ**受理。`PATCH` 経由で `status=canceled` にすることは **採用しない**（理由必須を担保）。

**キャンセル理由（Phase 184 SSOT 確定・Phase 185 以降 implement）:**

| 列 | 型 | 意味 |
|----|-----|------|
| `cancel_reason` | string, nullable | `owner_convenience`（こちら都合）・`target_convenience`（相手都合）・`other`（その他）。`status=canceled` のとき必須。それ以外は NULL。 |
| `cancel_remark` | text, nullable | 備考。`cancel_reason=other` のとき **必須**（非空）。他 2 値は **任意**。 |
| `canceled_at` | datetime, nullable | キャンセル確定日時（`POST cancel` 実行時にサーバ設定）。 |

**`cancel_reason` と `notes` の住み分け:** `notes` は **その回の議題・実施内容**（DATA_MODEL 上の位置づけは変更しない）。キャンセル理由・備考は **`cancel_reason` / `cancel_remark`** に保存する（`notes` への `[cancel:…]` 埋め込みは **採用しない**）。

**scheduled_at の変更:** 予定日時の変更は**上書き**で行う。変更履歴（監査ログ）が必要な場合は Future extensions で別テーブル等を検討する。

**status:**

| 値 | 意味 |
|----|------|
| planned | 予定・準備中 |
| completed | 実施済み |
| canceled | 予定が無効になった事実を残す**業務上の正規状態**（キャンセル）。「削除の代わり」ではなく、**無効化を履歴として残す**ための値。 |

**削除ポリシー（ONETOONES-DELETE-POLICY-P1・SSOT）:**

- **`one_to_ones` を物理削除する API / UI は採用しない**（製品方針）。レコードは **関係性の履歴**として保持する。
- 予定を取り消す場合は **`POST /api/one-to-ones/{id}/cancel`** で **`status = canceled`** + **`cancel_reason` / `cancel_remark` / `canceled_at`** を記録する（UI 表記は **「キャンセル」**。**「削除」ボタンは置かない**）。詳細は [ONETOONES_CANCEL_FIT_AND_GAP.md](ONETOONES_CANCEL_FIT_AND_GAP.md) §10.1。
- **`completed` 行はキャンセル操作の対象外**（初回 implement）。誤 status は Edit の上級者向け変更または運用で対応。
- 重複登録は **`cancel` で片方を無効化** して運用し、将来の重複警告は別 Phase で検討する。
- テスト・開発用のデータ掃除は **UI からの削除ではなく DB 運用**（Artisan / SQL 等）で行う。
- 物理削除を入れると `contact_memos.one_to_one_id` の `nullOnDelete`・Dashboard / Members 集計・Activity の意味が変わるため、現時点では見送る。詳細は [ONETOONES_DELETE_REQUIREMENTS.md](ONETOONES_DELETE_REQUIREMENTS.md) を参照。

#### 4.12.1 `one_to_one_status`（リード一覧・Members / Dashboard）

API `GET /api/dragonfly/members/one-to-one-status?owner_member_id=` が各行に付与する**実施ベース**の列挙値。実装は `MemberOneToOneLeadService`。UI ラベルは `www/resources/js/admin/religoOneToOneLeadLabels.js` と一致させる。

**レスポンス各行の追加キー（SPEC-005）:** **`category_label`**（`string | null`）— `members.category_id` → `categories` の表示名（`group_name` と `name` が同一なら `name` のみ、そうでなければ `group_name / name`）。未設定は `null`。Dashboard「次の 1to1 候補」で業種把握用。

**並び順:** 配列は **`display_no` を数値として昇順**（`CAST`・NULL は最後）・同順は `id` 昇順。文字列そのままだと `1,10,11,2…` になるため Members API と同じ **数値ソート**（`Member::orderByDisplayNoNumeric`）。`one_to_one_status` や want による並べ替えはしない。

**対象メンバー:** `members.type` が **`guest`（ゲスト）** または **`visitor`（ビジター）** の行は **在籍メンバーではない** ため、この API の一覧に **含めない**（`active` / `inactive` 等のみ）。**実装:** `MemberOneToOneLeadService` が上記 `type` を除外する。

| 値 | 意味 |
|------|------|
| **none** | 当該 owner→target に **status = completed** の 1 to 1 が 0 件（未実施） |
| **needs_action** | completed が 1 件以上かつ、最後の completed の代表日時が `config('religo.one_to_one_lead_needs_action_days')` 日（既定 30・`app.timezone` 基準）より**古い** |
| **ok** | 最後の completed の代表日時が閾値**以内** |

**代表日時:** 各行の completed について `COALESCE(ended_at, started_at, scheduled_at)` の最大。`planned` / `canceled` は実施件数・最終実施の算出に含めない。

#### 4.12.2 Dashboard `GET /api/dashboard/activity`（活動フィード）

管理画面 Dashboard の「最近の活動」用。実装は `DashboardService::getActivity`。時系列は各ソースの日時をマージして降順、`limit` で打ち切り。

| `kind`（API） | ソース |
|---------------|--------|
| `memo_added` | `contact_memos`（紹介以外） |
| `memo_introduction` | `contact_memos`・`memo_type = introduction` |
| `one_to_one_created` / `one_to_one_completed` | `one_to_ones` |
| `flag_changed` | `dragonfly_contact_flags`・`updated_at` |
| `bo_assigned` | **`bo_assignment_audit_logs`**（BO-AUDIT-P1〜P3）。`actor_owner_member_id` で Dashboard owner に一致する行のみ。 |

**`bo_assignment_audit_logs`:** 主線 breakouts / breakout-rounds・**レガシー** `PUT .../breakout-assignments`（PUT のみ）成功時に `BoAssignmentAuditLogWriter` が **1 行追加**。**actor / workspace** は `ReligoActorContext` と **GET `/api/users/me`** と同一基準（BO-AUDIT-P3〜P4）。詳細は [BO_AUDIT_LOG_DESIGN.md](BO_AUDIT_LOG_DESIGN.md)、[USER_ME_AND_ACTOR_RESOLUTION.md](USER_ME_AND_ACTOR_RESOLUTION.md)。**`meeting_csv_apply_logs` とは別**。

---

### 4.13 introductions（紹介・外部リファーラル）

| 項目 | 内容 |
|------|------|
| **目的** | 外部リファーラル。紹介の記録（誰が誰を誰に紹介したか）。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | owner_member_id → members.id (restrictOnDelete), from_member_id → members.id (restrictOnDelete), to_member_id → members.id (restrictOnDelete), meeting_id → meetings.id (nullable, nullOnDelete), **workspace_id → workspaces.id (nullable, nullOnDelete)**（追加 migration で付与） |
| **ユニーク制約** | なし（同一ペアで複数回紹介があり得る） |
| **主要カラム** | id, **workspace_id (nullable)**, owner_member_id, from_member_id, to_member_id, **`referral_kind` (string, 既定 `external`)**, meeting_id (nullable), **introduced_at** (date, nullable), **note** (text, nullable), created_at, updated_at |
| **インデックス** | (owner_member_id, from_member_id, to_member_id), meeting_id, **workspace_id**, **referral_kind**（任意・実装 Phase で最適化） |

**`referral_kind`:** SPEC-009 に従い、**内部リファーラルは `internal_referrals` にのみ格納**する。`introductions` の値は **当面 `external` のみ**とする。既存行のマイグレーションでは **NULL または未設定は `external` とみなす**（default 付与）。将来、外部の細分類が必要なときのみ値を拡張する。**実装:** `2026_05_18_080000_add_referral_kind_to_introductions_table`（Phase 123）。API: `GET|POST /api/introductions`, `GET|PATCH /api/introductions/{id}`（owner スコープ）。

**逆紹介:** 紹介先（to）が紹介元（from）に紹介し返す場合は、**逆方向の introductions 行（from_member_id と to_member_id を入れ替えた別行）** で表現する。同一レコードで「逆紹介」リンクを持たない。

---

### 4.14 internal_referrals（内部リファーラル・TYFCB）

| 項目 | 内容 |
|------|------|
| **目的** | 内部リファーラル。チャプター内メンバー間で **成立した** サービス・商品の購入・契約の記録（SPEC-009）。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | **workspace_id → workspaces.id (nullable, nullOnDelete)**；**owner_member_id** → members.id (restrictOnDelete)；**buyer_member_id** → members.id (restrictOnDelete)；**seller_member_id** → members.id (restrictOnDelete) |
| **業務制約（アプリ層）** | `owner_member_id` は `buyer_member_id` または `seller_member_id` の **どちらかと同一**。`buyer_member_id` ≠ `seller_member_id`。当面、buyer / seller の **`members.workspace_id` は同一チャプター** とみなす運用（クロスチャプター取引の構造化はスコープ外）。 |
| **ユニーク制約** | なし（Phase 122・同一取引の二重登録は運用で避ける）。 |
| **主要カラム** | id, workspace_id (nullable), owner_member_id, buyer_member_id, seller_member_id, **summary** (string, 必須・UI で空禁止), **closed_on** (date, nullable), **amount_yen** (unsignedBigInteger, nullable, **税込の整数円・ユーザー申告**), notes (text, nullable), created_at, updated_at |
| **インデックス** | (owner_member_id, created_at), workspace_id, buyer_member_id, seller_member_id |

**実装:** マイグレーション `2026_05_18_080100_create_internal_referrals_table`（Phase 123）。API: `GET|POST /api/internal-referrals`, `GET|PATCH /api/internal-referrals/{id}`（owner スコープ・SPEC-009）。

**last_contact / Hint:** 本テーブルの日時は **`last_contact_at` の合成・Introduction Hint の入力に含めない**（SPEC-009）。

---

### 4.15 zoom_accounts（Zoom 連携・SPEC-012）

| 項目 | 内容 |
|------|------|
| **目的** | ユーザー（Owner）単位の Zoom OAuth 接続。1 to 1 取り込みのトークン保管。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | user_id → users.id (cascadeOnDelete) |
| **ユニーク制約** | user_id（1 user = 1 Zoom 接続） |
| **主要カラム** | id, user_id, zoom_user_id (nullable), zoom_account_id (nullable), zoom_email (nullable), **access_token (text, encrypted)**, **refresh_token (text, encrypted)**, token_expires_at (datetime, nullable), scopes (text, nullable), timestamps |
| **セキュリティ** | access_token / refresh_token は Eloquent `encrypted` キャスト（APP_KEY 由来）。アプリ資格情報（Client ID/Secret 等）は `user_zoom_credentials`（Phase 189）または `.env` フォールバック（SPEC-012 §6）。 |

**実装:** マイグレーション `2026_05_30_060000_create_zoom_accounts_table`（Phase 152）。

### 4.15.1 user_zoom_credentials（Zoom OAuth アプリ資格情報・SPEC-012 拡張 Phase 189）

| 項目 | 内容 |
|------|------|
| **目的** | ユーザーごとの Zoom OAuth アプリ資格情報（BYO app credentials）。AI BYO key（`user_ai_credentials`）と同型。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | user_id → users.id (cascadeOnDelete) |
| **ユニーク制約** | user_id（1 user = 1 資格情報セット） |
| **主要カラム** | id, user_id, client_id (nullable), **client_secret (text, encrypted)**, **webhook_secret_token (text, encrypted, nullable)**, is_active (bool, default true), timestamps |
| **セキュリティ** | client_secret / webhook_secret_token は Eloquent `encrypted` キャスト。API には平文を返さない（`has_*` フラグのみ）。`ZOOM_REDIRECT_URI` は `.env` 共通。 |

**実装:** マイグレーション `2026_06_04_120000_create_user_zoom_credentials_table`（Phase 189）。

### 4.16 zoom_meeting_imports（Zoom 取り込みステージング・SPEC-012）

| 項目 | 内容 |
|------|------|
| **目的** | Zoom から取得した予定・実施ミーティングの取り込み候補。人が複数選択・相手正規化して確定したものだけ one_to_ones に反映する。相手未確定の「保留」はこの表に留める。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | user_id → users.id (cascadeOnDelete)；owner_member_id → members.id (nullable, nullOnDelete)；workspace_id → workspaces.id (nullable, nullOnDelete)；matched_member_id → members.id (nullable, nullOnDelete)；one_to_one_id → one_to_ones.id (nullable, nullOnDelete) |
| **ユニーク制約** | (user_id, zoom_meeting_uuid)（過去インスタンス単位の二重取り込み防止） |
| **主要カラム** | zoom_meeting_id, zoom_meeting_uuid (nullable), kind (scheduled/past), topic, start_time, end_time, duration_minutes, participants_count, is_one_to_one_candidate (bool), confidence (high/medium/low), matched_member_id, match_status (matched/new/unmatched/hold), counterpart_name, counterpart_email, selected (bool), status (pending/imported/skipped/held), one_to_one_id, raw (json), timestamps |

**実装:** マイグレーション `2026_05_30_060100_create_zoom_meeting_imports_table`（Phase 152）。監査は `zoom_import_apply_logs`（同 Phase）。

---

### 4.17 user_ai_credentials（AI 設定・SPEC-013）

| 項目 | 内容 |
|------|------|
| **目的** | ユーザーごとの AI 利用設定（BYO key）。1to1 原稿生成に使用。 |
| **主キー** | id |
| **外部キー** | user_id → users.id (cascadeOnDelete) |
| **ユニーク制約** | user_id |
| **主要カラム** | ai_enabled (bool・既定 false), provider (openai/anthropic/google…), **api_key (text, encrypted)**, model (nullable), is_active (bool), timestamps |
| **セキュリティ** | api_key は `encrypted` キャスト。API は平文を返さない（has_api_key のみ）。現状 OpenAI 実装。 |

**実装:** `2026_05_30_103000_create_user_ai_credentials_table`（Phase 155）。

### 4.18 one_to_one_attachments（1to1 事前準備・SPEC-013）

| 項目 | 内容 |
|------|------|
| **目的** | 1to1 の相手プロフィール添付（PDF / NCAS URL / テキスト）と抽出テキスト。AI 原稿生成の素材。 |
| **主キー** | id |
| **外部キー** | one_to_one_id → one_to_ones.id (cascadeOnDelete)；target_member_id → members.id (nullable, nullOnDelete)；uploaded_by_user_id → users.id (nullable, nullOnDelete) |
| **主要カラム** | source_type (pdf/url/text), file_path (private disk), source_url, original_name, extracted_text (longtext), parsed_profile (json, nullable), timestamps |

**実装:** `2026_05_30_103100_create_one_to_one_attachments_table`（Phase 155）。ファイルは `Storage::disk('local')`（private）。

---

## 5. Derived Metrics

Religo では以下を**関係指標**として算出する。

| 指標 | 定義・算出方法 |
|------|----------------|
| **same_room_count** | **単位を確定:** owner と target が「同一 meeting 内で少なくとも 1 つの同じ breakout_room にいた」meeting の回数。同一 meeting 内で複数部屋に同室していても **meeting あたり 1 回**とみなす（部屋インスタンス数では数えない）。participant_breakout と participants から owner/target を member_id に変換し、同一 meeting_id ごとに「同一 breakout_room_id を持つ組み合わせが存在する」meeting を COUNT(DISTINCT meeting_id) で数える。**breakout_rooms が 0 件の meeting は same_room_count に寄与しない。** 算出イメージ（擬似）: owner/target の participant を取得 → その participant_id が属する breakout_room_id を participant_breakout から取得 → meeting_id 単位で「owner と target が共通の breakout_room_id を少なくとも1つ持つ」ものを DISTINCT meeting_id で COUNT。 |
| **last_same_room_meeting** | 上記「同室」だった meeting のうち、held_on または number が最大のもの。 |
| **last_memo** | contact_memos の (owner_member_id, target_member_id) で created_at 降順の先頭 1 件。memo_type / meeting_id / one_to_one_id があれば併せて返す。 |
| **one_to_one_count** | one_to_ones の (owner_member_id, target_member_id) で status = completed の件数。 |
| **last_one_to_one** | one_to_ones の (owner_member_id, target_member_id) で、**status = canceled の行は除外し、** scheduled_at または started_at の降順の先頭 1 件（直近の 1 to 1 予定または実施）。 |
| **introduction_count** | introductions の (owner_member_id, from_member_id, to_member_id) の組み合わせ、または owner が関与する紹介の件数。要件に応じて集計範囲を定義。 |
| **last_introduction** | introductions の (owner_member_id, from_member_id, to_member_id) など owner が関与する紹介のうち、created_at 降順の先頭 1 件。last_contact_at の候補の一つ。 |
| **last_contact_at** | **必須指標。** owner→target の「最後の接触」を **1 つの datetime** で表す。**比較規則:** (1) meeting.held_on（date）はその日の 00:00:00 として datetime に変換して比較する。(2) contact_memos.created_at, one_to_ones の **started_at / scheduled_at / created_at**（**status = canceled の行は除外**・日時未設定の 1 to 1 は **created_at で接触あり**）, introductions.created_at はそのまま datetime として扱う。(3) 上記の「存在する値」の MAX をとる。NULL は無視する。全て NULL なら last_contact_at は NULL。数式実装では datetime 同士で MAX をとること。**`internal_referrals` は last_contact の合成に含めない**（SPEC-009）。 |
| **last_bo_contact_at** | **派生（Phase 125）。** owner→target の **例会 BO 同席のみ**の最終日時。`participant_breakout` で同一 `breakout_room` かつ `meetings.held_on` が非 NULL の組のうち、`held_on` を各日 00:00 として比較した MAX。`last_contact_at` の BO 成分と同一ソース。 |
| **last_one_to_one_contact_at** | **派生（Phase 125）。** `one_to_ones` で owner→target・**canceled 以外**の `started_at` / `scheduled_at` / `created_at` の実効日時の MAX（日時未設定は `created_at`）。`last_contact_at` の 1to1 成分と同一ソース。 |
| **last_memo_contact_at** | **派生（Phase 125）。** `contact_memos`（owner→target）の `created_at` の MAX。workspace スコープは `MemberSummaryQuery::getSummaryLiteBatch` と同一（§5.1）。 |
| **relationship_score** | **現時点では未定義。** 重み・正規化・数式は別 SSOT（未作成）または Future extensions で定義する。本 SSOT では入力候補の列挙（same_room_count, last_same_room_meeting, last_memo の有無, one_to_one_count, introduction_count 等）までを正とし、**数式・スコア値の実装は禁止**とする。実装する場合は別ドキュメントで定義したうえで行う。 |

---

## 5.1 Workspace Scope Rules（スコープ一貫性）

Religo は将来の multi-workspace を想定し、**関係データ（flags / memos / introductions 等）は `workspace_id` 列でスコープしやすい形をとる**（各テーブルが workspace_id を保持する案。クエリが単純で一貫性を保ちやすい）。

**例外（SPEC-006 解釈 A・ONETOONES_CROSS_CHAPTER_WS_HIERARCHY_P1）:** **`one_to_ones.workspace_id` は「記録コンテキスト」**であり、通常は **オーナー（owner）側の所属チャプター** を指す。`target_member_id` が **別チャプター所属**（`members.workspace_id` が異なる）でもよい。クロスチャプター 1 to 1 は製品上正式に許容する。API では `is_cross_chapter`・`target_workspace_name` 等で識別可能。

上記を除き、**flags / memos / introductions** など **owner→target の関係データが「同一チャプター内のみ」を強制するか**は、集計・権限のフェーズでクエリ規約として揃える（現状は列の nullable と summary クエリ規約で運用）。

| テーブル | workspace_id | 備考 |
|----------|--------------|------|
| workspaces | — | 親エンティティ |
| one_to_ones | あり（nullable） | 既存で保持 |
| contact_memos | あり（nullable） | 追加 migration で付与 |
| introductions | あり（nullable） | 追加 migration で付与 |
| internal_referrals | あり（nullable） | Phase 123 で migration 追加済み（SPEC-009） |
| dragonfly_contact_flags | あり（nullable） | 追加 migration で付与 |
| members | **あり（nullable）** | **所属チャプター**（BNI 1 member = 1 workspace）。[MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md](MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md) · **MEMBERS-WORKSPACE-BACKFILL-P1** |
| meetings | なし（将来付与可） | Future extensions で workspace_id 付与を検討 |

既存データ互換のため workspace_id は nullable とする。`members.workspace_id` の初期 backfill は **MEMBERS-WORKSPACE-BACKFILL-P1** で migration 実行時に `MemberWorkspaceBackfillService` が実施する。詳細は [MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md](MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md)。

**workspace_id が NULL のときの扱い（実装で迷わないための確定ルール）:**

- **個人利用・単一 workspace 運用:** workspace_id が NULL の行は「デフォルト workspace（暗黙の 1 つ）」として扱う。＝ 単一 workspace 扱い。クエリでは「WHERE workspace_id = :id OR workspace_id IS NULL」を**許容**する（:id はそのときのデフォルト workspace の id。単一運用では 1 件しか workspace が無いか、NULL を「全件」として扱う）。
- **multi-workspace 運用:** workspace_id が一致する行だけを同一スコープとして扱う。NULL の行は「legacy / 未移行」として扱い、**同一クエリで「特定 workspace + NULL」を混在させない**。すなわち「WHERE workspace_id = :id OR workspace_id IS NULL」は**禁止**とする。NULL 行を扱う場合は別クエリ・別画面で「未移行データ」としてのみ参照する。
- **クエリ実装規約:** 単一 workspace 運用では OR workspace_id IS NULL を許容。multi-workspace 運用では WHERE workspace_id = :id のみとし、NULL を混在させない。

**実装（MemberSummaryQuery）:** `App\Queries\Religo\MemberSummaryQuery::getSummaryLiteBatch(..., $workspaceId)` は、`$workspaceId` が **非 null** のとき、上記 3 テーブル（`contact_memos` / `one_to_ones` / `dragonfly_contact_flags`）に対し **`(workspace_id = :id OR workspace_id IS NULL)`** を適用する（単一チャプター運用の legacy 行を現在 workspace に含める）。`$workspaceId` が **null** のときは workspace 列で絞らない（例: Dashboard stale・owner 全体の last_contact）。**MEMBER-SUMMARY-WORKSPACE-NULL-P1** で Query と SSOT を揃えた。

---

## 6. Phase Mapping

| Phase | 内容 | 主に利用するテーブル・指標 |
|-------|------|---------------------------|
| Phase1 | メンバー理解（検索・一覧・summary）。flags と memos。 | members, dragonfly_contact_flags, contact_memos, participants, meetings |
| Phase2 | 接触履歴の構造化。同室回数・直近メモ。 | same_room_count, last_same_room_meeting, last_memo。participants, participant_breakout, breakout_rooms, meetings, contact_memos, breakout_memos（既存） |
| Phase3 | 紹介・1 to 1 を含めた発想支援へ拡張。 | introductions, **internal_referrals**（TYFCB・Phase 123〜）, one_to_ones, members, dragonfly_contact_flags, contact_memos, one_to_one_count, last_one_to_one, introduction_count, relationship_score 等の派生 |

---

## 7. Future Extensions

- **workspace の紐付け:** **members.workspace_id** は **MEMBERS-WORKSPACE-BACKFILL-P1** で追加済み（nullable）。meetings に workspace_id を追加する案は **将来**。contact_memos / introductions / dragonfly_contact_flags には migration で workspace_id（nullable）を追加済み。**Dashboard stale の peer を案B（チャプター限定）にする**は **`members.workspace_id` の利用を `DashboardService` に組み込む別 Phase**（列は足場として利用可能）。
- **workspace_id の backfill（将来の移行手順）:** 既存行の workspace_id が NULL のままのデータがある場合、backfill は「単一 workspace を前提とする環境では、デフォルト workspace を 1 件作成し、該当テーブルを workspace_id で UPDATE する」方針で実施する。複数 workspace 混在時は meeting_id や owner の所属から workspace を推定するロジックを別途定義する。
- **紹介先の拡張（introductions）:** client（紹介先クライアント）, company（会社）, deal（案件）などのカラムまたは関連テーブルで、紹介先を構造化。
- **リファーラル（SPEC-009）:** [REFERRAL_RECORDING_REQUIREMENTS.md](REFERRAL_RECORDING_REQUIREMENTS.md)。**Phase 123:** `introductions.referral_kind`・`internal_referrals` テーブル・API 実装済み。以降の UI / Dashboard 連動は別 Phase。
- **紹介推論:** introductions と contact_flags / same_room_count / one_to_one_count を組み合わせた「紹介の糸口」推論。
- **relationship_score の具体化:** 重み・閾値・正規化ルールを SSOT または別ドキュメントで定義。
- **タグ:** members や contact_memos に対するタグテーブル（多対多）。
- **soft delete:** contact_memos の論理削除（deleted_at）を必要に応じて追加。**論理削除を導入する要件**（復元・監査・last_memo からの除外ルール）は Future extensions に記載する。現時点では物理削除のみとする。
- **dragonfly_contact_events:** 既存の理由ログ・関係ログはそのまま維持。contact_memos は「接触履歴」、contact_events は「フラグ理由・履歴」の住み分け。

---

## 8. 既存実装との対応（スコープロック）

- **既存テーブルは変更しない:** meetings, participants, breakout_rooms, participant_breakout のスキーマは変更しない。dragonfly_contact_flags は「既存カラムの削除・変更」は行わず、workspace_id の追加のみ行う。**members** は Phase14 で category_id 追加・category/role_notes 削除済み。本 SSOT はその状態を反映する。
- **本ドキュメントは SSOT:** 上記の「完成形」を Cursor の実装基準とする。contact_memos の拡張（memo_type, one_to_one_id, workspace_id）および one_to_ones テーブル、introductions（**`referral_kind` 列・SPEC-009**）/ internal_referrals（**§4.14 新規**）/ dragonfly_contact_flags への workspace_id 追加、**categories / roles / member_roles**（Phase14）は、マイグレーション・実装で本定義に従う。
- **新規テーブル:** one_to_ones。**internal_referrals**（§4.14・**Phase 123 で migration 追加済み**）。contact_memos / introductions / dragonfly_contact_flags への workspace_id 追加は別マイグレーションで実施する。**categories, roles, member_roles** は Phase14 で追加済み。

**API 互換（Phase14 以降）:**  
attendees（定例会参加者一覧）や roommates（同室者）など、従来 **members.category（文字列）** や **members.role_notes（文字列）** を返していた API は、互換のため **category** を「group_name / name の表示用文字列」、**role_notes** を「現在の役職名（current_role）」として返す実装とする。内部では categories / member_roles を参照し、レスポンスの形だけ従来どおりに揃える。
