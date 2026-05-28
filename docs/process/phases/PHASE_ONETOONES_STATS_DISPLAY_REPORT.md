# REPORT: ONETOONES-P2（1 to 1 統計カード＋表示品質）

## 1. 実施内容サマリ

Owner 文脈の **`GET /api/one-to-ones/stats`** を追加し、一覧上部に **4 枚の統計カード**（予定中・今月完了・今月キャンセル・want_1on1 ON）を表示した。**サブタイトル**「予定・実施・キャンセル履歴の管理」を追加。**ステータス**は API 値を変えず MUI **Chip** で日本語化（未知キーは生文字フォールバック）。**例会列**は `meeting` 結合で **`meeting_label`**（`#番号 — YYYY-MM-DD`）を表示。`POST /api/one-to-ones` 応答を `formatRecord` に揃え後方互換フィールドを拡張した。

## 2. 変更ファイル一覧

| 種別 | パス |
|------|------|
| 新規 | `www/app/Http/Requests/Religo/OneToOneStatsRequest.php` |
| 新規 | `www/app/Services/Religo/OneToOneStatsService.php` |
| 新規 | `www/tests/Feature/Religo/OneToOneStatsTest.php` |
| 新規 | `docs/process/phases/PHASE_ONETOONES_STATS_DISPLAY_PLAN.md` |
| 新規 | `docs/process/phases/PHASE_ONETOONES_STATS_DISPLAY_WORKLOG.md` |
| 新規 | 本 `PHASE_ONETOONES_STATS_DISPLAY_REPORT.md` |
| 更新 | `www/routes/api.php`（`/one-to-ones/stats` を `{oneToOne}` より前に） |
| 更新 | `www/app/Http/Controllers/Religo/OneToOneController.php` |
| 更新 | `www/app/Services/Religo/OneToOneIndexService.php` |
| 更新 | `www/tests/Feature/Religo/OneToOneIndexTest.php` |
| 更新 | `www/resources/js/admin/pages/OneToOnesList.jsx` |
| 更新 | `docs/process/PHASE_REGISTRY.md` |
| 更新 | `docs/dragonfly_progress.md` |
| 更新 | `docs/INDEX.md` |
| 更新 | `docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md` |

## 3. 実装内容

### 統計

- `OneToOneStatsService::getStats`：定義は **PLAN / サービス phpdoc** 参照。`period` で timezone・月初末を返却。
- `want_1on1_on_count`：**`dragonfly_contact_flags`** の当該 owner で `want_1on1 = true` の行数。

### サブタイトル

- `OneToOnesListBody` 先頭の `Typography`（`body2`・secondary）。

### ステータス表示

- `STATUS_CHIP_MAP` + 未知は Chip ラベルに素の `status`。

### Meeting 列

- `formatRecord` に `meeting_number`, `meeting_held_on`, `meeting_label`。一覧は `meeting` を `with` でロード（N+1 抑制）。

## 4. 確認結果

| 項目 | 結果 |
|------|------|
| 統計 API | `OneToOneStatsTest` 3 本通過（422・集計・月外除外） |
| meeting_label | Index Feature 通過 |
| 既存 OneToOne 系 | 回帰含む **280 passed** |
| フロント | `npm run build` 成功 |

## 5. 残課題（見送り）

- Create モーダル化、Owner UX、`contact_memos` 連携の本格 1to1 メモ、統計と **一覧フィルタの完全連動**、モックのサブ文案「先月比」相当のトレンド API。

## 6. 次 Phase 提案

- Create/Edit UX、Owner 既定（`/api/users/me` 連携など）、統計の filter 連動、1to1 メモ導線。

## 7. Merge Evidence

| 項目 | 値 |
|------|-----|
| merge commit id | **未実施**（実装・ドキュメントまで作成） |
| source branch | `feature/phase-onetoones-p2-stats-display`（想定） |
| test command | `php artisan test` / `npm run build` |
| test result | 280 passed / build OK |

---

scope check: OK  
ssot check: OK（FIT_AND_GAP 更新）  
dod check: OK
