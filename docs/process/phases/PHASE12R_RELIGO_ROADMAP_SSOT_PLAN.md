# PHASE12R Religo 全体ロードマップ SSOT — PLAN

**Phase:** Religo の全体ロードマップ（SSOT）を docs に固定し、Phase 設計・実装順序がブレない状態を作る  
**作成日:** 2026-03-05  
**SSOT:** 本 PLAN、[docs/SSOT/ROADMAP.md](../../SSOT/ROADMAP.md)

---

## 1. 目的

- Religo の開発を**迷いなく継続できる全体ロードマップ（SSOT）**を docs に固定する。
- 今後の Phase 設計と実装順序がブレないように、順番・DoD・依存・スコープロック・テスト規約を一枚にまとめる。
- **コード変更は行わない。docs のみ。**

## 2. スコープ

- **変更対象:** docs のみ（www/ および infra/ は触らない）。
- **新規作成:** docs/SSOT/ROADMAP.md、docs/process/phases/PHASE12R_RELIGO_ROADMAP_SSOT_PLAN.md / WORKLOG.md / REPORT.md。
- **更新:** docs/INDEX.md（SSOT セクションに ROADMAP.md 追加）、docs/dragonfly_progress.md（ロードマップ SSOT 確定を記録）。

## 3. 変更ファイル一覧

| 種別 | パス |
|------|------|
| 新規 | docs/SSOT/ROADMAP.md |
| 新規 | docs/process/phases/PHASE12R_RELIGO_ROADMAP_SSOT_PLAN.md |
| 新規 | docs/process/phases/PHASE12R_RELIGO_ROADMAP_SSOT_WORKLOG.md |
| 新規 | docs/process/phases/PHASE12R_RELIGO_ROADMAP_SSOT_REPORT.md |
| 更新 | docs/INDEX.md |
| 更新 | docs/dragonfly_progress.md |

## 4. DoD

- [ ] docs/SSOT/ROADMAP.md が指定章立て（Purpose, Scope Lock, 現在地, Target UX, Roadmap, Execution Playbook, Next 3）で存在する
- [ ] Roadmap 表が Phase ID・目的・成果物・依存・DoD・テスト・スコープ外の列を持ち、4 レーン（A/B/C/D）で矛盾していない
- [ ] 既存 SSOT（DATA_MODEL, ADMIN_UI_THEME 等）と矛盾していない
- [ ] docs/INDEX.md の SSOT セクションに ROADMAP.md が追加されている
- [ ] docs/dragonfly_progress.md に「ロードマップ SSOT 確定」が記録されている
- [ ] PLAN / WORKLOG / REPORT が tugilo 式で作成されている

## 5. リスク

- なし（docs のみのため）。既存 SSOT を参照して矛盾のない記述にすること。

## 6. ロールバック

- docs のみのため、git revert で変更を戻せばよい。merge 後であれば `git revert -m 1 <merge_commit_id>` で merge 打ち消し可能。

## 7. Git

- ブランチ: `feature/phase12r-roadmap-ssot-v1`
- コミット: 1 コミット
- コミットメッセージ: `docs: establish Religo roadmap SSOT`
- 取り込み: `git merge --no-ff feature/phase12r-roadmap-ssot-v1 -m "Merge feature/phase12r-roadmap-ssot-v1 into develop"` のあと、テスト実行して push。
