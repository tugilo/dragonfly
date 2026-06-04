# WORKLOG: Phase 195 — リファーラル提案 横断マッチング

**Phase ID:** 195  
**PLAN:** [PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_PLAN.md](PHASE_195_REFERRAL_SUGGESTION_CROSS_MATCH_PLAN.md)

---

## 記録方針

「いつ何をしたか」ではなく **判断理由と実装の結び** を書く。

---

## Entries

### 2026-06-04 22:19 JST — PLAN 確定

- **横断共有:** 初期値 **オプトイン（false）**。定例会は貢献設定対象外・直近 6 回を常時コーパスに含める。
- **生成:** `context_mode=document`（MVP 互換）と `relationship`（新規）を共存。UI/API 既定は `relationship`。
- **Givers Gain:** `via_connector` + `corpus_source=member_network`。register 時 from=つなぎ手、to=依頼者。

### 2026-06-04 22:20 JST — T1–T7 着手（121 中心）

- migration `member_referral_corpus_settings` + run/suggestion 拡張。
- `ReferralRelationshipContextBuilder` / settings API / AI relationship プロンプト。
- UI: 設定トグル（ReligoSettings）、提案カード「紹介をお願い」、generate に `context_mode`。
- 定例会 `relationship` 生成は Phase 195 残タスク（document モードは現行維持）。

### 2026-06-04 22:25 JST — T5 定例会 relationship・回帰修正

- **Meeting `meetingMinute`:** Eloquent リレーション名は `minute` ではなく `meetingMinute`。`ReferralRelationshipContextBuilder` を修正（list/relationship 生成の 500 回避）。
- **API 既定 `context_mode`:** 後方互換のため **未指定時は `document`**。React は 121/定例会とも **`relationship` を明示送信**（PLAN の UI 既定と一致）。
- **定例会 T5:** `buildForMeeting` / `generateForMeetingRelationship` / `MeetingReferralSuggestionService` 二モード化。`parseMeetingSuggestions` に `via_connector` 対応。register は `resolveFromToForMeeting`。
- **テスト:** `ReferralRelationshipGenerateTest`（同意フィルタ・relationship 生成・つなぎ手登録）。全 suite **467 passed**。`npm run build` OK。
- **残:** T8（DATA_MODEL・FIT_AND_GAP・COMMON §0.7.2 1 行・REPORT・merge）。

### 2026-06-04 22:51 JST — Pack 精度強化（フライホイール第2段）・Phase 完了

- **① 主役関連定例会:** `recentMeetingExcerpts` に `relatedMemberIds` フィルタ（121=主役、定例会=当回参加者）。無関係回は Pack から除外。
- **② introductions:** `ReferralRelationshipIntroductionSummary` で主役・依頼者関与分を最大 20 件要約。AI に重複提案禁止を追記。
- **③ UI:** `formatCorpusMetaSummary` + モーダル Alert（121 抜粋数・関連定例会・紹介履歴・同意者数）。
- **subject_should_meet:** プロンプト・normalizer・UI（つなぐ CTA）。`via_connector` は contact 必須・connector 例 ID 禁止。
- **Phase F 索引:** 本 Phase 非スコープ（ROADMAP 据え置き）。
