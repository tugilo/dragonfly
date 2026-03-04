# PHASE07 Religo DragonFlyBoard から 1 to 1 登録 — REPORT

**Phase:** DragonFlyBoard 1 to 1 登録 UI  
**完了日:** 2026-03-04

---

## 実施内容

- DragonFlyBoard 右ペインに「1 to 1 登録」ボタンを追加。クリックでモーダルを表示。
- モーダル: workspace_id（必須・初期値 1）、status（予定/実施済み/キャンセル）、予定日時・開始日時・終了日時（datetime-local）、meeting_id（任意）、メモ。
- POST /api/one-to-ones で送信。成功後 members 再取得（with_summary=1）と summary 再取得で summary_lite（one_to_one_count, last_one_to_one, last_contact_at）を更新。
- canceled 登録時は count は増えるが last_* は変化しない（SSOT 規約どおり）。

## 変更ファイル一覧（git diff --name-only）

```
docs/INDEX.md
docs/dragonfly_progress.md
docs/process/phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_PLAN.md
docs/process/phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_WORKLOG.md
docs/process/phases/PHASE07_RELIGO_BOARD_ADD_ONE_TO_ONE_REPORT.md
www/resources/js/admin/pages/DragonFlyBoard.jsx
```

## テスト結果

- API は既存 Phase05 の RelationshipLogCreateTest で担保。本 Phase では UI のみ追加のため自動テストは追加しない。
- 手動確認: planned 登録で one_to_one_count 更新、canceled 登録で last_* 変化なしを確認。

## DoD チェック

- [x] DragonFlyBoard に「1 to 1 登録」UI（ボタン＋モーダル）を追加
- [x] workspace_id（必須）・status・scheduled_at/started_at/ended_at・notes・meeting_id の入力と POST 実装
- [x] POST 成功後に members 再 fetch（with_summary=1）で summary_lite を更新
- [x] WORKLOG に手動確認結果を記載
- [x] PLAN / WORKLOG / REPORT 作成済み

## 実行した git コマンド（コピペ用）

```bash
git checkout develop
git pull origin develop
git checkout -b feature/phase07-board-add-1to1-v1
# 実装・ドキュメント
git add -A
git commit -m "feat: add 1to1 create UI on DragonFlyBoard"
git push -u origin feature/phase07-board-add-1to1-v1
# develop へ merge（--no-ff）
git checkout develop
git pull origin develop
git merge --no-ff feature/phase07-board-add-1to1-v1 -m "Merge feature/phase07-board-add-1to1-v1 into develop"
# テスト実行後
git push origin develop
```

## 取り込み証跡（develop への merge 後）

| 項目 | 内容 |
|------|------|
| **merge commit id** | （merge 後に記入） |
| **merge 元ブランチ名** | feature/phase07-board-add-1to1-v1 |
| **変更ファイル一覧** | 上記参照 |
| **テスト結果** | php artisan test — 既存テスト green |
| **手動確認** | planned 登録で one_to_one_count 更新。canceled 登録で last_* 変化なし。 |
