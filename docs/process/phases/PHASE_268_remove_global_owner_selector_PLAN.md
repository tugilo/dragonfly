# Phase 268 PLAN — グローバル Owner セレクタ廃止（ログインユーザー固定）

**作成:** 2026-06-27 12:22 JST  
**Phase Type:** implement  
**Branch:** `feature/phase268-remove-global-owner-selector`  
**Related SSOT:** SPEC-020 §10 DoD（Owner 固定）/ §11.6 順位 7 / 旧 ADMIN_GLOBAL_OWNER_SELECTION（廃止）  
**Status:** completed  

---

## Purpose

マルチユーザー運用方針（SPEC-020）に合わせ、グローバルヘッダーの Owner プルダウンを廃止する。Owner はログインユーザー（`/api/users/me` の `owner_member_id`）に固定し、ヘッダーから他メンバーへ切り替える導線をなくす。

- admin の Owner Select（`<Select>`）と member の表示専用ラベルの両方を削除。
- Owner のデータスコープは引き続き `ReligoOwnerContext`（ログインユーザー由来）で解決。
- owner 未設定時の案内（旧「画面上部の Owner で選ぶ」）を、メンバー紐付けが必要な旨へ更新。

---

## Scope

### 変更可

| 領域 | ファイル |
|------|----------|
| AppBar | `www/resources/js/admin/CustomAppBar.jsx` |
| Layout | `www/resources/js/admin/ReligoLayout.jsx` |
| Docs | `PHASE_268_*`、`PHASE_REGISTRY.md`、`INDEX.md`、`dragonfly_progress.md` |

### 変更しない

- `ReligoOwnerContext`（`patchOwner` は他用途のため残置・ヘッダーからは未使用化）
- バックエンド API（owner 強制は Phase 263 で完了）

---

## DoD

- [ ] ヘッダーに Owner プルダウン・表示専用ラベルが表示されない
- [ ] Owner はログインユーザーに固定され、各画面のスコープが従来どおり動作
- [ ] `npm run build` 成功
- [ ] 既存 `php artisan test` 全 pass（バックエンド非変更の回帰確認）

---

## Tasks

| # | Task | 完了条件 |
|---|------|----------|
| 1 | AppBar から Owner UI 削除 | Select / ラベル両方除去 |
| 2 | 未設定時案内の更新 | Owner 切替前提の文言を撤去 |
| 3 | `npm run build` | 成功 |
| 4 | ブラウザ確認 | ヘッダーに Owner 無し |

---

## リスク

- `patchOwner` はヘッダーから呼ばれなくなるが、Context には残す（将来の管理用途・互換のため）。未使用 import は削除済み。
