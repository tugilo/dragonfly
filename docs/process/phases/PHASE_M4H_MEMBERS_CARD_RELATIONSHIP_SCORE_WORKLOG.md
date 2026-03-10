# Phase M4H Members Card Relationship Score 表示 — WORKLOG

**Phase:** M4H  
**参照:** [PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_PLAN.md](PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_PLAN.md)、[RELATIONSHIP_SCORE_SSOT.md](../../SSOT/RELATIONSHIP_SCORE_SSOT.md)

---

## Task1: Members Card で利用可能な既存データ確認

- **状態:** 完了
- **判断:** API の summary_lite は DragonFlyMemberController で same_room_count, one_to_one_count, last_contact_at, last_memo, interested, want_1on1 を返す。MemberCard では既に s = record?.summary_lite || {} で参照し、同室回数・最終接触・直近メモ・フラグ表示に利用している。スコア算出に必要な項目はすべて揃っている。
- **実施:** DragonFlyMemberController.php と MembersList.jsx の MemberCard を確認した。
- **確認:** last_memo はオブジェクト（body_short / body 等）で存在有無は last_memo != null と last_memo.body_short or body で判定可能。

---

## Task2: Relationship Score の算出ルール決定

- **状態:** 完了
- **判断:** RELATIONSHIP_SCORE_SSOT に準拠。same_room_count >= 10 → +2, >= 5 → +1。latest_memos の代わりに last_memo が存在すれば +1。interested / want_1on1 は true で +1。合計を 0〜5 にクリップ。DragonFlyBoard の summaryLiteToPseudoSummary と同様に last_memo 1 件を「直近メモあり」とみなす。
- **実施:** relationshipScoreFromSummaryLite(lite) を MembersList.jsx 内に純粋関数で実装。RELATIONSHIP_SCORE_STARS で 0〜5 を ☆☆☆☆☆〜★★★★★ にマッピング。
- **確認:** C-7 と同じ加算ルールで、データソースが summary_lite のみのため API 変更なしで実現可能。

---

## Task3: MemberCard に score 表示追加

- **状態:** 完了
- **判断:** mc-body 内で mc-rel の直後に「関係温度」ラベルと ★/☆ 表示のブロック（mc-score）を追加。カードの縦長を抑えるため 1 行でコンパクトに表示。
- **実施:** Box.mc-score を追加。Typography で「関係温度」キャプションと RELATIONSHIP_SCORE_STARS[score]。aria-label でアクセシビリティ対応。
- **確認:** Card 表示時のみ表示され、List（Datagrid）には一切手を入れていない。

---

## Task4: データ不足時のフォールバック確認

- **状態:** 完了
- **判断:** summary_lite が null/undefined のとき relationshipScoreFromSummaryLite は 0 を返す。RELATIONSHIP_SCORE_STARS[0] は「☆☆☆☆☆」のため、データ不足時も「関係がまだ薄い」として ☆☆☆☆☆ で表示される。
- **実施:** 実装で lite が無い場合は即 0 を返すようにした。追加の条件分岐は不要。
- **確認:** with_summary なしで一覧を取得した場合でも record.summary_lite が無く 0 になるため、エラーにならない。

---

## Task5: Card 全体の見やすさ確認

- **状態:** 完了
- **判断:** mc-rel と mc-memo の間に 1 行ブロックを挟んだだけであり、既存の gap: 1 で余白は統一。フォントは caption + body2 で他ブロックと整合。カードの可読性を損なわない。
- **実施:** mc-score は display: flex, alignItems: center, gap: 0.5 でラベルとスコアを横並びにした。
- **確認:** レイアウトが崩れていないこと、List 表示は従来どおりであることを確認。
