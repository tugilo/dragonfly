# PHASE17A Religo Member Detail Drawer — PLAN

**Phase:** Phase17A  
**作成日:** 2026-03-05  
**SSOT:** docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md（Members 詳細 = Drawer + タブ）

---

## 1. 目的

- モックの Members 詳細（右側 Drawer + Overview / Memos / 1to1 タブ）を実装し、「その人の情報に即アクセス」できるようにする。
- 既存の Members 一覧（Datagrid）と共存し、行アクション「詳細」から Drawer を開く。
- 既存 API（POST contact-memos, POST one-to-ones）をそのまま使い、履歴表示用に **GET contact-memos index** を追加する。one-to-ones は既存 index に **limit** 対応を追加する。

## 2. タスクと DoD

| Task | 内容 | DoD |
|------|------|-----|
| **A** | GET /api/contact-memos の追加 | owner_member_id, target_member_id 必須。limit 任意（default 20）。200 + 配列。Feature Test で 200 / owner・target 必須 / limit を検証。 |
| **B** | GET /api/one-to-ones に limit 対応 | 既存 IndexOneToOnesRequest に limit 追加。OneToOneIndexService で limit 適用。既存 OneToOneIndexTest を壊さない。 |
| **C** | Member Drawer UI | MUI Drawer（anchor=right）。開くトリガーは MembersList の「詳細」ボタン（Link を Drawer オープンに変更）。 |
| **D** | Drawer 内 Tabs | Overview / Memos / 1to1 の 3 タブ。Overview: 基本情報・カテゴリ・現在役職・summary_lite 要点・「メモ追加」「1to1予定」ボタン。Memos: 直近 N 件のメモ一覧 + 「メモ追加」で既存 MemoModal。1to1: 直近 N 件の 1to1 一覧 + 「1to1予定」で既存 O2oModal。 |
| **E** | 履歴の refetch | メモ追加・1to1追加の onSaved で Drawer 内の Memos/1to1 リストを再取得し表示を更新。 |
| **Test** | Feature Test | contact-memos index: 200, owner/target 必須, limit。one-to-ones: 既存維持 + limit 動作 1 本。既存全テスト green。 |

## 3. 非目標

- Member Show ページ（/members/:id）の削除はしない。Drawer を優先し、Show は残してもよい（または「詳細」を Drawer のみにし Show は使わない）。本 Phase では「詳細」クリックで Drawer を開くようにし、Show への導線は残すかどうかは実装時に判断（残す場合も Drawer を主導線とする）。
- フラグ編集モーダル（Members 画面から）は Phase17A では実装しない。
- メモ・1to1 のフィルタ（種別・日付範囲）は「直近 N 件」のみとし、後回し。

## 4. 成果物

- **API:** ContactMemoController::index、IndexContactMemosRequest。OneToOneIndexRequest + OneToOneIndexService の limit 対応。
- **UI:** MemberDrawer コンポーネント（Drawer + Tabs）。MembersList で「詳細」→ Drawer オープン、コンテキストで openDrawer(member) を提供。
- **Tests:** ContactMemosIndexTest（index 200, owner/target 必須, limit）。OneToOneIndexTest に limit テスト 1 本追加。
- **docs:** PHASE17A_PLAN / WORKLOG / REPORT。INDEX.md と dragonfly_progress.md に 1 行追加。

## 5. Git

- ブランチ: `feature/phase17a-member-drawer`
- コミット: 1 コミット。メッセージ: `feat(phase17a): Member detail Drawer + Memos/1to1 tabs, contact-memos index API`
- 取り込み: develop へ --no-ff merge、テスト実行、push、REPORT に取り込み証跡追記。

## 6. 判断メモ

- **contact_memos の index:** 現状 GET が無いため、Phase17A で新規追加。owner_member_id / target_member_id 必須とし、Drawer で「このメンバー宛のメモ」だけを取得する。
- **one_to_ones:** 既存 GET に target_member_id と limit がある（または追加）。Drawer の「1to1」タブで同じ owner + target で一覧表示。
- **Member Show ページ:** 詳細を Drawer に寄せるため、「詳細」ボタンは Drawer を開くのみにし、Show へのリンクは Drawer 内の「フル詳細を見る」など任意で残す。app.jsx の members Resource の show は残してよい（URL 直叩き用）。
