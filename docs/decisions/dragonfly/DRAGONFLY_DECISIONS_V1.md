# DragonFly V1 決定事項

**目的:** DragonFly SPA V1 の未決事項を「採用する決定」として確定し、SSOT と整合させる。  
**参照:** [DRAGONFLY_SPA_REQUIREMENTS_V1.md](../../requirements/dragonfly/DRAGONFLY_SPA_REQUIREMENTS_V1.md)、[DRAGONFLY_DATA_MODEL_V1.md](../../design/dragonfly/DRAGONFLY_DATA_MODEL_V1.md)、[DRAGONFLY_API_DESIGN_V1.md](../../design/dragonfly/DRAGONFLY_API_DESIGN_V1.md)、[DRAGONFLY_MIGRATION_PLAN_V1.md](../../design/dragonfly/DRAGONFLY_MIGRATION_PLAN_V1.md)、[DRAGONFLY_REACT_ADMIN_ARCHITECTURE_V1.md](../../design/dragonfly/DRAGONFLY_REACT_ADMIN_ARCHITECTURE_V1.md)  
**作成日:** 2026-03-03

---

## D-01: owner の渡し方（暫定運用）

**決定:** **A) 画面で owner_member_id を選択して API に渡す**

**理由:**  
API は owner_member_id を正としているため、SPA で「自分」に該当する参加者（participant）を選択し、その participant の member_id を取得して owner_member_id として全 API に渡す形がシンプル。B（participant_id を渡してサーバで解決）はサーバ側に participant→member 解決が増え、V1 では過剰。C（ログイン）は V1 では不可。

**影響する SSOT:**

- [DRAGONFLY_API_DESIGN_V1.md](../../design/dragonfly/DRAGONFLY_API_DESIGN_V1.md) … 入力は owner_member_id（クエリで毎回渡す）で統一。未決事項から削除。
- [DRAGONFLY_REACT_ADMIN_ARCHITECTURE_V1.md](../../design/dragonfly/DRAGONFLY_REACT_ADMIN_ARCHITECTURE_V1.md) … MVP 段階で「owner_member_id は手動選択」と既に記載。未決扱いをやめ本文で確定。
- [DRAGONFLY_DATA_MODEL_V1.md](../../design/dragonfly/DRAGONFLY_DATA_MODEL_V1.md) … 採用案「暫定対応」を D-01 に合わせて明記。
- [DRAGONFLY_SPA_REQUIREMENTS_V1.md](../../requirements/dragonfly/DRAGONFLY_SPA_REQUIREMENTS_V1.md) … 未決「自分（記録者）の識別」を Resolved（画面で owner_member_id を選択して渡す）とし、要件に追記。

---

## D-02: extra_status のみ更新時に contact_events を追加するか

**決定:** **A) 追加しない（主要フラグのみ履歴）**

**理由:**  
振り返りの中心は「なぜ気になったか／1on1 したいか」であり、interested / want_1on1 の ON/OFF 履歴で足りる。extra_status は拡張用のため、その変更まで events に残すと event_type が増え、V1 で過剰になる。データモデル SSOT の「フラグ ON/OFF 時に必ず 1 件」は主要 2 フラグに限定する。

**影響する SSOT:**

- [DRAGONFLY_API_DESIGN_V1.md](../../design/dragonfly/DRAGONFLY_API_DESIGN_V1.md) … PUT flags の挙動で「extra_status のみの変更の場合は contact_events に追加しない」と明記。未決事項から削除。
- [DRAGONFLY_DATA_MODEL_V1.md](../../design/dragonfly/DRAGONFLY_DATA_MODEL_V1.md) … 整合ルールを「interested / want_1on1 の変更時のみ events 追加」と限定（extra_status は触れない）。未決事項から削除。

---

## D-03: extra_status の更新方式（上書き or マージ）

**決定:** **B) 指定キーのみマージ（他キー保持）**

**理由:**  
送信した JSON で全上書きすると、既存の他キーが消える。マージにすると「送ったキーだけ更新し、送らなかったキーは保持」でき、スピード入力で 1 キーだけ変える運用が安全。V1 は過剰設計にせず、マージで十分。

**影響する SSOT:**

- [DRAGONFLY_API_DESIGN_V1.md](../../design/dragonfly/DRAGONFLY_API_DESIGN_V1.md) … PUT flags の Body で extra_status を「指定キーのみマージ。送信したキーを更新し、未送信キーは既存値を保持する」と明記。

---

## D-04: 1on1 作成時に want_1on1 を自動 ON にするか

**決定:** **A) 自動 ON しない（UI で別に ON）**

**理由:**  
1on1 予定を立てることと「1on1 したい」フラグは意味が異なる場合がある（予定だけ先に立てておく等）。自動で want_1on1 を true にすると意図が曖昧になる。V1 では UI で明示的にフラグを ON にする方が振り返り時の解釈が明確。

**影響する SSOT:**

- [DRAGONFLY_API_DESIGN_V1.md](../../design/dragonfly/DRAGONFLY_API_DESIGN_V1.md) … 未決事項「1on1 作成時に want_1on1 を自動 ON にするか」を削除。本文に「1on1 作成時は contact_flags を変更しない」と記載しない（挙動に書かなければ自動ONしない）。
- [DRAGONFLY_MIGRATION_PLAN_V1.md](../../design/dragonfly/DRAGONFLY_MIGRATION_PLAN_V1.md) … 整合ルールから「1on1 作成時 want_1on1 を自動 ON にするか」を削除し、「1on1 作成時は contact_flags / contact_events を更新しない（V1 決定）」と明記。未決事項から削除。

