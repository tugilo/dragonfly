# Religo 会の地図（Relationship Map）データモデル — SSOT

**目的:** Religo の「会の地図」を構成するデータモデルを SSOT として確定する。  
**前提:** 命名は [PROJECT_NAMING.md](../PROJECT_NAMING.md) に従う（Religo＝プロダクト名、DragonFly＝チャプター名、dragonfly＝リポジトリ名）。  
**作成日:** 2026-03-04

---

## 1. Overview（会の地図の定義）

会の地図は **「誰がいるか／会ったか／関係／紹介」** を構造化したものである。

- **誰がいるか** … 会（workspace）に属するメンバー一覧。
- **会ったか** … 定例会（meetings）への参加（participants）と、同室グループ（breakout_rooms / breakout_participants）。
- **関係** … 利用者（owner）から相手（target）へのフラグ（interested / want_1on1 / extra_status）とメモ（contact_memos）。
- **紹介** … 紹介の記録（introductions）。Phase3 で拡張。

owner は「自分（利用者）」を意味する。個人利用では `owner_member_id` ＝ 自分。将来 multi-user 化しても破綻しないよう owner を軸にする。

---

## 2. Entities 一覧

| 記号 | エンティティ | テーブル名 | 備考 |
|------|--------------|------------|------|
| A | workspace | workspaces | 会／チャプター・プロジェクト単位。個人利用でも拡張できる土台。 |
| B | members | members | 会にいる人。 |
| C | meetings | meetings | 定例会（meeting_number, date）。 |
| D | participants | participants | meeting 参加者の紐付け（meeting × member）。 |
| E | breakout_rooms | breakout_rooms | 同室グループ（meeting 内の部屋）。 |
| F | breakout_participants | participant_breakout | 部屋と参加者の紐付け（既存テーブル名は participant_breakout）。 |
| G | contact_flags | dragonfly_contact_flags | owner→target の関係フラグ：interested / want_1on1 / extra_status。 |
| H | contact_memos | contact_memos | owner→target のメモ。meeting に紐付け可能。 |
| I | introductions | introductions | 紹介の記録。Phase3 拡張。最低限スキーマ定義。 |

---

## 3. Relationship（ER の文章化）

- **workspace 1:N members**  
  1 つの workspace に複数の members が属する。※ 現行実装では workspace 未導入のため、単一 workspace を前提とする。将来 `members.workspace_id` で紐付ける。

- **workspace 1:N meetings**  
  1 つの workspace に複数の meetings が属する。※ 現行では `meetings` に workspace_id なし。将来追加。

- **meeting 1:N participants**  
  1 回の meeting に複数の participants（参加者）がいる。participant は member を参照する。

- **meeting 1:N breakout_rooms**  
  1 回の meeting に複数の breakout_rooms（同室グループ）がある。

- **breakout_room 1:N breakout_participants**  
  1 つの breakout_room に複数の breakout_participants が紐づく。breakout_participant は participant を経由して member に至る。実装ではテーブル `participant_breakout` が participant と breakout_room を多対多で結ぶ。

- **owner → target の関係データ**  
  - **contact_flags:** owner_member_id → target_member_id で 1 行。interested / want_1on1 / extra_status を保持。  
  - **contact_memos:** owner_member_id → target_member_id のメモ。meeting_id は任意。  
  - **introductions:** 紹介の記録（from / to / 経由 等）。Phase3 で利用。

---

## 4. Table definitions（各テーブル）

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

### 4.2 members

| 項目 | 内容 |
|------|------|
| **目的** | 会にいる人。名前・カテゴリ・紹介元等を保持。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | introducer_member_id → members.id (nullable), attendant_member_id → members.id (nullable)。将来 workspace_id → workspaces.id を追加可。 |
| **ユニーク制約** | なし（同一名の別メンバーを許容するため） |
| **主要カラム** | id, name, name_kana (nullable), category (nullable), role_notes (nullable), type, display_no (nullable), introducer_member_id, attendant_member_id, timestamps |
| **インデックス** | type, introducer_member_id, attendant_member_id |

※ 既存マイグレーションに合わせている。仕様変更は行わない。

---

### 4.3 meetings

| 項目 | 内容 |
|------|------|
| **目的** | 定例会。回番号と開催日を保持。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | なし。将来 workspace_id → workspaces.id を追加可。 |
| **ユニーク制約** | number UNIQUE |
| **主要カラム** | id, number (unsignedInteger), held_on (date), name (nullable), timestamps |
| **インデックス** | held_on, number |

---

### 4.4 participants

| 項目 | 内容 |
|------|------|
| **目的** | その meeting に誰が参加したかの紐付け。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | meeting_id → meetings.id (cascadeOnDelete), member_id → members.id (restrictOnDelete), introducer_member_id, attendant_member_id (nullable) |
| **ユニーク制約** | (meeting_id, member_id) UNIQUE |
| **主要カラム** | id, meeting_id, member_id, type, introducer_member_id, attendant_member_id (nullable), timestamps |
| **インデックス** | meeting_id, member_id, type |

---

### 4.5 breakout_rooms

| 項目 | 内容 |
|------|------|
| **目的** | 同室グループ。1 回の meeting 内の部屋。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | meeting_id → meetings.id (cascadeOnDelete) |
| **ユニーク制約** | (meeting_id, room_label) UNIQUE |
| **主要カラム** | id, meeting_id, room_label, sort_order (nullable), timestamps |
| **インデックス** | meeting_id, sort_order |

---

