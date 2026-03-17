# dragonfly プロジェクト進捗

本プロジェクトの Phase ・作業内容をここに記録する。

---

## 進捗一覧

| 日付 | Phase / 内容 |
|------|----------------|
| 2026-03-17 | **develop へ push**: M7-P1〜P6 参加者PDF機能一式をステージング・push 済み。 |
| 2026-03-17 | **Phase M7-P6 反映履歴の記録**: meeting_participant_imports に imported_at / applied_count 追加。apply 成功時に履歴更新。show で返却。Drawer に「未反映」／「日時 に N件反映」表示。PLAN/WORKLOG/REPORT、INDEX・PHASE_REGISTRY・dragonfly_progress 更新。 |
| 2026-03-17 | **Phase M7-P5 手動マッチングUI**: 候補ごとに既存 member を手動選択・解除可能に。PUT candidates で matched_member_id / match_source 保存。GET /api/members/search 追加。Drawer 編集モードに照合列・「member を選択」Dialog。apply で matched_member_id 優先。PLAN/WORKLOG/REPORT、INDEX・PHASE_REGISTRY・dragonfly_progress 更新。 |
| 2026-03-17 | **Phase M7-P4 member 照合と反映前確認の強化**: GET meeting show の participant_import に match_status / matched_member_id / matched_member_name と matched_count / new_count / total_count を追加。CandidateMemberMatchService で名前完全一致照合。Drawer に照合列・集計表示・確認ダイアログ強化。PLAN/WORKLOG/REPORT、INDEX・PHASE_REGISTRY・dragonfly_progress 更新。 |
| 2026-03-17 | **Phase M7-P3-IMPLEMENT-2 候補を participants に反映する確定フロー**: POST .../participants/import/apply を追加。ApplyParticipantCandidatesService で全置換・type_hint 変換・member 検索/新規作成。Drawer に「participants に反映」ボタンと確認ダイアログ。PLAN/WORKLOG/REPORT、INDEX・PHASE_REGISTRY・dragonfly_progress 更新。 |
| 2026-03-17 | **Phase M7-P3-IMPLEMENT-1 候補確認・修正UI**: PUT .../participants/import/candidates で候補を更新。Drawer に「候補を編集」・編集モード（名前/種別/削除・候補追加・保存/キャンセル）を追加。meta 保持・空 name 除外。participants には未反映。PLAN/WORKLOG/REPORT、INDEX・PHASE_REGISTRY・dragonfly_progress 更新。 |
| 2026-03-17 | **Phase M7-P2-IMPLEMENT-2 PDF解析候補表示UI**: show API の participant_import に candidates 追加。Drawer で解析待ち・解析失敗・解析成功時の候補一覧（名前・種別推定・抽出元行）を MUI Table で表示。candidate_count と表示件数を整合。PLAN/WORKLOG/REPORT、INDEX・PHASE_REGISTRY・dragonfly_progress 更新。 |
| 2026-03-17 | **Phase M7-P2-IMPLEMENT-1 PDFテキスト抽出と解析結果保存**: meeting_participant_imports に extracted_text/extracted_result 追加。smalot/pdfparser で PDF テキスト抽出、PdfParticipantParseService で候補生成。POST .../participants/import/parse、show に candidate_count。Drawer に「PDF解析」ボタン・候補 N件表示。participants には未反映。PLAN/WORKLOG/REPORT、INDEX・PHASE_REGISTRY・dragonfly_progress 更新。 |
| 2026-03-17 | **Phase M7-P2-DESIGN PDF解析・参加者抽出（設計のみ）**: docs/design/MEETINGS_PARTICIPANTS_PDF_P2_DESIGN.md を新規作成。処理フロー・データ設計・API 案・名前抽出方針・技術選定・画面・リスクを記載。実装は行わない。PLAN/WORKLOG/REPORT、INDEX・PHASE_REGISTRY・dragonfly_progress 更新。 |
| 2026-03-17 | **Phase M7-P2-PREP PDF解析のための基盤準備**: meeting_participant_imports に parsed_at（nullable）, parse_status（pending/success/failed）を追加。Model に定数・casts、show API に parse_status/parsed_at を追加。テスト期待値更新。PLAN/WORKLOG/REPORT、INDEX・PHASE_REGISTRY・dragonfly_progress 更新。 |
| 2026-03-17 | **Phase M7-P1-UX PDF状態の視認性改善**: 参加者PDF列の「あり」Chip に PictureAsPdfIcon を追加。「なし」は従来どおり。PLAN/WORKLOG/REPORT、INDEX・PHASE_REGISTRY・dragonfly_progress 更新。 |
| 2026-03-17 | **Phase M7-P1-FILTER 参加者PDFあり/なしフィルタ**: GET /api/meetings に has_participant_pdf クエリを追加。一覧ツールバーに「参加者PDF」Select（すべて/PDFあり/PDFなし）を追加。dataProvider で filter をクエリに反映。test_index_filters_by_has_participant_pdf 追加。PLAN/WORKLOG/REPORT、INDEX・PHASE_REGISTRY・dragonfly_progress 更新。 |
| 2026-03-17 | **Phase M7-P1-SSOT 参加者PDF列の仕様反映**: FIT_AND_GAP_MEETINGS.md に参加者PDF列の一覧表示仕様を追記。§2.1/2.2 に一覧・API・詳細の記載、§2.3 で参加者PDF列・データ仕様を明記、§3 に M10b、§4 の Fit に参加者PDFを追加。PLAN/WORKLOG/REPORT、INDEX・PHASE_REGISTRY・dragonfly_progress 更新。 |
| 2026-03-17 | **Phase M7-P1-LIST Meetings 一覧に参加者PDF有無表示**: GET /api/meetings に has_participant_pdf 追加、MeetingsList の Datagrid に「参加者PDF」列（Chip あり/なし）を追加。列順は番号・開催日・BO数・メモ・参加者PDF・Actions。PLAN/WORKLOG/REPORT 作成、INDEX・PHASE_REGISTRY 更新。 |
| 2026-03-17 | **Phase M7-P1 Meetings 参加者PDFアップロード**: 例会参加者PDFを Meeting に紐づけて保存・参照・ダウンロード可能に。meeting_participant_imports テーブル新規、MeetingParticipantImportController（show/store/download）、MeetingController@show に participant_import 追加、MeetingsList Drawer に「参加者PDF」ブロックと登録モーダル。1 Meeting = 1 PDF、participants には一切触れない。PLAN/WORKLOG/REPORT 作成、PHASE_REGISTRY・INDEX 更新。 |
| 2026-03-17 | **Phase M7 Meetings 参加者PDF取込 要件整理**: 要件たたき台（MEETINGS_PARTICIPANTS_PDF_REQUIREMENTS.md）と業務フロー A/B/C・画面・データ・Phase 案 P1〜P5・リスクを整理。PLAN/WORKLOG/REPORT 作成。 |
| 2026-03-10 | **tugilo AI DevOS v4.3 セットアップ**: .cursor/rules/devos-v4.mdc 作成（alwaysApply: true）、docs/02_specifications/SSOT_REGISTRY.md、docs/process/PHASE_REGISTRY.md、docs/git/BRANCH_STRATEGY.md、docs/process/templates/TEMPLATE_PHASE_PLAN.md・WORKLOG・REPORT、docs/01_architecture/・03_operations/ README、INDEX に DevOS 関連を追加。 |
| 2026-03-04 | **PRレス運用整備**: docs/git/PRLESS_MERGE_FLOW.md 新規、.cursorrules に取り込み手順・禁止事項追記、GIT_WORKFLOW.md をローカル merge 前提に更新、docs/process/templates/PHASE_REPORT_TEMPLATE.md（証跡欄）追加、INDEX に git/ と templates を追加。feature ブランチ 3 本（phase1-summary-api, derived-metrics-ssot, workspace-migration-policy）はリモート・ローカルとも削除済み。 |
| 2026-03-04 | **Phase06 Religo**: DragonFlyBoard からメモ追加 UI を実装。メモ追加ボタン→モーダル（memo_type/body/meeting_id/one_to_one_id）、POST 成功後に members 再 fetch で summary_lite 更新。feature/phase06-board-add-memo-v1 を develop に merge。 |
| 2026-03-04 | **Phase07 Religo**: DragonFlyBoard から 1 to 1 登録 UI を実装。1 to 1 登録ボタン→モーダル（workspace_id/status/日時/notes）、POST 成功後に members 再 fetch で summary_lite 更新。feature/phase07-board-add-1to1-v1 を develop に merge。 |
| 2026-03-04 | **Phase08 Religo**: 1 to 1 登録の workspace_id を手入力から自動取得に変更。GET /api/workspaces 追加、DragonFlyBoard で先頭 1 件を採用。取得失敗時はガイド表示＋保存無効。feature/phase08-auto-workspace-id-v1 を develop に merge。 |
| 2026-03-04 | **Phase09 Religo**: Workspace 初期化（WorkspaceSeeder 冪等）と GET /api/workspaces の Feature テスト 1 本を追加。運用で workspace が最低 1 件ある状態を保証。feature/phase09-workspace-seed-and-test-v1 を develop に merge。 |
| 2026-03-04 | **Phase10 Religo**: Meeting Breakout Room Builder。BO1/BO2 のメンバー割当・ルームメモ（breakout_rooms.notes）・メンバーへの meeting メモ導線を追加。GET/PUT /api/meetings, /api/meetings/{id}/breakouts。feature/phase10-breakout-room-builder-v1 を develop に merge。 |
| 2026-03-04 | **Phase10R Religo**: Breakout Round 可変。Meeting ごとに Round を複数管理可能に拡張。breakout_rounds テーブル新規・breakout_rooms.breakout_round_id 追加・バックフィル。GET/PUT /api/meetings/{id}/breakout-rounds、DragonFlyBoard「BO (Round)」セクション追加。Phase10 の BO1/BO2 固定 API/UI は互換のため維持。 |
| 2026-03-04 | **Phase11A Religo**: 管理画面メニュー整理（IA）。ReactAdmin カスタム Menu で Board → Members → 区切り → Meetings → 区切り → 1 to 1 の順に整理。1 to 1 は Meeting と独立であることを UI で明示。members/meetings/one-to-ones はプレースホルダー導線を追加。 |
| 2026-03-04 | **Phase11B Religo**: 1 to 1 独立一覧。GET /api/one-to-ones（フィルタ・並び順）、ReactAdmin Resource one-to-ones の List/Create。meeting_id は任意。OneToOneIndexTest 追加。 |
| 2026-03-04 | **Phase12 Religo**: Board UX Refresh。固定 BO セクション撤去、Round UI のみに統一。Meeting Autocomplete + 状態 Chip、Round タブ + Chip 割当 + メモ Dialog（文脈表示）、保存 1 ボタン。 |
| 2026-03-04 | **Phase12S Religo**: Board MUI Polish。Container/Grid/Card/Stack/Divider で骨格を整え、CardHeader・CardActions・Chip・LoadingButton で階層と状態を表現。機能は変更せず見た目・余白・導線のみ改善。 |
| 2026-03-04 | **Phase12T Religo**: Admin Theme SSOT + 適用。Theme を religoTheme.js に集約し全ページに適用。Typography/shape/spacing/components override と CssBaseline で統一感を担保。Board は微調整のみ。 |
| 2026-03-05 | **Phase12R Religo**: 全体ロードマップ SSOT 確定。docs/SSOT/ROADMAP.md で Phase 順序・DoD・依存・スコープロック・テスト規約・Execution Playbook・Next 3 を固定。4 レーン（UI/IA, データ整合, 機能拡張, 運用品質）の Phase 表を確定。 |
| 2026-03-05 | **Phase12U Religo**: Board 3ペイン IA。左：メンバー選択、中：Meeting 選択＋Round 編集、右：関係ログ（クイックアクション・要点・紹介 Coming soon）。getMeetings 追加。既存 Round 保存・メモ・1to1 導線維持。 |
| 2026-03-05 | **Phase12V Religo**: Members / Meetings の List 実装（placeholder 卒業）。dataProvider に members.getList / meetings.getList 追加。MembersList.jsx / MeetingsList.jsx で実データ Datagrid 表示、TopToolbar に「Board へ戻る」追加。 |
| 2026-03-05 | **Phase12W Religo**: Board ショートカット導線。右ペイン「メモを書く」で Meeting 未選択時に Snackbar で誘導。紹介ボタンに Tooltip（Phase14A で追加予定）。1to1 の「Meeting と独立」キャプション維持。 |
| 2026-03-05 | **Phase16A Religo**: Members 要件 SSOT 確定。docs/SSOT/MEMBERS_REQUIREMENTS.md で List/Show/Edit・表示項目・操作・メモ・1to1・役職履歴・権限・非目標・DoD を固定。実装は次 Phase。 |
| 2026-03-05 | **Phase16B Religo**: 管理画面 UI モック同期。religo-admin-mock.html を SSOT にメニュー・全ページ・モーダルを統一。Dashboard / Connections / Members / Meetings / 1 to 1 / Role History / Settings(Categories,Roles)。Members にメモ・1to1・1to1メモの 3 モーダル追加。 |
| 2026-03-05 | **Phase16C Religo**: Admin UI Mock→Working。Settings（Categories/Roles）を実 API で CRUD。Role History を GET /api/member-roles に接続。Members 一覧にカテゴリ・役職・最終接触・詳細（Member Show）・1to1メモ紐付け。CategoryApiTest/RoleApiTest 追加。 |
| 2026-03-05 | **Phase17A Religo**: Members 詳細 Drawer。GET /api/contact-memos 追加（owner/target 必須、limit 任意）。one-to-ones index に limit 対応。MembersList で「詳細」クリックで右側 Drawer（Overview / Memos / 1to1 タブ）、メモ・1to1 追加で refetch。 |
| 2026-03-05 | **Phase17B Religo**: Meetings 詳細 Drawer。GET /api/meeting-memos 追加（owner_member_id, meeting_id 必須、limit 任意）。MeetingsList で「詳細」クリックで右側 Drawer（Overview / Breakouts / Memos タブ）、例会メモ追加で refetch。Connections で編集導線維持。 |
| 2026-03-05 | **Connections UX 改善**: BO 表示を BO1/BO2/BO3… に統一（DB の A/B/C は表示のみ変換）。割当メンバーを縦一列リスト化・行クリックでメンバー詳細モーダル（氏名・カテゴリ・関係ログに表示・例会メモ）。各 BO カードに「BO○ を保存」ボタン、「割当をクリア」追加。1to1 登録を日付 1 つ＋開始時刻＋終了時刻の 3 フィールドに簡素化。BO データ一括クリアは `php artisan religo:clear-breakout-data`。.cursorrules に React 修正後のビルド必須を追記。 |
| 2026-03-06 | **Phase C-6 Connections Intelligence**: 右ペインに 🧠 Relationship Summary（同室回数・直近同室・1to1・直近メモ）と 💡 次の一手（ルールベース提案・最大3件）を追加。既存 summary / one-to-ones のみ使用・新 API なし。CONNECTIONS_INTELLIGENCE_SSOT 追加。 |
| 2026-03-06 | **Phase C-7 Relationship Score**: 右ペインに Relationship Score（関係温度 ★☆☆☆☆〜★★★★★）を追加。ContactSummary から UI 計算のみ。RELATIONSHIP_SCORE_SSOT 追加。 |
| 2026-03-06 | **Phase C-8 Introduction Hint**: 右ペインに 💡 Introduction Hint（紹介候補、業種（名前）→ 業種（名前）最大3件）を追加。members の summary_lite と C-7 スコアを利用・新 API なし。INTRODUCTION_HINT_SSOT 追加。 |
| 2026-03-06 | **Phase M-4 Members パッと見レイアウト**: モック準拠のブロック順（ヘッダー→統計カード→常時表示フィルタバー→一覧）を実装。統計4種（総メンバー数・1to1未実施30日・interested ON・want_1on1 ON）をクライアント集計で表示。フィルタバーを横並びで常時表示（検索・カテゴリ・役職・フラグ・並び順・件数）。一覧は Datagrid 維持。PHASE_M4_* PLAN/WORKLOG/REPORT、FIT_AND_GAP Members 節更新。 |
| 2026-03-06 | **Phase M-5 Members フラグ編集**: Members 一覧から interested / want_1on1 を編集可能に。行アクション「🚩 フラグ」で Dialog（Switch×2＋保存）。既存 PUT /api/dragonfly/flags/{id} を流用（Connections と同じ）。更新後は useRefresh で一覧再取得。PHASE_M5_* PLAN/WORKLOG/REPORT、FIT_AND_GAP Members 節更新。 |
| 2026-03-06 | **Phase M-6 Member Show / Drawer 履歴強化**: Drawer の Overview に直近メモを追加。Member Show を Overview / Memos / 1to1 タブで履歴表示に変更（contacts summary・contact-memos・one-to-ones を既存 API で取得）。「Coming soon」除去。Drawer と Show の情報構造を揃えた。PHASE_M6_* PLAN/WORKLOG/REPORT、FIT_AND_GAP Members 節更新。 |

---

## main 反映（リリース証跡）

| 日付 | main HEAD (merge commit) | 取り込んだ Phase | テスト結果 |
|------|-------------------------|------------------|------------|
| 2026-03-04 | `cc22f08f79a367e937b9d15f2f8c0095ca0fec6f` | Phase04〜08（一覧 summary、メモ/1to1 API、Board メモ追加、Board 1to1 登録、workspace_id 自動取得） | 13 passed (58 assertions) |
| 2026-03-05 | `3278e8cd74bbb8e7bf5968861732d644d85387a4` | Phase12U / Phase12V / Phase12W（Board 3ペインIA / Members+Meetings List / Boardショートカット導線） | 27 passed (125 assertions) |
| 2026-03-05 | `73e7525e878a489fb80e3e698a7d61a39ae7358f` | 証跡の main 反映（docs: record release to main (Religo)） | 27 passed (125 assertions) |

- **develop HEAD（反映時点）:** `fff8e16`（証跡追記前）
- **手順:** develop を main に no-ff merge → テスト実行 → push main → 本証跡を develop に追記して push。
