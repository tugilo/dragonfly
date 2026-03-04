# BNI DragonFly メンバー・参加者管理 実装設計

**前提ドキュメント:** [REQUIREMENTS_MEMBER_PARTICIPANTS.md](../../../networking/bni/dragonfly/REQUIREMENTS_MEMBER_PARTICIPANTS.md)  
**作成日:** 2026-03-03  
**役割:** バックエンド設計（DB・リレーション・実装順）

---

## 1. テーブル定義詳細

### 1.1 members（メンバーマスター）

人物のマスタデータ。メンバー・ビジター・ゲストを一括で登録する。

| カラム | 型 | null | index | 備考 |
|--------|----|------|-------|------|
| id | bigIncrements | NO | PK | 主キー |
| name | string(255) | NO | - | 氏名 |
| name_kana | string(255) | YES | - | ふりがな |
| category | string(255) | YES | - | カテゴリー（建設・不動産、中小企業サポート 等） |
| role_notes | string(500) | YES | - | 役職/備考（メンバー用）。ビジター/ゲストは null 可 |
| type | string(20) | NO | YES | 区分: `member` / `visitor` / `guest` |
| display_no | string(20) | YES | - | 表示用 No（例: 1, 2, V1, G1）。一覧表示順の参考 |
| introducer_member_id | foreignId nullable | YES | YES | 紹介者（members.id）。ビジター/ゲスト用 |
| attendant_member_id | foreignId nullable | YES | YES | アテンド（members.id）。ビジター/ゲスト用 |
| created_at | timestamp | YES | - | |
| updated_at | timestamp | YES | - | |

**外部キー制約:**

- `introducer_member_id` → `members.id` (ON DELETE SET NULL)
- `attendant_member_id` → `members.id` (ON DELETE SET NULL)

**インデックス方針:**

- `type`: メンバー/ビジター/ゲスト絞り込み
- `introducer_member_id`, `attendant_member_id`: 紹介者・アテンドでの検索

**補足:** 紹介者・アテンドは「その回の参加時点」の情報であるため、要件上は participants 側に持つ案もある。本設計では元資料の「マスターに紹介者・アテンドあり」を踏まえ members に持つ。回ごとに変わる場合は participants の introducer_member_id / attendant_member_id を優先する運用とする。

---

### 1.2 meetings（定例会）

第何回・いつ実施したかを管理する。

| カラム | 型 | null | index | 備考 |
|--------|----|------|-------|------|
| id | bigIncrements | NO | PK | 主キー |
| number | unsignedInteger | NO | UNIQUE | 回数（例: 199） |
| held_on | date | NO | YES | 実施日 |
| name | string(255) | YES | - | 例: 「第199回定例会」 |
| created_at | timestamp | YES | - | |
| updated_at | timestamp | YES | - | |

**ユニーク制約:** `number`

**インデックス方針:** `held_on`（日付範囲検索）

---

### 1.3 participants（参加者）

「その回に誰が参加したか」を meeting × member で表現する。

| カラム | 型 | null | index | 備考 |
|--------|----|------|-------|------|
| id | bigIncrements | NO | PK | 主キー |
| meeting_id | foreignId | NO | YES | meetings.id |
| member_id | foreignId | NO | YES | members.id |
| type | string(20) | NO | YES | その回の区分: `member` / `visitor` / `guest` |
| introducer_member_id | foreignId nullable | YES | YES | 紹介者（members.id）。ビジター/ゲスト用 |
| attendant_member_id | foreignId nullable | YES | YES | アテンド（members.id）。ビジター/ゲスト用 |
| created_at | timestamp | YES | - | |
| updated_at | timestamp | YES | - | |

**外部キー制約:**

- `meeting_id` → `meetings.id` (ON DELETE CASCADE)
- `member_id` → `members.id` (ON DELETE RESTRICT)
- `introducer_member_id` → `members.id` (ON DELETE SET NULL)
- `attendant_member_id` → `members.id` (ON DELETE SET NULL)

**ユニーク制約:** `(meeting_id, member_id)` — 同一回に同一人物は1件のみ。

**インデックス方針:**

- `meeting_id`: 今日の参加者一覧
- `member_id`: ある人物の参加履歴
- `type`: 回ごとのメンバー/ビジター/ゲスト絞り

---

### 1.4 breakout_rooms（ブレイクアウトルーム）

その回のルーム単位。1 meeting に複数ルーム（A, B, C 等）。

| カラム | 型 | null | index | 備考 |
|--------|----|------|-------|------|
| id | bigIncrements | NO | PK | 主キー |
| meeting_id | foreignId | NO | YES | meetings.id |
| room_label | string(50) | NO | - | ルーム名（例: A, B, C または 1, 2, 3） |
| sort_order | unsignedTinyInteger | YES | YES | 表示順（任意） |
| created_at | timestamp | YES | - | |
| updated_at | timestamp | YES | - | |

