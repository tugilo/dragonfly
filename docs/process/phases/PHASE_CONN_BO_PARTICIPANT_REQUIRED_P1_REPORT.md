# PHASE CONN-BO-PARTICIPANT-REQUIRED-P1 — REPORT

## 何を禁止したか

- **`participants` 行の BO 保存時自動生成** — 以前は `MeetingBreakoutService` / `MeetingBreakoutRoundsService` が `(meeting_id, member_id)` 不一致時に `Participant::create(['type' => 'regular'])` していた。**削除**。
- **未登録メンバーによる BO 割当の成功** — 必ず **422**（`rooms` または `rounds` バリデーションエラー）。

## メソッド責務の変更

| メソッド | 変更内容 |
|----------|----------|
| `MeetingBreakoutService::updateBreakouts` | 割当対象の **全 `member_id` について**当該 `meeting_id` の `Participant` を事前検証。不在は 422、欠席/代理は 422。検証後は既存 participant の `id` のみで `participant_breakout` を組み立てる。 |
| `MeetingBreakoutRoundsService::updateBreakoutRounds` | **各 round** について同様（エラーキーは `rounds`、文面に `Round N:` を含む）。 |

## 既存との互換性

- **破壊的変更:** 以前は participant 無しでも BO 保存が成功し `regular` が自動作成された。**今後は必ず事前登録が必要**（CSV / Meetings 参加者反映等）。
- **互換を維持:** `absent` / `proxy` の拒否、G11（同一 member を BO1/BO2 に可）、GET 応答形状、監査ログ（成功時のみ）は従来どおり。
- **API 形状:** 422 時 `errors.rooms` / `errors.rounds` の配列メッセージ（既存クライアントが `message` のみ参照している場合は、**本文が変わる**可能性 — Connections は今回 `errors.*` を結合するよう修正）。

## UI 側に今後必要な調整

- **Connections 左ペイン**は依然 **全会員 `GET /api/dragonfly/members`** — BO に載せられない相手（未参加者）を選ぶと **422**。次 Phase で **参加者のみ表示**または **選択時のガード**を入れると UX が安定する（SPEC-007 5.3・CONN-PARTICIPANTS-ALIGN-P0 REPORT）。

## テスト

- `php artisan test` — **349 passed**（実施時点）。
- `npm run build` — 成功。

## SSOT 整合

- [MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md](../../SSOT/MEMBERS_VISITOR_GUEST_PROXY_CONNECTIONS_POLICY.md) **5.2** を「自動作成しない」に更新済み。

## Merge Evidence

- **実施環境:** ローカル Docker。merge / push は未実施（ブランチ運用はリポジトリルールに従うこと）。

| 項目 | 値 |
|------|-----|
| test command | `php artisan test` |
| test result | 349 passed |
| changed files | サービス2・テスト3・DragonFlyBoard・SSOT・process docs・INDEX・PHASE_REGISTRY・dragonfly_progress |
