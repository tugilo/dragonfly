# Religo 会の地図（Relationship Map）データモデル — SSOT

**目的:** Religo（DragonFly）の「会の地図」を構成するデータモデルを SSOT として確定する。  
**Cursor の実装基準:** 本ドキュメントに書かれている内容を実装の正とする。  
**前提:** 命名は [PROJECT_NAMING.md](../PROJECT_NAMING.md) に従う（Religo＝プロダクト名、DragonFly＝チャプター名、dragonfly＝リポジトリ名）。  
**作成日:** 2026-03-04

---

## 1. Overview

### 1.1 Religo の目的

**Religo の目的は「BNI メンバーの関係を構造化した会の地図を作ること」である。** DragonFly は BNI チャプター名であり、本データモデルは Religo（プロダクト）の SSOT とする。

会の地図は、次の 4 つの関係をデータとして蓄積するモデルとする。

| 関係 | 意味 | 主なデータ |
|------|------|------------|
| **会った** | いつ・どの定例会で会ったか | meetings, participants |
| **話した** | 同室・接触・メモ | breakout_rooms, participant_breakout, contact_memos |
| **1 to 1** | BNI の「1 to 1」の予定と履歴 | one_to_ones |
| **紹介** | 誰を誰に紹介したか | introductions |

### 1.2 会の地図の関係データ（7 要素）

会の地図を構成する正式な要素は以下とする。

| # | 要素 | テーブル | 説明 |
|---|------|----------|------|
| 1 | 誰がいるか | members | 会にいる人。 |
| 2 | いつ会ったか | meetings | 定例会（回番号・日付）。 |
| 3 | 同室履歴 | breakout_rooms, participant_breakout | どの meeting で誰と同室だったか。 |
| 4 | 接触履歴 | contact_memos | 例会メモ・1 to 1 メモ・紹介メモ・雑談メモなど。 |
| 5 | 1 to 1 | one_to_ones | BNI の「1 to 1」の予定と実施履歴。 |
| 6 | 興味関心 | dragonfly_contact_flags | owner→target のフラグ（interested / want_1on1 / extra_status）。 |
| 7 | 紹介 | introductions | 紹介の記録（誰が誰を誰に紹介したか）。 |

Religo では BNI 正式用語に合わせて「1 to 1」を扱う。表記: UI/文章は "1 to 1"、テーブル名は one_to_ones、memo_type の値は one_to_one。1 to 1 は「予定」「実施」「キャンセル」を持つイベントとして扱い、メモは関係履歴として contact_memos に保存し、1 to 1 に紐付け可能とする。

**owner** は「自分（利用者）」を意味する。個人利用では `owner_member_id` ＝ 自分。将来 multi-user 化しても破綻しないよう owner を軸にする。

**接触履歴が無い状態の表現:** 同室・メモ・1 to 1 のいずれも無くても、dragonfly_contact_flags（interested / want_1on1）で「会ったことはないが興味がある」「1 to 1 したい」という状態を表現できる。last_contact_at が NULL かつ flags が ON の組み合わせで「会ったことないが興味ある」と解釈する。

---

## 2. Entities

| 記号 | エンティティ | テーブル名 | 備考 |
|------|--------------|------------|------|
| A | workspace | workspaces | 会／チャプター・プロジェクト単位。個人利用でも拡張できる土台。 |
| B | members | members | 誰がいるか。会にいる人。 |
| C | meetings | meetings | いつ会ったか。定例会（回番号・日付）。 |
| D | participants | participants | meeting 参加者の紐付け（meeting × member）。 |
| E | breakout_rooms | breakout_rooms | 同室履歴の単位。1 回の meeting 内の部屋。 |
| F | breakout_participants | participant_breakout | 同室履歴の紐付け。部屋と参加者（既存テーブル名は participant_breakout）。 |
| G | contact_flags | dragonfly_contact_flags | 興味関心。owner→target のフラグ。 |
| H | contact_memos | contact_memos | 接触履歴。owner→target のメモ（例会・1 to 1・紹介・雑談など）。 |
| I | one_to_ones | one_to_ones | 1 to 1。BNI の「1 to 1」の予定と履歴。 |
| J | introductions | introductions | 紹介。紹介の記録。 |

---

## 3. Relationships

- **workspace 1:N members**  
  1 つの workspace に複数の members が属する。※ 現行実装では workspace 未導入のため、単一 workspace を前提とする。将来 `members.workspace_id` で紐付ける。

- **workspace 1:N meetings**  
  1 つの workspace に複数の meetings が属する。※ 現行では `meetings` に workspace_id なし。将来追加。

- **meeting 1:N participants**  
  1 回の meeting に複数の participants（参加者）がいる。participant は member を参照する。

