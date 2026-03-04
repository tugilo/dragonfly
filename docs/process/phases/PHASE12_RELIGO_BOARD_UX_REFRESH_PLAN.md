# PHASE12 Religo Board UX Refresh — PLAN

**Phase:** DragonFlyBoard を「直感的でスピーディ」な会の地図づくり UI に全面改善  
**作成日:** 2026-03-04  
**SSOT:** 本 PLAN、既存 API（breakout-rounds / breakouts 互換維持）

---

## 1. 狙い

- **課題解消:** (1) 固定 BO と Round の二重表示を廃止し Round UI のみにする (2) メンバー割当を「検索→追加→Chip」に変更 (3) メモの文脈（Meeting / Round / Room）を Dialog で明示 (4) 保存を 1 アクションに統一 (5) MUI らしい余白・カード・タブでモダン化。
- **あるべき体験:** Meeting 選択 → Round 選択/追加 → Room へメンバー割当（クリック最短）→ Room メモ・個人メモ → 「この Round を保存」で完結。

## 2. スコープ

- **変更対象:** `DragonFlyBoard.jsx` の UI のみ。API・DB は変更しない。
- **廃止（UI 上）:** Phase10 固定 BO1/BO2 セクション（表示を削除）。API の GET/PUT `/api/meetings/{id}/breakouts` は互換のため残す。
- **正とする API:** GET/PUT `/api/meetings/{id}/breakout-rounds`。UI は Round API のみ利用。

## 3. 新 UI 構成

- **Header（上部）:** 左にタイトル「Board（会の地図）」、中央に Meeting Autocomplete（#number held_on）、右に状態 Chip（Loading / Saved / Unsaved）。保存成功後 3 秒間 Saved 表示。
- **Body 2 カラム:**
  - **左:** Round タブ（Round 1 / Round 2 / …）+ 「+ Round」ボタン。
  - **右:** 選択中 Round の編集エリア（Card）。Round 名（label）TextField、BO1/BO2 の 2 カラム。各 Room は Card：タイトル、Room メモ Textarea、メンバー割当は「候補 Autocomplete + 追加」と「追加済み Chip（×で解除）」、Chip 横にメモアイコン（EditNote）→ Dialog で「Meeting #xxx / Round y / BO1 / 相手名」+ body、保存で Snackbar「保存しました」、members 再取得。
- **保存:** 「Round 割当を保存」1 ボタンで PUT breakout-rounds。Unsaved 時は離脱確認（簡易で可）。

## 4. 仕様

- 同一 Round 内で同一メンバーを複数 Room に割り当てない（UI で候補から除外）。
- absent/proxy は割当候補に出さない（API 前提に合わせる）。
- 個人メモは POST /api/contact-memos（memo_type=meeting, meeting_id 固定）。成功後 members 再 fetch（with_summary=1）。

## 5. DoD

- [ ] Board に固定 BO セクションが出ていない（Round UI のみ）
- [ ] Meeting → Round → Room 割当 → 保存 → 復元が直感的にできる
- [ ] Room メモが保存・復元できる
- [ ] 個人メモが Meeting 文脈で書け、保存後 last_memo が更新される
- [ ] php artisan test green
- [ ] PLAN/WORKLOG/REPORT と WORKLOG に手動スモーク結果
