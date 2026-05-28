# REPORT: ONETOONES-DELETE-POLICY-P1

**Phase:** 1 to 1 削除しない方針の固定（`canceled` 正規運用化）  
**完了日:** 2026-03-23  
**ブランチ:** `feature/phase-onetoones-delete-policy-p1` → `develop`

---

## 1. 実施内容サマリ

- **SSOT:** 物理削除不採用・`canceled` の業務的意味・運用上の手当てを `ONETOONES_DELETE_REQUIREMENTS.md` / `DATA_MODEL.md` / `FIT_AND_GAP` / `ONETOONES_P1_P4_SUMMARY.md` に反映。
- **API:** `exclude_canceled`（boolean）を `IndexOneToOnesRequest` / `OneToOneStatsRequest` に追加。`OneToOneIndexService::applyIndexFilters` で `status` 未指定時に `canceled` を除外可能に。
- **UI:** 一覧 `filterDefaultValues` に `exclude_canceled: true`、フィルタに `BooleanInput`、説明文言。編集画面の `状態` に helperText。
- **テスト:** `OneToOneIndexTest::test_exclude_canceled_filters_out_canceled_when_owner_scoped`。

---

## 2. 変更ファイル一覧

| 種別 | ファイル |
|------|----------|
| API | `www/app/Services/Religo/OneToOneIndexService.php` |
| API | `www/app/Http/Requests/Religo/IndexOneToOnesRequest.php` |
| API | `www/app/Http/Requests/Religo/OneToOneStatsRequest.php` |
| フロント | `www/resources/js/admin/dataProvider.js` |
| フロント | `www/resources/js/admin/pages/OneToOnesList.jsx` |
| フロント | `www/resources/js/admin/pages/OneToOnesEdit.jsx` |
| テスト | `www/tests/Feature/Religo/OneToOneIndexTest.php` |
| SSOT | `docs/SSOT/ONETOONES_DELETE_REQUIREMENTS.md` |
| SSOT | `docs/SSOT/DATA_MODEL.md` |
| SSOT | `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` |
| process | `docs/process/ONETOONES_P1_P4_SUMMARY.md` |
| process | `docs/process/phases/PHASE_ONETOONES_DELETE_POLICY_P1_PLAN.md` |
| process | `docs/process/phases/PHASE_ONETOONES_DELETE_POLICY_P1_WORKLOG.md` |
| process | `docs/process/phases/PHASE_ONETOONES_DELETE_POLICY_P1_REPORT.md`（本ファイル） |
| 索引 | `docs/process/PHASE_REGISTRY.md`、`docs/INDEX.md`、`docs/dragonfly_progress.md`（他、既存ドキュメント追記） |

---

## 3. 削除ポリシー整理（要約）

- **DELETE は採用しない**（実装なし＝不足ではなく方針）。
- **履歴優先**・集計・メモ紐付けの一貫性を維持。
- **開発・テストデータの掃除**は UI 削除ではなく運用。

---

## 4. `canceled` の定義（要約）

- **予定が無効になった事実**を残す正規状態。
- **誤登録・重複**は当面 `canceled` で片付け、将来は重複警告を別 Phase で検討可能。

---

## 5. 実装内容（詳細）

- `exclude_canceled=true` かつ `status` 未指定: `WHERE status != 'canceled'`。
- `status=canceled` 指定時は `exclude_canceled` の除外は適用しない（上書き）。

---

## 6. テスト結果

| コマンド | 結果 |
|----------|------|
| `php artisan test` | 326 passed |
| `npm run build` | 成功 |

---

## 7. 未解決事項

- 重複登録の **自動警告・validation**（将来 Phase）。
- クイック作成 Dialog への方針文言の追記（任意）。

---

## 8. 次 Phase 提案

- [ONETOONES_CREATE_UX_REQUIREMENTS.md](../../SSOT/ONETOONES_CREATE_UX_REQUIREMENTS.md) に沿った Create UX（相手サマリ・所要時間・例会選択）。
- 重複検知・警告の要否ヒアリング。

---

## 9. Merge Evidence（取り込み証跡）

| 項目 | 内容 |
|------|------|
| merge method | `git merge --no-ff feature/phase-onetoones-delete-policy-p1` |
| merged branch | `feature/phase-onetoones-delete-policy-p1` |
| target branch | `develop` |
| merge commit id | `1a25e89a173e907488f2b693bd2642d732454680` |
| feature last commit id | `a17ee6e1ec57917226c5e75d49193c15c9a01d20` |
| test command | `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` / `exec node npm run build` |
| test result | 326 passed / build OK |
| notes | 削除不採用・`canceled` 正規化・一覧既定 `exclude_canceled` |

---

## 10. Merge Evidence 追記コミット

`develop` への merge 後、§9 の merge commit id・feature tip・`WORKLOG` の merge 記述を確定する変更を、コミットメッセージ `docs: add merge evidence for onetoones delete policy p1` で `develop` に追加した。
