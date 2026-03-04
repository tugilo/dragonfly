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
| 2026-03-04 | **Phase09 Religo**: Workspace 初期化（WorkspaceSeeder 冪等）と GET /api/workspaces の Feature テスト 1 本を追加。運用で workspace が最低 1 件ある状態を保証。feature/phase09-workspace-seed-and-test-v1 を develop に merge。 |
| 2026-03-04 | **Phase10 Religo**: Meeting Breakout Room Builder。BO1/BO2 のメンバー割当・ルームメモ（breakout_rooms.notes）・メンバーへの meeting メモ導線を追加。GET/PUT /api/meetings, /api/meetings/{id}/breakouts。feature/phase10-breakout-room-builder-v1 を develop に merge。 |
| 2026-03-04 | **Phase10R Religo**: Breakout Round 可変。Meeting ごとに Round を複数管理可能に拡張。breakout_rounds テーブル新規・breakout_rooms.breakout_round_id 追加・バックフィル。GET/PUT /api/meetings/{id}/breakout-rounds、DragonFlyBoard「BO (Round)」セクション追加。Phase10 の BO1/BO2 固定 API/UI は互換のため維持。 |
| 2026-03-04 | **Phase11A Religo**: 管理画面メニュー整理（IA）。ReactAdmin カスタム Menu で Board → Members → 区切り → Meetings → 区切り → 1 to 1 の順に整理。1 to 1 は Meeting と独立であることを UI で明示。members/meetings/one-to-ones はプレースホルダー導線を追加。 |
| 2026-03-04 | **Phase11B Religo**: 1 to 1 独立一覧。GET /api/one-to-ones（フィルタ・並び順）、ReactAdmin Resource one-to-ones の List/Create。meeting_id は任意。OneToOneIndexTest 追加。 |

---

## main 反映（リリース証跡）

| 日付 | main HEAD (merge commit) | 取り込んだ Phase | テスト結果 |
|------|-------------------------|------------------|------------|
| 2026-03-04 | `cc22f08f79a367e937b9d15f2f8c0095ca0fec6f` | Phase04〜08（一覧 summary、メモ/1to1 API、Board メモ追加、Board 1to1 登録、workspace_id 自動取得） | 13 passed (58 assertions) |

- **develop HEAD（反映時点）:** `2b404aeb4346dd9132b4b9b28fefda5e790a6aa3`
- **手順:** develop を main に no-ff merge → テスト実行 → push main → 本証跡を develop に追記して push。