### 4.6 breakout_participants（テーブル名: participant_breakout）

| 項目 | 内容 |
|------|------|
| **目的** | どの参加者がどの同室にいたかの紐付け。participant 経由で member に至る。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | participant_id → participants.id (cascadeOnDelete), breakout_room_id → breakout_rooms.id (cascadeOnDelete) |
| **ユニーク制約** | (participant_id, breakout_room_id) UNIQUE |
| **主要カラム** | id, participant_id, breakout_room_id, timestamps |
| **インデックス** | participant_id, breakout_room_id |

---

### 4.7 contact_flags（テーブル名: dragonfly_contact_flags）

| 項目 | 内容 |
|------|------|
| **目的** | owner→target の「今の状態」を 1 行で保持。interested / want_1on1 / extra_status。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | owner_member_id → members.id (restrictOnDelete), target_member_id → members.id (restrictOnDelete) |
| **ユニーク制約** | (owner_member_id, target_member_id) UNIQUE |
| **主要カラム** | id, owner_member_id, target_member_id, interested (boolean, default false), want_1on1 (boolean, default false), extra_status (json, nullable), timestamps |
| **インデックス** | owner_member_id, interested, want_1on1 |

---

### 4.8 contact_memos

| 項目 | 内容 |
|------|------|
| **目的** | owner→target のメモ。meeting に紐付け可能（直近メモ・同室メモの補完）。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | owner_member_id → members.id (restrictOnDelete), target_member_id → members.id (restrictOnDelete), meeting_id → meetings.id (nullable, nullOnDelete) |
| **ユニーク制約** | なし（1 owner–target で複数メモ可） |
| **主要カラム** | id, owner_member_id, target_member_id, meeting_id (nullable), body (text, nullable), timestamps |
| **インデックス** | (owner_member_id, target_member_id, created_at) で直近取得。meeting_id。 |

**soft delete:** まずは無し。論理削除が必要になったら `deleted_at` を追加する。理由: 直近メモ表示は「存在するメモ」のみで足りるため、初期は物理削除でよい。

---

### 4.9 introductions

| 項目 | 内容 |
|------|------|
| **目的** | 紹介の記録。Phase3 拡張用。最低限スキーマのみ定義。 |
| **主キー** | id (bigIncrements) |
| **外部キー** | owner_member_id → members.id, from_member_id → members.id, to_member_id → members.id。meeting_id (nullable), introduced_at (date nullable) 等を想定。 |
| **ユニーク制約** | なし（同一ペアで複数回紹介があり得る） |
| **主要カラム** | id, owner_member_id, from_member_id, to_member_id, meeting_id (nullable), introduced_at (nullable), note (text, nullable), timestamps |
| **インデックス** | (owner_member_id, from_member_id, to_member_id), meeting_id |

---

## 5. Derived metrics（派生値の定義）

以下はテーブルではなく、既存テーブルから算出する値とする。

| 指標 | 定義・算出方法 |
|------|----------------|
| **same_room_count** | owner と target が同じ breakout_room に入った meeting の回数。participant_breakout と participants から、owner/target を member_id に変換し、同一 meeting 内で同一 breakout_room_id の組み合わせを COUNT。 |
| **last_same_room_meeting** | 上記「同室」だった meeting のうち、held_on または number が最大のもの。 |
| **last_memo** | contact_memos の (owner_member_id, target_member_id) で created_at 降順の先頭 1 件。meeting 紐付けありの場合は meeting 情報も併せて返す。 |

既存の breakout_memos は「その回の同室での具体メモ」として別用途。contact_memos は owner→target の直近メモ・Phase2 の「直近メモ」表示に使う。

---

## 6. Phase 対応表

| Phase | 内容 | 主に利用するテーブル |
|-------|------|----------------------|
| Phase1 | メンバー理解（検索・一覧・summary・flags: interested / want_1on1 / extra_status） | members, dragonfly_contact_flags, participants, meetings |
| Phase2 | 接触履歴の構造化（同室回数・直近メモ） | participants, participant_breakout, breakout_rooms, meetings, contact_memos, breakout_memos（既存） |
| Phase3 | 紹介発想支援（紹介の糸口） | introductions, members, contact_flags, contact_memos, same_room_count 等の派生 |

---

## 7. Future extensions（将来拡張）

- **workspace の紐付け:** members / meetings に workspace_id を追加し、マルチワークスペース対応。
- **紹介推論:** introductions と contact_flags / same_room_count を組み合わせた「紹介の糸口」推論。
- **関係性スコア:** 同室回数・メモ数・フラグを元にしたスコア（別テーブル or 算出のみ）。
- **タグ:** members や contact_memos に対するタグテーブル（多対多）。
- **soft delete:** contact_memos の論理削除（deleted_at）を必要に応じて追加。
- **dragonfly_contact_events:** 既存の理由ログ・関係ログはそのまま維持。contact_memos は「自由メモ」、contact_events は「フラグ理由・履歴」の住み分け。

---

## 8. 既存実装との対応（スコープロック）

- 既存テーブル（members, meetings, participants, breakout_rooms, participant_breakout, breakout_memos, dragonfly_contact_flags, dragonfly_contact_events）の仕様は変更しない。
- 本ドキュメントは「会の地図」の正規のデータモデルを SSOT として定義し、既存テーブル名（dragonfly_contact_flags, participant_breakout 等）はそのまま記載している。
- 新規追加するのは **workspaces**, **contact_memos**, **introductions** のマイグレーション雛形のみ。
