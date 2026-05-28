# PHASE14 Religo DragonFly Member Model Refactor — REPORT

**Phase:** PHASE14 Member Model Refactor  
**完了日:** 2026-03-05

---

## 実施内容（完了時点）

- Step1: categories テーブル新規、members に category_id 追加、既存 category を categories に移行し category カラム削除。
- Step2: roles / member_roles テーブル新規、既存 role_notes を roles + member_roles に移行し role_notes 削除。Member に currentRole() 等追加。
- Step3: Member API レスポンスを category オブジェクト・current_role に変更。GET/PUT /api/dragonfly/members/{id}, GET /api/categories, GET /api/roles 追加。
- Step4: Members 一覧にカテゴリー・役職表示。Member 編集画面（カテゴリー/役職 select）追加。
- Step5: 全テスト通過、docs 更新。

## 変更ファイル一覧（develop との diff）

REPORT 取り込み後に `git diff --name-only develop^1...develop` で確定し、ここに貼る。

## テスト結果

```
docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test
Tests: 27 passed (125 assertions)
```

## DoD チェック

- [x] category 正規化完了
- [x] role 履歴管理導入
- [x] Member 一覧表示正常
- [x] DragonFlyBoard 動作確認（attendees / roommates API は category 文字列・role_notes 互換で返却）
- [x] docs 更新（PLAN / WORKLOG / REPORT, dragonfly_progress, INDEX）

---

## 取り込み証跡（develop への merge 後）

| 項目 | 内容 |
|------|------|
| **merge commit id** | （merge 後に `git log -1 --format=%H develop` で取得して記入） |
| **merge 元ブランチ名** | `feature/phase14-1-category-normalization` |
| **変更ファイル一覧** | 上記「変更ファイル一覧」参照 |
| **テスト結果** | 27 passed (125 assertions) |
| **手動確認** | Member 一覧・編集、Board 表示確認推奨 |
