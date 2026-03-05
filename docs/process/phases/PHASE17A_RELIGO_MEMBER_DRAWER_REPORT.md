# PHASE17A Religo Member Detail Drawer — REPORT

**Phase:** Phase17A  
**完了日:** （完了時に入力）

---

## 実施内容

- GET /api/contact-memos を追加（owner_member_id, target_member_id 必須、limit 任意 default 20）。
- GET /api/one-to-ones に limit パラメータ対応を追加。
- Member Drawer（MUI Drawer anchor=right）を実装。MembersList の「詳細」クリックで開く。
- Drawer 内に Tabs: Overview（基本情報・カテゴリ・役職・summary_lite・メモ追加/1to1予定ボタン）、Memos（直近メモ一覧+メモ追加）、1to1（直近 1to1 一覧+1to1予定）。追加成功後に refetch でリスト更新。
- ContactMemosIndexTest 追加。OneToOneIndexTest に limit テスト追加。

## 変更ファイル一覧（feature ブランチ）

- docs/process/phases/PHASE17A_RELIGO_MEMBER_DRAWER_PLAN.md
- docs/process/phases/PHASE17A_RELIGO_MEMBER_DRAWER_WORKLOG.md
- docs/process/phases/PHASE17A_RELIGO_MEMBER_DRAWER_REPORT.md
- docs/INDEX.md
- docs/dragonfly_progress.md
- www/app/Http/Requests/Religo/IndexContactMemosRequest.php（新規）
- www/app/Http/Controllers/Religo/ContactMemoController.php（index 追加）
- www/routes/api.php（GET /api/contact-memos 追加）
- www/app/Http/Requests/Religo/IndexOneToOnesRequest.php（limit 追加）
- www/app/Services/Religo/OneToOneIndexService.php（limit 適用）
- www/tests/Feature/Religo/ContactMemosIndexTest.php（新規）
- www/tests/Feature/Religo/OneToOneIndexTest.php（test_limit_applied 追加）
- www/resources/js/admin/pages/MembersList.jsx（MemberDetailDrawer、詳細→Drawer、refetch 連携）

## テスト結果

- `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` — 50 passed (209 assertions)

## DoD チェック

- [x] Members 一覧から Drawer が開く
- [x] Tabs (Overview / Memos / 1to1) が表示される
- [x] Memos / 1to1 が履歴表示できる
- [x] 追加ができ、成功後に履歴が更新される（refetch）
- [x] php artisan test が green

---

## 取り込み証跡（develop への merge 後）

| 項目 | 内容 |
|------|------|
| **merge commit id** | （merge 後に記入） |
| **merge 元ブランチ名** | feature/phase17a-member-drawer |
| **変更ファイル一覧** | （merge 後に記入） |
| **テスト結果** | （記入） |
| **手動確認** | （記入） |
