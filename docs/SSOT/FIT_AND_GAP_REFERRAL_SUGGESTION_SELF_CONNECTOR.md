# フィット＆ギャップ：リファーラル提案の自己つなぎ手誤提案（SPEC-015/016/022）

**調査日:** 2026-07-08 14:41 JST  
**要件 SSOT:** [REFERRAL_SUGGESTION_COMMON.md](REFERRAL_SUGGESTION_COMMON.md) §0.8 / §0.8.6 / §0.8.7、[ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md](ONETOONE_REFERRAL_SUGGESTION_REQUIREMENTS.md)（SPEC-015）、[CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md](CHAPTER_MEETING_REFERRAL_SUGGESTION_REQUIREMENTS.md)（SPEC-016）、[CONNECTION_PREPARATION_REQUIREMENTS.md](CONNECTION_PREPARATION_REQUIREMENTS.md)（SPEC-022）  
**比較対象:** 現行 DB `one_to_one_referral_suggestion_runs.id=19` / `one_to_one_referral_suggestions.id=38,39`、`ReferralSuggestionAiService`、`ReferralSuggestionPayloadNormalizer`、`ReferralConnectCopyPartyDefaults`、`ReferralSuggestionList`

---

## 1. サマリ

| 領域 | Fit（既にある） | Gap（足りない） |
|------|----------------|-----------------|
| **つなぎ手経由の理念** | COMMON §0.8 で「他メンバー A が社外 B を依頼者 C へ紹介する」と定義済み | `A = C`（依頼者本人がつなぎ手）を生成・保存時に弾く不変条件がない |
| **AI プロンプト** | `via_connector` の `connector_member_id` / `suggested_contact_label` を要求している | 「connector は requester 以外」「根拠コーパスに登場する他メンバーのみ」を明示していない |
| **Normalizer** | `via_connector` を `from=A`, `to=C` へ寄せる実装がある | `fromId === ownerMemberId` / `fromId === toId` を reject しない |
| **社外ラベル補正** | P1 方針として社外紹介は `suggested_to_label` を使う | AI が通常提案で `suggested_contact_label` に社外像を返した場合、表示に落ちない |
| **UI 表示** | `via_connector` には「つなぎ手経由（社外）」Chip と「A さんと 1 to 1」導線がある | 自己つなぎ手の場合、意味のない「自分と 1 to 1」「自分に紹介」導線が出得る |
| **紹介登録** | `introductions` 登録時は `from_member_id != to_member_id` を検証 | 生成時に不正候補が見えてしまう。登録前のUXで止められない |

**結論:** 今回の「次廣さんが次廣さんに紹介する」表示は、AI が `connector_member_id=37`（依頼者本人）を返したことに対し、サーバ側が `via_connector` の三者不変条件を検証していないため発生した。SSOT 上は Gap であり、生成・正規化・表示の各層で防ぐ必要がある。

---

## 2. 実例（2026-07-08 海沼功 121）

対象 1to1:

| 項目 | 値 |
|------|----|
| `one_to_ones.id` | 110 |
| owner / requester C | `members.id=37` 次廣 淳 |
| subject / 121相手 | `members.id=24` 海沼 功 |
| run | `one_to_one_referral_suggestion_runs.id=19` |
| context | `relationship` |
| corpus_meta | `{"consented_owner_count":0,"o2o_excerpt_count":0,"meeting_count":6,"introduction_count":0}` |

問題の提案:

| 項目 | 値 |
|------|----|
| suggestion | `one_to_one_referral_suggestions.id=39` |
| direction | `via_connector` |
| corpus_source | `member_network` |
| suggested_from_member_id | `37`（次廣 淳） |
| suggested_to_member_id | `37`（次廣 淳） |
| suggested_contact_label | AI業務改善に興味のある企業 |
| summary | 次廣さんのAI業務改善システム構築に興味を持つ企業に対して、海沼さんを紹介することができます。 |

AI raw response では `connector_member_id=37` / `suggested_from_member_id=37` が返っていた。Normalizer は `via_connector` で `suggested_to_member_id` を owner に補完するため、結果として `from=37` / `to=37` が保存された。

---

## 3. 期待仕様（To-Be）

COMMON §0.8 の三者は次の不変条件を満たす。

| 役割 | 意味 | 不変条件 |
|------|------|----------|
| **connector A** | 社外 contact B を紹介するメンバー | `A != requester C` |
| **contact B** | A の顧客・知人・社外紹介先 | `suggested_contact_label` 必須（または将来 contact member） |
| **requester C** | 提案を見る owner / 依頼者 | `to = requester C` |

`via_connector` は **他メンバー A に紹介をお願いする**ための候補であり、依頼者本人を A にしてはいけない。依頼者本人の議事録から「自分が誰かに紹介する」候補を出す場合は `owner_to_target` などの自己履歴経路として扱う。

