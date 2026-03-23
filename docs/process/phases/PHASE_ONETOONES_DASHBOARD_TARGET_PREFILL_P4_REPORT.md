# REPORT: ONETOONES_DASHBOARD_TARGET_PREFILL_P4

**Phase:** target_member_id プリフィル（URL クエリ）の統一と Dashboard Tasks 補強  
**完了日:** 2026-03-23  
**ブランチ:** `feature/phase-onetoones-dashboard-target-prefill-p4` → `develop`

---

## 1. 実施内容サマリ

- **Create:** `target_member_id` の妥当性を **`GET /api/dragonfly/members?owner_member_id=`**（オーナースコープ）で判定するよう変更。
- **Dashboard Tasks（stale・1 行目）:** `href` を `/one-to-ones/create?target_member_id={tid}` に変更（PHP）。
- **Quick Create:** `useSearchParams` + スコープ検証で **一覧 URL の `target_member_id`** を初期値に反映可能にした。
- SSOT **`ONETOONES_TARGET_PREFILL_FIT_AND_GAP.md`** を追加。

---

## 2. 変更ファイル一覧

| 種別 | ファイル |
|------|----------|
| API | `www/app/Services/Religo/DashboardService.php` |
| フロント | `www/resources/js/admin/pages/OneToOnesCreate.jsx` |
| フロント | `www/resources/js/admin/pages/OneToOnesList.jsx` |
| テスト | `www/tests/Feature/Religo/DashboardApiTest.php` |
| SSOT | `docs/SSOT/ONETOONES_TARGET_PREFILL_FIT_AND_GAP.md` |
| 整合 | `docs/SSOT/ONETOONES_CREATE_UX_REQUIREMENTS.md`（追記） |
| process | `docs/process/phases/PHASE_ONETOONES_DASHBOARD_TARGET_PREFILL_P4_{PLAN,WORKLOG,REPORT}.md` |
| 索引 | `docs/process/PHASE_REGISTRY.md`、`docs/INDEX.md`、`docs/dragonfly_progress.md` |

---

## 3. Target prefill Fit & Gap

- 詳細は [ONETOONES_TARGET_PREFILL_FIT_AND_GAP.md](../../SSOT/ONETOONES_TARGET_PREFILL_FIT_AND_GAP.md)。

---

## 4. 実装内容

- **不正値:** 非数値・owner 自身・スコープ外 ID は **prefill しない**（無視）。
- **ヘッダ / ショートカット:** メンバー未特定のため、従来どおりクエリなしの Create へのみ。

---

## 5. テスト結果

| コマンド | 結果 |
|----------|------|
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` | 328 passed（1312 assertions） |
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node npm run build` | 成功 |

---

## 6. 未解決事項

- 一覧「フォームで追加」から **現在の URL クエリを引き継ぐ**（`?target_member_id=`）は未実装（必要なら小改修）。
- `dataProvider.create` への経路統一（任意）。

---

## 7. 次 Phase 提案

| 候補 | 内容 |
|------|------|
| ONETOONES_DURATION_CUSTOM_P5 | 30/60/90 以外の所要時間。 |

---

## 8. Merge Evidence（取り込み証跡）

| 項目 | 内容 |
|------|------|
| merge method | `git merge --no-ff feature/phase-onetoones-dashboard-target-prefill-p4` |
| merged branch | `feature/phase-onetoones-dashboard-target-prefill-p4` |
| target branch | `develop` |
| merge commit id | `9a4c07cf2157f38aa97b3703b8afbdd323ac2ba9` |
| feature last commit id | `1954174ba0e371752960487119a03d1ba4211aa3` |
| pushed at | 2026-03-23T14:45Z UTC 目安（evidence 追記コミットを `origin/develop` に push した時刻） |
| test result | 328 passed（1312 assertions）/ `npm run build` OK（merge 後の `develop` で再実行） |
| notes | URL クエリを正とし、Create scoped 検証・Tasks stale の `?target_member_id=`・Quick Create 一覧 URL prefill。競合なし。 |

---

## 9. Merge Evidence 追記コミット

`develop` への merge 後、§8 を確定する変更を、コミットメッセージ `docs: add merge evidence for onetoones dashboard target prefill p4` で `develop` に追加した（本セクション・§8 はそのコミットで確定）。
