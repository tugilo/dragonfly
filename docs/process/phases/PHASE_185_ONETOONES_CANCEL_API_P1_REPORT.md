# REPORT: Phase 185 — ONETOONES-CANCEL-API-P1

**Phase:** 1 to 1 予定キャンセル API（POST cancel）  
**完了日:** 2026-06-03 22:25 JST  
**ブランチ:** `feature/phase185-onetoones-cancel-api-p1` → `develop`

---

## 1. 実施内容サマリ

- **migration:** `cancel_reason`, `cancel_remark`, `canceled_at`
- **API:** `POST /api/one-to-ones/{id}/cancel`（`planned` のみ）
- **PATCH:** `status=canceled` を validation で拒否
- **formatRecord:** キャンセルフィールドを JSON に含める
- **テスト:** `OneToOneCancelTest` 5 件

---

## 2. 変更ファイル一覧

| 種別 | ファイル |
|------|----------|
| migration | `www/database/migrations/2026_06_03_131800_add_cancel_fields_to_one_to_ones_table.php` |
| API | `CancelOneToOneRequest.php`, `OneToOneController.php`, `OneToOneService.php`, `UpdateOneToOneRequest.php`, `OneToOneIndexService.php`, `OneToOne.php`, `routes/api.php` |
| テスト | `www/tests/Feature/Religo/OneToOneCancelTest.php` |
| SSOT | `docs/SSOT/ONETOONES_DELETE_REQUIREMENTS.md` |
| process | PHASE_REGISTRY, PLAN/WORKLOG/REPORT |

---

## 3. Merge Evidence

| 項目 | 内容 |
|------|------|
| merge commit id | （merge 後に記入） |
| source branch | `feature/phase185-onetoones-cancel-api-p1` |
| target branch | `develop` |
| phase id | 185 |
| phase type | implement |
| related ssot | DATA_MODEL §4.12, ONETOONES_CANCEL_FIT_AND_GAP §10.1 |
| test command | `php artisan test` |
| test result | 434 passed |
| scope check | OK |
| ssot check | OK |
| dod check | OK |

---

## 4. 次 Phase

**Phase 186:** 一覧 Cancel Dialog、Edit から canceled 除外、理由 Chip、`npm run build`。
