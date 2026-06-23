# Phase 234 WORKLOG — チームMTG議事録 DB 化 要件整理

**tool:** cursor  
**開始:** 2026-06-23 19:25 JST

---

## 判断ログ

### meeting_types マスタ採用

- **判断:** `meetings.session_type` 文字列定数の拡張ではなく、`meeting_types` テーブルを正とする。
- **理由:** 種別ごとに `is_numbered` / `supports_participants` / `supports_breakouts` / `supports_referral_suggestions` が必要。Webマスター MTG 等の将来種別も seed で先行定義可能。
- **互換:** `session_type` 列は移行期 legacy として維持し `meeting_types.code` と同期。

### team_id 必須

- **判断:** チーム MTG の upsert キーは `(team_meeting, team_id, held_on)`。
- **理由:** 現行 `(session_type, held_on)` では同一日複数チームが衝突する。front matter の `team_id` は既存 Markdown（`team_threebiz_*`）で運用済み。

### meeting_minutes 再利用

- **判断:** 新テーブル `team_meeting_minutes` は作らない。
- **理由:** SPEC-014 の形状が種別非依存。1 meeting : 1 minute の不変条件を維持。

### SPEC-014 との分離

- **判断:** チーム MTG は SPEC-018 として独立 Spec。SPEC-014 はチャプター定例会の取込・UI のまま。
- **理由:** 非目標（参加者/BO/リファーラル）が異なる。CHAPTER_MINUTES に混在させない。

### SPEC-014 ドリフト修正

- **判断:** モメンタム/BOD の DB 取込を「不可」→「可（session_type + held_on）」に修正。
- **理由:** Phase 220 実装・chapter README と一致。要件 SSOT の信頼性回復。

### 実装順序

- **判断:** DB → import → API → UI の 4 Phase。
- **理由:** import コマンドが meeting_types に依存。UI は API メタ列に依存。
