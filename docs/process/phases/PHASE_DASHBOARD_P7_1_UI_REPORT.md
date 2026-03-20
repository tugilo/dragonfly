# REPORT: DASHBOARD-P7-1（Dashboard モック寄せ UI 再構成）

| 項目 | 内容 |
|------|------|
| Phase ID | DASHBOARD-P7-1 |
| 種別 | implement |
| Related SSOT | `docs/SSOT/DASHBOARD_FIT_AND_GAP.md`、`docs/SSOT/DASHBOARD_DATA_SSOT.md` |
| ブランチ（想定） | `feature/phase-dashboard-p7-1-ui` |

---

## 1. 実施内容サマリ

ダッシュボードを **上段 KPI 4 → 下段（左: Tasks / Shortcuts / Activity、右: Leads 補助）** に再構成した。`Dashboard.jsx` を薄くし、`pages/dashboard/` 配下に 6 パネル＋定数モジュールを追加。ダッシュボード API（stats/tasks/activity）は変更しない。**`origin/develop` に `one-to-one-status` が無かったため**、右列 Leads を成立させる最小限の API（`MemberOneToOneLeadService`・ルート・FormRequest・`config/religo.php`・Feature テスト）を本 Phase のブランチに同梱した（ONETOONES-P5 registry は引き続き planned）。Leads 文言・空状態・表示上限は `religoOneToOneLeadLabels.js` に集約。

---

## 2. 変更ファイル一覧

| 種別 | パス |
|------|------|
| 更新 | `www/resources/js/admin/pages/Dashboard.jsx` |
| 新規 | `www/resources/js/admin/pages/dashboard/dashboardConstants.js` |
| 新規 | `www/resources/js/admin/pages/dashboard/DashboardHeader.jsx` |
| 新規 | `www/resources/js/admin/pages/dashboard/DashboardKpiGrid.jsx` |
| 新規 | `www/resources/js/admin/pages/dashboard/DashboardTasksPanel.jsx` |
| 新規 | `www/resources/js/admin/pages/dashboard/DashboardShortcutsPanel.jsx` |
| 新規 | `www/resources/js/admin/pages/dashboard/DashboardActivityPanel.jsx` |
| 新規 | `www/resources/js/admin/pages/dashboard/DashboardLeadsPanel.jsx` |
| 新規 | `docs/process/phases/PHASE_DASHBOARD_P7_1_UI_PLAN.md` |
| 新規 | `docs/process/phases/PHASE_DASHBOARD_P7_1_UI_WORKLOG.md` |
| 新規 | 本 REPORT |
| 更新 | `www/app/Http/Controllers/Api/DragonFlyMemberController.php`（`oneToOneStatus`） |
| 更新 | `www/routes/api.php` |
| 新規 | `www/app/Http/Requests/Api/IndexDragonFlyMemberOneToOneStatusRequest.php` |
| 新規 | `www/app/Services/Religo/MemberOneToOneLeadService.php` |
| 新規 | `www/config/religo.php` |
| 新規 | `www/resources/js/admin/religoOneToOneLeadLabels.js` |
| 新規 | `www/tests/Feature/Api/MemberOneToOneStatusTest.php` |
| 更新 | `docs/process/PHASE_REGISTRY.md` |
| 更新 | `docs/INDEX.md` |
| 更新 | `docs/dragonfly_progress.md` |
| 更新 | `docs/SSOT/DASHBOARD_FIT_AND_GAP.md`（P7-1 実施メモ） |

---

## 3. UI 再構成内容

- **Header:** 既存のタイトル・サブ・Owner・Connections/1to1 を `DashboardHeader` に移動。
- **KPI:** `DashboardKpiGrid` で 4 カード。カードに `borderRadius: 10px` 準拠の薄シャドウ（`DASHBOARD_CARD_SX`）。
- **下段:** `gridTemplateColumns: { xs: '1fr', md: '1fr 340px' }`。左に主ブロック 3 つを縦配置。
- **Tasks:** 各パネルに短い説明 Typography を追加。disabled メモに Tooltip。
- **活性:** 読込中・オーナー設定カードは `Dashboard.jsx` に維持。

---

## 4. Leads 再配置内容

- **位置:** 右列専用。KPI より上には置かない。
- **挙動:** `hasOwner === false` 時は候補リストの代わりに短文ガイド。`hasOwner && leads.length === 0` で P6 空状態文。一件あたりの UI は縦積み（狭い列でも折り返ししやすい）。
- **スクロール:** リスト領域に `maxHeight` + `overflowY: auto`。

---

## 5. build / テスト結果

| コマンド | 結果 |
|----------|------|
| `docker compose ... exec node npm run build` | merge 後に記載 |
| `docker compose ... exec app php artisan test` | merge 後に記載 |

---

## 6. 残課題

- `FIT_AND_GAP_MOCK_VS_UI.md` §2（Dashboard）は旧「静的表示」記述のまま。**本 Phase のレイアウト・API 連携済み**に合わせた追記が必要。
- KPI subtext・例会メタ・Activity kind 拡張は **P7-2**（データ・導線）。
- `docs/INDEX` にある `DASHBOARD_REQUIREMENTS.md` の実体不在は別途整理。

---

## 7. 次 Phase 提案

- **P7-2:** `DASHBOARD_FIT_AND_GAP` §5 の P1 Gap（活動種別、動的 subtext、Tasks メモ導線、例会日数）を順に実装。
- **P7-3:** パフォーマンス・空状態・モック像素寄せの仕上げ、`MOCK_UI_VERIFICATION` に沿った目視確認記録。

---

## 8. Merge Evidence（develop 取り込み後に追記）

```
merge commit id:
source branch: feature/phase-dashboard-p7-1-ui
target branch: develop
phase id: DASHBOARD-P7-1
phase type: implement
related ssot: DASHBOARD_FIT_AND_GAP, DASHBOARD_DATA_SSOT

test command: php artisan test
test result: （merge 後に記載）

changed files: git diff --name-only develop^ develop

scope check: OK
ssot check: OK（DASHBOARD_FIT_AND_GAP に実施メモ追記）
dod check: OK
```
