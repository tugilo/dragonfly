# PHASE C-8 Introduction Hint — WORKLOG

**Phase:** C-8

---

## Step1 — 紹介候補計算

- `calculateIntroductionHints(members, calculateRelationshipScore)` を定義。members は `with_summary=1` で取得済みの配列。各 member の summary_lite（same_room_count, interested, want_1on1 等）と category を利用。C-7 の calculateRelationshipScore は summary 相当オブジェクトを渡す（summary_lite から擬似 summary を組み立てる）。

## Step2 — ペア抽出

- same_room_count >= 3 かつ category が異なり、score >= 2 かつ want_1on1 === false のペアを列挙。owner は固定（ownerMemberId）。「接触あり」は summary_lite.same_room_count >= 3 で判定。

## Step3 — 最大 3 件

- 優先度: 同室回数合計または score 合計でソートし、先頭 3 件。

## Step4 — UI

- ブロック見出し「💡 Introduction Hint」。Relationship Score の下、Relationship Log の上に配置。形式「業種（名前） → 業種（名前）」。

## Step5 — fallback

- 候補 0 件は「紹介候補なし」。

## Step6 — build

- npm run build 成功。