---

## 4. 機能別 Fit / Gap

### 4.1 AI 生成プロンプト

| 要件 | 現状 | Fit/Gap |
|------|------|---------|
| `via_connector` は A・B・C の三者を分ける | schema に `connector_member_id` / `suggested_contact_label` はある | **部分 Fit** |
| A は依頼者 C 以外 | 明示なし | **Gap** |
| A は根拠コーパス上の他メンバー | 明示なし | **Gap** |
| 自己履歴由来の社外紹介と他者ネットワーク由来を分ける | `corpus_source` はある | **部分 Fit** — AI が誤分類した場合の補正なし |

### 4.2 Payload Normalizer

| 要件 | 現状 | Fit/Gap |
|------|------|---------|
| `via_connector` の `from=A`, `to=C` 補完 | `toId` は owner へ補完される | **Fit** |
| `from=A` が null のとき reject | 実装済み | **Fit** |
| `A = C` を reject | 未実装 | **Gap（P0）** |
| `A = to` を reject | 未実装 | **Gap（P0）** |
| 通常社外紹介の label 補正 | `suggested_to_label` のみ採用 | **Gap** — AI が `suggested_contact_label` に入れた場合に消える |

### 4.3 UI

| 要件 | 現状 | Fit/Gap |
|------|------|---------|
| `via_connector` は A に紹介依頼する導線 | `suggested_from_member_id` への 1to1 作成ボタン | **Fit** |
| 自己つなぎ手を表示しない | サーバから来たら表示する | **Gap** |
| 自己つなぎ手時の警告 | なし | **Gap** — サーバ reject 後は不要だが、防御的表示も検討 |
| 「紹介文を作成」の初期値 | `via_connector` では A=owner, B=connector | **仕様どおりだが誤候補では破綻** |

### 4.4 既存データ・run 履歴

| 要件 | 現状 | Fit/Gap |
|------|------|---------|
| run / suggestion は監査用に残す | 物理削除しない方針 | **Fit** |
| 誤提案を無効化できる | status を `dismissed` にできる | **Fit** |
| 既存誤提案の扱い | #39 は `pending` のまま | **Gap** — Phase 実装後に手動却下または修正 SQL を検討 |

---

## 5. Gap 一覧

| ID | Gap | 優先 | 対応案 |
|----|-----|------|--------|
| G1 | `via_connector` で `connector_member_id` が owner 本人でも保存される | P0 | Normalizer で `fromId === ownerMemberId` を reject |
| G2 | `via_connector` で `fromId === toId` が保存される | P0 | Normalizer で reject。登録時だけでなく生成時に止める |
| G3 | AI プロンプトが connector の除外条件を明示していない | P0 | system/user prompt に「connector は requester 以外の章内メンバー」と明記 |
| G4 | 通常提案で `suggested_contact_label` に入った社外像が表示されない | P1 | `direction !== via_connector` では `suggested_to_label ?? suggested_contact_label` を採用 |
| G5 | UI が不正候補を表示し得る | P1 | サーバ修正を主、UI は `from===to` / `from===owner && via_connector` の警告または非表示 |
| G6 | 既存誤提案 #39 が pending | P1 | 実装後に `dismissed` へ更新する運用判断 |
| G7 | `relationship` 既定生成の意図が UI で分かりにくい | P2 | `document` / `relationship` の選択または説明強化 |

---

## 6. 推奨 Phase

**Phase 276: リファーラル提案自己つなぎ手ガード**

### Scope

- `ReferralSuggestionPayloadNormalizer`
- `ReferralSuggestionAiService`
- `ReferralSuggestionList` / `referralSuggestionApi`（必要最小限）
- Feature / Unit tests
- 本 Fit&Gap と Phase 文書

### DoD

- `via_connector` で `connector_member_id = requester` の AI 出力が保存されない。
- `via_connector` で `from_member_id = to_member_id` の提案が保存されない。
- 通常社外紹介で AI が `suggested_contact_label` を返しても、`suggested_to_label` として表示できる。
- 海沼功 121 の再生成で「次廣→次廣」候補が出ない。
- 既存 #39 の扱い（却下・残置）を REPORT に記録する。

---

## 7. Open Questions

| # | 論点 | 暫定 |
|---|------|------|
| 1 | 既存誤提案 #39 を DB 上で `dismissed` にするか | 実装 Phase で判断。監査上は残して status 更新が妥当 |
| 2 | `relationship` を既定のままにするか | 既定維持。ただし説明強化は P2 |
| 3 | consented owner 0 名でも `member_network` が出た場合の扱い | `via_connector` は根拠 source 必須化を検討。P0 は自己つなぎ手除外を優先 |

