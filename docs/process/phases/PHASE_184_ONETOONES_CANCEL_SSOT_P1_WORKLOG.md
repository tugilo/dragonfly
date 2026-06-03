# WORKLOG: Phase 184 — ONETOONES-CANCEL-SSOT-P1

## 判断

### SSOT の分割

- **合意の単一情報源:** `ONETOONES_CANCEL_FIT_AND_GAP.md` §10（調査 + 合意ログ）
- **実装 SSOT:** `DATA_MODEL.md` §4.12（列・API・validation）
- **製品方針:** `ONETOONES_DELETE_REQUIREMENTS.md`（物理削除不採用は維持、キャンセル UX を §2/§3 に追記）

### PATCH 経由 canceled を SSOT で禁止

- Edit から reason なしで `canceled` になる経路を塞ぐため、**`POST /cancel` のみ**と DATA_MODEL に明記。
- 既存 `PATCH` の `status=canceled` は implement Phase で 422 または validation 拒否（Phase 185）。

### notes との分離

- キャンセル理由は **`cancel_reason` / `cancel_remark`**。`notes` は議事のまま（§10.1 #5）。