**外部キー制約:**

- `meeting_id` → `meetings.id` (ON DELETE CASCADE)

**インデックス方針:** `meeting_id`

**補足:** 同一 meeting 内で `(meeting_id, room_label)` のユニークを付けると、ルーム名の重複を防げる（必要に応じて追加）。

---

### 1.5 participant_breakout（参加者 ⇔ ルーム 中間）

誰がどのルームに入ったか。1 participant は 1 meeting 内で 1 ルームのみ想定。

| カラム | 型 | null | index | 備考 |
|--------|----|------|-------|------|
| id | bigIncrements | NO | PK | 主キー |
| participant_id | foreignId | NO | YES | participants.id |
| breakout_room_id | foreignId | NO | YES | breakout_rooms.id |
| created_at | timestamp | YES | - | （任意） |
| updated_at | timestamp | YES | - | （任意） |

**外部キー制約:**

- `participant_id` → `participants.id` (ON DELETE CASCADE)
- `breakout_room_id` → `breakout_rooms.id` (ON DELETE CASCADE)

**ユニーク制約:** `(participant_id, breakout_room_id)`  
※ 実運用では「1 participant は 1 meeting 内で 1 ルーム」なので、`participant_id` のみユニークでも可。その場合は 1 回の meeting でルーム変更しない前提。ここでは「同室グループ」の多対多として (participant_id, breakout_room_id) ユニークとする。

**インデックス方針:**

- `participant_id`: ある参加者のルーム取得
- `breakout_room_id`: あるルームの参加者一覧（同室者抽出に使用）

---

### 1.6 breakout_memos（同室メモ）

その回で、同室した相手に対して書いたメモ（ミーティング単位）。

| カラム | 型 | null | index | 備考 |
|--------|----|------|-------|------|
| id | bigIncrements | NO | PK | 主キー |
| meeting_id | foreignId | NO | YES | meetings.id |
| participant_id | foreignId | NO | YES | 書いた人（participants.id） |
| target_participant_id | foreignId | NO | YES | メモ対象の同室者（participants.id） |
| breakout_room_id | foreignId nullable | YES | YES | どのルームで同室だったか（breakout_rooms.id） |
| body | text | YES | - | メモ本文 |
| created_at | timestamp | YES | - | |
| updated_at | timestamp | YES | - | |

**外部キー制約:**

- `meeting_id` → `meetings.id` (ON DELETE CASCADE)
- `participant_id` → `participants.id` (ON DELETE CASCADE)
- `target_participant_id` → `participants.id` (ON DELETE CASCADE)
- `breakout_room_id` → `breakout_rooms.id` (ON DELETE SET NULL)

**ユニーク制約（推奨):** `(meeting_id, participant_id, target_participant_id)`  
→ 1 回の meeting で「自分 → 相手」のメモは 1 件。編集時は UPDATE で上書き。

**インデックス方針:**

- `(meeting_id, participant_id)`: ある回で自分が書いたメモ一覧
- `target_participant_id`: 自分宛てのメモ一覧
- `breakout_room_id`: ルーム単位のメモ参照（任意）

---

## 2. リレーション設計（Eloquent 想定）

### 2.1 Member

```php
// 参加履歴（参加者レコード）
public function participants(): HasMany

// 紹介した参加者（ビジター/ゲストの紹介者として）
public function introducedParticipants(): HasMany
// Participant の introducer_member_id → members.id

// アテンドした参加者（ビジター/ゲストのアテンドとして）
public function attendedParticipants(): HasMany
// Participant の attendant_member_id → members.id

// 紹介者としての自己参照（任意）
public function introducer(): BelongsTo  // introducer_member_id
public function attendant(): BelongsTo   // attendant_member_id（members 側では通常未使用）
```

### 2.2 Meeting

```php
public function participants(): HasMany
public function breakoutRooms(): HasMany
public function breakoutMemos(): HasMany  // その回に紐づくメモ一覧
```

### 2.3 Participant

```php
public function meeting(): BelongsTo
public function member(): BelongsTo

// 紹介者・アテンド（メンバーマスター）
public function introducer(): BelongsTo  // introducer_member_id → members
public function attendant(): BelongsTo    // attendant_member_id → members

// ブレイクアウトルーム（多対多）
public function breakoutRooms(): BelongsToMany
// 中間テーブル: participant_breakout

// メモ（書いた側）
public function writtenBreakoutMemos(): HasMany
// breakout_memos.participant_id

// メモ（受け取った側）
public function receivedBreakoutMemos(): HasMany
// breakout_memos.target_participant_id
```

### 2.4 BreakoutRoom

```php
public function meeting(): BelongsTo
public function participants(): BelongsToMany
// 中間テーブル: participant_breakout
public function breakoutMemos(): HasMany  // そのルームで書かれたメモ（breakout_room_id）
```

