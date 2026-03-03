# DragonFly データモデル v1（SSOT）

**目的:** DragonFly SPA に必要なデータモデルを、既存スキーマを踏まえて SSOT として確定する。  
**前提:** [DRAGONFLY_SPA_REQUIREMENTS_V1.md](../../requirements/dragonfly/DRAGONFLY_SPA_REQUIREMENTS_V1.md)、既存テーブル（meetings, members, participants, breakout_rooms, participant_breakout, breakout_memos）。  
**制約:** 既存テーブルの破壊的変更は禁止。新規テーブル・追加カラムは設計案として提示するのみ。  
**作成日:** 2026-03-03

---

## 0. 目的と設計方針

- **“スピード入力” を壊さない**  
  ワンタップ中心の UI を支えるため、人物カードの「今の状態」は 1 テーブルで高速に参照できるようにする（恒久フラグ）。

- **後で振り返れる（理由が残る）**  
  「気になる」を恒久フラグにすると“なぜ気になったか”を忘れがちなため、**恒久フラグ ＋ 理由ログ（meeting 単位のコンテキスト）** を設計に組み込む。

- **meeting スコープと恒久スコープを分離する**  
  - meeting 内: 同室者・同室メモ（既存 participant_breakout / breakout_memos）。  
  - 恒久: 人物に対するフラグ状態（新規 contact_flags）と、その理由・履歴（新規 contact_events）。

- **将来のログイン導入に耐える（owner 概念）**  
  記録者を「owner」として一貫して扱い、当面は participant から解決し、将来は member（ログインユーザー）に切り替え可能にする。

---

## 1. 既存スキーマの位置づけ（簡単に）

| テーブル | 役割（本設計での位置づけ） |
|----------|----------------------------|
| **participants** | 「その meeting に参加した member」。記録者（自分）と相手はともに participant として扱える。 |
| **breakout_memos** | **meeting 内**での、相手（target_participant）への具体メモ。同室での会話内容・フォロー内容を格納。 |
| **participant_breakout** | **meeting 内**の同室関係（誰がどの breakout_room に入ったか）。ルーム経由で「同室者」を導出する。 |

既存の meetings / members / breakout_rooms は変更せず、そのまま参照する。

---

## 2. 新規に必要な概念（必須）

要件 SSOT および「気になるは恒久だが理由を忘れない」という洞察から、以下を **要件として必須** とし、データモデルに落とす。

### A) 恒久フラグ（人物ベース）

- 例: **interested**（気になる）/ **want_1on1**（1on1 したい）など。
- 相手は **member** で一意に識別する（meeting をまたいで同じ「人」を指すため）。
- 「今の状態」を人物カードで即表示するために、1 行で取得できるテーブルとする。

### B) 理由ログ（コンテキストログ）

- **いつ・どの meeting で・なぜ** フラグを立てたか（短文）を残す。
- meeting が無い場合（会全体のメモや、会議外で付けたフラグ）もあり得るため、meeting_id は nullable。
- フラグ ON/OFF の履歴としても利用し、振り返りの根拠にする。

### C) 次アクション（任意だが強い）

- 1on1 予定、紹介予定、フォロー期限などは **将来拡張** として扱う。
- 本 v1 では contact_events の event_type に "note" や meta（JSON）を用意し、必要になったら event_type 拡張または別テーブルで対応する。

---

## 3. 提案データモデル（テーブル案）

### 3.1 dragonfly_contact_flags（恒久状態）

**目的:** 「今の状態」を高速に参照する（人物カードの即表示）。owner × target で 1 行。

| カラム | 型 | null | 備考 |
|--------|----|------|------|
| id | bigIncrements | NO | PK |
| owner_member_id | foreignId | NO | 記録者（将来ログイン時の“自分”）。members.id を参照。 |
| target_member_id | foreignId | NO | 相手。members.id。 |
| interested | boolean | NO | 気になる。デフォルト false。 |
| want_1on1 | boolean | NO | 1on1 したい。デフォルト false。 |
| created_at | timestamp | YES | |
| updated_at | timestamp | YES | |

**外部キー制約:**

- `owner_member_id` → `members.id` (ON DELETE CASCADE または RESTRICT。owner 削除時の方針は運用で決定)
- `target_member_id` → `members.id` (ON DELETE CASCADE または RESTRICT)

