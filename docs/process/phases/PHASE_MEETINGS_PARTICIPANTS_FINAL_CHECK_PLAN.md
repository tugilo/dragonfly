# Phase M7-FINAL-CHECK: CSV 同期フロー最終確認 PLAN

| 項目 | 内容 |
|------|------|
| Phase ID | **M7-FINAL-CHECK** |
| 種別 | **docs**（コード変更・新規実装なし。確認結果の文書化のみ） |
| 関連 SSOT | [MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_CSV_REQUIREMENTS.md), [MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_DIFF_UPDATE_REQUIREMENTS.md), [MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md](../../SSOT/MEETINGS_PARTICIPANTS_MEMBER_ROLE_REQUIREMENTS.md) |

## 背景

M7 系で CSV アップロードから participants / members / Role History 反映、監査ログ、unresolved 解消まで段階実装済み。リリース前に **実装・API・UI・DB・テスト・ドキュメントの横断整合** を確認し、保守可能な状態かを判断する。

## 目的

- 業務フロー（読み取り・保存・更新・再取得）をコードで追跡し、矛盾がないか確認する。
- **resolution 優先**・**No 列**・**BO 保護**・**members / roles の境界**・**監査ログ**・**UI 再取得**を観点化する。
- 不整合・テストの穴・ドキュメントずれを列挙し、**実務投入判断**の材料にする。

## 調査対象

- **サービス**: `MeetingCsvPreviewService`, `MeetingCsvDiffPreviewService`, `MeetingCsvMemberDiffPreviewService`, `MeetingCsvRoleDiffPreviewService`, `ApplyMeetingCsvImportService`, `ApplyMeetingCsvMemberDiffService`, `ApplyMeetingCsvRoleDiffService`, `MeetingCsvApplyLogWriter`, `MeetingCsvUnresolvedSummaryService`
- **HTTP / モデル**: `MeetingCsvImportController`, `MeetingCsvImport`, `MeetingCsvImportResolution`, `MeetingCsvApplyLog`, `MeetingController@show`
- **UI**: `MeetingsList.jsx`（CSV ブロック・Drawer・再取得）
- **DB**: `meeting_csv_import_resolutions`, `meeting_csv_apply_logs` のマイグレーション
- **テスト**: `MeetingCsvImportControllerTest` 等
- **ドキュメント**: PHASE_REGISTRY, INDEX, dragonfly_progress, SSOT 実装メモ, 各 M7 REPORT

## 整理観点

1. 全体フロー（11 ステップ）
2. resolution 優先順序（member / category / role × preview / apply）
3. No 列は表示用のみ
4. participants / BO 保護
5. members 更新範囲
6. Role History（current 判定、effective_date、unchanged、自動作成なし）
7. 監査ログ（成功時のみ、422 でログなし）
8. unresolved / resolution（訂正・削除導線の有無）
9. UI 再取得タイミング
10. DB 制約・リレーション
11. テストの薄い箇所
12. ドキュメント整合

## 成果物

- 本 PLAN
- [PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_WORKLOG.md](./PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_WORKLOG.md)
- [PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_REPORT.md](./PHASE_MEETINGS_PARTICIPANTS_FINAL_CHECK_REPORT.md)（**14 セクションの最終チェック結果の本体**）

## DoD

- [x] 上記観点をコードベースで確認し、REPORT に **整合 / 不整合** を明記した
- [x] **プレビューと apply の member 解決順**の差異など、運用上のリスクを明示した
- [x] テストの穴・リリース前推奨事項を列挙した
- [x] PHASE_REGISTRY / INDEX / dragonfly_progress を更新した
- [x] 新規実装・仕様変更は行わない（本 Phase は docs のみ）

## Merge Evidence

- docs のみの Phase のため **merge は任意**。取り込み時は REPORT に取り込みコミットを追記してよい。