- **meeting 1:N breakout_rooms**  
  1 回の meeting に複数の breakout_rooms（同室グループ）がある。

- **breakout_room N:M participants**（実装: participant_breakout）  
  1 つの breakout_room に複数の participants が紐づく。participant は member に至る。テーブル `participant_breakout` が participant と breakout_room を多対多で結ぶ。

- **owner → target の関係データ**  
  - **dragonfly_contact_flags:** owner_member_id → target_member_id で 1 行。interested / want_1on1 / extra_status を保持。  
  - **contact_memos:** owner_member_id → target_member_id のメモ。meeting_id / one_to_one_id は任意。memo_type で種別（例会・1 to 1・紹介・その他）を区別。  
  - **one_to_ones:** owner_member_id → target_member_id の「1 to 1」予定・履歴。1 件の one_to_one に複数の contact_memos を紐付け可能。  
  - **introductions:** owner_member_id, from_member_id, to_member_id で紹介を記録。

- **one_to_ones 1:N contact_memos**  
  1 件の 1 to 1 の会話内容を、contact_memos（memo_type = one_to_one, one_to_one_id 設定）として履歴保存する。

---

## 4. Table Definitions

### 4.1 workspaces

| 項目 | 内容 |
|------|------|
| **目的** | 会／チャプターやプロジェクト単位のコンテキスト。個人利用でも 1 workspace で拡張できる土台。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | なし |
| **ユニーク制約** | 特になし（必要に応じて name 等を後から追加可） |
| **主要カラム** | id, name (string), slug (string, nullable), timestamps |
| **インデックス** | slug にユニークまたは検索用インデックスを検討 |

※ created_at / updated_at は Laravel 標準で付与する前提。

---

### 4.2 members（既存・変更しない）

| 項目 | 内容 |
|------|------|
| **目的** | 誰がいるか。会にいる人。名前・カテゴリ・紹介元等を保持。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | introducer_member_id → members.id (nullable), attendant_member_id → members.id (nullable)。将来 workspace_id → workspaces.id を追加可。 |
| **ユニーク制約** | なし |
| **主要カラム** | id, name, name_kana (nullable), category (nullable), role_notes (nullable), type, display_no (nullable), introducer_member_id, attendant_member_id, timestamps |
| **インデックス** | type, introducer_member_id, attendant_member_id |

**members.type の値域（SSOT 確定・実装で迷わない最小セット）:** active（在籍）, inactive（休会・退会等）, guest（ゲスト参加者）。将来拡張は Future extensions に記載する。一覧・指標で「除外する type」を決める場合はこの値域を参照する。

---

### 4.3 meetings（既存・変更しない）

| 項目 | 内容 |
|------|------|
| **目的** | いつ会ったか。定例会。回番号と開催日を保持。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | なし。将来 workspace_id → workspaces.id を追加可。 |
| **ユニーク制約** | number UNIQUE |
| **主要カラム** | id, number (unsignedInteger), held_on (date), name (nullable), timestamps |
| **インデックス** | held_on, number |

**number / held_on が不明な場合のルール（実装規約）:** 現行スキーマでは number は UNIQUE のため、番号が不明な過去回は「ダミー番号（例: 0。他と衝突しない値）を使用する」か、将来 number を nullable にする migration を実施するまで許容しない。held_on が NULL の meeting は、last_contact_at や last_same_room_meeting の算出では「その meeting の held_on は存在しない」として扱い、同室のみで寄与する場合は datetime 変換の対象から外す（NULL として無視する）。

---

### 4.4 participants（既存・変更しない）

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

### 4.5 breakout_rooms（既存・変更しない）

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

### 4.6 breakout_participants（テーブル名: participant_breakout）（既存・変更しない）

| 項目 | 内容 |
|------|------|
| **目的** | 同室履歴の紐付け。どの参加者がどの同室にいたか。participant 経由で member に至る。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | participant_id → participants.id (cascadeOnDelete), breakout_room_id → breakout_rooms.id (cascadeOnDelete) |
| **ユニーク制約** | (participant_id, breakout_room_id) UNIQUE |
| **主要カラム** | id, participant_id, breakout_room_id, timestamps |
| **インデックス** | participant_id, breakout_room_id |

---

### 4.7 contact_flags（テーブル名: dragonfly_contact_flags）（既存・変更しない）

