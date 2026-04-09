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

### 打合せ・会議メモ（docs/meetings/）

| ファイル | 説明 |
|----------|------|
| [meetings/README.md](meetings/README.md) | **直下と `1to1/` の役割分担**（複数者ミーティング・提案書 vs **1対1専用**）。 |

#### 1to1 専用（docs/meetings/1to1/）

| ファイル | 説明 |
|----------|------|
| [meetings/1to1/README.md](meetings/1to1/README.md) | **ファイル命名・スラッグ・DB取り込み想定**（`1to1_id` 等）。チャプターを跨ぐ1to1もここに集約。 |
| [meetings/1to1/_TEMPLATE.md](meetings/1to1/_TEMPLATE.md) | 新規1to1用テンプレ（任意 YAML front matter）。 |
| [meetings/1to1/1to1_sato_takuto_brightlink.md](meetings/1to1/1to1_sato_takuto_brightlink.md) | 佐藤 拓斗（株式会社BrightLink）**1to1＋BNIプロフィール統合**（サマリー・第N回・累積・戦略・リファーラル）。第1回 **2026-04-03 JST 07:15–08:15**・Zoom。 |
| [meetings/1to1/1to1_okamoto_kachiteru_present.md](meetings/1to1/1to1_okamoto_kachiteru_present.md) | **岡元智美（RyoTen・筑後市）** 勝てるプレゼン資料作成。プロフィール・推薦文インサイト・リファーラル強化済。第1回2025-03-16・時刻TODO。 |
| [meetings/1to1/1to1_kimura_kengo_mfg_retail.md](meetings/1to1/1to1_kimura_kengo_mfg_retail.md) | 木村健悟（**ハート・プランニング／倉敷屋**）。**自己紹介シート統合済**（G.A.I.N.S・Top3・推薦インサイト）・付録に旧システム構想全文（2025-03-12・時刻TODO）。 |
| [meetings/1to1/1to1_gunji_lstep_webhook.md](meetings/1to1/1to1_gunji_lstep_webhook.md) | 軍司・Lステップ×Webhook×AI。**付録にアジェンダ全文**。実施日時はYAML **TODO**。 |
| [meetings/1to1/1to1_yonezawa_yuka_comechan_design.md](meetings/1to1/1to1_yonezawa_yuka_comechan_design.md) | **米澤 侑桂（Comechan Design）**。**§10〜14**＝協業合意・案件・スキル・稼働・成功要因（2026-04-08）。**§15〜18**＝再現用ヒアリング／台本。**求人サイトアプリ化＋腰回収リッチメニュー** 合意。 |

#### 提案書・その他（docs/meetings/ 直下）

| ファイル | 説明 |
|----------|------|
| [2025-03-12_kimura_system_concept_proposal.md](meetings/2025-03-12_kimura_system_concept_proposal.md) | 木村様向け提案書：業務整理と仕組みづくりの構想メモ（2025/3/12）。クライアント共有用。 |
| [2026-03-30_gunji_lstep_webhook_ai_proposal.md](meetings/2026-03-30_gunji_lstep_webhook_ai_proposal.md) | 軍司様向け提案書（2026/3/30）：Lステップ Webhook × AI チャットボット構築・協業（START / GROW / SHIFT プラン・展開）。クライアント／パートナー共有用。 |

### ワークショップ（docs/workshop/）

| ファイル | 説明 |
|----------|------|
| [workshop/README.md](workshop/README.md) | 本ディレクトリの用途（研修・WS向けメモ。SSOT とは分離）。 |
| [workshop/BNI_KeySkills_Referral_Workshop_Prep_Tsugihiro_202604.md](workshop/BNI_KeySkills_Referral_Workshop_Prep_Tsugihiro_202604.md) | **KeySkills・リファーラルWS 実戦用台本**（即答・10/30/1分・紹介文型・RP）。**§⑧ 事例と効果**、個人事業主ターゲット。**1to1WSとは別。** |
| [workshop/BNI_DragonFly_BO_Step1_Referral_Minutes_20260402.md](workshop/BNI_DragonFly_BO_Step1_Referral_Minutes_20260402.md) | WS **ステップ1 BO** リファー視点議事録（紹介矢印・L推定・次廣アクション）。 |
| [workshop/BNI_KeySkills_Lesson2_Referral_Script_Tsugihiro_202604.md](workshop/BNI_KeySkills_Lesson2_Referral_Script_Tsugihiro_202604.md) | WS **レッスン2** 第三者紹介文（**AI業務改善システム構築の次廣**）。個人事業主・**事例と効果**の型。 |
| [workshop/BNI_KeySkills_Lesson2_Referral_Workflow_Tsugihiro_202604.md](workshop/BNI_KeySkills_Lesson2_Referral_Workflow_Tsugihiro_202604.md) | WS **レッスン2** 進め方4問（■①〜④）・**ウィークリー§2.1**・Script／事例参照。 |

### tugilo AI DevOS v4.3

| ファイル | 説明 |
|----------|------|
| [.cursor/rules/devos-v4.mdc](../.cursor/rules/devos-v4.mdc) | DevOS 本体ルール（alwaysApply: true）。Phase 管理・SSOT 起点・Merge Evidence。**プロジェクト共有ルールとして repo 管理。** |

### 仕様（docs/02_specifications/）

| ファイル | 説明 |
|----------|------|
| [SSOT_REGISTRY.md](02_specifications/SSOT_REGISTRY.md) | 仕様一覧（SSOT の起点）。AI は仕様参照時必ずここから。 |

### アーキテクチャ（docs/01_architecture/）

| ファイル | 説明 |
|----------|------|
| [README.md](01_architecture/README.md) | アーキテクチャ関連ドキュメントの格納先。 |

### 運用（docs/03_operations/）

| ファイル | 説明 |
|----------|------|
| [README.md](03_operations/README.md) | 運用・デプロイ・監視ドキュメントの格納先。 |

### Git 運用（docs/git/）

| ファイル | 説明 |
|----------|------|
| [BRANCH_STRATEGY.md](git/BRANCH_STRATEGY.md) | ブランチ規約（main / develop / feature/phaseXXX-name）。DevOS v4.3。 |
| [PRLESS_MERGE_FLOW.md](git/PRLESS_MERGE_FLOW.md) | PR を介さない取り込みフロー（feature → develop のローカル merge、証跡の残し方、禁止事項、トラブル時）。 |

### SSOT（docs/SSOT/）

