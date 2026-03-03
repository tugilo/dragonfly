# DragonFly Migration 計画 v1（SSOT）

**目的:** DragonFly SPA 用の新規テーブルを DDL レベルで定義する。既存テーブル（meetings, members, participants, breakout_rooms, participant_breakout, breakout_memos）は変更しない。  
**参照:** [DRAGONFLY_DATA_MODEL_V1.md](DRAGONFLY_DATA_MODEL_V1.md)（V1.1）、[DRAGONFLY_API_DESIGN_V1.md](DRAGONFLY_API_DESIGN_V1.md)  
**作成日:** 2026-03-03

---

## 0. 方針

- **新規テーブルのみ** 作成。既存テーブルへのカラム追加・変更は行わない。
- **Laravel の schema ビルダー** で記載するカラム型は、SQLite / MariaDB 両対応を前提とする（string, text, boolean, json, dateTime 等の共通型）。
- **実行順序:** 1 → 2 → 3（members, meetings は既存のため、contact_flags / contact_events はそのまま作成可。one_on_one_sessions も members, meetings に依存）。

---

## 1. create_dragonfly_contact_flags_table

**テーブル名:** `dragonfly_contact_flags`

| カラム | Laravel 型 | null | 備考 |
|--------|------------|------|------|
| id | bigIncrements() | NO | PK |
| owner_member_id | foreignId()->constrained('members') | NO | 記録者。ON DELETE は RESTRICT または CASCADE を運用で決定 |
| target_member_id | foreignId()->constrained('members') | NO | 相手 |
| interested | boolean()->default(false) | NO | 気になる |
| want_1on1 | boolean()->default(false) | NO | 1on1 したい |
| extra_status | json()->nullable() | YES | 追加フラグ。キー snake_case、値 boolean/string/number のみ |
| created_at | timestamps() | YES | |
| updated_at | timestamps() | YES | |

**制約:**

- `unique(['owner_member_id', 'target_member_id'])`
- `index('owner_member_id')`
- `index('interested')`
- `index('want_1on1')`

**DDL イメージ（参考）:**

```sql
CREATE TABLE dragonfly_contact_flags (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  owner_member_id BIGINT UNSIGNED NOT NULL,
  target_member_id BIGINT UNSIGNED NOT NULL,
  interested TINYINT(1) NOT NULL DEFAULT 0,
  want_1on1 TINYINT(1) NOT NULL DEFAULT 0,
  extra_status JSON NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  UNIQUE KEY (owner_member_id, target_member_id),
  INDEX (owner_member_id),
  INDEX (interested),
  INDEX (want_1on1),
  FOREIGN KEY (owner_member_id) REFERENCES members(id),
  FOREIGN KEY (target_member_id) REFERENCES members(id)
);
```

---

## 2. create_dragonfly_contact_events_table

**テーブル名:** `dragonfly_contact_events`

| カラム | Laravel 型 | null | 備考 |
|--------|------------|------|------|
| id | bigIncrements() | NO | PK |
| owner_member_id | foreignId()->constrained('members') | NO | 記録者 |
| target_member_id | foreignId()->constrained('members') | NO | 相手 |
| meeting_id | foreignId()->nullable()->constrained('meetings')->nullOnDelete() | YES | 会議外なら null |
| event_type | string(32) | NO | interested_on / interested_off / want_1on1_on / want_1on1_off / note |
| reason | string(280)->nullable() | YES | 理由の短文 |
| meta | json()->nullable() | YES | 将来拡張用 |
| created_at | timestamp() | YES | updated_at は持たない（イミュータブルログ） |

**注意:** contact_events は「追加のみ」のログとするため、`updated_at` は持たない。Laravel の `timestamps()` を使う場合は `updated_at` を nullable で追加し運用で更新しないか、または `created_at` のみのカラムとする。

**制約:**

- `index(['owner_member_id', 'target_member_id', 'created_at'])`
- `index('meeting_id')`

**DDL イメージ（参考）:**

