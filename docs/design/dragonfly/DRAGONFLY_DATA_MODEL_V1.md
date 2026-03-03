# DragonFly データモデル v1.1（SSOT）

**V1.1（ハイブリッドフラグ ＋ 1on1 履歴）** — フラグを boolean + extra_status JSON のハイブリッドに拡張し、1on1 の予定・実施履歴を meeting と独立して扱う。

**目的:** DragonFly SPA に必要なデータモデルを、既存スキーマを踏まえて SSOT として確定する。  
**前提:** [DRAGONFLY_SPA_REQUIREMENTS_V1.md](../../requirements/dragonfly/DRAGONFLY_SPA_REQUIREMENTS_V1.md)、既存テーブル（meetings, members, participants, breakout_rooms, participant_breakout, breakout_memos）。  
**制約:** 既存テーブルの破壊的変更は禁止。新規テーブル・追加カラムは設計案として提示するのみ。  
**作成日:** 2026-03-03  
**更新:** V1.1 2026-03-03（ハイブリッドフラグ・1on1 履歴追加）

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

### A) 恒久フラグ（人物ベース）— ハイブリッド（V1.1）

- **主要 2 フラグ**は高速・安定のため **boolean 列**で持つ: **interested**（気になる）/ **want_1on1**（1on1 したい）。
- フラグは増える可能性が高いため、**追加フラグ用に extra_status（JSON nullable）** を用意し、柔軟性を確保する（ハイブリッド）。
- 相手は **member** で一意に識別する（meeting をまたいで同じ「人」を指すため）。
- 「今の状態」を人物カードで即表示するために、1 行で取得できるテーブルとする。

### B) 理由ログ・関係ログ（コンテキストログ）

- **いつ・どの meeting で・なぜ** フラグを立てたか（短文）を残す。
- meeting が無い場合（会全体のメモや、会議外で付けたフラグ）もあり得るため、meeting_id は nullable。
- フラグ ON/OFF の履歴としても利用し、振り返りの根拠にする。**役割:** 「理由ログ」＋「関係ログ」の両方（V1.1 で明確化）。

### C) 次アクション・1on1 履歴（V1.1）

- 1on1 予定、実施履歴、メモ、次アクションは **meeting と独立** したテーブル **dragonfly_one_on_one_sessions** で扱う（セクション 3.3）。
- 定例会は週 1 回、別途 1on1 を行う運用を想定し、1on1 の履歴（日時・メモ・次アクション）を残す。
- contact_events の「次アクション」は、フラグのきっかけ・理由に留め、実施済み 1on1 の詳細は one_on_one_sessions に委譲する。

---

## 3. 提案データモデル（テーブル案）

### 3.1 dragonfly_contact_flags（恒久状態）— ハイブリッド（V1.1）

**目的:** 「今の状態」を高速に参照する（人物カードの即表示）。owner × target で 1 行。主要 2 フラグは boolean、それ以外は extra_status JSON で拡張する。

| カラム | 型 | null | 備考 |
|--------|----|------|------|
| id | bigIncrements | NO | PK |
| owner_member_id | foreignId | NO | 記録者（将来ログイン時の“自分”）。members.id を参照。 |
| target_member_id | foreignId | NO | 相手。members.id。 |
| interested | boolean | NO | 気になる。デフォルト false。 |
| want_1on1 | boolean | NO | 1on1 したい。デフォルト false。 |
| extra_status | json | YES | 追加フラグ用（V1.1）。下記 JSON 管理ルールに従う。 |
| created_at | timestamp | YES | |
| updated_at | timestamp | YES | |

**extra_status の JSON 管理ルール（SSOT として明文化）:**

- **キーは snake_case** とする。
- **値は boolean / string / number のみ** とする。複雑なネスト（オブジェクト・配列の入れ子）は禁止。
- **キーを追加する場合は、本ドキュメント（または付録）にキー名・意味を追記し、SSOT 更新を必須とする。**
- 運用上、extra_status のキー一覧は本設計書または design 配下の別ファイルで管理する。

**外部キー制約:**

- `owner_member_id` → `members.id` (ON DELETE CASCADE または RESTRICT。owner 削除時の方針は運用で決定)
- `target_member_id` → `members.id` (ON DELETE CASCADE または RESTRICT)

**ユニーク制約:**

- `(owner_member_id, target_member_id)` UNIQUE  
  → 1 owner に対して 1 相手あたり 1 行。

**インデックス:**

- `owner_member_id` … 自分の全フラグ一覧
- `target_member_id` … 自分宛てのフラグ検索（任意）
- `interested` … 気になる一覧（列インデックス、現状維持）
- `want_1on1` … 1on1 したい一覧（列インデックス、現状維持）
- **extra_status** … V1.1 では原則インデックス不要（集計要件が無い前提）。将来、特定キーで絞る要件が出た場合は GIN 等の検討は別フェーズで行う。

