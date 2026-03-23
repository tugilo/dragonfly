# REPORT: ONETOONES_QUICK_CREATE_UX_P3

**Phase:** 一覧 Quick Create Dialog を Create / Edit UX・`buildOneToOnePayload` に統一  
**完了日:** 2026-03-23  
**ブランチ:** `feature/phase-onetoones-quick-create-ux-p3` → `develop`

---

## 1. 実施内容サマリ

- 一覧の **Quick Create Dialog** を、**`OneToOneFormFields`（`mode="create"`）** と **`buildOneToOnePayload`** に統一した。
- **Owner** は従来どおり一覧フィルタの `owner_member_id` に固定（`ownerInputDisabled`）。Create ページ向けの Owner 説明は Dialog では非表示（`suppressCreateOwnerHint`）。
- **`notes`** の trim・空は `oneToOnesTransform.js` で Create/Edit/Quick 共通にした。
- SSOT **`ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md`** を追加した。

---

## 2. 変更ファイル一覧

| 種別 | ファイル |
|------|----------|
| フロント | `www/resources/js/admin/pages/OneToOnesList.jsx` |
| フロント | `www/resources/js/admin/pages/OneToOneFormFields.jsx` |
| フロント | `www/resources/js/admin/utils/oneToOnesTransform.js` |
| SSOT | `docs/SSOT/ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md` |
| process | `docs/process/phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_PLAN.md` |
| process | `docs/process/phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_WORKLOG.md` |
| process | `docs/process/phases/PHASE_ONETOONES_QUICK_CREATE_UX_P3_REPORT.md`（本ファイル） |
| 索引 | `docs/process/PHASE_REGISTRY.md`、`docs/INDEX.md`、`docs/dragonfly_progress.md` |
| 整合 | `docs/SSOT/ONETOONES_CREATE_UX_REQUIREMENTS.md`（Quick Create 追随の注記） |

---

## 3. Quick Create Fit & Gap

- 調査・整理の SSOT: [ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md](../../SSOT/ONETOONES_QUICK_CREATE_UI_FIT_AND_GAP.md)。
- **P3 前:** 手組み state・手組み POST・例会/相手の入力が Create と二重。  
- **P3 後:** Create と同一フォーム・同一 transform。

---

## 4. 実装内容

- `Form`（react-admin）の `onSubmit` で `buildOneToOnePayload` → `POST /api/one-to-ones`。
- `GET /api/workspaces` と `GET /api/dragonfly/members`（Owner 候補）は Create と同様に取得。
- `formSession` による `Form` リマウントでダイアログ再オープン時の初期化。

---

## 5. テスト結果

| コマンド | 結果 |
|----------|------|
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` | 328 passed（1310 assertions） |
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node npm run build` | 成功 |

---

## 6. 未解決事項

- Dashboard / Leads からの **target 自動プリフィル**（別 Phase）。
- **カスタム所要時間**（別 Phase）。
- Quick Create の `POST` を **`dataProvider.create`** に寄せて通信経路まで完全一本化するかは任意（現状は payload 形状で整合）。

---

## 7. 次 Phase 提案

| 候補 ID | 内容 |
|---------|------|
| ONETOONES_DASHBOARD_TARGET_PREFILL_P4 | Dashboard / Leads → Create の target 自動セット。 |
| ONETOONES_DURATION_CUSTOM_P5 | 30/60/90 以外の所要時間。 |

---

## 8. Merge Evidence（取り込み証跡）

`develop` への `--no-ff` merge 完了後に下表を確定し、追記コミットで `origin/develop` に反映する。

| 項目 | 内容 |
|------|------|
| merge method | `git merge --no-ff feature/phase-onetoones-quick-create-ux-p3` |
| merged branch | `feature/phase-onetoones-quick-create-ux-p3` |
| target branch | `develop` |
| merge commit id | _（merge 後に記入）_ |
| feature last commit id | _（merge 直前の feature tip）_ |
| pushed at | _（evidence 追記コミット push 時刻）_ |
| test result | _（merge 後の test / build）_ |
| notes | Quick Create を `OneToOneFormFields` + `buildOneToOnePayload` に統一。Owner は一覧フィルタ固定。 |

---

## 9. Merge Evidence 追記コミット

`develop` への merge 後、§8 を確定する変更をコミットメッセージ `docs: add merge evidence for onetoones quick create ux p3` で `develop` に追加する。