```sql
CREATE TABLE dragonfly_contact_events (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  owner_member_id BIGINT UNSIGNED NOT NULL,
  target_member_id BIGINT UNSIGNED NOT NULL,
  meeting_id BIGINT UNSIGNED NULL,
  event_type VARCHAR(32) NOT NULL,
  reason VARCHAR(280) NULL,
  meta JSON NULL,
  created_at TIMESTAMP NULL,
  INDEX (owner_member_id, target_member_id, created_at),
  INDEX (meeting_id),
  FOREIGN KEY (owner_member_id) REFERENCES members(id),
  FOREIGN KEY (target_member_id) REFERENCES members(id),
  FOREIGN KEY (meeting_id) REFERENCES meetings(id) ON DELETE SET NULL
);
```

---

## 3. create_dragonfly_one_on_one_sessions_table

**テーブル名:** `dragonfly_one_on_one_sessions`

| カラム | Laravel 型 | null | 備考 |
|--------|------------|------|------|
| id | bigIncrements() | NO | PK |
| owner_member_id | foreignId()->constrained('members') | NO | 記録者 |
| target_member_id | foreignId()->constrained('members') | NO | 相手 |
| held_at | dateTime()->nullable() | YES | 実施日時。未定なら null |
| status | string(16) | NO | planned / done / canceled |
| agenda | text()->nullable() | YES | 話したいこと |
| memo | text()->nullable() | YES | 結果メモ |
| next_action | text()->nullable() | YES | 次やること |
| source_meeting_id | foreignId()->nullable()->constrained('meetings')->nullOnDelete() | YES | きっかけの meeting |
| created_at | timestamps() | YES | |
| updated_at | timestamps() | YES | |

**制約:**

- `index(['owner_member_id', 'target_member_id', 'held_at'])`
- `index('status')`
- `index('source_meeting_id')`

**DDL イメージ（参考）:**

```sql
CREATE TABLE dragonfly_one_on_one_sessions (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  owner_member_id BIGINT UNSIGNED NOT NULL,
  target_member_id BIGINT UNSIGNED NOT NULL,
  held_at DATETIME NULL,
  status VARCHAR(16) NOT NULL,
  agenda TEXT NULL,
  memo TEXT NULL,
  next_action TEXT NULL,
  source_meeting_id BIGINT UNSIGNED NULL,
  created_at TIMESTAMP NULL,
  updated_at TIMESTAMP NULL,
  INDEX (owner_member_id, target_member_id, held_at),
  INDEX (status),
  INDEX (source_meeting_id),
  FOREIGN KEY (owner_member_id) REFERENCES members(id),
  FOREIGN KEY (target_member_id) REFERENCES members(id),
  FOREIGN KEY (source_meeting_id) REFERENCES meetings(id) ON DELETE SET NULL
);
```

---

## 4. 整合ルール（明文化）

- **flags 更新は必ず events を伴う**  
  API で contact_flags の interested または want_1on1 を変更した場合、同一リクエスト内で contact_events に 1 件（以上）追加する。event_type は変更内容に応じて自動設定（interested_on / interested_off / want_1on1_on / want_1on1_off）。アプリケーション層（Service または Controller）で保証する。

- **1on1 作成時 want_1on1 を自動 ON にするか**  
  未決事項とする。する場合は contact_flags の upsert と contact_events への want_1on1_on 追加を整合ルールに従って行う。

---

## 5. 未決事項

- **1on1 セッション作成時に contact_flags.want_1on1 を自動で true にするか**  
  する場合、contact_events に want_1on1_on を 1 件追加する整合ルールに従う。

- **contact_events に updated_at を設けるか**  
  本設計では「追加のみ」のログとして created_at のみでよいとする。Laravel の timestamps() で updated_at を付ける場合は、更新しない運用とする。

- **外部キー ON DELETE**  
  owner_member_id / target_member_id は RESTRICT か CASCADE を運用で決定。members 削除が稀であれば RESTRICT でよい。