**owner について:**  
V1 採用案では **owner_member_id を正** とする。ログイン未導入時は「現在の meeting の自分の participant から member_id を取得し、その member_id を owner_member_id として扱う」暫定対応をとる（セクション 7 参照）。

---

### 3.2 dragonfly_contact_events（理由ログ・関係ログ・履歴）

**目的:** 「なぜそう思ったか」を忘れない。振り返りの根拠にする。**役割:** 理由ログ ＋ 関係ログ（V1.1 で明確化）。フラグ ON/OFF の履歴と理由・meeting 文脈を保持する。

**整合ルール:** フラグ（contact_flags の interested / want_1on1）を ON/OFF したときは、**必ず contact_events に 1 件追加** する。理由（reason）は任意（空でも可）。これにより「いつ・なぜ」が追える。

**1on1 の「予定・実施履歴」について:**  
1on1 の**予定日・実施日・メモ・次アクション**は **dragonfly_one_on_one_sessions** に委譲する。contact_events の event_type に `one_on_one_*` を増やさない。理由・きっかけ（「第○回で同室して 1on1 したいと思った」等）は既存の `want_1on1_on` と reason で足りる。**採用案:** event_type は現状の interested_on/off, want_1on1_on/off, note のままとし、1on1 実施履歴は one_on_one_sessions のみで扱う。

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

**event_type の例（V1.1 で想定）:**

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

### 3.3 dragonfly_one_on_one_sessions（1on1 履歴）— V1.1 追加

**目的:** meeting とは別枠で 1on1 の予定・実施履歴を残す。振り返り・次アクション管理に使う。定例会は週 1 回、別途 1on1 を行う運用を想定する。

| カラム | 型 | null | 備考 |
|--------|----|------|------|
| id | bigIncrements | NO | PK |
| owner_member_id | foreignId | NO | 記録者（自分）。members.id。 |
| target_member_id | foreignId | NO | 相手。members.id。 |
| held_at | datetime | YES | 実施日時。未定の場合は null。 |
| status | string(20) | NO | planned / done / canceled。 |
| agenda | text | YES | 話したいこと（予定時）。 |
| memo | text | YES | 結果メモ（実施後）。 |
| next_action | text | YES | 次やること（紹介／再連絡など）。 |
| source_meeting_id | foreignId | YES | きっかけになった meeting。meetings.id。 |
| created_at | timestamp | YES | |
| updated_at | timestamp | YES | |

**外部キー制約:**

- `owner_member_id` → `members.id` (ON DELETE CASCADE または RESTRICT)
- `target_member_id` → `members.id` (ON DELETE CASCADE または RESTRICT)
- `source_meeting_id` → `meetings.id` (ON DELETE SET NULL)

**ユニーク制約:** なし（1 ペアで複数回の 1on1 があり得るため）。

**インデックス:**

- `(owner_member_id, target_member_id, held_at)` … 相手別・時系列の一覧・直近取得
- `status` … planned / done 等の絞り込み
- `source_meeting_id` … どの meeting がきっかけか参照

**将来拡張:** 1on1 の詳細ログ（発言メモ・複数ノート）を増やしたくなった場合は、**dragonfly_one_on_one_notes** のような子テーブルで拡張可能とする。

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
| 1on1 回数 | dragonfly_one_on_one_sessions | status = 'done' の件数を (owner_member_id, target_member_id) で COUNT。 |
| 直近 1on1 日時 | dragonfly_one_on_one_sessions | status = 'done' で (owner_member_id, target_member_id)、held_at 降順の先頭 1 件の held_at。 |
| 次の 1on1 予定 | dragonfly_one_on_one_sessions | status = 'planned' で (owner_member_id, target_member_id)、held_at 昇順の先頭 1 件（最小 held_at）。 |

※ owner / target の「自分」「相手」は、SPA では member_id で統一して扱う想定。participant は「その meeting での参加者」の解決にのみ使う。

---

## 6. API 設計への影響（要点だけ）

SPA が欲しい I/O を **データモデル視点** で列挙する。URL は仮でよい。

