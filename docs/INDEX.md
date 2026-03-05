# ドキュメント INDEX

このファイルは **docs/ 以下のドキュメント一覧と管理ルール** を定義する INDEX です。  
**ドキュメントを追加・変更・削除したら、必ずこの INDEX を更新すること。**

---

## 更新ルール（必須）

- 新しいドキュメントを追加したら、この INDEX の「一覧」に追記する。
- **進捗ファイル（<プロジェクト名>_progress.md）を更新したら、この INDEX の一覧に含まれていることを確認する。**
- ドキュメントを移動・リネーム・削除したら、この INDEX を整合する。

---

## 一覧

### 進捗（docs/ 直下）

進捗は **必ず** `docs/<プロジェクト名>_progress.md` に記録する。このプロジェクトの進捗ファイルは以下。

| ファイル | 説明 |
|----------|------|
| [dragonfly_progress.md](dragonfly_progress.md) | 本プロジェクトの進捗。Phase ・作業内容をここに追記する。 |

### その他（docs/）

| ファイル | 説明 |
|----------|------|
| [INDEX.md](INDEX.md) | 本ファイル。ドキュメントの索引と更新ルール。 |
| [GIT_WORKFLOW.md](GIT_WORKFLOW.md) | Git ブランチ運用ルール（main / develop / feature / hotfix、1push 原則、**PRレス取り込み**）。SSOT。 |
| [PROJECT_NAMING.md](PROJECT_NAMING.md) | プロジェクト命名（Religo＝プロダクト名、DragonFly＝チャプター名、dragonfly＝リポジトリ名）。 |

### Git 運用（docs/git/）

| ファイル | 説明 |
|----------|------|
| [PRLESS_MERGE_FLOW.md](git/PRLESS_MERGE_FLOW.md) | PR を介さない取り込みフロー（feature → develop のローカル merge、証跡の残し方、禁止事項、トラブル時）。 |

### SSOT（docs/SSOT/）

| ファイル | 説明 |
|----------|------|
| [DATA_MODEL.md](SSOT/DATA_MODEL.md) | Religo 会の地図（Relationship Map）データモデル。エンティティ・テーブル定義・派生指標・Phase 対応の SSOT。 |
| [MEMBERS_REQUIREMENTS.md](SSOT/MEMBERS_REQUIREMENTS.md) | Religo Members（メンバー一覧・詳細）要件の SSOT。List/Show/Edit の表示項目・操作・メモ・1to1・役職履歴・権限・非目標・DoD。 |
| [MEMBERS_REQUIREMENTS_REVIEW.md](SSOT/MEMBERS_REQUIREMENTS_REVIEW.md) | Members 要件整理結果。要件サマリ・現状との差分・不明点・推奨設計。実装前の参照用。 |
| [ADMIN_UI_THEME_SSOT.md](SSOT/ADMIN_UI_THEME_SSOT.md) | Religo 管理画面 UI Theme の SSOT。Typography / Shape / Spacing / Components override / ReactAdmin ルール。 |
| [MOCK_UI_VERIFICATION.md](SSOT/MOCK_UI_VERIFICATION.md) | モック比較による UI 検証ルール。手順・チェックリスト・参照 URL。UI 改修 Phase は PLAN に「モック比較」を必須。 |
| [DASHBOARD_REQUIREMENTS.md](SSOT/DASHBOARD_REQUIREMENTS.md) | ダッシュボード画面をモック（religo-admin-mock2.html）に合わせるための要件。構成・ブロック・データ・チェックリスト。 |
| [ROADMAP.md](SSOT/ROADMAP.md) | Religo 全体ロードマップ SSOT。Phase 順序・DoD・依存・スコープロック・テスト規約・Execution Playbook・Next 3。 |

### プロダクト要件（docs/product/）

| ファイル | 説明 |
|----------|------|
| [DRAGONFLY_REQUIREMENTS.md](product/DRAGONFLY_REQUIREMENTS.md) | DragonFly 要件定義（目的・Phase・UX・技術構成・Cursor 向けルール）。 |

