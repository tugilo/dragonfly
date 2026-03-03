# DragonFly API 設計 v1（SSOT）

**目的:** DragonFly SPA が利用する Laravel API の差分設計を SSOT として定義する。既存 API（参加者・同室者・breakout メモ等）は変更せず、flags / contact events / 1on1 sessions / summary を追加する。  
**参照:** [DRAGONFLY_SPA_REQUIREMENTS_V1.md](../../requirements/dragonfly/DRAGONFLY_SPA_REQUIREMENTS_V1.md)、[DRAGONFLY_DATA_MODEL_V1.md](DRAGONFLY_DATA_MODEL_V1.md)（V1.1）  
**作成日:** 2026-03-03

---

## 0. 設計方針

- **flags は contact_flags を正とする**  
  人物カードの「今の状態」は `dragonfly_contact_flags` を参照する。取得・更新ともこのテーブルを正とする。

- **flags 更新時は contact_events を必ず 1 件追加（整合ルール）**  
  PUT /api/dragonfly/flags/{target_member_id} で interested または want_1on1 を変更した場合、**必ず** `dragonfly_contact_events` に 1 件追加する。event_type は変更内容に応じて自動生成（例: interested_on / interested_off）。理由（reason）はリクエストで任意送信、空でも可。

- **1on1 は one_on_one_sessions テーブルを正とする**  
  1on1 の予定・実施履歴は `dragonfly_one_on_one_sessions` のみで扱う。contact_events に one_on_one_* は持たない。

- **owner は owner_member_id を正とする**  
  V1 暫定: 画面で「自分」に該当する参加者（participant）を選択し、その member_id を owner_member_id として全 API にクエリで渡す（[D-01](../../decisions/dragonfly/DRAGONFLY_DECISIONS_V1.md)）。将来はログインで確定。

- **URL 方針**  
  プレフィックスは `/api/dragonfly/` で統一。既存の meeting 依存 API は `meetings/{number}/...`、新規の owner 依存 API（flags / contacts / one-on-one）は直下で、owner_member_id はクエリで渡す（[D-07](../../decisions/dragonfly/DRAGONFLY_DECISIONS_V1.md)）。

---

## 1. Flags API

### GET /api/dragonfly/flags

**目的:** 自分（owner）が付けた全対象のフラグ一覧を取得。人物カード用の状態表示に利用。

**入力（クエリ）:**

| パラメータ | 型 | 必須 | 説明 |
|------------|-----|------|------|
| owner_member_id | integer | 是 | 記録者（自分）の members.id。暫定は participant から解決した member_id を渡す。 |

**出力（JSON 配列）:**

各要素:

| フィールド | 型 | 説明 |
|------------|-----|------|
| target_member_id | integer | 相手の members.id |
| interested | boolean | 気になる |
| want_1on1 | boolean | 1on1 したい |
| extra_status | object \| null | 追加フラグ（JSON）。キーは snake_case、値は boolean/string/number のみ。 |

**エラー:**

- 400: owner_member_id 未指定
- 404: owner_member_id に該当する member が存在しない（任意で 422 でも可）

---

### PUT /api/dragonfly/flags/{target_member_id}

**目的:** 特定相手に対するフラグを更新。interested / want_1on1 / extra_status のいずれかまたは複数を更新可能。

**入力（クエリ or ヘッダ）:**

| パラメータ | 型 | 必須 | 説明 |
|------------|-----|------|------|
| owner_member_id | integer | 是 | 記録者（自分）の members.id |

**入力（Body JSON）:**