| 項目 | 内容 |
|------|------|
| **目的** | 興味関心。owner→target の「今の状態」を 1 行で保持。interested / want_1on1 / extra_status。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | owner_member_id → members.id (restrictOnDelete), target_member_id → members.id (restrictOnDelete), **workspace_id → workspaces.id (nullable, nullOnDelete)**（追加 migration で付与） |
| **ユニーク制約** | (owner_member_id, target_member_id) UNIQUE（維持）。将来は (workspace_id, owner_member_id, target_member_id) のユニークを検討。 |
| **主要カラム** | id, **workspace_id (nullable)**, owner_member_id, target_member_id, interested (boolean, default false), want_1on1 (boolean, default false), extra_status (json, nullable), timestamps |
| **インデックス** | owner_member_id, interested, want_1on1, **workspace_id** |

---

### 4.8 contact_memos（接触履歴・拡張定義）

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

### 4.9 one_to_ones（新規）

BNI の「1 to 1」の予定と履歴を保存するテーブル。BNI では「1 to 1」が正式用語のため、テーブル名は **one_to_ones** とする。

| 項目 | 内容 |
|------|------|
| **目的** | 1 to 1。BNI の「1 to 1」の予定と実施履歴。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | workspace_id → workspaces.id (nullable。現行は未導入のため nullable 可), owner_member_id → members.id (restrictOnDelete), target_member_id → members.id (restrictOnDelete), meeting_id → meetings.id (nullable, nullOnDelete) |
| **ユニーク制約** | なし（同一ペアで複数回の 1 to 1 があり得る）。重複予定を避けるため (owner_member_id, target_member_id, scheduled_at) のユニークは将来検討とし、今回はインデックスのみ。 |
| **主要カラム** | id, workspace_id (nullable), owner_member_id, target_member_id, scheduled_at (datetime, nullable), started_at (datetime, nullable), ended_at (datetime, nullable), status (string: planned / completed / canceled), meeting_id (nullable), notes (text, nullable), timestamps |
| **インデックス** | (owner_member_id, target_member_id), scheduled_at |

**scheduled_at の変更:** 予定日時の変更は**上書き**で行う。変更履歴（監査ログ）が必要な場合は Future extensions で別テーブル等を検討する。

**status:**

| 値 | 意味 |
|----|------|
| planned | 予定 |
| completed | 実施済み |
| canceled | キャンセル |

---

### 4.10 introductions（紹介）

| 項目 | 内容 |
|------|------|
| **目的** | 紹介。紹介の記録（誰が誰を誰に紹介したか）。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | owner_member_id → members.id (restrictOnDelete), from_member_id → members.id (restrictOnDelete), to_member_id → members.id (restrictOnDelete), meeting_id → meetings.id (nullable, nullOnDelete), **workspace_id → workspaces.id (nullable, nullOnDelete)**（追加 migration で付与） |
| **ユニーク制約** | なし（同一ペアで複数回紹介があり得る） |
| **主要カラム** | id, **workspace_id (nullable)**, owner_member_id, from_member_id, to_member_id, meeting_id (nullable), notes (text, nullable), created_at, updated_at |
| **インデックス** | (owner_member_id, from_member_id, to_member_id), meeting_id, **workspace_id** |

**逆紹介:** 紹介先（to）が紹介元（from）に紹介し返す場合は、**逆方向の introductions 行（from_member_id と to_member_id を入れ替えた別行）** で表現する。同一レコードで「逆紹介」リンクを持たない。

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
| **last_contact_at** | **必須指標。** owner→target の「最後の接触」を **1 つの datetime** で表す。**比較規則:** (1) meeting.held_on（date）はその日の 00:00:00 として datetime に変換して比較する。(2) contact_memos.created_at, one_to_ones の scheduled_at/started_at（**status = canceled の行は除外**）, introductions.created_at はそのまま datetime として扱う。(3) 上記の「存在する値」の MAX をとる。NULL は無視する。全て NULL なら last_contact_at は NULL。数式実装では datetime 同士で MAX をとること。 |
| **relationship_score** | **現時点では未定義。** 重み・正規化・数式は別 SSOT（未作成）または Future extensions で定義する。本 SSOT では入力候補の列挙（same_room_count, last_same_room_meeting, last_memo の有無, one_to_one_count, introduction_count 等）までを正とし、**数式・スコア値の実装は禁止**とする。実装する場合は別ドキュメントで定義したうえで行う。 |

---

## 5.1 Workspace Scope Rules（スコープ一貫性）

Religo は将来の multi-workspace を想定する。**原則: すべての関係データ（flags / memos / 1to1 / introductions）は「同一 workspace 内」で完結することとする。** スコープ方法は「各テーブルが workspace_id を保持する」案を採用する（クエリが単純で一貫性を保ちやすい）。