### 詳細資料（docs/process/）

Phase 別の詳細な PLAN / WORKLOG / REPORT を置く場合は docs/process/ を使用し、この一覧に追記する。**develop への取り込み後**は REPORT に「取り込み証跡」を記録する。テンプレートは [process/templates/PHASE_REPORT_TEMPLATE.md](process/templates/PHASE_REPORT_TEMPLATE.md)。

| ファイル | 説明 |
|----------|------|
| [README.md](process/README.md) | process/ の必須ルール（進捗・INDEX 更新）。 |
| [templates/PHASE_REPORT_TEMPLATE.md](process/templates/PHASE_REPORT_TEMPLATE.md) | Phase REPORT の証跡欄テンプレート（merge commit id・変更ファイル一覧・テスト結果等）。 |
| （必要に応じて PHASE_<内容>_PLAN.md 等を追加） | |
| [phases/PHASE_DF_RA_01_SETUP_PLAN.md](process/phases/PHASE_DF_RA_01_SETUP_PLAN.md) | Phase DF-RA-01: ReactAdmin 基盤導入 PLAN。 |
| [phases/PHASE_DF_RA_01_SETUP_WORKLOG.md](process/phases/PHASE_DF_RA_01_SETUP_WORKLOG.md) | Phase DF-RA-01: ReactAdmin 基盤導入 WORKLOG。 |
| [phases/PHASE_DF_RA_01_SETUP_REPORT.md](process/phases/PHASE_DF_RA_01_SETUP_REPORT.md) | Phase DF-RA-01: ReactAdmin 基盤導入 REPORT。 |
| [phases/PHASE_DF_RA_02_DATAPROVIDER_PLAN.md](process/phases/PHASE_DF_RA_02_DATAPROVIDER_PLAN.md) | Phase DF-RA-02: DataProvider 最小実装 PLAN。 |
| [phases/PHASE_DF_RA_02_DATAPROVIDER_WORKLOG.md](process/phases/PHASE_DF_RA_02_DATAPROVIDER_WORKLOG.md) | Phase DF-RA-02: DataProvider 最小実装 WORKLOG。 |
| [phases/PHASE_DF_RA_02_DATAPROVIDER_REPORT.md](process/phases/PHASE_DF_RA_02_DATAPROVIDER_REPORT.md) | Phase DF-RA-02: DataProvider 最小実装 REPORT。 |
| [phases/PHASE_DF_BOARD_01_MVP_PLAN.md](process/phases/PHASE_DF_BOARD_01_MVP_PLAN.md) | Phase DF-BOARD-01: DragonFlyBoard MVP PLAN。 |
| [phases/PHASE_DF_BOARD_01_MVP_WORKLOG.md](process/phases/PHASE_DF_BOARD_01_MVP_WORKLOG.md) | Phase DF-BOARD-01: DragonFlyBoard MVP WORKLOG。 |
| [phases/PHASE_DF_BOARD_01_MVP_REPORT.md](process/phases/PHASE_DF_BOARD_01_MVP_REPORT.md) | Phase DF-BOARD-01: DragonFlyBoard MVP REPORT。 |
| [phases/PHASE04_RELIGO_MEMBERS_LIST_SUMMARY_PLAN.md](process/phases/PHASE04_RELIGO_MEMBERS_LIST_SUMMARY_PLAN.md) | Phase04 Religo: Members一覧に summary 統合 PLAN。 |
| [phases/PHASE04_RELIGO_MEMBERS_LIST_SUMMARY_WORKLOG.md](process/phases/PHASE04_RELIGO_MEMBERS_LIST_SUMMARY_WORKLOG.md) | Phase04 Religo: Members一覧に summary 統合 WORKLOG。 |
| [phases/PHASE04_RELIGO_MEMBERS_LIST_SUMMARY_REPORT.md](process/phases/PHASE04_RELIGO_MEMBERS_LIST_SUMMARY_REPORT.md) | Phase04 Religo: Members一覧に summary 統合 REPORT。 |
| [phases/PHASE05_RELIGO_RELATIONSHIP_LOG_CREATE_PLAN.md](process/phases/PHASE05_RELIGO_RELATIONSHIP_LOG_CREATE_PLAN.md) | Phase05 Religo: メモ追加API / 1to1 登録API PLAN。 |
| [phases/PHASE05_RELIGO_RELATIONSHIP_LOG_CREATE_WORKLOG.md](process/phases/PHASE05_RELIGO_RELATIONSHIP_LOG_CREATE_WORKLOG.md) | Phase05 Religo: メモ追加API / 1to1 登録API WORKLOG。 |
| [phases/PHASE05_RELIGO_RELATIONSHIP_LOG_CREATE_REPORT.md](process/phases/PHASE05_RELIGO_RELATIONSHIP_LOG_CREATE_REPORT.md) | Phase05 Religo: メモ追加API / 1to1 登録API REPORT。 |
| [phases/PHASE06_RELIGO_BOARD_ADD_MEMO_PLAN.md](process/phases/PHASE06_RELIGO_BOARD_ADD_MEMO_PLAN.md) | Phase06 Religo: DragonFlyBoard からメモ追加 PLAN。 |
| [phases/PHASE06_RELIGO_BOARD_ADD_MEMO_WORKLOG.md](process/phases/PHASE06_RELIGO_BOARD_ADD_MEMO_WORKLOG.md) | Phase06 Religo: DragonFlyBoard からメモ追加 WORKLOG。 |
| [phases/PHASE06_RELIGO_BOARD_ADD_MEMO_REPORT.md](process/phases/PHASE06_RELIGO_BOARD_ADD_MEMO_REPORT.md) | Phase06 Religo: DragonFlyBoard からメモ追加 REPORT。 |
| [phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_PLAN.md](process/phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_PLAN.md) | Phase07 Religo: DragonFlyBoard から 1 to 1 登録 PLAN。 |
| [phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_WORKLOG.md](process/phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_WORKLOG.md) | Phase07 Religo: DragonFlyBoard から 1 to 1 登録 WORKLOG。 |
| [phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_REPORT.md](process/phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_REPORT.md) | Phase07 Religo: DragonFlyBoard から 1 to 1 登録 REPORT。 |
| [phases/PHASE08_RELIGO_AUTO_WORKSPACE_ID_PLAN.md](process/phases/PHASE08_RELIGO_AUTO_WORKSPACE_ID_PLAN.md) | Phase08 Religo: workspace_id 自動取得（1to1 登録）PLAN。 |
| [phases/PHASE08_RELIGO_AUTO_WORKSPACE_ID_WORKLOG.md](process/phases/PHASE08_RELIGO_AUTO_WORKSPACE_ID_WORKLOG.md) | Phase08 Religo: workspace_id 自動取得 WORKLOG。 |
| [phases/PHASE08_RELIGO_AUTO_WORKSPACE_ID_REPORT.md](process/phases/PHASE08_RELIGO_AUTO_WORKSPACE_ID_REPORT.md) | Phase08 Religo: workspace_id 自動取得 REPORT。 |
| [phases/PHASE09_RELIGO_WORKSPACE_BOOTSTRAP_PLAN.md](process/phases/PHASE09_RELIGO_WORKSPACE_BOOTSTRAP_PLAN.md) | Phase09 Religo: Workspace 初期化（Seeder）と API テスト PLAN。 |
| [phases/PHASE09_RELIGO_WORKSPACE_BOOTSTRAP_WORKLOG.md](process/phases/PHASE09_RELIGO_WORKSPACE_BOOTSTRAP_WORKLOG.md) | Phase09 Religo: Workspace 初期化 WORKLOG。 |
| [phases/PHASE09_RELIGO_WORKSPACE_BOOTSTRAP_REPORT.md](process/phases/PHASE09_RELIGO_WORKSPACE_BOOTSTRAP_REPORT.md) | Phase09 Religo: Workspace 初期化 REPORT。 |
| [phases/PHASE10_RELIGO_BREAKOUT_ROOM_BUILDER_PLAN.md](process/phases/PHASE10_RELIGO_BREAKOUT_ROOM_BUILDER_PLAN.md) | Phase10 Religo: Meeting Breakout Room Builder（BO1/BO2）PLAN。 |
| [phases/PHASE10_RELIGO_BREAKOUT_ROOM_BUILDER_WORKLOG.md](process/phases/PHASE10_RELIGO_BREAKOUT_ROOM_BUILDER_WORKLOG.md) | Phase10 Religo: Breakout Room Builder WORKLOG。 |
| [phases/PHASE10_RELIGO_BREAKOUT_ROOM_BUILDER_REPORT.md](process/phases/PHASE10_RELIGO_BREAKOUT_ROOM_BUILDER_REPORT.md) | Phase10 Religo: Breakout Room Builder REPORT。 |
| [phases/PHASE10R_RELIGO_BREAKOUT_ROUNDS_PLAN.md](process/phases/PHASE10R_RELIGO_BREAKOUT_ROUNDS_PLAN.md) | Phase10R Religo: Breakout Round 可変（複数回対応）PLAN。 |
| [phases/PHASE10R_RELIGO_BREAKOUT_ROUNDS_WORKLOG.md](process/phases/PHASE10R_RELIGO_BREAKOUT_ROUNDS_WORKLOG.md) | Phase10R Religo: Breakout Rounds WORKLOG。 |
| [phases/PHASE10R_RELIGO_BREAKOUT_ROUNDS_REPORT.md](process/phases/PHASE10R_RELIGO_BREAKOUT_ROUNDS_REPORT.md) | Phase10R Religo: Breakout Rounds REPORT。 |
| [phases/PHASE11A_RELIGO_ADMIN_MENU_IA_PLAN.md](process/phases/PHASE11A_RELIGO_ADMIN_MENU_IA_PLAN.md) | Phase11A Religo: 管理画面メニュー整理（IA）PLAN。 |
| [phases/PHASE11A_RELIGO_ADMIN_MENU_IA_WORKLOG.md](process/phases/PHASE11A_RELIGO_ADMIN_MENU_IA_WORKLOG.md) | Phase11A Religo: メニュー IA WORKLOG。 |
| [phases/PHASE11A_RELIGO_ADMIN_MENU_IA_REPORT.md](process/phases/PHASE11A_RELIGO_ADMIN_MENU_IA_REPORT.md) | Phase11A Religo: メニュー IA REPORT。 |
| [phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_PLAN.md](process/phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_PLAN.md) | Phase11B Religo: 1 to 1 独立一覧 PLAN。 |
| [phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_WORKLOG.md](process/phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_WORKLOG.md) | Phase11B Religo: 1 to 1 一覧 WORKLOG。 |
| [phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_REPORT.md](process/phases/PHASE11B_RELIGO_ONE_TO_ONE_LIST_REPORT.md) | Phase11B Religo: 1 to 1 一覧 REPORT。 |
| [phases/PHASE12_RELIGO_BOARD_UX_REFRESH_PLAN.md](process/phases/PHASE12_RELIGO_BOARD_UX_REFRESH_PLAN.md) | Phase12 Religo: Board UX Refresh PLAN。 |
| [phases/PHASE12_RELIGO_BOARD_UX_REFRESH_WORKLOG.md](process/phases/PHASE12_RELIGO_BOARD_UX_REFRESH_WORKLOG.md) | Phase12 Religo: Board UX WORKLOG。 |
| [phases/PHASE12_RELIGO_BOARD_UX_REFRESH_REPORT.md](process/phases/PHASE12_RELIGO_BOARD_UX_REFRESH_REPORT.md) | Phase12 Religo: Board UX REPORT。 |
| [phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_PLAN.md](process/phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_PLAN.md) | Phase12S Religo: Board MUI 骨格・余白・階層 PLAN。 |
| [phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_WORKLOG.md](process/phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_WORKLOG.md) | Phase12S Religo: Board MUI Polish WORKLOG。 |
| [phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_REPORT.md](process/phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_REPORT.md) | Phase12S Religo: Board MUI Polish REPORT。 |
| [phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_PLAN.md](process/phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_PLAN.md) | Phase12T Religo: Admin Theme SSOT + 適用 PLAN。 |
| [phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_WORKLOG.md](process/phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_WORKLOG.md) | Phase12T Religo: Admin Theme SSOT WORKLOG。 |
| [phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_REPORT.md](process/phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_REPORT.md) | Phase12T Religo: Admin Theme SSOT REPORT。 |
| [phases/PHASE12R_RELIGO_ROADMAP_SSOT_PLAN.md](process/phases/PHASE12R_RELIGO_ROADMAP_SSOT_PLAN.md) | Phase12R Religo: 全体ロードマップ SSOT PLAN。 |
| [phases/PHASE12R_RELIGO_ROADMAP_SSOT_WORKLOG.md](process/phases/PHASE12R_RELIGO_ROADMAP_SSOT_WORKLOG.md) | Phase12R Religo: ロードマップ SSOT WORKLOG。 |
| [phases/PHASE12R_RELIGO_ROADMAP_SSOT_REPORT.md](process/phases/PHASE12R_RELIGO_ROADMAP_SSOT_REPORT.md) | Phase12R Religo: ロードマップ SSOT REPORT。 |
| [phases/PHASE12U_RELIGO_BOARD_3PANE_IA_PLAN.md](process/phases/PHASE12U_RELIGO_BOARD_3PANE_IA_PLAN.md) | Phase12U Religo: Board 3ペイン IA PLAN。 |
| [phases/PHASE12U_RELIGO_BOARD_3PANE_IA_WORKLOG.md](process/phases/PHASE12U_RELIGO_BOARD_3PANE_IA_WORKLOG.md) | Phase12U Religo: Board 3ペイン IA WORKLOG。 |
| [phases/PHASE12U_RELIGO_BOARD_3PANE_IA_REPORT.md](process/phases/PHASE12U_RELIGO_BOARD_3PANE_IA_REPORT.md) | Phase12U Religo: Board 3ペイン IA REPORT。 |
| [phases/PHASE12V_RELIGO_MEMBERS_MEETINGS_LIST_PLAN.md](process/phases/PHASE12V_RELIGO_MEMBERS_MEETINGS_LIST_PLAN.md) | Phase12V Religo: Members/Meetings List PLAN。 |
| [phases/PHASE12V_RELIGO_MEMBERS_MEETINGS_LIST_WORKLOG.md](process/phases/PHASE12V_RELIGO_MEMBERS_MEETINGS_LIST_WORKLOG.md) | Phase12V Religo: Members/Meetings List WORKLOG。 |
| [phases/PHASE12V_RELIGO_MEMBERS_MEETINGS_LIST_REPORT.md](process/phases/PHASE12V_RELIGO_MEMBERS_MEETINGS_LIST_REPORT.md) | Phase12V Religo: Members/Meetings List REPORT。 |
| [phases/PHASE12W_RELIGO_BOARD_SHORTCUT_PLAN.md](process/phases/PHASE12W_RELIGO_BOARD_SHORTCUT_PLAN.md) | Phase12W Religo: Board ショートカット導線 PLAN。 |
| [phases/PHASE12W_RELIGO_BOARD_SHORTCUT_WORKLOG.md](process/phases/PHASE12W_RELIGO_BOARD_SHORTCUT_WORKLOG.md) | Phase12W Religo: Board ショートカット WORKLOG。 |
| [phases/PHASE12W_RELIGO_BOARD_SHORTCUT_REPORT.md](process/phases/PHASE12W_RELIGO_BOARD_SHORTCUT_REPORT.md) | Phase12W Religo: Board ショートカット REPORT。 |
| [phases/PHASE16A_MEMBERS_REQUIREMENTS_PLAN.md](process/phases/PHASE16A_MEMBERS_REQUIREMENTS_PLAN.md) | Phase16A Religo: Members 要件棚卸し（SSOT 化）PLAN。 |
| [phases/PHASE16A_MEMBERS_REQUIREMENTS_WORKLOG.md](process/phases/PHASE16A_MEMBERS_REQUIREMENTS_WORKLOG.md) | Phase16A Religo: Members 要件 SSOT WORKLOG。 |
| [phases/PHASE16A_MEMBERS_REQUIREMENTS_REPORT.md](process/phases/PHASE16A_MEMBERS_REQUIREMENTS_REPORT.md) | Phase16A Religo: Members 要件 SSOT REPORT。 |
| [phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_PLAN.md](process/phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_PLAN.md) | Phase16B Religo: 管理画面 UI モック同期 PLAN。 |
| [phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_WORKLOG.md](process/phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_WORKLOG.md) | Phase16B Religo: 管理画面 UI モック同期 WORKLOG。 |
| [phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_REPORT.md](process/phases/PHASE16B_RELIGO_ADMIN_UI_MOCK_SYNC_REPORT.md) | Phase16B Religo: 管理画面 UI モック同期 REPORT。 |
| [phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_PLAN.md](process/phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_PLAN.md) | Phase16C Religo: Settings CRUD + RoleHistory + Members 最短操作 PLAN。 |
| [phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_WORKLOG.md](process/phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_WORKLOG.md) | Phase16C Religo: Settings CRUD + Members 仕上げ WORKLOG。 |
| [phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_REPORT.md](process/phases/PHASE16C_SETTINGS_CRUD_AND_MEMBER_ACTIONS_REPORT.md) | Phase16C Religo: Settings CRUD + Members 仕上げ REPORT。 |
| [phases/PHASE17A_RELIGO_MEMBER_DRAWER_PLAN.md](process/phases/PHASE17A_RELIGO_MEMBER_DRAWER_PLAN.md) | Phase17A Religo: Members 詳細 Drawer + Memos/1to1 タブ PLAN。 |
| [phases/PHASE17A_RELIGO_MEMBER_DRAWER_WORKLOG.md](process/phases/PHASE17A_RELIGO_MEMBER_DRAWER_WORKLOG.md) | Phase17A Religo: Member Drawer WORKLOG。 |
| [phases/PHASE17A_RELIGO_MEMBER_DRAWER_REPORT.md](process/phases/PHASE17A_RELIGO_MEMBER_DRAWER_REPORT.md) | Phase17A Religo: Member Drawer REPORT。 |
| [phases/PHASE17B_RELIGO_MEETING_DRAWER_PLAN.md](process/phases/PHASE17B_RELIGO_MEETING_DRAWER_PLAN.md) | Phase17B Religo: Meetings 詳細 Drawer + 例会メモ PLAN。 |
| [phases/PHASE17B_RELIGO_MEETING_DRAWER_WORKLOG.md](process/phases/PHASE17B_RELIGO_MEETING_DRAWER_WORKLOG.md) | Phase17B Religo: Meeting Drawer WORKLOG。 |
| [phases/PHASE17B_RELIGO_MEETING_DRAWER_REPORT.md](process/phases/PHASE17B_RELIGO_MEETING_DRAWER_REPORT.md) | Phase17B Religo: Meeting Drawer REPORT。 |
| [phases/PHASE_DASHBOARD_MOCK_ALIGN_PLAN.md](process/phases/PHASE_DASHBOARD_MOCK_ALIGN_PLAN.md) | Phase D: Dashboard モック一致 PLAN。 |
| [phases/PHASE_DASHBOARD_MOCK_ALIGN_WORKLOG.md](process/phases/PHASE_DASHBOARD_MOCK_ALIGN_WORKLOG.md) | Phase D: Dashboard モック一致 WORKLOG。 |
| [phases/PHASE_DASHBOARD_MOCK_ALIGN_REPORT.md](process/phases/PHASE_DASHBOARD_MOCK_ALIGN_REPORT.md) | Phase D: Dashboard モック一致 REPORT。 |