| パラメータ | 型 | 必須 | 説明 |
|------------|-----|------|------|
| interested | boolean | 否 | 気になる。省略時は変更しない。 |
| want_1on1 | boolean | 否 | 1on1 したい。省略時は変更しない。 |
| extra_status | object | 否 | 追加フラグ（JSON）。省略時は変更しない。**指定キーのみマージ**（送信したキーを更新し、未送信キーは既存値を保持）。[D-03](../../decisions/dragonfly/DRAGONFLY_DECISIONS_V1.md) |
| reason | string(280) | 否 | フラグ変更に付ける理由。contact_events の reason に保存。空でも可。 |
| meeting_id | integer | 否 | どの meeting で付けたか。null の場合は会議外。 |

**挙動:**

1. **contact_flags を upsert**  
   (owner_member_id, target_member_id) で 1 行。存在しなければ INSERT、存在すれば UPDATE。送信された interested / want_1on1 / extra_status のみ更新。

2. **contact_events に 1 件追加（整合ルール）**  
   interested または want_1on1 が**変更された**場合、変更ごとに event_type を自動生成して 1 件ずつ追加する。
   - 例: interested が false→true → event_type = `interested_on`
   - 例: interested が true→false → event_type = `interested_off`
   - 例: want_1on1 が false→true → event_type = `want_1on1_on`
   - 例: want_1on1 が true→false → event_type = `want_1on1_off`  
   reason / meeting_id はリクエストの値を contact_events に保存。**extra_status のみの変更の場合は contact_events には追加しない**（主要フラグ interested / want_1on1 の変更時のみ履歴を残す）。[D-02](../../decisions/dragonfly/DRAGONFLY_DECISIONS_V1.md)

**出力:** 更新後の contact_flags の 1 行（target_member_id, interested, want_1on1, extra_status, updated_at 等）。

**エラー:**

- 404: owner_member_id または target_member_id に該当する member が存在しない
- 422: バリデーションエラー（例: extra_status の形式不正）

---

## 2. Contact Events API

### GET /api/dragonfly/contacts/{target_member_id}/history

**目的:** 相手（target）に対する理由ログ・関係ログの履歴。人物カードの「履歴」表示に利用。

**入力:**

| パラメータ | 場所 | 型 | 必須 | 説明 |
|------------|------|-----|------|------|
| owner_member_id | query | integer | 是 | 記録者（自分）の members.id |
| target_member_id | path | integer | 是 | 相手の members.id |
| limit | query | integer | 否 | 取得件数。デフォルト 20、最大 100 程度を推奨 |

**出力（JSON 配列）:**

各要素:

| フィールド | 型 | 説明 |
|------------|-----|------|
| id | integer | contact_events.id |
| event_type | string | interested_on / interested_off / want_1on1_on / want_1on1_off / note |
| reason | string \| null | 理由の短文 |
| meeting_id | integer \| null | 紐づく meeting。null は会議外 |
| created_at | string (ISO 8601) | 発生日時 |

**並び:** created_at 降順。

**エラー:**

- 404: owner または target の member が存在しない
- 422: limit が範囲外

---

## 3. 1on1 Sessions API

### GET /api/dragonfly/one-on-one

**目的:** 1on1 の予定・実施履歴の一覧。target_member_id を指定すると相手別に絞る。

**入力（クエリ）:**

| パラメータ | 型 | 必須 | 説明 |
|------------|-----|------|------|
| owner_member_id | integer | 是 | 記録者（自分）の members.id |
| target_member_id | integer | 否 | 相手の members.id。省略時は全相手の 1on1 一覧 |
| status | string | 否 | planned / done / canceled で絞り込み（任意） |
| limit | integer | 否 | 取得件数。デフォルト 50 等 |

**出力（JSON 配列）:**

各要素:

| フィールド | 型 | 説明 |
|------------|-----|------|
| id | integer | one_on_one_sessions.id |
| target_member_id | integer | 相手の members.id |
| held_at | string \| null | 実施日時（ISO 8601）。未定なら null |
| status | string | planned / done / canceled |
| agenda | string \| null | 話したいこと |
| memo | string \| null | 結果メモ |
| next_action | string \| null | 次やること |
| source_meeting_id | integer \| null | きっかけの meeting |
| created_at | string | |
| updated_at | string | |

