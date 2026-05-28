# Phase M4H Members Card Relationship Score 表示 — PLAN

**Phase:** M4H  
**作成日:** 2026-03-10  
**SSOT:** [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4.1, §4.2 / [RELATIONSHIP_SCORE_SSOT.md](../../SSOT/RELATIONSHIP_SCORE_SSOT.md)

---

## Phase

M4H — Members の **Card 表示**に Relationship Score（関係温度）を追加し、カード一覧で「このメンバーとの関係性の温度感」を直感的に把握できるようにする。

---

## Purpose

- Members の **Card 表示のみ**に Relationship Score を表示する。
- 既存 API は変更しない。List（Datagrid）は変更しない。
- 既存の summary_lite（same_room_count, one_to_one_count, last_memo, interested, want_1on1 等）を利用し、C-7 と同様の **UI 計算のみ**で 0〜5 のスコアを算出し、★1〜5（または ☆/★ の視覚表現）で表示する。

---

## Background

- FIT_AND_GAP §4.1 の .mcard には「同室回数・最終接触・直近メモ・フラグ・関係ログ」が含まれる。Connections 右ペインでは C-7 で **Relationship Score**（★☆☆☆☆〜★★★★★）が既に実装されている（RELATIONSHIP_SCORE_SSOT）。
- RELATIONSHIP_SCORE_SSOT の算出ルール: same_room_count >= 10 → +2, >= 5 → +1; latest_memos あり → +1; interested → +1; want_1on1 → +1。合計を 0〜5 にクリップ。表示は 5〜0 で ★★★★★〜☆☆☆☆☆。
- Members 一覧 API の summary_lite は same_room_count, one_to_one_count, last_contact_at, **last_memo**, interested, want_1on1 を返す。**latest_memos は含まない**が、last_memo が 1 件あれば「直近メモあり」とみなして +1 とする（DragonFlyBoard の summaryLiteToPseudoSummary と同様）。

---

## Related SSOT

- docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md §4.1（.mcard 構成）、§4.2（実装比較）
- docs/SSOT/RELATIONSHIP_SCORE_SSOT.md（算出ルール・表示ルール・データソース）

---

## Scope

- **変更可能:** www/resources/js/admin/pages/MembersList.jsx の **Card 表示（MemberCard）** のみ。
- **変更しない:** API、dataProvider、List（Datagrid）表示、他ページ、DragonFlyBoard.jsx。

---

## Target Files

- www/resources/js/admin/pages/MembersList.jsx

---

## Implementation Strategy

1. **スコア算出**
   - RELATIONSHIP_SCORE_SSOT に準拠。summary_lite のみ使用。same_room_count >= 10 → +2, >= 5 → +1。直近メモ: **last_memo が存在すれば +1**（latest_memos の代わり）。interested === true → +1。want_1on1 === true → +1。合計を Math.min(5, Math.max(0, s)) でクリップ。MembersList.jsx 内に純粋関数として実装し、DragonFlyBoard とは共有しない（Scope が MembersList のみのため）。

2. **表示**
   - スコア 0〜5 を ★★★★★〜☆☆☆☆☆ で表示（C-7 と同じ表記）。ラベルは「Relationship Score」または「関係温度」のいずれか短い表記。

3. **配置**
   - MemberCard の mc-body 内で、**同室回数・最終接触のブロック（mc-rel）の直後**に 1 行の Relationship Score ブロックを追加。カードの可読性を壊さないようコンパクトに表示。

4. **データ不足時**
   - summary_lite が無い、または null の場合はスコア 0 として表示（☆☆☆☆☆）するか、ブロックを「—」で表示。どちらでもよいが、未データは「関係がまだ薄い」と解釈して ☆☆☆☆☆ で統一する。

5. **追加 fetch 禁止**
   - 既存の record（summary_lite 付き）だけで完結する。追加 API は呼ばない。

---

## Tasks

- [ ] Task1: Members Card で利用可能な既存データ確認（summary_lite のキー）
- [ ] Task2: Relationship Score の算出ルール決定（C-7 準拠・last_memo でメモあり扱い）
- [ ] Task3: MemberCard に score 表示ブロック追加（mc-rel 直後）
- [ ] Task4: データ不足時のフォールバック（summary_lite 無し → 0 または —）
- [ ] Task5: Card 全体の見やすさ確認（レイアウト・文字サイズ）

---

## DoD

- Card 表示にのみ Relationship Score（★☆☆☆☆〜★★★★★）が表示されること。
- 算出は summary_lite の same_room_count, last_memo, interested, want_1on1 のみで行い、RELATIONSHIP_SCORE_SSOT のルールに準拠していること。
- List（Datagrid）には追加しないこと。
- MembersList.jsx 以外は変更しないこと。API 変更なし。
- summary_lite が無い場合は 0（☆☆☆☆☆）または「—」でフォールバックすること。
- php artisan test および npm run build が通ること。

---

## 参照

- RELATIONSHIP_SCORE_SSOT: データソース・計算ルール・表示ルール
- DragonFlyBoard.jsx: calculateRelationshipScore, summaryLiteToPseudoSummary（参考。MembersList では同ロジックを自前実装）