---

## D-05: contact_events に updated_at を持たせるか

**決定:** **A) created_at のみ（ログ扱いで更新しない）**

**理由:**  
contact_events は「いつ・なぜ」のイミュータブルログとして扱う。更新しない前提にすると整合が取りやすく、振り返りも「発生日時」だけで十分。V1 で timestamps の updated_at を付けると「更新しない運用」の説明が増えるため、カラム自体を持たない形で統一する。

**影響する SSOT:**

- [DRAGONFLY_MIGRATION_PLAN_V1.md](../../design/dragonfly/DRAGONFLY_MIGRATION_PLAN_V1.md) … contact_events は created_at のみ。Laravel では timestamp() で created_at のみ追加するか、timestamps() を使わない。DDL から updated_at を削除。未決事項から削除。

---

## D-06: 外部キーの ON DELETE 方針

**決定:**

- **members を参照する FK（owner_member_id, target_member_id）:** **RESTRICT**  
  member 削除は稀な想定。削除する場合は先に dragonfly 側のデータ（flags / events / one_on_one_sessions）を削除または差し替える運用とする。
- **meetings を参照する FK（meeting_id, source_meeting_id）:** **SET NULL**  
  meeting 削除時は「どの会議で」の文脈だけ null にし、イベント・1on1 レコードは残す。既存設計の nullOnDelete() のまま。

**理由:**  
RESTRICT で誤削除を防ぎ、V1 では CASCADE で関連を一括削除する複雑さを避ける。meeting は「きっかけ」なので SET NULL で十分。

**影響する SSOT:**

- [DRAGONFLY_MIGRATION_PLAN_V1.md](../../design/dragonfly/DRAGONFLY_MIGRATION_PLAN_V1.md) … 各テーブルの FK に ON DELETE RESTRICT（members 参照）、ON DELETE SET NULL（meetings 参照・nullable のみ）を明記。DDL イメージと未決事項を更新。

---

## D-07: 既存 API との URL プレフィックス整合

**決定:** **`/api/dragonfly/` のままで統一。既存（meeting 依存）と新規（owner 依存）を並存させる。**

- 既存: `/api/dragonfly/meetings/{number}/attendees`、`/api/dragonfly/meetings/{number}/breakout-*` 等 … meeting number がパスに含まれる。
- 新規: `/api/dragonfly/flags`、`/api/dragonfly/contacts/{target_member_id}/history`、`/api/dragonfly/one-on-one`、`/api/dragonfly/contacts/{target_member_id}/summary` … いずれもクエリで owner_member_id を渡す。meeting をパスに含めない。

**理由:**  
meeting に依存しないリソース（flags / contacts / 1on1）は meeting を URL に含めない方が自然。既存 API はそのまま触らず、同じプレフィックス `/api/dragonfly/` の直下に新規を追加するだけで共存できる。V1 でプレフィックスを分離（例: /api/dragonfly-v2/）する必要はない。

**影響する SSOT:**

- [DRAGONFLY_API_DESIGN_V1.md](../../design/dragonfly/DRAGONFLY_API_DESIGN_V1.md) … 未決事項「既存 API との URL プレフィックス」を削除。セクション 0 または 5 の代わりに「URL 方針: /api/dragonfly/ 直下。meeting 依存は meetings/{number}/...、owner 依存はクエリで owner_member_id」と本文に追記。

---

## D-08: Summary API の責務範囲（V1 の最小）

**決定:** **A) 人物カードに必要な最小（flags ＋ 履歴要約 ＋ 1on1 要約）**

**理由:**  
V1 は過剰設計にしない方針。現在の Summary 出力（flags, same_room_count, last_same_room_meeting, latest_memos, latest_interested_reason, latest_1on1_reason, one_on_one_count, last_one_on_one_at, next_one_on_one_at）で人物カードに必要な最小限を満たしている。集計を増やすのは将来拡張とする。

**影響する SSOT:**

- [DRAGONFLY_API_DESIGN_V1.md](../../design/dragonfly/DRAGONFLY_API_DESIGN_V1.md) … Summary API の目的に「V1 では人物カード用の最小限。集計の追加は将来」と 1 行追記。未決として書いていなければ未決事項の追加は不要。
- [DRAGONFLY_DATA_MODEL_V1.md](../../design/dragonfly/DRAGONFLY_DATA_MODEL_V1.md) … GET summary の説明で「人物カード用の最小集約（V1）」と触れてもよい（任意）。

---

## 参照: 決定一覧

| ID | 決定 |
|----|------|
| D-01 | owner は画面で owner_member_id を選択して API に渡す（暫定） |
| D-02 | extra_status のみの変更時は contact_events に追加しない |
| D-03 | extra_status は指定キーのみマージ（他キー保持） |
| D-04 | 1on1 作成時は want_1on1 を自動 ON にしない |
| D-05 | contact_events は created_at のみ（updated_at を持たない） |
| D-06 | FK: members → RESTRICT、meetings（nullable）→ SET NULL |
| D-07 | URL は /api/dragonfly/ で統一、既存と新規を並存 |
| D-08 | Summary API は人物カード用の最小責務（V1） |