**並び:** held_at 降順（null は末尾等、実装で統一）。

**エラー:** 404（owner 不在）、422（パラメータ不正）

---

### POST /api/dragonfly/one-on-one

**目的:** 1on1 の予定または実施済み記録を 1 件作成。

**入力（Body JSON）:**

| パラメータ | 型 | 必須 | 説明 |
|------------|-----|------|------|
| owner_member_id | integer | 是 | 記録者（自分） |
| target_member_id | integer | 是 | 相手 |
| held_at | string \| null | 否 | 実施日時（ISO 8601）。未定なら null |
| status | string | 是 | planned / done / canceled |
| agenda | string | 否 | 話したいこと |
| memo | string | 否 | 結果メモ |
| next_action | string | 否 | 次やること |
| source_meeting_id | integer | 否 | きっかけの meeting |

**出力:** 作成された 1 件（id, held_at, status, ... updated_at）。

**エラー:** 404（member 不在）、422（バリデーション、例: status が planned/done/canceled 以外）

---

### PUT /api/dragonfly/one-on-one/{id}

**目的:** 既存の 1on1 セッションを更新。

**入力（Path）:** id … one_on_one_sessions.id

**入力（Body JSON）:** POST と同様（owner_member_id, target_member_id は通常変更しない想定。実装で上書き禁止にしても可）。

**出力:** 更新後の 1 件。

**エラー:** 404（id または owner に紐づかない）、422（バリデーション）

---

## 4. Summary API（人物カード用集約）

### GET /api/dragonfly/contacts/{target_member_id}/summary

**目的:** 人物カードに必要な情報を 1 リクエストで取得。V1 では**人物カード用の最小責務**（flags ＋ 履歴要約 ＋ 1on1 要約）に限定する。同室回数・メモ・フラグ・理由・1on1 サマリを集約する。[D-08](../../decisions/dragonfly/DRAGONFLY_DECISIONS_V1.md)

**入力（クエリ）:**

| パラメータ | 型 | 必須 | 説明 |
|------------|-----|------|------|
| owner_member_id | integer | 是 | 記録者（自分）の members.id |

**Path:** target_member_id … 相手の members.id

**出力（JSON オブジェクト）:**

| フィールド | 型 | 説明 |
|------------|-----|------|
| flags | object | contact_flags の 1 行。interested, want_1on1, extra_status |
| same_room_count | number | 同室回数（participant_breakout 等から算出） |
| last_same_room_meeting | object \| null | 最終同室 meeting。例: { id, number, held_on } |
| latest_memos | array | 最新メモ最大 3 件（breakout_memos）。例: { id, body, meeting_id, created_at }[] |
| latest_interested_reason | string \| null | 気になる理由の最新 1 件（contact_events interested_on の reason） |
| latest_1on1_reason | string \| null | 1on1 理由の最新 1 件（contact_events want_1on1_on の reason） |
| one_on_one_count | number | 実施済み 1on1 回数（status=done の件数） |
| last_one_on_one_at | string \| null | 直近 1on1 実施日時（ISO 8601） |
| next_one_on_one_at | string \| null | 次の 1on1 予定（status=planned の最小 held_at）。無ければ null |

**エラー:** 404（owner または target の member が存在しない）、422

---

## 5. 未決事項・Resolved

V1 で決定した項目（D-01〜D-08）は [DRAGONFLY_DECISIONS_V1.md](../../decisions/dragonfly/DRAGONFLY_DECISIONS_V1.md) に記載。owner の渡し方（D-01）、extra_status のみの変更時は events に追加しない（D-02）、extra_status はマージ（D-03）、1on1 作成時は want_1on1 を自動 ON にしない（D-04）、URL は /api/dragonfly/ で統一（D-07）、Summary は人物カード用最小（D-08）は本文に反映済み。