| テーブル | workspace_id | 備考 |
|----------|--------------|------|
| workspaces | — | 親エンティティ |
| one_to_ones | あり（nullable） | 既存で保持 |
| contact_memos | あり（nullable） | 追加 migration で付与 |
| introductions | あり（nullable） | 追加 migration で付与 |
| dragonfly_contact_flags | あり（nullable） | 追加 migration で付与 |
| members | なし（将来付与可） | Future extensions で workspace_id 付与を検討 |
| meetings | なし（将来付与可） | Future extensions で workspace_id 付与を検討 |

既存データ互換のため workspace_id は nullable とする。既存行の workspace_id 埋め（backfill）は別タスクとし、方針は「7. Future Extensions」に記載する。

**workspace_id が NULL のときの扱い（実装で迷わないための確定ルール）:**

- **個人利用・単一 workspace 運用:** workspace_id が NULL の行は「デフォルト workspace（暗黙の 1 つ）」として扱う。＝ 単一 workspace 扱い。クエリでは「WHERE workspace_id = :id OR workspace_id IS NULL」を**許容**する（:id はそのときのデフォルト workspace の id。単一運用では 1 件しか workspace が無いか、NULL を「全件」として扱う）。
- **multi-workspace 運用:** workspace_id が一致する行だけを同一スコープとして扱う。NULL の行は「legacy / 未移行」として扱い、**同一クエリで「特定 workspace + NULL」を混在させない**。すなわち「WHERE workspace_id = :id OR workspace_id IS NULL」は**禁止**とする。NULL 行を扱う場合は別クエリ・別画面で「未移行データ」としてのみ参照する。
- **クエリ実装規約:** 単一 workspace 運用では OR workspace_id IS NULL を許容。multi-workspace 運用では WHERE workspace_id = :id のみとし、NULL を混在させない。

---

## 6. Phase Mapping

| Phase | 内容 | 主に利用するテーブル・指標 |
|-------|------|---------------------------|
| Phase1 | メンバー理解（検索・一覧・summary）。flags と memos。 | members, dragonfly_contact_flags, contact_memos, participants, meetings |
| Phase2 | 接触履歴の構造化。同室回数・直近メモ。 | same_room_count, last_same_room_meeting, last_memo。participants, participant_breakout, breakout_rooms, meetings, contact_memos, breakout_memos（既存） |
| Phase3 | 紹介・1 to 1 を含めた発想支援へ拡張。 | introductions, one_to_ones, members, dragonfly_contact_flags, contact_memos, one_to_one_count, last_one_to_one, introduction_count, relationship_score 等の派生 |

---

## 7. Future Extensions

- **workspace の紐付け:** members / meetings に workspace_id を追加し、マルチワークスペース対応。contact_memos / introductions / dragonfly_contact_flags には今回 migration で workspace_id（nullable）を追加済み。
- **workspace_id の backfill（将来の移行手順）:** 既存行の workspace_id が NULL のままのデータがある場合、backfill は「単一 workspace を前提とする環境では、デフォルト workspace を 1 件作成し、該当テーブルを workspace_id で UPDATE する」方針で実施する。複数 workspace 混在時は meeting_id や owner の所属から workspace を推定するロジックを別途定義する。
- **紹介先の拡張（introductions）:** client（紹介先クライアント）, company（会社）, deal（案件）などのカラムまたは関連テーブルで、紹介先を構造化。
- **紹介推論:** introductions と contact_flags / same_room_count / one_to_one_count を組み合わせた「紹介の糸口」推論。
- **relationship_score の具体化:** 重み・閾値・正規化ルールを SSOT または別ドキュメントで定義。
- **タグ:** members や contact_memos に対するタグテーブル（多対多）。
- **soft delete:** contact_memos の論理削除（deleted_at）を必要に応じて追加。**論理削除を導入する要件**（復元・監査・last_memo からの除外ルール）は Future extensions に記載する。現時点では物理削除のみとする。
- **dragonfly_contact_events:** 既存の理由ログ・関係ログはそのまま維持。contact_memos は「接触履歴」、contact_events は「フラグ理由・履歴」の住み分け。

---

## 8. 既存実装との対応（スコープロック）

- **既存テーブルは変更しない:** members, meetings, participants, breakout_rooms, participant_breakout のスキーマは変更しない。dragonfly_contact_flags は「既存カラムの削除・変更」は行わず、workspace_id の追加のみ行う。
- **本ドキュメントは SSOT:** 上記の「完成形」を Cursor の実装基準とする。contact_memos の拡張（memo_type, one_to_one_id, workspace_id）および one_to_ones テーブル、introductions / dragonfly_contact_flags への workspace_id 追加は、マイグレーションで本定義に従う。
- **新規テーブル:** one_to_ones。contact_memos / introductions / dragonfly_contact_flags への workspace_id 追加は別マイグレーションで実施する。
