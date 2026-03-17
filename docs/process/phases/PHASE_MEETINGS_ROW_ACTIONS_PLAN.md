# Phase Meetings Row Actions — PLAN

**Phase:** M2（Meetings 一覧に行アクション追加）  
**作成日:** 2026-03-17  
**SSOT:** [FIT_AND_GAP_MEETINGS.md](../../SSOT/FIT_AND_GAP_MEETINGS.md)、[PHASE_MEETINGS_LIST_ENHANCEMENT_REPORT.md](PHASE_MEETINGS_LIST_ENHANCEMENT_REPORT.md)

---

## 1. 背景

- Phase M1 により Meetings 一覧にサブ説明・番号/開催日/BO数/メモ列が実装済み。一方で行単位の操作導線がなく、「見るだけの一覧」のままである。
- モック（religo-admin-mock-v2.html#/meetings）では各行に「📝 メモ」「🗺 BO編集」の行アクションがあり、FIT_AND_GAP_MEETINGS の M12 で Gap として挙がっている。
- M2 は行アクションの追加に限定し、Drawer/詳細表示やメモ編集モーダル本体は M3/M4 に委ねる。

---

## 2. 目的

- Datagrid の各行に **Actions** 列を追加する。
- 行アクションとして **「📝 メモ」** と **「🗺 BO編集」** を追加し、Meetings を「次の操作へ進める一覧」にする。
- 「🗺 BO編集」は /connections への導線とする。
- 「📝 メモ」は M4 の例会メモ編集モーダルへの導線となるよう、後で差し替えやすい構造で実装する。

---

## 3. スコープ

- **変更可能:** www/resources/js/admin/pages/MeetingsList.jsx、docs/process/phases/PHASE_MEETINGS_ROW_ACTIONS_*.md
- **変更しない:** API、他ページ、dataProvider、Drawer/詳細表示（M3）、例会メモ編集モーダル本体（M4）

---

## 4. 変更対象ファイル

| ファイル | 変更内容 |
|----------|----------|
| www/resources/js/admin/pages/MeetingsList.jsx | Actions 列追加、MeetingActionsField（📝メモ・🗺BO編集）の実装 |
| docs/process/phases/PHASE_MEETINGS_ROW_ACTIONS_PLAN.md | 本ファイル |
| docs/process/phases/PHASE_MEETINGS_ROW_ACTIONS_WORKLOG.md | 作業記録 |
| docs/process/phases/PHASE_MEETINGS_ROW_ACTIONS_REPORT.md | 完了報告 |

---

## 5. 実装方針

- **Actions 列:** TextField ではなく、専用の **MeetingActionsField** を FunctionField の render で用いるか、FunctionField 内で直接ボタン群を描画する。React Admin / MUI で自然なのは「列に 1 コンポーネントでボタン 2 つ」の構成。
- **「🗺 BO編集」:** React Router の `Link` で `to="/connections"` に遷移。Connections 側で meeting を選択するのはユーザー操作に委ね、この Phase では query parameter は付けない（過剰なら不要の方針）。
- **「📝 メモ」:** クリック時に `onMeetingMemoClick(record)` のようなハンドラを呼ぶ。現時点ではプレースホルダ（例: console.log や window.alert）でよい。M4 ではこのハンドラを「例会メモ編集 Dialog を開く」実装に差し替える想定のため、**ハンドラをコンポーネントの props または同一ファイル内の名前付き関数として切り出し**、後で差し替え可能にする。
- **過度な状態管理は入れない:** モーダル開閉 state は M4 で導入する。M2 ではボタンと導線のみ。
- **UI:** MUI の Button（size="small"）または IconButton + Stack/Box で横並び。モックは「btn btn-g btn-xs」「btn btn-t btn-xs」相当の小さいボタンなので、`variant="outlined"` と `size="small"` で揃える。

---

## 6. テスト観点

- 一覧に **Actions** 列が表示されること。
- 各行に「📝 メモ」「🗺 BO編集」が表示されること。
- 「🗺 BO編集」のリンク先が `/connections`（または admin ベースの `/connections`）であること。
- 既存の番号・開催日・BO数・メモ表示に影響がないこと。
- （手動）「📝 メモ」クリックでプレースホルダ動作（alert 等）が起こること。M4 で Dialog に差し替えた際、同じクリックで Dialog が開く設計であること。

---

## 7. DoD

- [x] Datagrid に Actions 列が追加されていること。
- [x] 各行に「📝 メモ」「🗺 BO編集」が表示されること。
- [x] 「🗺 BO編集」が /connections へ遷移すること。
- [x] 「📝 メモ」がプレースホルダでも M4 で差し替えやすい構造（ハンドラの切り出し）になっていること。
- [x] 既存の php artisan test が通ること（82 passed）。
- [x] PLAN / WORKLOG / REPORT が揃っていること。

---

## 8. 参照

- モック: http://localhost/mock/religo-admin-mock-v2.html#/meetings  
- 実装: http://localhost/admin#/meetings  