| ファイル | 説明 |
|----------|------|
| [DATA_MODEL.md](SSOT/DATA_MODEL.md) | Religo 会の地図（Relationship Map）データモデル。エンティティ・テーブル定義・**Workspace と User（BNI 1 user = 1 workspace）**・派生指標・Phase 対応の SSOT。 |
| [MEMBERS_REQUIREMENTS.md](SSOT/MEMBERS_REQUIREMENTS.md) | Religo Members（メンバー一覧・詳細）要件の SSOT。List/Show/Edit の表示項目・操作・メモ・1to1・役職履歴・権限・非目標・DoD。 |
| [MEMBERS_REQUIREMENTS_REVIEW.md](SSOT/MEMBERS_REQUIREMENTS_REVIEW.md) | Members 要件整理結果。要件サマリ・現状との差分・不明点・推奨設計。実装前の参照用。 |
| [MEMBERS_MOCK_VS_UI_SUMMARY.md](SSOT/MEMBERS_MOCK_VS_UI_SUMMARY.md) | Members のモックと実装の差・要件まとめ。差分一覧・要件対応・チェックリスト。 |
| [ADMIN_UI_THEME_SSOT.md](SSOT/ADMIN_UI_THEME_SSOT.md) | Religo 管理画面 UI Theme の SSOT。Typography / Shape / Spacing / Components override / ReactAdmin ルール。 |
| [ADMIN_GLOBAL_OWNER_SELECTION.md](SSOT/ADMIN_GLOBAL_OWNER_SELECTION.md) | **グローバルヘッダーでの Owner 選択**（SPEC-003）・全画面で同一 `owner_member_id` を基準にする要件。**記録:** [PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_REPORT.md](process/phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_REPORT.md)（実装・`ReligoOwnerContext`・follow-up 一括取り込み）。 |
| [MOCK_UI_VERIFICATION.md](SSOT/MOCK_UI_VERIFICATION.md) | モック比較による UI 検証ルール。手順・チェックリスト・参照 URL。UI 改修 Phase は PLAN に「モック比較」を必須。 |
| [FIT_AND_GAP_MOCK_VS_UI.md](SSOT/FIT_AND_GAP_MOCK_VS_UI.md) | モック vs 実装 UI のフィット＆ギャップ一覧（画面別）。 |
| [FIT_AND_GAP_MENU_HEADER.md](SSOT/FIT_AND_GAP_MENU_HEADER.md) | メニュー・ヘッダーに特化したフィット＆ギャップ（モック v2 基準）。**2026-04-06:** カスタム AppBar・グローバル Owner（SPEC-003）・`/settings` ゲート例外を §4.1 に反映。 |
| [FIT_AND_GAP_MEETINGS.md](SSOT/FIT_AND_GAP_MEETINGS.md) | Meetings 画面のモック vs 実装のフィット＆ギャップ調査（#/meetings 基準）。 |
| [MEETINGS_CREATE_FIT_AND_GAP.md](SSOT/MEETINGS_CREATE_FIT_AND_GAP.md) | Meetings 例会マスタ（新規作成・編集・削除）の要否・現状実装・Fit/Gap・案A/B/C・推奨方針（調査 SSOT）。 |
| [MEETINGS_DELETE_FIT_AND_GAP.md](SSOT/MEETINGS_DELETE_FIT_AND_GAP.md) | Meetings **削除**の業務要否・子データ/FK影響・案A〜E・推奨・実装前の決定事項（調査のみ・コード変更なし）。 |
| [MEETINGS_ARCHIVE_FIT_AND_GAP.md](SSOT/MEETINGS_ARCHIVE_FIT_AND_GAP.md) | Meetings **Archive**（非表示/論理無効化/履歴保持）の要否・Delete 代替との関係・子データ/一覧/stats/Drawer 影響・設計案A〜F・推奨・実装前の決定事項。**補足前提:** 初回は `archived_at` のみ・`show` 非破壊・`next_meeting` は未アーカイブのみ・初回 restore 不要（調査のみ・コード変更なし）。 |
| [ONETOONES_DELETE_REQUIREMENTS.md](SSOT/ONETOONES_DELETE_REQUIREMENTS.md) | 1 to 1 **削除不採用**の製品方針・`canceled` の業務定義・`exclude_canceled` 一覧既定・物理削除を見送る理由（SSOT）。 |
| [ONETOONES_CREATE_UX_REQUIREMENTS.md](SSOT/ONETOONES_CREATE_UX_REQUIREMENTS.md) | 1 to 1 **Create** UX：相手サマリ・予定開始＋所要時間・例会 Autocomplete。Create P1 実装済み（要件 SSOT）。 |
| [ONETOONES_EDIT_UI_FIT_AND_GAP.md](SSOT/ONETOONES_EDIT_UI_FIT_AND_GAP.md) | 1 to 1 **Edit** 画面を Create と比較した Fit/Gap。**ONETOONES_EDIT_UX_P2** で主要 Gap を解消（§8）。 |
| [ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md](SSOT/ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md) | 1 to 1 **一覧 Quick Create Dialog** の Fit/Gap。**ONETOONES_QUICK_CREATE_UX_P3** で Create と同一フォーム・同一 payload に統一。 |
| [ONETOONES_TARGET_PREFILL_FIT_AND_GAP.md](SSOT/ONETOONES_TARGET_PREFILL_FIT_AND_GAP.md) | 1 to 1 作成時の **`target_member_id` プリフィル**（URL クエリ）。**ONETOONES_DASHBOARD_TARGET_PREFILL_P4**（Create 検証・Tasks・Quick Create）。 |
| [DASHBOARD_REQUIREMENTS.md](SSOT/DASHBOARD_REQUIREMENTS.md) | ダッシュボード画面をモック（religo-admin-mock2.html）に合わせるための要件。構成・ブロック・データ・チェックリスト。 |
| [DASHBOARD_DATA_SSOT.md](SSOT/DASHBOARD_DATA_SSOT.md) | Dashboard のデータ定義 SSOT。stats/tasks/activity の定義・owner_member_id・件数上限・実装紐づけ・**§6 実数検証（SQL / `dashboard:verify-summary` / local の `/api/debug/dashboard-summary`）**。 |
| [DASHBOARD_TASK_SOURCE_ANALYSIS.md](SSOT/DASHBOARD_TASK_SOURCE_ANALYSIS.md) | 「今日やること（Tasks）」の取得元トレース（UI・API・DashboardService・DB・workspace 未適用・SSOT ギャップ）。 |
| [DASHBOARD_FIT_AND_GAP.md](SSOT/DASHBOARD_FIT_AND_GAP.md) | Dashboard のモック v2 構造分解・データ要件・現行実装との Fit & Gap・実装方針・次 Phase。 |
| [DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md](SSOT/DASHBOARD_WEEKLY_PRESENTATION_REQUIREMENTS.md) | **SPEC-004** — Dashboard に **ウィークリープレゼン（例:25秒）原稿**を表示する要件。Owner 紐づけ・UI 配置・データ案・DoD。 |
| [DASHBOARD_ONETOONE_LEADS_REQUIREMENTS.md](SSOT/DASHBOARD_ONETOONE_LEADS_REQUIREMENTS.md) | **SPEC-005** — Dashboard **次の1to1候補**の **カテゴリ表示**・API `category_label`・絞り込み・**guest/visitor を対象外**。 |
| [CONTACT_LOGIC_ALIGNMENT.md](SSOT/CONTACT_LOGIC_ALIGNMENT.md) | 接触ロジック整合（`last_contact_at`・999・1to1 completed のみ・改善 A/B/C）。 |
| [BO_AUDIT_LOG_DESIGN.md](SSOT/BO_AUDIT_LOG_DESIGN.md) | BO（breakout）割当保存の監査ログ設計・Dashboard `bo_assigned` のイベント源（BO-AUDIT-P1〜）。 |
| [USER_ME_AND_ACTOR_RESOLUTION.md](SSOT/USER_ME_AND_ACTOR_RESOLUTION.md) | `/api/users/me`・BO 監査 actor・**所属チャプター**（workspace）解決の SSOT（BO-AUDIT-P3〜P4・WORKSPACE-SINGLE-CHAPTER-ASSUMPTION）。 |
| [WORKSPACE_RESOLUTION_POLICY.md](SSOT/WORKSPACE_RESOLUTION_POLICY.md) | `workspace_id` 解決順（**所属** `default_workspace_id` → legacy 補完 → システムフォールバック）。BNI 1 user = 1 workspace 前提（BO-AUDIT-P4 / WORKSPACE-SINGLE-CHAPTER-ASSUMPTION）。 |
| [MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md](SSOT/MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md) | **`members.workspace_id`**（所属チャプター）の意味・backfill 順序・null。MEMBERS-WORKSPACE-BACKFILL-P1。 |
| [CONNECTIONS_REQUIREMENTS.md](SSOT/CONNECTIONS_REQUIREMENTS.md) | Connections 画面（会の地図）をモックに合わせるための要件。3 ペイン構成・Members/Meeting+BO/Relationship Log・チェックリスト。 |
| [CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md](SSOT/CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md) | Connections の BO 割当・Relationship Log 見出しで **メンバー名に加えカテゴリ表示**する要件・Fit/Gap（左ペインは既存 Fit）。 |
| [CONNECTIONS_INTELLIGENCE_SSOT.md](SSOT/CONNECTIONS_INTELLIGENCE_SSOT.md) | Connections 関係の知性（Relationship Summary / Next Action）の SSOT。表示項目・ルール・データソース・UI 配置。C-6。 |
| [RELATIONSHIP_SCORE_SSOT.md](SSOT/RELATIONSHIP_SCORE_SSOT.md) | Relationship Score（関係温度 0〜5・★表示）の SSOT。計算ルール・データソース・UI 配置。C-7。 |
| [INTRODUCTION_HINT_SSOT.md](SSOT/INTRODUCTION_HINT_SSOT.md) | Introduction Hint（紹介候補・業種→業種 最大3件）の SSOT。members summary_lite と C-7 スコア利用。C-8。 |
| [ROADMAP.md](SSOT/ROADMAP.md) | Religo 全体ロードマップ SSOT。Phase 順序・DoD・依存・スコープロック・テスト規約・Execution Playbook・Next 3。 |
| [MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md](SSOT/MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md) | Meetings 参加者PDF取込の要件整理たたき台。業務フロー A/B/C・画面・データ・Phase 案・リスク・推奨方針。実装前参照用。 |
| [MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md](SSOT/MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md) | Meetings 参加者CSV取込（ChatGPT作成CSV連携）の要件整理たたき台。業務フロー・画面・データ・CSV仕様・既存連携・フェーズ案。実装前参照用。 |
| [MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md](SSOT/MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md) | Meetings 参加者CSV反映の差分更新方式の要件整理。全置換 vs 差分更新・BO保護・判定キー・UI/UX・フェーズ案。実装前参照用。 |
| [MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md](SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md) | Meetings 参加者CSV反映の participants 差分更新 + members 更新 + Role History 連携の要件整理。反映対象3層・members項目分類・カテゴリー・役割履歴・フェーズ案。実装前参照用。 |

### プロダクト要件（docs/product/）

| ファイル | 説明 |
|----------|------|
| [DRAGONFLY_REQUIREMENTS.md](product/DRAGONFLY_REQUIREMENTS.md) | DragonFly 要件定義（目的・Phase・UX・技術構成・Cursor 向けルール）。 |

### 詳細資料（docs/process/）

Phase 別の詳細な PLAN / WORKLOG / REPORT を置く場合は docs/process/ を使用し、この一覧に追記する。**develop への取り込み後**は REPORT に「取り込み証跡」を記録する。DevOS v4.3: 次番号は [PHASE_REGISTRY.md](process/PHASE_REGISTRY.md)、仕様起点は [SSOT_REGISTRY.md](02_specifications/SSOT_REGISTRY.md)。