**ユニーク制約:**

- `(owner_member_id, target_member_id)` UNIQUE  
  → 1 owner に対して 1 相手あたり 1 行。

**インデックス:**

- `owner_member_id` … 自分の全フラグ一覧
- `target_member_id` … 自分宛てのフラグ検索（任意）
- `interested` … 気になる一覧
- `want_1on1` … 1on1 したい一覧

**owner について:**  
V1 採用案では **owner_member_id を正** とする。ログイン未導入時は「現在の meeting の自分の participant から member_id を取得し、その member_id を owner_member_id として扱う」暫定対応をとる（セクション 7 参照）。

---

### 3.2 dragonfly_contact_events（理由ログ・履歴）

**目的:** 「なぜそう思ったか」を忘れない。振り返りの根拠にする。フラグ ON/OFF の履歴と理由・meeting 文脈を保持する。

| カラム | 型 | null | 備考 |
|--------|----|------|------|
| id | bigIncrements | NO | PK |
| owner_member_id | foreignId | NO | 記録者。members.id。 |
| target_member_id | foreignId | NO | 相手。members.id。 |
| meeting_id | foreignId | YES | どの meeting で付けたか。会全体・会議外の場合は null。meetings.id。 |
| event_type | string(32) | NO | 下記 enum 的に扱う文字列。 |
| reason | string(280) | YES | “なぜ”の一言（VARCHAR 想定）。空でも保存可。 |
| meta | json | YES | 将来拡張用。未使用でも可。 |
| created_at | timestamp | YES | 発生日時。 |

**event_type の例（V1 で想定）:**

- `interested_on` … 気になるを ON にした
- `interested_off` … 気になるを OFF にした
- `want_1on1_on` … 1on1 したいを ON にした
- `want_1on1_off` … 1on1 したいを OFF にした
- `note` … 単純メモ（フラグに直結しないメモ）

**外部キー制約:**

- `owner_member_id` → `members.id` (ON DELETE CASCADE または RESTRICT)
- `target_member_id` → `members.id` (ON DELETE CASCADE または RESTRICT)
- `meeting_id` → `meetings.id` (ON DELETE SET NULL) … null 許容のため SET NULL

**インデックス:**

- `(owner_member_id, target_member_id, created_at)` … 相手別・時系列の履歴取得
- `meeting_id` … meeting 単位のイベント一覧

**方針:**

- 現在の「状態」は **dragonfly_contact_flags** を参照する。
- 「なぜ／いつ」は **dragonfly_contact_events** を参照する。
- UI ではフラグ切替時に **contact_events に 1 件追加** する。理由（reason）は任意入力（空でも保存する）。

---

## 4. 既存 breakout_memos との住み分け

| テーブル | スコープ | 用途 | 記録する内容の目安 |
|---------|----------|------|---------------------|
| **breakout_memos** | **meeting 内**・相手（participant）別 | その回の同室での具体メモ | 会話内容、フォローしたいこと、その回で話したこと。「第○回で〇〇の話をした」という **会話・事実**。 |
| **dragonfly_contact_events** | **meeting 横断**（meeting_id は任意） | 関係ログ・フラグの理由 | なぜ気になったか、なぜ 1on1 したいか。「第○回で同室して興味を持った」のような **理由・きっかけ**。 |

**ガイドライン:**

- **同じ内容を両方に書かない。**  
  - 具体的な会話メモ → breakout_memos のみ。  
  - 「気になった理由」「1on1 にしたい理由」の短文 → contact_events の reason（および対応する event_type）。
- 人物カードでは「同室メモ（breakout_memos の直近）」と「気になる/1on1 の理由（contact_events の直近）」を **別枠** で表示し、役割を分けておく。

---

## 5. 履歴表示の要件をデータで満たす方法

人物カードに出す情報と、参照元・算出方法を下表で整理する。

