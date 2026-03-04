# dragonfly プロジェクト進捗

本プロジェクトの Phase ・作業内容をここに記録する。

---

## 進捗一覧

| 日付 | Phase / 内容 |
|------|----------------|
| 2026-03-04 | **PRレス運用整備**: docs/git/PRLESS_MERGE_FLOW.md 新規、.cursorrules に取り込み手順・禁止事項追記、GIT_WORKFLOW.md をローカル merge 前提に更新、docs/process/templates/PHASE_REPORT_TEMPLATE.md（証跡欄）追加、INDEX に git/ と templates を追加。feature ブランチ 3 本（phase1-summary-api, derived-metrics-ssot, workspace-migration-policy）はリモート・ローカルとも削除済み。 |
| 2026-03-04 | **Phase06 Religo**: DragonFlyBoard からメモ追加 UI を実装。メモ追加ボタン→モーダル（memo_type/body/meeting_id/one_to_one_id）、POST 成功後に members 再 fetch で summary_lite 更新。feature/phase06-board-add-memo-v1 を develop に merge。 |
| 2026-03-04 | **Phase07 Religo**: DragonFlyBoard から 1 to 1 登録 UI を実装。1 to 1 登録ボタン→モーダル（workspace_id/status/日時/notes）、POST 成功後に members 再 fetch で summary_lite 更新。feature/phase07-board-add-1to1-v1 を develop に merge。 |
| 2026-03-04 | **Phase08 Religo**: 1 to 1 登録の workspace_id を手入力から自動取得に変更。GET /api/workspaces 追加、DragonFlyBoard で先頭 1 件を採用。取得失敗時はガイド表示＋保存無効。feature/phase08-auto-workspace-id-v1 を develop に merge。 |

---

（Phase や日付ごとに追記する）
