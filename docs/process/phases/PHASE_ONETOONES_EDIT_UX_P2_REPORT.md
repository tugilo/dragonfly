# REPORT: ONETOONES_EDIT_UX_P2

**Phase:** 1 to 1 Edit 画面を Create UX に揃える（共有フォーム・transform・相手サマリ・例会選択）  
**完了日:** 2026-03-23  
**ブランチ:** `feature/phase-onetoones-edit-ux-p2` → `develop`

---

## 1. 実施内容サマリ

- **Create を正**として、[ONETOONES_EDIT_UI_FIT_AND_GAP.md](../../SSOT/ONETOONES_EDIT_UI_FIT_AND_GAP.md) で整理していた Gap（相手サマリ・日時 UX・Meeting 入力・PATCH 正規化）を Edit で解消した。
- **`oneToOnesTransform.js`** に `buildOneToOnePayload` を集約し、Create / Edit の送信規則を一本化した。
- **`OneToOneFormFields.jsx`** で Create / Edit のフォームを共通化し、Edit では **`status === 'completed'` のときのみ**実績 `started_at` / `ended_at` を表示する。
- **例会**は `OneToOneMeetingReferenceInput` に統一。**`EditContextHeader`** は相手サマリと重複するため削除。
- SSOT に §8（P2 実装済み）を追記。本 REPORT で Phase 資産として固定する。

---

## 2. 変更ファイル一覧

| 種別 | ファイル |
|------|----------|
| 新規 | `www/resources/js/admin/utils/oneToOnesTransform.js` |
| 新規 | `www/resources/js/admin/pages/OneToOneFormFields.jsx` |
| 変更 | `www/resources/js/admin/pages/OneToOnesCreate.jsx` |
| 変更 | `www/resources/js/admin/pages/OneToOnesEdit.jsx` |
| SSOT | `docs/SSOT/ONETOONES_EDIT_UI_FIT_AND_GAP.md`（§8） |
| process | `docs/process/phases/PHASE_ONETOONES_EDIT_UX_P2_PLAN.md` |
| process | `docs/process/phases/PHASE_ONETOONES_EDIT_UX_P2_WORKLOG.md` |
| process | `docs/process/phases/PHASE_ONETOONES_EDIT_UX_P2_REPORT.md`（本ファイル） |
| 索引 | `docs/process/PHASE_REGISTRY.md`、`docs/INDEX.md`、`docs/dragonfly_progress.md` |
| 整合（任意） | `docs/SSOT/ONETOONES_CREATE_UX_REQUIREMENTS.md`（Edit 追随の一文） |

---

## 3. Fit & Gap の解消内容

| SSOT の論点（要約） | 対応 |
|---------------------|------|
| 相手サマリ未表示 | `TargetMemberSummaryCard` を `OneToOneFormFields` で Create/Edit 共通表示。 |
| 日時が 3 つの DateTimeInput のみ | `OneToOneCreateScheduleFields` ＋ 所要時間チップ。completed のみ実績ブロック。 |
| Meeting が NumberInput | `OneToOneMeetingReferenceInput` に置換。 |
| PATCH に正規化なし | `SimpleForm` の `transform` で `buildOneToOnePayload(..., { mode: 'edit' })`。 |
| Edit 専用ヘッダ | `EditContextHeader` 削除（サマリカードに集約）。 |

詳細は [ONETOONES_EDIT_UI_FIT_AND_GAP.md](../../SSOT/ONETOONES_EDIT_UI_FIT_AND_GAP.md) §8 を参照。

---

## 4. 実装内容（要点）

- **`buildOneToOnePayload`:** `normalizeMeetingId`、`inferDurationMinutes`、create/edit で `started_at`/`ended_at` の扱いを分岐（planned/canceled は実績クリア寄り、completed は実績入力を尊重）。
- **`OneToOneFormFields`:** `mode: 'create' \| 'edit'`、Owner/相手/サマリ/状態/スケジュール/（条件付き実績）/例会/メモ。
- **`OneToOnesEdit`:** `EditDurationInitializer` で所要の初期推定、`contact_memos` 履歴パネルは従来どおり。

---

## 5. テスト結果

| コマンド | 結果（merge 前の feature 上での確認） |
|----------|----------------------------------------|
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` | 328 passed |
| `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec node npm run build` | 成功 |

_merge 後に同一コマンドで再実行し、§8 に最終結果を記載する。_

---

## 6. 未解決事項

- **Quick Create Dialog** への同一フォーム・transform の全面追随（別 Phase）。
- **Dashboard / Leads** からの `target_member_id` 自動プリフィル（別 Phase）。
- **所要時間の任意分数**（カスタム duration）（別 Phase）。
- **completed / planned** の状態切り替え時の文言・バリデーションの微調整余地。

---

## 7. 次 Phase 提案

| 候補 ID | 内容 |
|---------|------|
| ONETOONES_QUICK_CREATE_UX_P3 | 一覧クイック作成 Dialog を Create/Edit と同じ UX・payload に揃える。 |
| ONETOONES_DASHBOARD_TARGET_PREFILL_P4 | Dashboard / Leads から Create への target 自動セット。 |
| ONETOONES_DURATION_CUSTOM_P5 | 30/60/90 以外の所要時間（カスタム分）。 |

---

## 8. Merge Evidence（取り込み証跡）

`develop` への `--no-ff` merge 完了後、下表を確定し、必要なら **追記コミット**（`docs: add merge evidence for onetoones edit ux p2`）を `develop` に追加する。

| 項目 | 内容 |
|------|------|
| merge method | `git merge --no-ff feature/phase-onetoones-edit-ux-p2` |
| merged branch | `feature/phase-onetoones-edit-ux-p2` |
| target branch | `develop` |
| merge commit id | _（merge 後に `git log -1 --format=%H develop` で記入）_ |
| feature last commit id | _（merge 直前の feature tip）_ |
| pushed at | _（merge evidence 追記コミット push 日時）_ |
| test command | `docker compose -f infra/compose/docker-compose.yml --env-file project.env exec app php artisan test` / `exec node npm run build` |
| test result | _（merge 後の件数・build）_ |
| notes | Create と揃えた項目（サマリ・duration・例会・transform）。未解決は §6 参照。 |