### 2.5 BreakoutMemo

```php
public function meeting(): BelongsTo
public function participant(): BelongsTo   // 書いた人
public function targetParticipant(): BelongsTo  // メモ対象
public function breakoutRoom(): BelongsTo  // nullable
```

---

## 3. インデックス・制約方針

### 3.1 インデックス一覧

| テーブル | カラム（複合可） | 用途 |
|----------|------------------|------|
| members | type | 区分絞り |
| members | introducer_member_id, attendant_member_id | 紹介者・アテンド検索 |
| meetings | number (UNIQUE) | 回数での一意・検索 |
| meetings | held_on | 日付範囲 |
| participants | meeting_id | 今日の参加者 |
| participants | member_id | 参加履歴 |
| participants | (meeting_id, member_id) UNIQUE | 重複防止 |
| breakout_rooms | meeting_id | ルーム一覧 |
| participant_breakout | participant_id, breakout_room_id | 同室者取得・重複防止 |
| breakout_memos | (meeting_id, participant_id) | 自分が書いたメモ |
| breakout_memos | target_participant_id | 自分宛てメモ |
| breakout_memos | (meeting_id, participant_id, target_participant_id) UNIQUE | 1対1メモの一意 |

### 3.2 制約ルール

- **既存テーブル変更禁止:** users 等の既存テーブルは触らない。
- **SQLite / MariaDB 両対応:** Laravel の schema ビルダーで共通の型（string, text, unsignedInteger, date, foreignId）を使用。DB 固有の型は使わない。
- **外部キー:** マイグレーションで `foreignId()->constrained()->cascadeOnDelete()` 等を明示。SQLite は `Schema::enableForeignKeyConstraints()` を確認。
- **ソフトデリート:** 本設計では未使用。必要なら将来 `deleted_at` を追加。

---

## 4. 実装ステップ順序

| 順序 | 内容 | 成果物・備考 |
|------|------|-----------------------------|
| 1 | マイグレーション作成 | 上記 6 テーブル。依存順: members → meetings → participants → breakout_rooms → participant_breakout → breakout_memos |
| 2 | Eloquent モデル作成 | Member, Meeting, Participant, BreakoutRoom, BreakoutMemo。$fillable, $casts, テーブル名 |
| 3 | リレーション定義 | 上記 2 節のとおり。BelongsTo / HasMany / BelongsToMany を実装 |
| 4 | シード／インポート用 | All_Participants の Markdown から members + 1 meeting + participants を投入する Artisan コマンドまたは Seeder |
| 5 | 今日の参加者一覧 | 指定 meeting_id で participants + member を取得する API またはメソッド（F4） |
| 6 | 同室者抽出ロジック | participant_id から同じ breakout_room_id の他 participant を返すメソッド（F7） |
| 7 | ブレイクアウトメモ CRUD | メモの登録・更新・取得（F8）。必要なら API/画面 |

**推奨:** 1 → 2 → 3 までを一括で行い、`php artisan migrate` とリレーションの動作確認後に 4 以降に進む。

---

## 5. 将来拡張ポイント

| 拡張内容 | 方針 |
|----------|------|
| **member_notes（マスター側の恒常メモ）** | テーブル `member_notes (id, member_id, body, created_at)` を追加。Member hasMany MemberNotes。 |
| **参加者インポート（CSV/MD）** | 専用の Importer クラスまたは Artisan コマンドで、All_Participants 形式をパースして members / participants を一括投入。 |
| **ブレイクアウト「ルーム名」の厳密化** | breakout_rooms に `(meeting_id, room_label)` の UNIQUE を追加し、同一回での重複を禁止。 |
| **紹介者・アテンドを participant 基準に** | 回ごとに変わる場合は participants.introducer_member_id / attendant_member_id を優先し、members 側は「初期値」扱いにする。 |
| **ソフトデリート** | members / participants に `deleted_at` を追加し、削除は論理削除に変更可能。 |
| **アクセス制御** | 個人情報のため、Policy やスコープで「見えてよい meeting / member」を制限する拡張を想定。 |

---

## 6. 制約まとめ

- **既存テーブル変更禁止**
- **SQLite / MariaDB 両対応**（Laravel の共通型のみ使用）
- **外部キー制約はマイグレーションで明示**
- 前提要件: [REQUIREMENTS_MEMBER_PARTICIPANTS.md](../../../networking/bni/dragonfly/REQUIREMENTS_MEMBER_PARTICIPANTS.md) に準拠

---

## 7. 参照

- 要件: `docs/networking/bni/dragonfly/REQUIREMENTS_MEMBER_PARTICIPANTS.md`
- 元データ: `docs/networking/bni/dragonfly/participants/BNI_DragonFly_All_Participants_20260303.md`, `BNI_DragonFly_Breakout_20260303.md`