### BNI DragonFly（docs/networking/bni/dragonfly/）

| ファイル | 説明 |
|----------|------|
| [REQUIREMENTS_MEMBER_PARTICIPANTS.md](networking/bni/dragonfly/REQUIREMENTS_MEMBER_PARTICIPANTS.md) | メンバーマスター・参加者・ブレイクアウトメモの要件定義。 |
| [STATUS_MVP_199.md](networking/bni/dragonfly/STATUS_MVP_199.md) | 第199回 MVP の完了範囲・未実装・技術的注意点。 |
| [api/DRAGONFLY_MVP_API_GUIDE.md](networking/bni/dragonfly/api/DRAGONFLY_MVP_API_GUIDE.md) | DragonFly MVP API のエンドポイント・curl 例・レスポンス・エラー仕様。 |
| [breakout/DRAGONFLY_BREAKOUT_SEEDING_POLICY_20260303.md](networking/bni/dragonfly/breakout/DRAGONFLY_BREAKOUT_SEEDING_POLICY_20260303.md) | 第199回ブレイクアウトの暫定割当ルールと冪等性・正式割当反映手順。 |

### 実装設計（docs/design/）

| ファイル | 説明 |
|----------|------|
| [bni/dragonfly/BNI_MEMBER_PARTICIPANTS_IMPLEMENTATION_DESIGN.md](design/bni/dragonfly/BNI_MEMBER_PARTICIPANTS_IMPLEMENTATION_DESIGN.md) | メンバー・参加者管理のDB設計・リレーション・実装順序。 |
| [dragonfly/DRAGONFLY_DATA_MODEL_V1.md](design/dragonfly/DRAGONFLY_DATA_MODEL_V1.md) | DragonFly SPA 用データモデル v1.1（恒久フラグ・理由ログ、ハイブリッドフラグ、1on1 履歴、既存スキーマとの住み分け）。 |
| [dragonfly/DRAGONFLY_API_DESIGN_V1.md](design/dragonfly/DRAGONFLY_API_DESIGN_V1.md) | DragonFly SPA 用 API 設計 v1（flags / contact events / 1on1 sessions / summary）。 |
| [dragonfly/DRAGONFLY_MIGRATION_PLAN_V1.md](design/dragonfly/DRAGONFLY_MIGRATION_PLAN_V1.md) | DragonFly 新規テーブル Migration 計画 v1（contact_flags / contact_events / one_on_one_sessions）。 |
| [dragonfly/DRAGONFLY_REACT_ADMIN_ARCHITECTURE_V1.md](design/dragonfly/DRAGONFLY_REACT_ADMIN_ARCHITECTURE_V1.md) | DragonFly ReactAdmin 構成設計 v1（Resources / DragonFlyBoard 3 ペイン / DataProvider / 状態管理）。 |

### 決定事項（docs/decisions/）

| ファイル | 説明 |
|----------|------|
| [dragonfly/DRAGONFLY_DECISIONS_V1.md](decisions/dragonfly/DRAGONFLY_DECISIONS_V1.md) | DragonFly V1 未決事項の確定（D-01〜D-08: owner の渡し方、extra_status、1on1 自動ON、contact_events、FK、URL、Summary 責務）。 |

### 要件（docs/requirements/）

| ファイル | 説明 |
|----------|------|
| [dragonfly/DRAGONFLY_SPA_REQUIREMENTS_V1.md](requirements/dragonfly/DRAGONFLY_SPA_REQUIREMENTS_V1.md) | DragonFly SPA（Laravel API + ReactAdmin + MUI）の SSOT 要件書 v1（1on1 候補・1on1 履歴含む）。 |