| 操作 | 目的 | 主な入出力（データモデル対応） |
|------|------|-------------------------------|
| **GET flags** | 人物カード用の現在状態 | 入力: owner_member_id（または現状は participant_id から解決）。出力: target_member_id ごとの interested / want_1on1 / extra_status。参照元: dragonfly_contact_flags。 |
| **PUT flags** | フラグの一括 or 単体更新 | 入力: owner_member_id, target_member_id, interested, want_1on1, extra_status（任意・JSON）。出力: 更新後の 1 行。contact_flags を UPSERT。 |
| **POST event** | フラグ変更時の理由ログ | 入力: owner_member_id, target_member_id, meeting_id（任意）, event_type, reason（任意）。出力: 作成された contact_events の 1 件。 |
| **GET history** | 相手別の直近 N 件 | 入力: owner_member_id, target_member_id, limit。出力: contact_events の created_at 降順 N 件（event_type, reason, meeting_id, created_at）。 |
| **GET summary** | 人物カード用の集約 | 入力: owner_member_id, target_member_id。出力: contact_flags の 1 行 ＋ 同室回数・最終同室回（participant_breakout 等から算出）＋ 最新メモ 3 件（breakout_memos）＋ 気になる/1on1 の最新理由各 1 件（contact_events）＋ 1on1 回数・直近日時・次の予定（dragonfly_one_on_one_sessions）。 |
| **1on1 session 一覧（相手別）** | 人物カード用の 1on1 履歴 | 入力: owner_member_id, target_member_id, 任意で status / limit。出力: one_on_one_sessions の一覧（held_at, status, memo, next_action 等）。 |
| **1on1 session 作成／更新** | 予定・実施メモの保存 | 入力: owner_member_id, target_member_id, held_at（任意）, status, agenda / memo / next_action（任意）, source_meeting_id（任意）。出力: 保存された 1 件。 |

---

## 7. 採用案（V1 で採用するもの）

- **owner の正とするキー**  
  - **owner_member_id を正** とする。将来ログインを見据え、ユーザー＝ member で紐づく設計にする。  
  - **暫定対応:** ログイン未導入の間は、SPA で「自分」を選択した participant の member_id を取得し、それを owner_member_id として API に渡す。API は owner_member_id のみを受け取り、participant_id は使わない（必要なら別エンドポイントで「現在 meeting の参加者一覧」取得に使う）。

- **フラグ種類（V1.1 ハイブリッド）**  
  - **主要 2 つは boolean 列:** `interested`（気になる）, `want_1on1`（1on1 したい）。  
  - **追加フラグ** は **extra_status（JSON）** で拡張する。キー追加時は本ドキュメント（SSOT）への追記を必須とする。

- **reason（理由）**  
  - **任意入力**。空でも保存する。フラグ切替時に reason を送らなくても contact_events は 1 件作成する（event_type のみ必須）。

- **採用するテーブル**  
  - **dragonfly_contact_flags** … 恒久状態・ハイブリッド（採用）。  
  - **dragonfly_contact_events** … 理由ログ・関係ログ・履歴（採用）。  
  - **dragonfly_one_on_one_sessions** … 1on1 の予定・実施履歴（V1.1 で採用）。  
  - 既存テーブルは変更しない。

---

## 8. 未決事項

- **owner の確定方法**  
  - ログイン導入時期と、その際に owner を users と紐づけるか、members のみで扱うか。

- **meeting_id null の扱い**  
  - 会全体イベント（会議外で「気になる」を付けた等）の運用ルールと、一覧表示での「会議なし」の表示仕様。

- **event_type の拡張方針**  
  - 上記の通り、1on1 実施履歴は one_on_one_sessions に委譲。event_type の追加は「理由・関係ログ」に必要なものに限定する。

- **既存 members の同一性**  
  - display_no や name が将来変わった場合の履歴の一貫性。target_member_id で一意にしているため、同一人物は member_id で追えるが、表示名の変更ポリシーは未決。

- **extra_status のキー追加方針**  
  - 追加時は本ドキュメント（または design 配下の SSOT）にキー名・意味を追記するルールとした。運用で使うキー一覧をどこで管理するか（本ファイルの付録か別ファイルか）は未決。

- **1on1 の held_at が未定の運用**  
  - status = 'planned' で held_at が null の扱い（「日付未定で予定だけ立てる」）を許容するか、必須にするか。UI では「予定日＋一言メモ」から始める要件のため、held_at は nullable のままとするが、一覧表示での並び順・フィルタは未決。

---

## 完了条件（DoD）チェック

- [x] 新規テーブル案が具体（PK / FK / unique / index）で記載されている。
- [x] 「恒久フラグ（contact_flags）+ 理由ログ（contact_events）」の両方が設計に含まれている。
- [x] ハイブリッド（boolean + extra_status JSON）のルールが SSOT として明文化されている（V1.1）。
- [x] 1on1 履歴を meeting と独立で扱う設計が入り、dragonfly_one_on_one_sessions のテーブル案が具体である。
- [x] 既存 breakout_memos との住み分けが明文化されている（セクション 4）。
- [x] V1 / V1.1 の採用案が明記されている（owner_member_id を正、暫定対応、ハイブリッドフラグ、reason 任意、one_on_one_sessions 採用）。
