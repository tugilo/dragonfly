# PHASE11A Religo 管理画面メニュー整理（IA）— REPORT

**Phase:** メニュー IA 整理  
**完了日:** 2026-03-04

---

## 実施内容

- React Admin のカスタム Menu を導入。順序: Board（会の地図）→ Members → 区切り → Meetings → 区切り → 1 to 1（予定・履歴）。
- 区切りは MUI ListDivider で表現し、「1 to 1 は Meeting と独立」であることが分かる構成にした。
- Resource: members, meetings, one-to-ones を追加（list はプレースホルダー）。既存 Board（ダッシュボード）への導線は維持。

## 変更ファイル一覧

- `www/resources/js/admin/ReligoMenu.jsx`（新規）
- `www/resources/js/admin/ReligoLayout.jsx`（新規）
- `www/resources/js/admin/pages/MembersPlaceholder.jsx`（新規）
- `www/resources/js/admin/pages/MeetingsPlaceholder.jsx`（新規）
- `www/resources/js/admin/pages/OneToOnesPlaceholder.jsx`（新規）
- `www/resources/js/admin/app.jsx`（Layout・Resource 追加）
- `docs/process/phases/PHASE11A_RELIGO_ADMIN_MENU_IA_PLAN.md`（新規）
- `docs/process/phases/PHASE11A_RELIGO_ADMIN_MENU_IA_WORKLOG.md`（新規）
- `docs/process/phases/PHASE11A_RELIGO_ADMIN_MENU_IA_REPORT.md`（新規）
- `docs/INDEX.md`（Phase11A ドキュメント追加）
- `docs/dragonfly_progress.md`（Phase11A 進捗追加）

## テスト結果

（merge 後に記載）

## DoD

- [x] メニューが上記の意図通り並ぶ
- [x] 既存画面への導線が壊れていない
- [x] docs 更新
- [ ] 1 コミット push → develop へ --no-ff merge → push
- [ ] REPORT に merge commit id を記録

## 取り込み証跡

| 項目 | 内容 |
|------|------|
| **merge commit id** | （merge 後に記入） |
| **テスト結果** | （passed 数） |