| UI 表示 | 参照元 | 算出方法 |
|---------|--------|----------|
| 同室回数 | participant_breakout（＋ participants で owner/target を member に変換） | owner と target が同じ breakout_room に入った meeting を meeting 跨ぎで集計（COUNT）。 |
| 最終同室回 | participant_breakout ＋ meetings | 上記「同室」だった meeting の max(meetings.held_on) または max(meetings.number)。 |
| 最新メモ 3 件 | breakout_memos | owner の participant_id と target の participant_id を meeting ごとに解決し、target_participant_id に対するメモを meeting_id 条件なしで created_at 降順で直近 3 件。 |
| 気になる理由（最新） | dragonfly_contact_events | event_type = 'interested_on' かつ (owner_member_id, target_member_id) で、created_at 降順の先頭 1 件の reason。 |
| 1on1 理由（最新） | dragonfly_contact_events | event_type = 'want_1on1_on' かつ (owner_member_id, target_member_id) で、created_at 降順の先頭 1 件の reason。 |

※ owner / target の「自分」「相手」は、SPA では member_id で統一して扱う想定。participant は「その meeting での参加者」の解決にのみ使う。

---

## 6. API 設計への影響（要点だけ）

SPA が欲しい I/O を **データモデル視点** で列挙する。URL は仮でよい。

| 操作 | 目的 | 主な入出力（データモデル対応） |
|------|------|-------------------------------|
| **GET flags** | 人物カード用の現在状態 | 入力: owner_member_id（または現状は participant_id から解決）。出力: target_member_id ごとの interested / want_1on1。参照元: dragonfly_contact_flags。 |
| **PUT flags** | フラグの一括 or 単体更新 | 入力: owner_member_id, target_member_id, interested, want_1on1。出力: 更新後の 1 行。contact_flags を UPSERT。 |
| **POST event** | フラグ変更時の理由ログ | 入力: owner_member_id, target_member_id, meeting_id（任意）, event_type, reason（任意）。出力: 作成された contact_events の 1 件。 |
| **GET history** | 相手別の直近 N 件 | 入力: owner_member_id, target_member_id, limit。出力: contact_events の created_at 降順 N 件（event_type, reason, meeting_id, created_at）。 |
| **GET summary** | 人物カード用の集約 | 入力: owner_member_id, target_member_id。出力: contact_flags の 1 行 ＋ 同室回数・最終同室回（participant_breakout 等から算出）＋ 最新メモ 3 件（breakout_memos）＋ 気になる/1on1 の最新理由各 1 件（contact_events）。 |

---

## 7. 採用案（V1 で採用するもの）

- **owner の正とするキー**  
  - **owner_member_id を正** とする。将来ログインを見据え、ユーザー＝ member で紐づく設計にする。  
  - **暫定対応:** ログイン未導入の間は、SPA で「自分」を選択した participant の member_id を取得し、それを owner_member_id として API に渡す。API は owner_member_id のみを受け取り、participant_id は使わない（必要なら別エンドポイントで「現在 meeting の参加者一覧」取得に使う）。

- **フラグ種類**  
  - まず **2 つ**: `interested`（気になる）, `want_1on1`（1on1 したい）。  
  - 追加フラグは将来、contact_flags にカラム追加または JSON 列で拡張する。

- **reason（理由）**  
  - **任意入力**。空でも保存する。フラグ切替時に reason を送らなくても contact_events は 1 件作成する（event_type のみ必須）。

- **採用するテーブル**  
  - **dragonfly_contact_flags** … 恒久状態（採用）。  
  - **dragonfly_contact_events** … 理由ログ・履歴（採用）。  
  - 既存テーブルは変更しない。

---

## 8. 未決事項

- **owner の確定方法**  
  - ログイン導入時期と、その際に owner を users と紐づけるか、members のみで扱うか。

- **meeting_id null の扱い**  
  - 会全体イベント（会議外で「気になる」を付けた等）の運用ルールと、一覧表示での「会議なし」の表示仕様。

- **event_type の拡張方針**  
  - 次アクション（1on1 予定、紹介予定等）を event_type で増やすか、meta のみで持つか、別テーブルにするか。

- **既存 members の同一性**  
  - display_no や name が将来変わった場合の履歴の一貫性。target_member_id で一意にしているため、同一人物は member_id で追えるが、表示名の変更ポリシーは未決。

---

## 完了条件（DoD）チェック

- [x] 新規テーブル案が具体（PK / FK / unique / index）で記載されている。
- [x] 「恒久フラグ（contact_flags）+ 理由ログ（contact_events）」の両方が設計に含まれている。
- [x] 既存 breakout_memos との住み分けが明文化されている（セクション 4）。
- [x] V1 の採用案が明記されている（owner_member_id を正、暫定対応、フラグ 2 種、reason 任意）。
