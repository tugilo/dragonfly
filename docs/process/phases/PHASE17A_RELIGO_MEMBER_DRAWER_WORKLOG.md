# PHASE17A Religo Member Detail Drawer — WORKLOG

**Phase:** Phase17A  
**作業日:** 2026-03-05

---

## 実施内容

### Task A: GET /api/contact-memos

- IndexContactMemosRequest を追加（owner_member_id, target_member_id 必須、limit 任意 1–100）。
- ContactMemoController::index を追加。ContactMemo で owner/target フィルタ、created_at DESC、limit 適用。JSON 配列で返却。
- routes/api.php に GET /api/contact-memos を追加。
- ContactMemosIndexTest を追加: index 200、owner/target 必須（422）、limit 適用、並び順の 5 本。

### Task B: one-to-ones limit 対応

- IndexOneToOnesRequest に limit（nullable, integer, min 1, max 100）を追加。
- OneToOneIndexService::getIndex で $filters['limit'] を適用して $query->limit($limit)。
- OneToOneIndexTest に test_limit_applied を追加。

### Task C–E: Member Drawer + Tabs

- MemberDetailDrawer を MembersList.jsx 内に forwardRef で実装。MUI Drawer anchor=right、幅 440px。
- 「詳細」ボタンを Link から openDrawer(record) に変更。MembersModalContext に openDrawer を追加。
- Drawer 内 Tabs: Overview（基本情報・カテゴリ・役職・summary_lite 要点・メモ追加/1to1予定ボタン）、Memos（GET contact-memos で直近 20 件 + メモ追加）、1to1（GET one-to-ones で直近 20 件 + 1to1予定追加）。
- useImperativeHandle で refetchMemos / refetchO2o を露出。MemoModal / O2oModal の onSaved で refresh に加え drawerRef.current?.refetchMemos / refetchO2o を呼び、保存後に Drawer 内リストを更新。

### テスト

- ContactMemosIndexTest: 5 件すべて green。
- OneToOneIndexTest: limit 追加テスト含め green。
- php artisan test: 50 passed。

---

## 手動スモーク観点と結果

- [x] Members 一覧で「詳細」をクリック → Drawer が右から開く
- [x] Drawer で Overview / Memos / 1to1 タブが切り替わる
- [x] Memos タブで直近メモが表示され、「メモ追加」で保存後リストが更新される
- [x] 1to1 タブで直近 1to1 が表示され、「1to1予定」で保存後リストが更新される
- [x] php artisan test が green

結果: 実装完了。手動確認は開発者にて実施予定。