| ファイル | 説明 |
|----------|------|
| [README.md](process/README.md) | process/ の必須ルール（進捗・INDEX 更新）。 |
| [PROMPT_SSOT_IMPROVEMENT.md](process/PROMPT_SSOT_IMPROVEMENT.md) | **SSOT 改善用プロンプト**（実装ブレ防止・観点7・出力形式3部・任意のバグ想定オプション）。Cursor/人間レビュー兼用。 |
| [PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md](process/PROMPT_ADMIN_GLOBAL_OWNER_SSOT_IMPROVEMENT.md) | **ADMIN_GLOBAL_OWNER_SELECTION 専用**の改善プロンプト（未設定・初期ロード・dataProvider・禁止パターン・Phase 順・出力4部）。 |
| [PHASE_REGISTRY.md](process/PHASE_REGISTRY.md) | Phase 履歴（全 Phase 一覧）。次番号取得はここを参照。 |
| [FEATURE_BRANCH_MERGE_PLAN.md](process/FEATURE_BRANCH_MERGE_PLAN.md) | feature/* 棚卸しと develop 取り込み計画（merge は実行しない）。 |
| [PHASE12T_AND_M4_MERGE_VERIFICATION_REPORT.md](process/PHASE12T_AND_M4_MERGE_VERIFICATION_REPORT.md) | phase12t 取り込み可否および M4D〜M4L Git 実態の最終確認報告（merge/push 未実行）。 |
| [templates/PHASE_REPORT_TEMPLATE.md](process/templates/PHASE_REPORT_TEMPLATE.md) | Phase REPORT の証跡欄テンプレート（merge commit id・変更ファイル一覧・テスト結果等）。 |
| [templates/TEMPLATE_PHASE_PLAN.md](process/templates/TEMPLATE_PHASE_PLAN.md) | Phase PLAN テンプレート（DevOS v4.3）。 |
| [templates/TEMPLATE_PHASE_WORKLOG.md](process/templates/TEMPLATE_PHASE_WORKLOG.md) | Phase WORKLOG テンプレート（DevOS v4.3）。 |
| [templates/TEMPLATE_PHASE_REPORT.md](process/templates/TEMPLATE_PHASE_REPORT.md) | Phase REPORT テンプレート（DevOS v4.3・Merge Evidence 含む）。 |
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
| [phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_PLAN.md](process/phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_PLAN.md) | ONETOONES-P1: 1 to 1 一覧フィルタ＋行アクション PLAN。 |
| [phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_WORKLOG.md](process/phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_WORKLOG.md) | ONETOONES-P1: WORKLOG。 |
| [phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_REPORT.md](process/phases/PHASE_ONETOONES_LIST_FILTER_ACTIONS_REPORT.md) | ONETOONES-P1: REPORT。 |
| [phases/PHASE_ONETOONES_STATS_DISPLAY_PLAN.md](process/phases/PHASE_ONETOONES_STATS_DISPLAY_PLAN.md) | ONETOONES-P2: 統計カード＋表示品質 PLAN。 |
| [phases/PHASE_ONETOONES_STATS_DISPLAY_WORKLOG.md](process/phases/PHASE_ONETOONES_STATS_DISPLAY_WORKLOG.md) | ONETOONES-P2: WORKLOG。 |
| [phases/PHASE_ONETOONES_STATS_DISPLAY_REPORT.md](process/phases/PHASE_ONETOONES_STATS_DISPLAY_REPORT.md) | ONETOONES-P2: REPORT。 |
| [phases/PHASE_ONETOONES_CREATE_EDIT_UX_PLAN.md](process/phases/PHASE_ONETOONES_CREATE_EDIT_UX_PLAN.md) | ONETOONES-P3: Create/Edit UX PLAN。 |
| [phases/PHASE_ONETOONES_CREATE_EDIT_UX_WORKLOG.md](process/phases/PHASE_ONETOONES_CREATE_EDIT_UX_WORKLOG.md) | ONETOONES-P3: WORKLOG。 |
| [phases/PHASE_ONETOONES_CREATE_EDIT_UX_REPORT.md](process/phases/PHASE_ONETOONES_CREATE_EDIT_UX_REPORT.md) | ONETOONES-P3: REPORT。 |
| [phases/PHASE_ONETOONES_P4_STATS_FILTER_MEMO_PLAN.md](process/phases/PHASE_ONETOONES_P4_STATS_FILTER_MEMO_PLAN.md) | ONETOONES-P4: 統計フィルタ連動＋メモ本流 PLAN。 |
| [phases/PHASE_ONETOONES_P4_STATS_FILTER_MEMO_WORKLOG.md](process/phases/PHASE_ONETOONES_P4_STATS_FILTER_MEMO_WORKLOG.md) | ONETOONES-P4: WORKLOG。 |
| [phases/PHASE_ONETOONES_P4_STATS_FILTER_MEMO_REPORT.md](process/phases/PHASE_ONETOONES_P4_STATS_FILTER_MEMO_REPORT.md) | ONETOONES-P4: REPORT。 |
| [phases/PHASE_ONETOONES_DELETE_POLICY_P1_PLAN.md](process/phases/PHASE_ONETOONES_DELETE_POLICY_P1_PLAN.md) | ONETOONES-DELETE-POLICY-P1: 1 to 1 削除不採用 SSOT・`canceled` 正規運用・一覧 `exclude_canceled` PLAN。 |
| [phases/PHASE_ONETOONES_DELETE_POLICY_P1_WORKLOG.md](process/phases/PHASE_ONETOONES_DELETE_POLICY_P1_WORKLOG.md) | ONETOONES-DELETE-POLICY-P1: WORKLOG。 |
| [phases/PHASE_ONETOONES_DELETE_POLICY_P1_REPORT.md](process/phases/PHASE_ONETOONES_DELETE_POLICY_P1_REPORT.md) | ONETOONES-DELETE-POLICY-P1: REPORT（Merge Evidence）。 |
| [phases/PHASE_ONETOONES_EDIT_UX_P2_PLAN.md](process/phases/PHASE_ONETOONES_EDIT_UX_P2_PLAN.md) | ONETOONES_EDIT_UX_P2: Edit を Create UX に揃える PLAN（[ONETOONES_EDIT_UI_FIT_AND_GAP](SSOT/ONETOONES_EDIT_UI_FIT_AND_GAP.md) §8 と対応）。 |
| [phases/PHASE_ONETOONES_EDIT_UX_P2_WORKLOG.md](process/phases/PHASE_ONETOONES_EDIT_UX_P2_WORKLOG.md) | ONETOONES_EDIT_UX_P2: WORKLOG。 |
| [phases/PHASE_ONETOONES_EDIT_UX_P2_REPORT.md](process/phases/PHASE_ONETOONES_EDIT_UX_P2_REPORT.md) | ONETOONES_EDIT_UX_P2: REPORT（Merge Evidence）。 |
| [phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_PLAN.md](process/phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_PLAN.md) | ONETOONES_QUICK_CREATE_UX_P3: 一覧 Quick Create を Create/Edit に揃える PLAN（[ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP](SSOT/ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md)）。 |
| [phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_WORKLOG.md](process/phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_WORKLOG.md) | ONETOONES_QUICK_CREATE_UX_P3: WORKLOG。 |
| [phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_REPORT.md](process/phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_REPORT.md) | ONETOONES_QUICK_CREATE_UX_P3: REPORT（Merge Evidence）。 |
| [phases/PHASE_ONETOONES_DASHBOARD_TARGET_PREFILL_P4_PLAN.md](process/phases/PHASE_ONETOONES_DASHBOARD_TARGET_PREFILL_P4_PLAN.md) | ONETOONES_DASHBOARD_TARGET_PREFILL_P4: target プリフィル PLAN（[ONETOONES_TARGET_PREFILL_FIT_AND_GAP](SSOT/ONETOONES_TARGET_PREFILL_FIT_AND_GAP.md)）。 |
| [phases/PHASE_ONETOONES_DASHBOARD_TARGET_PREFILL_P4_WORKLOG.md](process/phases/PHASE_ONETOONES_DASHBOARD_TARGET_PREFILL_P4_WORKLOG.md) | ONETOONES_DASHBOARD_TARGET_PREFILL_P4: WORKLOG。 |
| [phases/PHASE_ONETOONES_DASHBOARD_TARGET_PREFILL_P4_REPORT.md](process/phases/PHASE_ONETOONES_DASHBOARD_TARGET_PREFILL_P4_REPORT.md) | ONETOONES_DASHBOARD_TARGET_PREFILL_P4: REPORT（Merge Evidence）。 |
| [phases/PHASE_ONETOONES_P5_LEADS_PLAN.md](process/phases/PHASE_ONETOONES_P5_LEADS_PLAN.md) | ONETOONES-P5: Members/Dashboard 導線・次の 1to1 PLAN。 |
| [phases/PHASE_ONETOONES_P5_LEADS_WORKLOG.md](process/phases/PHASE_ONETOONES_P5_LEADS_WORKLOG.md) | ONETOONES-P5: WORKLOG。 |
| [phases/PHASE_ONETOONES_P5_LEADS_REPORT.md](process/phases/PHASE_ONETOONES_P5_LEADS_REPORT.md) | ONETOONES-P5: REPORT。 |
| [phases/PHASE_DASHBOARD_P7_1_UI_PLAN.md](process/phases/PHASE_DASHBOARD_P7_1_UI_PLAN.md) | DASHBOARD-P7-1: Dashboard モック寄せ UI 再構成 PLAN。 |
| [phases/PHASE_DASHBOARD_P7_1_UI_WORKLOG.md](process/phases/PHASE_DASHBOARD_P7_1_UI_WORKLOG.md) | DASHBOARD-P7-1: WORKLOG。 |
| [phases/PHASE_DASHBOARD_P7_1_UI_REPORT.md](process/phases/PHASE_DASHBOARD_P7_1_UI_REPORT.md) | DASHBOARD-P7-1: REPORT。 |
| [phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_PLAN.md](process/phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_PLAN.md) | DASHBOARD-P7-2: Dashboard データ・導線 PLAN。 |
| [phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_WORKLOG.md](process/phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_WORKLOG.md) | DASHBOARD-P7-2: WORKLOG。 |
| [phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_REPORT.md](process/phases/PHASE_DASHBOARD_P7_2_DATA_ACTIONS_REPORT.md) | DASHBOARD-P7-2: REPORT。 |
| [phases/PHASE_DASHBOARD_P7_3_FINISHING_PLAN.md](process/phases/PHASE_DASHBOARD_P7_3_FINISHING_PLAN.md) | DASHBOARD-P7-3: Dashboard 仕上げ PLAN。 |
| [phases/PHASE_DASHBOARD_P7_3_FINISHING_WORKLOG.md](process/phases/PHASE_DASHBOARD_P7_3_FINISHING_WORKLOG.md) | DASHBOARD-P7-3: WORKLOG。 |
| [phases/PHASE_DASHBOARD_P7_3_FINISHING_REPORT.md](process/phases/PHASE_DASHBOARD_P7_3_FINISHING_REPORT.md) | DASHBOARD-P7-3: REPORT。 |
| [phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_PLAN.md](process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_PLAN.md) | DASHBOARD-TASKS-ALIGNMENT-P1: Dashboard 役割・Tasks 再定義 PLAN。 |
| [phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_WORKLOG.md](process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_WORKLOG.md) | DASHBOARD-TASKS-ALIGNMENT-P1: WORKLOG。 |
| [phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_REPORT.md](process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P1_REPORT.md) | DASHBOARD-TASKS-ALIGNMENT-P1: REPORT。 |
| [phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P2_PLAN.md](process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P2_PLAN.md) | DASHBOARD-TASKS-ALIGNMENT-P2: meeting_follow_up 突合 PLAN。 |
| [phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P2_WORKLOG.md](process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P2_WORKLOG.md) | DASHBOARD-TASKS-ALIGNMENT-P2: WORKLOG。 |
| [phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P2_REPORT.md](process/phases/PHASE_DASHBOARD_TASKS_ALIGNMENT_P2_REPORT.md) | DASHBOARD-TASKS-ALIGNMENT-P2: REPORT。 |
| [phases/PHASE_DASHBOARD_STALE_WORKSPACE_SCOPE_P1_PLAN.md](process/phases/PHASE_DASHBOARD_STALE_WORKSPACE_SCOPE_P1_PLAN.md) | DASHBOARD-STALE-WORKSPACE-SCOPE-P1: stale×workspace 設計 PLAN。 |
| [phases/PHASE_DASHBOARD_STALE_WORKSPACE_SCOPE_P1_WORKLOG.md](process/phases/PHASE_DASHBOARD_STALE_WORKSPACE_SCOPE_P1_WORKLOG.md) | DASHBOARD-STALE-WORKSPACE-SCOPE-P1: WORKLOG。 |
| [phases/PHASE_DASHBOARD_STALE_WORKSPACE_SCOPE_P1_REPORT.md](process/phases/PHASE_DASHBOARD_STALE_WORKSPACE_SCOPE_P1_REPORT.md) | DASHBOARD-STALE-WORKSPACE-SCOPE-P1: REPORT。 |
| [phases/PHASE_MEMBER_SUMMARY_WORKSPACE_NULL_P1_PLAN.md](process/phases/PHASE_MEMBER_SUMMARY_WORKSPACE_NULL_P1_PLAN.md) | MEMBER-SUMMARY-WORKSPACE-NULL-P1: MemberSummaryQuery workspace OR NULL PLAN。 |
| [phases/PHASE_MEMBER_SUMMARY_WORKSPACE_NULL_P1_WORKLOG.md](process/phases/PHASE_MEMBER_SUMMARY_WORKSPACE_NULL_P1_WORKLOG.md) | MEMBER-SUMMARY-WORKSPACE-NULL-P1: WORKLOG。 |
| [phases/PHASE_MEMBER_SUMMARY_WORKSPACE_NULL_P1_REPORT.md](process/phases/PHASE_MEMBER_SUMMARY_WORKSPACE_NULL_P1_REPORT.md) | MEMBER-SUMMARY-WORKSPACE-NULL-P1: REPORT。 |
| [phases/PHASE_DASHBOARD_STALE_WORKSPACE_P2_PLAN.md](process/phases/PHASE_DASHBOARD_STALE_WORKSPACE_P2_PLAN.md) | DASHBOARD-STALE-WORKSPACE-P2: stale peer / workspace 整理 PLAN。 |
| [phases/PHASE_DASHBOARD_STALE_WORKSPACE_P2_WORKLOG.md](process/phases/PHASE_DASHBOARD_STALE_WORKSPACE_P2_WORKLOG.md) | DASHBOARD-STALE-WORKSPACE-P2: WORKLOG。 |
| [phases/PHASE_DASHBOARD_STALE_WORKSPACE_P2_REPORT.md](process/phases/PHASE_DASHBOARD_STALE_WORKSPACE_P2_REPORT.md) | DASHBOARD-STALE-WORKSPACE-P2: REPORT。 |
| [phases/PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1_PLAN.md](process/phases/PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1_PLAN.md) | DASHBOARD-ONETOONES-SUMMARY-EXPANSION-P1: 1to1 KPI 総登録/予定/キャンセル補助表示 PLAN。 |
| [phases/PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1_WORKLOG.md](process/phases/PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1_WORKLOG.md) | DASHBOARD-ONETOONES-SUMMARY-EXPANSION-P1: WORKLOG。 |
| [phases/PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1_REPORT.md](process/phases/PHASE_DASHBOARD_ONETOONES_SUMMARY_EXPANSION_P1_REPORT.md) | DASHBOARD-ONETOONES-SUMMARY-EXPANSION-P1: REPORT（Merge Evidence）。 |
| [phases/PHASE_MEMBERS_WORKSPACE_BACKFILL_P1_PLAN.md](process/phases/PHASE_MEMBERS_WORKSPACE_BACKFILL_P1_PLAN.md) | MEMBERS-WORKSPACE-BACKFILL-P1: members.workspace_id PLAN。 |
| [phases/PHASE_MEMBERS_WORKSPACE_BACKFILL_P1_WORKLOG.md](process/phases/PHASE_MEMBERS_WORKSPACE_BACKFILL_P1_WORKLOG.md) | MEMBERS-WORKSPACE-BACKFILL-P1: WORKLOG。 |
| [phases/PHASE_MEMBERS_WORKSPACE_BACKFILL_P1_REPORT.md](process/phases/PHASE_MEMBERS_WORKSPACE_BACKFILL_P1_REPORT.md) | MEMBERS-WORKSPACE-BACKFILL-P1: REPORT。 |
| [phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_PLAN.md](process/phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_PLAN.md) | M8.6: members.ncast_profile_url SSOT反映 PLAN。 |
| [phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_WORKLOG.md](process/phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_WORKLOG.md) | M8.6: WORKLOG。 |
| [phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_REPORT.md](process/phases/PHASE_M8_6_MEMBERS_NCAST_PROFILE_URL_SSOT_SYNC_REPORT.md) | M8.6: REPORT。 |
| [phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_PLAN.md](process/phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_PLAN.md) | ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP: `/settings` 例外・1to1 owner フィルタ削除・§5.1 補足・死蔵 JS 削除 PLAN。 |
| [phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_WORKLOG.md](process/phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_WORKLOG.md) | ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP: WORKLOG。 |
| [phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_REPORT.md](process/phases/PHASE_ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP_REPORT.md) | ADMIN_GLOBAL_OWNER_SPEC003_FOLLOWUP: REPORT（Merge Evidence 記載）。 |
| [phases/PHASE_DASHBOARD_WEEKLY_P1_PLAN.md](process/phases/PHASE_DASHBOARD_WEEKLY_P1_PLAN.md) | **DASHBOARD-WEEKLY-P1:** Dashboard ウィークリープレゼン原稿（SPEC-004）最小実装 PLAN。 |
| [phases/PHASE_DASHBOARD_WEEKLY_P1_WORKLOG.md](process/phases/PHASE_DASHBOARD_WEEKLY_P1_WORKLOG.md) | DASHBOARD-WEEKLY-P1: WORKLOG。 |
| [phases/PHASE_DASHBOARD_WEEKLY_P1_REPORT.md](process/phases/PHASE_DASHBOARD_WEEKLY_P1_REPORT.md) | DASHBOARD-WEEKLY-P1: REPORT。 |
| [phases/PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_PLAN.md](process/phases/PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_PLAN.md) | AXIOS-SC-2026-03: axios サプライチェーン侵害 影響調査 PLAN。 |
| [phases/PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_WORKLOG.md](process/phases/PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_WORKLOG.md) | AXIOS-SC-2026-03: WORKLOG（コマンド・証拠）。 |
| [phases/PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_REPORT.md](process/phases/PHASE_AXIOS_SUPPLY_CHAIN_INVESTIGATION_REPORT.md) | AXIOS-SC-2026-03: REPORT（結論 SAFE・根拠）。 |
| [phases/PHASE_BO_AUDIT_P1_PLAN.md](process/phases/PHASE_BO_AUDIT_P1_PLAN.md) | BO-AUDIT-P1: BO 保存監査ログ設計・Dashboard `bo_assigned` PLAN。 |
| [phases/PHASE_BO_AUDIT_P1_WORKLOG.md](process/phases/PHASE_BO_AUDIT_P1_WORKLOG.md) | BO-AUDIT-P1: WORKLOG。 |
| [phases/PHASE_BO_AUDIT_P1_REPORT.md](process/phases/PHASE_BO_AUDIT_P1_REPORT.md) | BO-AUDIT-P1: REPORT。 |
| [phases/PHASE_BO_AUDIT_P2_PLAN.md](process/phases/PHASE_BO_AUDIT_P2_PLAN.md) | BO-AUDIT-P2: レガシー BO 監査・workspace・actor PLAN。 |
| [phases/PHASE_BO_AUDIT_P2_WORKLOG.md](process/phases/PHASE_BO_AUDIT_P2_WORKLOG.md) | BO-AUDIT-P2: WORKLOG。 |
| [phases/PHASE_BO_AUDIT_P2_REPORT.md](process/phases/PHASE_BO_AUDIT_P2_REPORT.md) | BO-AUDIT-P2: REPORT。 |
| [phases/PHASE_BO_AUDIT_P3_PLAN.md](process/phases/PHASE_BO_AUDIT_P3_PLAN.md) | BO-AUDIT-P3: users/me と BO actor 一本化・workspace PLAN。 |
| [phases/PHASE_BO_AUDIT_P3_WORKLOG.md](process/phases/PHASE_BO_AUDIT_P3_WORKLOG.md) | BO-AUDIT-P3: WORKLOG。 |
| [phases/PHASE_BO_AUDIT_P3_REPORT.md](process/phases/PHASE_BO_AUDIT_P3_REPORT.md) | BO-AUDIT-P3: REPORT。 |
| [phases/PHASE_BO_AUDIT_P4_PLAN.md](process/phases/PHASE_BO_AUDIT_P4_PLAN.md) | BO-AUDIT-P4: `default_workspace_id`・me/actor 整合・Dashboard workspace 表示方針 PLAN。 |
| [phases/PHASE_BO_AUDIT_P4_WORKLOG.md](process/phases/PHASE_BO_AUDIT_P4_WORKLOG.md) | BO-AUDIT-P4: WORKLOG。 |
| [phases/PHASE_BO_AUDIT_P4_REPORT.md](process/phases/PHASE_BO_AUDIT_P4_REPORT.md) | BO-AUDIT-P4: REPORT。 |
| [phases/PHASE_BO_AUDIT_P5_PLAN.md](process/phases/PHASE_BO_AUDIT_P5_PLAN.md) | BO-AUDIT-P5: 所属チャプター設定 UI・me 連携 PLAN。 |
| [phases/PHASE_BO_AUDIT_P5_WORKLOG.md](process/phases/PHASE_BO_AUDIT_P5_WORKLOG.md) | BO-AUDIT-P5: WORKLOG。 |
| [phases/PHASE_BO_AUDIT_P5_REPORT.md](process/phases/PHASE_BO_AUDIT_P5_REPORT.md) | BO-AUDIT-P5: REPORT。 |
| [phases/PHASE_CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT_PLAN.md](process/phases/PHASE_CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT_PLAN.md) | CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT: BO/Autocomplete/Relationship Log にカテゴリ副行 PLAN（[SSOT](SSOT/CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md)）。 |
| [phases/PHASE_CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT_WORKLOG.md](process/phases/PHASE_CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT_WORKLOG.md) | CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT: WORKLOG。 |
| [phases/PHASE_CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT_REPORT.md](process/phases/PHASE_CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT_REPORT.md) | CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT: REPORT。 |
| [phases/PHASE_CONTACT_LOGIC_ALIGNMENT_ANALYSIS_PLAN.md](process/phases/PHASE_CONTACT_LOGIC_ALIGNMENT_ANALYSIS_PLAN.md) | CONTACT_LOGIC_ALIGNMENT_ANALYSIS: SSOT 整理 PLAN。 |
| [phases/PHASE_CONTACT_LOGIC_ALIGNMENT_ANALYSIS_WORKLOG.md](process/phases/PHASE_CONTACT_LOGIC_ALIGNMENT_ANALYSIS_WORKLOG.md) | CONTACT_LOGIC_ALIGNMENT_ANALYSIS: WORKLOG。 |
| [phases/PHASE_CONTACT_LOGIC_ALIGNMENT_ANALYSIS_REPORT.md](process/phases/PHASE_CONTACT_LOGIC_ALIGNMENT_ANALYSIS_REPORT.md) | CONTACT_LOGIC_ALIGNMENT_ANALYSIS: REPORT。 |
| [phases/PHASE_CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT_PLAN.md](process/phases/PHASE_CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT_PLAN.md) | CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT: 999 表示・補助文 PLAN。 |
| [phases/PHASE_CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT_WORKLOG.md](process/phases/PHASE_CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT_WORKLOG.md) | CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT: WORKLOG。 |
| [phases/PHASE_CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT_REPORT.md](process/phases/PHASE_CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT_REPORT.md) | CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT: REPORT。 |
| [phases/PHASE_MEMBER_DISPLAY_HELPER_UNIFICATION_PLAN.md](process/phases/PHASE_MEMBER_DISPLAY_HELPER_UNIFICATION_PLAN.md) | MEMBER_DISPLAY_HELPER_UNIFICATION: `memberDisplay.js` 共通化 PLAN。 |
| [phases/PHASE_MEMBER_DISPLAY_HELPER_UNIFICATION_WORKLOG.md](process/phases/PHASE_MEMBER_DISPLAY_HELPER_UNIFICATION_WORKLOG.md) | MEMBER_DISPLAY_HELPER_UNIFICATION: WORKLOG。 |
| [phases/PHASE_MEMBER_DISPLAY_HELPER_UNIFICATION_REPORT.md](process/phases/PHASE_MEMBER_DISPLAY_HELPER_UNIFICATION_REPORT.md) | MEMBER_DISPLAY_HELPER_UNIFICATION: REPORT。 |
| [phases/PHASE_WORKSPACE_SINGLE_CHAPTER_ASSUMPTION_PLAN.md](process/phases/PHASE_WORKSPACE_SINGLE_CHAPTER_ASSUMPTION_PLAN.md) | WORKSPACE-SINGLE-CHAPTER-ASSUMPTION: BNI 前提 1 user=1 workspace SSOT 固定 PLAN。 |
| [phases/PHASE_WORKSPACE_SINGLE_CHAPTER_ASSUMPTION_WORKLOG.md](process/phases/PHASE_WORKSPACE_SINGLE_CHAPTER_ASSUMPTION_WORKLOG.md) | WORKSPACE-SINGLE-CHAPTER-ASSUMPTION: WORKLOG。 |
| [phases/PHASE_WORKSPACE_SINGLE_CHAPTER_ASSUMPTION_REPORT.md](process/phases/PHASE_WORKSPACE_SINGLE_CHAPTER_ASSUMPTION_REPORT.md) | WORKSPACE-SINGLE-CHAPTER-ASSUMPTION: REPORT。 |
| [process/ONETOONES_P1_P4_SUMMARY.md](process/ONETOONES_P1_P4_SUMMARY.md) | **ONETOONES P1〜P4 総括**（実運用到達・設計決定・Gap・優先順位）。 |
| [phases/PHASE12_RELIGO_BOARD_UX_REFRESH_PLAN.md](process/phases/PHASE12_RELIGO_BOARD_UX_REFRESH_PLAN.md) | Phase12 Religo: Board UX Refresh PLAN。 |
| [phases/PHASE12_RELIGO_BOARD_UX_REFRESH_WORKLOG.md](process/phases/PHASE12_RELIGO_BOARD_UX_REFRESH_WORKLOG.md) | Phase12 Religo: Board UX WORKLOG。 |
| [phases/PHASE12_RELIGO_BOARD_UX_REFRESH_REPORT.md](process/phases/PHASE12_RELIGO_BOARD_UX_REFRESH_REPORT.md) | Phase12 Religo: Board UX REPORT。 |
| [phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_PLAN.md](process/phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_PLAN.md) | Phase12S Religo: Board MUI 骨格・余白・階層 PLAN。 |
| [phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_WORKLOG.md](process/phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_WORKLOG.md) | Phase12S Religo: Board MUI Polish WORKLOG。 |
| [phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_REPORT.md](process/phases/PHASE12S_RELIGO_BOARD_MUI_POLISH_REPORT.md) | Phase12S Religo: Board MUI Polish REPORT。 |
| [phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_PLAN.md](process/phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_PLAN.md) | Phase12T Religo: Admin Theme SSOT + 適用 PLAN。 |
| [phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_WORKLOG.md](process/phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_WORKLOG.md) | Phase12T Religo: Admin Theme SSOT WORKLOG。 |
| [phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_REPORT.md](process/phases/PHASE12T_RELIGO_ADMIN_THEME_SSOT_REPORT.md) | Phase12T Religo: Admin Theme SSOT REPORT。 |
| [phases/PHASE_G1_PHASE12T_AND_M4_INTEGRATION_PLAN.md](process/phases/PHASE_G1_PHASE12T_AND_M4_INTEGRATION_PLAN.md) | Phase G1: phase12t と M4 UI suite の Git 整合 PLAN。 |
| [phases/PHASE_G1_PHASE12T_AND_M4_INTEGRATION_WORKLOG.md](process/phases/PHASE_G1_PHASE12T_AND_M4_INTEGRATION_WORKLOG.md) | Phase G1: Git 整合 WORKLOG。 |
| [phases/PHASE_G1_PHASE12T_AND_M4_INTEGRATION_REPORT.md](process/phases/PHASE_G1_PHASE12T_AND_M4_INTEGRATION_REPORT.md) | Phase G1: Git 整合 REPORT。 |
| [phases/PHASE_G2_SSOT_DOCS_ALIGNMENT_PLAN.md](process/phases/PHASE_G2_SSOT_DOCS_ALIGNMENT_PLAN.md) | Phase G2: SSOT / docs alignment after G1 PLAN。 |
| [phases/PHASE_G2_SSOT_DOCS_ALIGNMENT_WORKLOG.md](process/phases/PHASE_G2_SSOT_DOCS_ALIGNMENT_WORKLOG.md) | Phase G2: SSOT/docs alignment WORKLOG。 |
| [phases/PHASE_G2_SSOT_DOCS_ALIGNMENT_REPORT.md](process/phases/PHASE_G2_SSOT_DOCS_ALIGNMENT_REPORT.md) | Phase G2: SSOT/docs alignment REPORT。 |
| [phases/PHASE_G3_IMPLEMENTATION_RESIDUE_TRIAGE_PLAN.md](process/phases/PHASE_G3_IMPLEMENTATION_RESIDUE_TRIAGE_PLAN.md) | Phase G3: Implementation residue triage PLAN。 |
| [phases/PHASE_G3_IMPLEMENTATION_RESIDUE_TRIAGE_WORKLOG.md](process/phases/PHASE_G3_IMPLEMENTATION_RESIDUE_TRIAGE_WORKLOG.md) | Phase G3: Implementation residue triage WORKLOG。 |
| [phases/PHASE_G3_IMPLEMENTATION_RESIDUE_TRIAGE_REPORT.md](process/phases/PHASE_G3_IMPLEMENTATION_RESIDUE_TRIAGE_REPORT.md) | Phase G3: Implementation residue triage REPORT。 |
| [phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_PLAN.md](process/phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_PLAN.md) | Phase G4: CSV import implementation bundle PLAN。 |
| [phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_WORKLOG.md](process/phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_WORKLOG.md) | Phase G4: CSV import implementation bundle WORKLOG。 |
| [phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_REPORT.md](process/phases/PHASE_G4_CSV_IMPORT_IMPLEMENTATION_BUNDLE_REPORT.md) | Phase G4: CSV import implementation bundle REPORT。 |
| [phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_PLAN.md](process/phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_PLAN.md) | Phase G5: mock asset / reference file alignment PLAN。 |
| [phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_WORKLOG.md](process/phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_WORKLOG.md) | Phase G5: mock asset / reference file alignment WORKLOG。 |
| [phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_REPORT.md](process/phases/PHASE_G5_MOCK_ASSET_ALIGNMENT_REPORT.md) | Phase G5: mock asset / reference file alignment REPORT。 |
| [phases/PHASE_G6_CURSOR_TOOLING_POLICY_ALIGNMENT_PLAN.md](process/phases/PHASE_G6_CURSOR_TOOLING_POLICY_ALIGNMENT_PLAN.md) | Phase G6: .cursor tooling policy alignment PLAN。 |
| [phases/PHASE_G6_CURSOR_TOOLING_POLICY_ALIGNMENT_WORKLOG.md](process/phases/PHASE_G6_CURSOR_TOOLING_POLICY_ALIGNMENT_WORKLOG.md) | Phase G6: .cursor tooling policy alignment WORKLOG。 |
| [phases/PHASE_G6_CURSOR_TOOLING_POLICY_ALIGNMENT_REPORT.md](process/phases/PHASE_G6_CURSOR_TOOLING_POLICY_ALIGNMENT_REPORT.md) | Phase G6: .cursor tooling policy alignment REPORT。 |
| [phases/PHASE_G10_PHASE13_REMOVE_ROUND_REWORK_PLAN.md](process/phases/PHASE_G10_PHASE13_REMOVE_ROUND_REWORK_PLAN.md) | Phase G10: phase13 remove round rework PLAN。 |
| [phases/PHASE_G10_PHASE13_REMOVE_ROUND_REWORK_WORKLOG.md](process/phases/PHASE_G10_PHASE13_REMOVE_ROUND_REWORK_WORKLOG.md) | Phase G10: phase13 remove round rework WORKLOG。 |
| [phases/PHASE_G10_PHASE13_REMOVE_ROUND_REWORK_REPORT.md](process/phases/PHASE_G10_PHASE13_REMOVE_ROUND_REWORK_REPORT.md) | Phase G10: phase13 remove round rework REPORT。 |
| [phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_PLAN.md](process/phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_PLAN.md) | Phase G11: DragonFly breakout duplicate member support PLAN。 |
| [phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_WORKLOG.md](process/phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_WORKLOG.md) | Phase G11: DragonFly breakout duplicate member support WORKLOG。 |
| [phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_REPORT.md](process/phases/PHASE_G11_BREAKOUT_DUPLICATE_MEMBER_SUPPORT_REPORT.md) | Phase G11: DragonFly breakout duplicate member support REPORT。 |
| [phases/PHASE_G13_REPOSITORY_BRANCH_CLEANUP_FINAL_PLAN.md](process/phases/PHASE_G13_REPOSITORY_BRANCH_CLEANUP_FINAL_PLAN.md) | Phase G13: Repository Branch Cleanup Final PLAN。 |
| [phases/PHASE_G13_REPOSITORY_BRANCH_CLEANUP_FINAL_WORKLOG.md](process/phases/PHASE_G13_REPOSITORY_BRANCH_CLEANUP_FINAL_WORKLOG.md) | Phase G13: Repository Branch Cleanup Final WORKLOG。 |
| [phases/PHASE_G13_REPOSITORY_BRANCH_CLEANUP_FINAL_REPORT.md](process/phases/PHASE_G13_REPOSITORY_BRANCH_CLEANUP_FINAL_REPORT.md) | Phase G13: Repository Branch Cleanup Final REPORT。 |
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
| [phases/PHASE_M1_MEMBERS_GAP_PLAN.md](process/phases/PHASE_M1_MEMBERS_GAP_PLAN.md) | Phase M-1: Members Gap 解消（Docs）PLAN。 |
| [phases/PHASE_M1_MEMBERS_GAP_WORKLOG.md](process/phases/PHASE_M1_MEMBERS_GAP_WORKLOG.md) | Phase M-1: Members Gap WORKLOG。 |
| [phases/PHASE_M1_MEMBERS_GAP_REPORT.md](process/phases/PHASE_M1_MEMBERS_GAP_REPORT.md) | Phase M-1: Members Gap REPORT。 |
| [phases/PHASE_M2_MEMBERS_REQUIRED_COLUMNS_REPORT.md](process/phases/PHASE_M2_MEMBERS_REQUIRED_COLUMNS_REPORT.md) | Phase M-2: Members 必須列・サブタイトル REPORT。 |
| [phases/PHASE_M3_MEMBERS_FILTER_SORT_PLAN.md](process/phases/PHASE_M3_MEMBERS_FILTER_SORT_PLAN.md) | Phase M-3: Members 検索/フィルタ/ソート PLAN。 |
| [phases/PHASE_M3_MEMBERS_FILTER_SORT_WORKLOG.md](process/phases/PHASE_M3_MEMBERS_FILTER_SORT_WORKLOG.md) | Phase M-3: Members 検索/フィルタ/ソート WORKLOG。 |
| [phases/PHASE_M3_MEMBERS_FILTER_SORT_REPORT.md](process/phases/PHASE_M3_MEMBERS_FILTER_SORT_REPORT.md) | Phase M-3: Members 検索/フィルタ/ソート REPORT。 |
| [phases/PHASE_M4_MEMBERS_LAYOUT_PLAN.md](process/phases/PHASE_M4_MEMBERS_LAYOUT_PLAN.md) | Phase M-4: Members パッと見レイアウト（モック準拠）PLAN。統計カード・横並びフィルタバー・ブロック構成。 |
| [phases/PHASE_M4_MEMBERS_LAYOUT_WORKLOG.md](process/phases/PHASE_M4_MEMBERS_LAYOUT_WORKLOG.md) | Phase M-4: Members パッと見レイアウト WORKLOG。 |
| [phases/PHASE_M4_MEMBERS_LAYOUT_REPORT.md](process/phases/PHASE_M4_MEMBERS_LAYOUT_REPORT.md) | Phase M-4: Members パッと見レイアウト REPORT。 |
| [phases/PHASE_M4D_MEMBERS_LIST_CARD_PLAN.md](process/phases/PHASE_M4D_MEMBERS_LIST_CARD_PLAN.md) | Phase M4D: Members List/Card 表示切替 PLAN。 |
| [phases/PHASE_M4D_MEMBERS_LIST_CARD_WORKLOG.md](process/phases/PHASE_M4D_MEMBERS_LIST_CARD_WORKLOG.md) | Phase M4D: Members List/Card 表示切替 WORKLOG。 |
| [phases/PHASE_M4D_MEMBERS_LIST_CARD_REPORT.md](process/phases/PHASE_M4D_MEMBERS_LIST_CARD_REPORT.md) | Phase M4D: Members List/Card 表示切替 REPORT。 |
| [phases/PHASE_M4E_MEMBERS_CARD_LOGS_PLAN.md](process/phases/PHASE_M4E_MEMBERS_CARD_LOGS_PLAN.md) | Phase M4E: Members Card 関係ログ表示 PLAN。 |
| [phases/PHASE_M4E_MEMBERS_CARD_LOGS_WORKLOG.md](process/phases/PHASE_M4E_MEMBERS_CARD_LOGS_WORKLOG.md) | Phase M4E: Members Card 関係ログ表示 WORKLOG。 |
| [phases/PHASE_M4E_MEMBERS_CARD_LOGS_REPORT.md](process/phases/PHASE_M4E_MEMBERS_CARD_LOGS_REPORT.md) | Phase M4E: Members Card 関係ログ表示 REPORT。 |
| [phases/PHASE_M4F_MEMBERS_NAME_KANA_PLAN.md](process/phases/PHASE_M4F_MEMBERS_NAME_KANA_PLAN.md) | Phase M4F: Members 一覧かな表示 PLAN。 |
| [phases/PHASE_M4F_MEMBERS_NAME_KANA_WORKLOG.md](process/phases/PHASE_M4F_MEMBERS_NAME_KANA_WORKLOG.md) | Phase M4F: Members 一覧かな表示 WORKLOG。 |
| [phases/PHASE_M4F_MEMBERS_NAME_KANA_REPORT.md](process/phases/PHASE_M4F_MEMBERS_NAME_KANA_REPORT.md) | Phase M4F: Members 一覧かな表示 REPORT。 |
| [phases/PHASE_M4G_MEMBERS_GROUP_FILTER_PLAN.md](process/phases/PHASE_M4G_MEMBERS_GROUP_FILTER_PLAN.md) | Phase M4G: Members 大カテゴリ単独フィルタ追加 PLAN。 |
| [phases/PHASE_M4G_MEMBERS_GROUP_FILTER_WORKLOG.md](process/phases/PHASE_M4G_MEMBERS_GROUP_FILTER_WORKLOG.md) | Phase M4G: Members 大カテゴリ単独フィルタ追加 WORKLOG。 |
| [phases/PHASE_M4G_MEMBERS_GROUP_FILTER_REPORT.md](process/phases/PHASE_M4G_MEMBERS_GROUP_FILTER_REPORT.md) | Phase M4G: Members 大カテゴリ単独フィルタ追加 REPORT。 |
| [phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_PLAN.md](process/phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_PLAN.md) | Phase M4H: Members Card Relationship Score 表示 PLAN。 |
| [phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_WORKLOG.md](process/phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_WORKLOG.md) | Phase M4H: Members Card Relationship Score 表示 WORKLOG。 |
| [phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_REPORT.md](process/phases/PHASE_M4H_MEMBERS_CARD_RELATIONSHIP_SCORE_REPORT.md) | Phase M4H: Members Card Relationship Score 表示 REPORT。 |
| [phases/PHASE_M4I_MEMBERS_DEFAULT_CARD_PLAN.md](process/phases/PHASE_M4I_MEMBERS_DEFAULT_CARD_PLAN.md) | Phase M4I: Members デフォルト表示を Card に変更 PLAN。 |
| [phases/PHASE_M4I_MEMBERS_DEFAULT_CARD_WORKLOG.md](process/phases/PHASE_M4I_MEMBERS_DEFAULT_CARD_WORKLOG.md) | Phase M4I: Members デフォルト表示を Card に変更 WORKLOG。 |
| [phases/PHASE_M4I_MEMBERS_DEFAULT_CARD_REPORT.md](process/phases/PHASE_M4I_MEMBERS_DEFAULT_CARD_REPORT.md) | Phase M4I: Members デフォルト表示を Card に変更 REPORT。 |
| [phases/PHASE_M4J_MEMBERS_FILTERBAR_IMPROVEMENT_PLAN.md](process/phases/PHASE_M4J_MEMBERS_FILTERBAR_IMPROVEMENT_PLAN.md) | Phase M4J: Members FilterBar 改善 PLAN。 |
| [phases/PHASE_M4J_MEMBERS_FILTERBAR_IMPROVEMENT_WORKLOG.md](process/phases/PHASE_M4J_MEMBERS_FILTERBAR_IMPROVEMENT_WORKLOG.md) | Phase M4J: Members FilterBar 改善 WORKLOG。 |
| [phases/PHASE_M4J_MEMBERS_FILTERBAR_IMPROVEMENT_REPORT.md](process/phases/PHASE_M4J_MEMBERS_FILTERBAR_IMPROVEMENT_REPORT.md) | Phase M4J: Members FilterBar 改善 REPORT。 |
| [phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_PLAN.md](process/phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_PLAN.md) | Phase M4K: Members Card向け並び順の強化 PLAN。 |
| [phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_WORKLOG.md](process/phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_WORKLOG.md) | Phase M4K: Members Card向け並び順の強化 WORKLOG。 |
| [phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_REPORT.md](process/phases/PHASE_M4K_MEMBERS_CARD_SORT_IMPROVEMENT_REPORT.md) | Phase M4K: Members Card向け並び順の強化 REPORT。 |
| [phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_PLAN.md](process/phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_PLAN.md) | Phase M4L: Members から Connections への導線強化 PLAN。 |
| [phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_WORKLOG.md](process/phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_WORKLOG.md) | Phase M4L: Members から Connections への導線強化 WORKLOG。 |
| [phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_REPORT.md](process/phases/PHASE_M4L_MEMBERS_TO_CONNECTIONS_NAV_REPORT.md) | Phase M4L: Members から Connections への導線強化 REPORT。 |
| [phases/PHASE_MEETINGS_LIST_ENHANCEMENT_PLAN.md](process/phases/PHASE_MEETINGS_LIST_ENHANCEMENT_PLAN.md) | Phase M1: Meetings 一覧改善（API 拡張・サブ説明・BO数/メモ列）PLAN。 |
| [phases/PHASE_MEETINGS_LIST_ENHANCEMENT_WORKLOG.md](process/phases/PHASE_MEETINGS_LIST_ENHANCEMENT_WORKLOG.md) | Phase M1: Meetings 一覧改善 WORKLOG。 |
| [phases/PHASE_MEETINGS_LIST_ENHANCEMENT_REPORT.md](process/phases/PHASE_MEETINGS_LIST_ENHANCEMENT_REPORT.md) | Phase M1: Meetings 一覧改善 REPORT。 |
| [phases/PHASE_MEETINGS_ROW_ACTIONS_PLAN.md](process/phases/PHASE_MEETINGS_ROW_ACTIONS_PLAN.md) | Phase M2: Meetings 一覧行アクション（📝メモ・🗺BO編集）PLAN。 |
| [phases/PHASE_MEETINGS_ROW_ACTIONS_WORKLOG.md](process/phases/PHASE_MEETINGS_ROW_ACTIONS_WORKLOG.md) | Phase M2: Meetings 行アクション WORKLOG。 |
| [phases/PHASE_MEETINGS_ROW_ACTIONS_REPORT.md](process/phases/PHASE_MEETINGS_ROW_ACTIONS_REPORT.md) | Phase M2: Meetings 行アクション REPORT。 |
| [phases/PHASE_MEETINGS_DETAIL_DRAWER_PLAN.md](process/phases/PHASE_MEETINGS_DETAIL_DRAWER_PLAN.md) | Phase M3: Meetings 例会詳細 Drawer PLAN。 |
| [phases/PHASE_MEETINGS_DETAIL_DRAWER_WORKLOG.md](process/phases/PHASE_MEETINGS_DETAIL_DRAWER_WORKLOG.md) | Phase M3: Meetings 詳細 Drawer WORKLOG。 |
| [phases/PHASE_MEETINGS_DETAIL_DRAWER_REPORT.md](process/phases/PHASE_MEETINGS_DETAIL_DRAWER_REPORT.md) | Phase M3: Meetings 詳細 Drawer REPORT。 |
| [phases/PHASE_MEETINGS_MEMO_MODAL_PLAN.md](process/phases/PHASE_MEETINGS_MEMO_MODAL_PLAN.md) | Phase M4: Meetings 例会メモ編集モーダル PLAN。 |
| [phases/PHASE_MEETINGS_MEMO_MODAL_WORKLOG.md](process/phases/PHASE_MEETINGS_MEMO_MODAL_WORKLOG.md) | Phase M4: Meetings メモモーダル WORKLOG。 |
| [phases/PHASE_MEETINGS_MEMO_MODAL_REPORT.md](process/phases/PHASE_MEETINGS_MEMO_MODAL_REPORT.md) | Phase M4: Meetings メモモーダル REPORT。 |
| [phases/PHASE_MEETINGS_TOOLBAR_FILTERS_PLAN.md](process/phases/PHASE_MEETINGS_TOOLBAR_FILTERS_PLAN.md) | Phase M5: Meetings 一覧ツールバー・フィルタ PLAN。 |
| [phases/PHASE_MEETINGS_TOOLBAR_FILTERS_WORKLOG.md](process/phases/PHASE_MEETINGS_TOOLBAR_FILTERS_WORKLOG.md) | Phase M5: Meetings ツールバー・フィルタ WORKLOG。 |
| [phases/PHASE_MEETINGS_TOOLBAR_FILTERS_REPORT.md](process/phases/PHASE_MEETINGS_TOOLBAR_FILTERS_REPORT.md) | Phase M5: Meetings ツールバー・フィルタ REPORT。 |
| [phases/PHASE_MEETINGS_STATS_CARDS_PLAN.md](process/phases/PHASE_MEETINGS_STATS_CARDS_PLAN.md) | Phase M6: Meetings 統計カード PLAN。 |
| [phases/PHASE_MEETINGS_STATS_CARDS_WORKLOG.md](process/phases/PHASE_MEETINGS_STATS_CARDS_WORKLOG.md) | Phase M6: Meetings 統計カード WORKLOG。 |
| [phases/PHASE_MEETINGS_STATS_CARDS_REPORT.md](process/phases/PHASE_MEETINGS_STATS_CARDS_REPORT.md) | Phase M6: Meetings 統計カード REPORT。 |
| [phases/PHASE_MEETINGS_FIT_AND_GAP_FINAL_UPDATE_PLAN.md](process/phases/PHASE_MEETINGS_FIT_AND_GAP_FINAL_UPDATE_PLAN.md) | Meetings FIT&GAP Final Update PLAN。 |
| [phases/PHASE_MEETINGS_FIT_AND_GAP_FINAL_UPDATE_WORKLOG.md](process/phases/PHASE_MEETINGS_FIT_AND_GAP_FINAL_UPDATE_WORKLOG.md) | Meetings FIT&GAP Final Update WORKLOG。 |
| [phases/PHASE_MEETINGS_FIT_AND_GAP_FINAL_UPDATE_REPORT.md](process/phases/PHASE_MEETINGS_FIT_AND_GAP_FINAL_UPDATE_REPORT.md) | Meetings FIT&GAP Final Update REPORT。 |
| [phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_PLAN.md](process/phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_PLAN.md) | Meetings 例会マスタ作成 Fit & Gap 調査 PLAN（実装なし）。 |
| [phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_WORKLOG.md](process/phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_REPORT.md](process/phases/PHASE_MEETINGS_CREATE_FIT_AND_GAP_CHECK_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_CREATE_IMPLEMENT_PLAN.md](process/phases/PHASE_MEETINGS_CREATE_IMPLEMENT_PLAN.md) | Meetings 新規作成（POST / 一覧 Dialog）実装 PLAN。 |
| [phases/PHASE_MEETINGS_CREATE_IMPLEMENT_WORKLOG.md](process/phases/PHASE_MEETINGS_CREATE_IMPLEMENT_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_CREATE_IMPLEMENT_REPORT.md](process/phases/PHASE_MEETINGS_CREATE_IMPLEMENT_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_UPDATE_IMPLEMENT_PLAN.md](process/phases/PHASE_MEETINGS_UPDATE_IMPLEMENT_PLAN.md) | Meetings 更新（PATCH・一覧編集 Dialog）実装 PLAN。 |
| [phases/PHASE_MEETINGS_UPDATE_IMPLEMENT_WORKLOG.md](process/phases/PHASE_MEETINGS_UPDATE_IMPLEMENT_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_UPDATE_IMPLEMENT_REPORT.md](process/phases/PHASE_MEETINGS_UPDATE_IMPLEMENT_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_PLAN.md](process/phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_PLAN.md) | Meetings 削除 Fit & Gap / ポリシー整理 PLAN（docs のみ）。 |
| [phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_WORKLOG.md](process/phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_REPORT.md](process/phases/PHASE_MEETINGS_DELETE_FIT_AND_GAP_CHECK_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_PLAN.md) | Meetings 参加者PDF取込 要件整理 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_WORKLOG.md) | Meetings 参加者PDF取込 要件整理 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS_REPORT.md) | Meetings 参加者PDF取込 要件整理 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_PLAN.md) | Phase M7-P1: Meetings 参加者PDFアップロード PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_WORKLOG.md) | Phase M7-P1: 参加者PDFアップロード WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_REPORT.md) | Phase M7-P1: 参加者PDFアップロード REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_PLAN.md) | M7-P1 参加者PDF登録ダイアログ「ファイル選択が開かない」事象 調査 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_WORKLOG.md) | 同上 調査 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_INVESTIGATION_REPORT.md) | 同上 調査 REPORT（原因・最小修正方針・次アクション）。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_PLAN.md) | M7-P1 参加者PDF登録ダイアログ「ファイル選択が開かない」修正 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_WORKLOG.md) | 同上 修正 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UPLOAD_DIALOG_FIX_REPORT.md) | 同上 修正 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_PLAN.md) | M7-P1 一覧に参加者PDF有無表示 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_LIST_INDICATOR_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_SSOT_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_SSOT_PLAN.md) | M7-P1-SSOT: 参加者PDF列の仕様反映 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_SSOT_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_SSOT_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_SSOT_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_SSOT_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_PLAN.md) | M7-P1-FILTER: 参加者PDFあり/なしフィルタ PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_FILTER_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UX_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UX_PLAN.md) | M7-P1-UX: PDF状態の視認性改善 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UX_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UX_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UX_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_UX_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_PREP_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_PREP_PLAN.md) | M7-P2-PREP: PDF解析のための基盤準備 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_PREP_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_PREP_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_PREP_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_PREP_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_DESIGN_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_DESIGN_PLAN.md) | M7-P2-DESIGN: PDF解析・参加者抽出 設計 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_DESIGN_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_DESIGN_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_DESIGN_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_DESIGN_REPORT.md) | 同上 REPORT。 |
| [design/MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md](design/MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md) | Meetings 参加者PDF P2: PDF解析・参加者抽出 設計（実装なし）。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_PLAN.md) | M7-P2-IMPLEMENT-1: PDFテキスト抽出と解析結果保存 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_1_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_PLAN.md) | M7-P2-IMPLEMENT-2: PDF解析候補表示UI PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P2_IMPLEMENT_2_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_PLAN.md) | M7-P3-IMPLEMENT-1: 候補確認・修正UI PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_1_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_PLAN.md) | M7-P3-IMPLEMENT-2: 候補を participants に反映する確定フロー PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P3_IMPLEMENT_2_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_PLAN.md) | M7-P4: member 照合と反映前確認の強化 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P4_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_PLAN.md) | M7-P5: 手動マッチングUI PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P5_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_PLAN.md) | M7-P6: 反映履歴の記録 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P6_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_PLAN.md) | M7-P7: 内容ベースのページ判定（ignore / members / participants）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P7_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_PLAN.md) | M7-P8: participants / members 専用パーサ強化 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P8_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P9_INVESTIGATION_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P9_INVESTIGATION_REPORT.md) | M7-P9-INVESTIGATION: 解析結果クリア機能の調査 REPORT（実装なし）。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_PLAN.md) | M7-P10: 再解析導線の追加（UI中心）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_PDF_P10_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_PLAN.md) | M7-P11-REQUIREMENTS: ChatGPT作成CSVアップロード連携 要件整理 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_WORKLOG.md) | 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS_REPORT.md) | 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_PLAN.md) | M7-C2: 参加者CSVプレビュー PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_WORKLOG.md) | M7-C2: 参加者CSVプレビュー WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C2_REPORT.md) | M7-C2: 参加者CSVプレビュー REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C3_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C3_PLAN.md) | M7-C3: 参加者CSVを participants/members に反映 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C3_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C3_WORKLOG.md) | M7-C3: 参加者CSV反映 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C3_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_CSV_C3_REPORT.md) | M7-C3: 参加者CSV反映 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_PLAN.md) | M7-C4-REQUIREMENTS: participants 差分更新 要件整理 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_WORKLOG.md) | M7-C4-REQUIREMENTS: participants 差分更新 要件整理 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS_REPORT.md) | M7-C4-REQUIREMENTS: participants 差分更新 要件整理 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_PLAN.md) | M7-C4.5-REQUIREMENTS: participants 差分更新 + members 更新 + Role History 連携 要件整理 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_WORKLOG.md) | M7-C4.5-REQUIREMENTS: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS_REPORT.md) | M7-C4.5-REQUIREMENTS: 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_PLAN.md) | M7-M1: participants 差分更新（BO保護あり）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_WORKLOG.md) | M7-M1: participants 差分更新 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_M1_REPORT.md) | M7-M1: participants 差分更新 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_PLAN.md) | M7-M2: members 基本情報更新候補プレビュー PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_WORKLOG.md) | M7-M2: members 基本情報更新候補 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M2_REPORT.md) | M7-M2: members 基本情報更新候補 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_PLAN.md) | M7-M3: members 基本情報の確定反映 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_WORKLOG.md) | M7-M3: members 基本情報の確定反映 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_DIFF_M3_REPORT.md) | M7-M3: members 基本情報の確定反映 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_PLAN.md) | M7-M4: Role History 差分検知（role-diff-preview・表示のみ）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_WORKLOG.md) | M7-M4: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_DIFF_M4_REPORT.md) | M7-M4: 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_PLAN.md) | M7-M5（M5）: Role History の確定反映（role-apply）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_WORKLOG.md) | M7-M5: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_ROLE_APPLY_M5_REPORT.md) | M7-M5: 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_PLAN.md) | M7-M6（M6）: CSV反映監査ログ・Role基準日 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_WORKLOG.md) | M7-M6: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_AUDIT_AND_EFFECTIVE_DATE_M6_REPORT.md) | M7-M6: 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_PLAN.md) | D2: participants 差分プレビューUI（名前解決ベース）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_WORKLOG.md) | D2: 差分プレビューUI WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D2_REPORT.md) | D2: 差分プレビューUI REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_PLAN.md) | D3: 削除候補 + BO保護付き削除オプション PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_WORKLOG.md) | D3: 削除候補 + BO保護付き削除オプション WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_DIFF_UPDATE_D3_REPORT.md) | D3: 削除候補 + BO保護付き削除オプション REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_PLAN.md) | M7-M7: CSV 未解決データのガイド付き解決フロー PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_WORKLOG.md) | M7-M7: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_FLOW_M7_REPORT.md) | M7-M7: 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_PLAN.md) | M7-FINAL-CHECK: CSV 同期フロー最終確認（横断レビュー）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_WORKLOG.md) | M7-FINAL-CHECK: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_REPORT.md) | M7-FINAL-CHECK: 同上 REPORT（14 観点の結果）。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_PLAN.md) | M8: CSV 未解決向けあいまい一致候補（suggestions API・UI）PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_WORKLOG.md) | M8: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_SUGGESTION_M8_REPORT.md) | M8: 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_PLAN.md) | M8.5: CSV member 解決順（resolution→名前）の preview/apply 統一 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_WORKLOG.md) | M8.5: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_MEMBER_RESOLUTION_ORDER_M85_REPORT.md) | M8.5: 同上 REPORT。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_MANAGEMENT_M9_PLAN.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_MANAGEMENT_M9_PLAN.md) | M9: resolution 管理UI強化 + 同名member警告 PLAN。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_MANAGEMENT_M9_WORKLOG.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_MANAGEMENT_M9_WORKLOG.md) | M9: 同上 WORKLOG。 |
| [phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_MANAGEMENT_M9_REPORT.md](process/phases/PHASE_MEETINGS_PARTICIPANTS_RESOLUTION_MANAGEMENT_M9_REPORT.md) | M9: 同上 REPORT。 |
| [phases/PHASE_M5_MEMBERS_FLAG_EDIT_PLAN.md](process/phases/PHASE_M5_MEMBERS_FLAG_EDIT_PLAN.md) | Phase M-5: Members フラグ編集（Interested / Want 1on1）PLAN。 |
| [phases/PHASE_M5_MEMBERS_FLAG_EDIT_WORKLOG.md](process/phases/PHASE_M5_MEMBERS_FLAG_EDIT_WORKLOG.md) | Phase M-5: Members フラグ編集 WORKLOG。 |
| [phases/PHASE_M5_MEMBERS_FLAG_EDIT_REPORT.md](process/phases/PHASE_M5_MEMBERS_FLAG_EDIT_REPORT.md) | Phase M-5: Members フラグ編集 REPORT。 |
| [phases/PHASE_M6_MEMBER_SHOW_PLAN.md](process/phases/PHASE_M6_MEMBER_SHOW_PLAN.md) | Phase M-6: Member Show / Drawer 履歴強化 PLAN。 |
| [phases/PHASE_M6_MEMBER_SHOW_WORKLOG.md](process/phases/PHASE_M6_MEMBER_SHOW_WORKLOG.md) | Phase M-6: Member Show / Drawer 履歴強化 WORKLOG。 |
| [phases/PHASE_M6_MEMBER_SHOW_REPORT.md](process/phases/PHASE_M6_MEMBER_SHOW_REPORT.md) | Phase M-6: Member Show / Drawer 履歴強化 REPORT。 |
| [phases/PHASE_MEMBERS_CSV_IMPORT_200_PLAN.md](process/phases/PHASE_MEMBERS_CSV_IMPORT_200_PLAN.md) | Phase Members CSV Import 200: 第200回参加者CSV 汎用コマンド PLAN。 |
| [phases/PHASE_MEMBERS_CSV_IMPORT_200_WORKLOG.md](process/phases/PHASE_MEMBERS_CSV_IMPORT_200_WORKLOG.md) | Phase Members CSV Import 200 WORKLOG。 |
| [phases/PHASE_MEMBERS_CSV_IMPORT_200_REPORT.md](process/phases/PHASE_MEMBERS_CSV_IMPORT_200_REPORT.md) | Phase Members CSV Import 200 REPORT。 |
| [phases/PHASE_DASHBOARD_MOCK_ALIGN_PLAN.md](process/phases/PHASE_DASHBOARD_MOCK_ALIGN_PLAN.md) | Phase D: Dashboard モック一致 PLAN。 |
| [phases/PHASE_DASHBOARD_MOCK_ALIGN_WORKLOG.md](process/phases/PHASE_DASHBOARD_MOCK_ALIGN_WORKLOG.md) | Phase D: Dashboard モック一致 WORKLOG。 |
| [phases/PHASE_DASHBOARD_MOCK_ALIGN_REPORT.md](process/phases/PHASE_DASHBOARD_MOCK_ALIGN_REPORT.md) | Phase D: Dashboard モック一致 REPORT。 |
| [phases/PHASE_RELIGO_SIDEBAR_MOCK_ALIGN_PLAN.md](process/phases/PHASE_RELIGO_SIDEBAR_MOCK_ALIGN_PLAN.md) | Phase 1: Religo Sidebar モック準拠化 PLAN。 |
| [phases/PHASE_RELIGO_SIDEBAR_MOCK_ALIGN_WORKLOG.md](process/phases/PHASE_RELIGO_SIDEBAR_MOCK_ALIGN_WORKLOG.md) | Phase 1: Religo Sidebar モック準拠化 WORKLOG。 |
| [phases/PHASE_RELIGO_SIDEBAR_MOCK_ALIGN_REPORT.md](process/phases/PHASE_RELIGO_SIDEBAR_MOCK_ALIGN_REPORT.md) | Phase 1: Religo Sidebar モック準拠化 REPORT。 |
| [phases/PHASE_RELIGO_APPBAR_MOCK_ALIGN_PLAN.md](process/phases/PHASE_RELIGO_APPBAR_MOCK_ALIGN_PLAN.md) | Phase 2: Religo AppBar モック準拠化 PLAN。 |
| [phases/PHASE_RELIGO_APPBAR_MOCK_ALIGN_WORKLOG.md](process/phases/PHASE_RELIGO_APPBAR_MOCK_ALIGN_WORKLOG.md) | Phase 2: Religo AppBar モック準拠化 WORKLOG。 |
| [phases/PHASE_RELIGO_APPBAR_MOCK_ALIGN_REPORT.md](process/phases/PHASE_RELIGO_APPBAR_MOCK_ALIGN_REPORT.md) | Phase 2: Religo AppBar モック準拠化 REPORT。 |
| [phases/PHASE_E1_DASHBOARD_API_WORKLOG.md](process/phases/PHASE_E1_DASHBOARD_API_WORKLOG.md) | Phase E-1: Dashboard API 動的化 WORKLOG。 |
| [phases/PHASE_E1_DASHBOARD_API_REPORT.md](process/phases/PHASE_E1_DASHBOARD_API_REPORT.md) | Phase E-1: Dashboard API 動的化 REPORT。 |
| [phases/PHASE_E4_OWNER_SETTINGS_PLAN.md](process/phases/PHASE_E4_OWNER_SETTINGS_PLAN.md) | Phase E-4: Owner 設定（永続化）PLAN。 |
| [phases/PHASE_E4_OWNER_SETTINGS_WORKLOG.md](process/phases/PHASE_E4_OWNER_SETTINGS_WORKLOG.md) | Phase E-4: Owner 設定 WORKLOG。 |
| [phases/PHASE_E4_OWNER_SETTINGS_REPORT.md](process/phases/PHASE_E4_OWNER_SETTINGS_REPORT.md) | Phase E-4: Owner 設定 REPORT。 |
| [phases/PHASE_C1_CONNECTIONS_LAYOUT_REPORT.md](process/phases/PHASE_C1_CONNECTIONS_LAYOUT_REPORT.md) | Phase C-1: Connections レイアウト REPORT。 |
| [phases/PHASE_C2_CONNECTIONS_MEMBERS_REPORT.md](process/phases/PHASE_C2_CONNECTIONS_MEMBERS_REPORT.md) | Phase C-2: Connections Members ペイン REPORT。 |
| [phases/PHASE_C3_CONNECTIONS_MEETING_BO_REPORT.md](process/phases/PHASE_C3_CONNECTIONS_MEETING_BO_REPORT.md) | Phase C-3: Connections Meeting + BO REPORT。 |
| [phases/PHASE_C4_CONNECTIONS_RELATIONSHIP_LOG_REPORT.md](process/phases/PHASE_C4_CONNECTIONS_RELATIONSHIP_LOG_REPORT.md) | Phase C-4: Connections Relationship Log REPORT。 |
| [phases/PHASE_C6_CONNECTIONS_INTELLIGENCE_PLAN.md](process/phases/PHASE_C6_CONNECTIONS_INTELLIGENCE_PLAN.md) | Phase C-6: Connections Intelligence（Relationship Summary / Next Action）PLAN。 |
| [phases/PHASE_C6_CONNECTIONS_INTELLIGENCE_WORKLOG.md](process/phases/PHASE_C6_CONNECTIONS_INTELLIGENCE_WORKLOG.md) | Phase C-6: Connections Intelligence WORKLOG。 |
| [phases/PHASE_C6_CONNECTIONS_INTELLIGENCE_REPORT.md](process/phases/PHASE_C6_CONNECTIONS_INTELLIGENCE_REPORT.md) | Phase C-6: Connections Intelligence REPORT。 |
| [phases/PHASE_C7_RELATIONSHIP_SCORE_PLAN.md](process/phases/PHASE_C7_RELATIONSHIP_SCORE_PLAN.md) | Phase C-7: Relationship Score PLAN。 |
| [phases/PHASE_C7_RELATIONSHIP_SCORE_WORKLOG.md](process/phases/PHASE_C7_RELATIONSHIP_SCORE_WORKLOG.md) | Phase C-7: Relationship Score WORKLOG。 |
| [phases/PHASE_C7_RELATIONSHIP_SCORE_REPORT.md](process/phases/PHASE_C7_RELATIONSHIP_SCORE_REPORT.md) | Phase C-7: Relationship Score REPORT。 |
| [phases/PHASE_C8_INTRODUCTION_HINT_PLAN.md](process/phases/PHASE_C8_INTRODUCTION_HINT_PLAN.md) | Phase C-8: Introduction Hint PLAN。 |
| [phases/PHASE_C8_INTRODUCTION_HINT_WORKLOG.md](process/phases/PHASE_C8_INTRODUCTION_HINT_WORKLOG.md) | Phase C-8: Introduction Hint WORKLOG。 |
| [phases/PHASE_C8_INTRODUCTION_HINT_REPORT.md](process/phases/PHASE_C8_INTRODUCTION_HINT_REPORT.md) | Phase C-8: Introduction Hint REPORT。 |

### BNI 活動戦略（docs/strategy/networking/）

|| ファイル | 説明 |
||----------|------|
|| [BNI_DragonFly_Guest_Strategy_202603.md](strategy/networking/BNI_DragonFly_Guest_Strategy_202603.md) | BNI DragonFly ゲスト招待戦略（2026/03）。 |
|| [BNI_DragonFly_Joining_Speeches_202603.md](strategy/networking/BNI_DragonFly_Joining_Speeches_202603.md) | BNI 入会スピーチ集（25秒プレゼン・朝礼・例会・選んだ理由・tugilo思想）。2026/03 入会時確定版。 |
|| [BNI_Tsugihiro_Atsushi_Intro_Living_Document.md](strategy/networking/BNI_Tsugihiro_Atsushi_Intro_Living_Document.md) | **次廣淳（tugilo）常設:** BO自己紹介・25秒WP・朝礼/例会・キーワード・変更ログ。ブラッシュアップの単一参照先。 |

### BNI DragonFly（docs/networking/bni/dragonfly/）

| ファイル | 説明 |
|----------|------|
| [REQUIREMENTS_MEMBER_PARTICIPANTS.md](networking/bni/dragonfly/REQUIREMENTS_MEMBER_PARTICIPANTS.md) | メンバーマスター・参加者・ブレイクアウトメモの要件定義。 |
| [REQUIREMENTS_MEMBERS_CSV_200.md](networking/bni/dragonfly/REQUIREMENTS_MEMBERS_CSV_200.md) | 第200回メンバー表 CSV（dragonfly_59people.csv）の要件整理。関連 SSOT・実装・種別対応・DoD 案。 |
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
