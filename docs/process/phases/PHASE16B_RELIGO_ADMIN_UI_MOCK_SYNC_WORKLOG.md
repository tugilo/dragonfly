# PHASE16B Religo 管理画面 UI モック同期 — WORKLOG

**Phase:** Phase16B  
**作業日:** 2026-03-05

---

## 実施内容

1. **feature ブランチ作成**  
   - `feature/phase16b-admin-ui-mock-sync-v1` を作成。

2. **メニュー・ルーティング**  
   - ReligoMenu.jsx をモック通りに変更: Dashboard → Connections → Members → Meetings → 1 to 1 → Role History → Settings（Categories, Roles）。Settings は ListSubheader + ネスト MenuItem。  
   - app.jsx: dashboard を新規 Dashboard に変更。Resource に connections（DragonFlyBoard）, role-history（RoleHistoryList）を追加。dragonflyFlags を削除。CustomRoutes で /settings/categories, /settings/roles を CategoriesPage, RolesPage にマッピング。

3. **新規ページ**  
   - Dashboard.jsx: 統計カード・今日やること・クイックショートカット・最近の活動（静的）。  
   - RoleHistoryList.jsx: List + Datagrid、dataProvider の role-history スタブで表示。  
   - CategoriesPage.jsx, RolesPage.jsx: モック準拠のテーブル＋スタブデータ。追加ボタンは disabled + Coming soon。

4. **Connections**  
   - DragonFlyBoard.jsx: ページタイトルを「Connections」、サブ「Meeting → BO割当 → 関係ログの中心」に変更。右上に「BO割当を保存」「Meetingsへ」ボタン。Link で /meetings へ遷移。

5. **Members**  
   - MembersList.jsx: ヘッダー「Members」、TopToolbar に「Connectionsへ」「＋ メンバー追加（将来）」disabled。Datagrid に Actions 列を追加。MembersModalContext で「メモ」「1to1」「1to1メモ」を開く。MemoModal / O2oModal / O2oMemoModal を実装。既存 API（POST contact-memos, POST one-to-ones）で保存。ワークスペースは GET /api/workspaces で取得。

6. **Meetings / 1 to 1**  
   - MeetingsList: タイトル「Meetings」、Actions「Connectionsで編集」（/connections へ）。  
   - OneToOnesList: タイトル「1 to 1」、TopToolbar に「＋ 1to1を追加」「Connectionsへ」。

7. **dataProvider**  
   - role-history の getList でスタブ配列（役職履歴 7 件）を返す。

8. **docs**  
   - PHASE16B の PLAN / WORKLOG / REPORT 作成。INDEX.md と dragonfly_progress.md に Phase16B を追記。

---

## 手動スモーク観点（実施は任意・推奨）

- [ ] 左メニューから全ページ（Dashboard, Connections, Members, Meetings, 1 to 1, Role History, Settings → Categories, Roles）に遷移できる。  
- [ ] Members: 一覧表示、行の「メモ」「1to1」「1to1メモ」でモーダルが開く。メモ・1to1 は保存できる。  
- [ ] 1 to 1: 一覧表示、「＋ 1to1を追加」で追加画面が開く。  
- [ ] Role History: 一覧表示、フィルタ表示が崩れない。  
- [ ] Settings: Categories / Roles に遷移でき、テーブル UI が表示される。  
- [ ] Connections: タイトルが「Connections」、BO 割当・Meetings への導線が動作する。

---

## メモ

- Connections は既存 DragonFlyBoard をそのまま利用。名前とヘッダーのみモックに合わせた。  
- Settings（Categories / Roles）は UI のみ。dataProvider 追加は次 Phase。  
- 既存の contact-memos / one-to-ones API は変更していない。
