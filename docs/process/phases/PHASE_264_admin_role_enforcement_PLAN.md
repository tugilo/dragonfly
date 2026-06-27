# Phase 264 PLAN — Admin API Role Enforcement（SPEC-020 Phase C）

**作成:** 2026-06-27 11:57 JST  
**Phase Type:** implement  
**Branch:** `feature/phase264-admin-role-enforcement`  
**Related SSOT:** SPEC-010、SPEC-014、SPEC-020 §11.6 順位 5 / §11.8 Phase C（[ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md](../../SSOT/ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md)）  
**Status:** completed  

---

## Purpose

SPEC-020 P0-A 順位 5 を実装する。マスタ・例会管理の **編集系 API を `chapter_admin` 限定**にし、一般 member は直接 API でも 403 にする（B4 / B6 / B7 / B8）。

- **閲覧（GET）は全認証ユーザー可**（SPEC-014 方針: 例会データは閲覧自由・編集は admin）。
- **owner スコープ系の本人書き込み（contact-memos / one-to-ones / introductions / internal-referrals / dragonfly flags / users/me / zoom・ai credentials）は member のまま**（Phase 263 で owner 固定済み）。

---

## admin 限定にする編集系 API

| 領域 | エンドポイント |
|------|----------------|
| Member マスタ | `PUT /api/dragonfly/members/{id}` |
| Categories | `POST /categories`、`PUT /categories/{id}`、`DELETE /categories/{id}` |
| Roles | `POST /roles`、`PUT /roles/{id}`、`DELETE /roles/{id}` |
| Meetings | `POST /meetings`、`PATCH /meetings/{id}`、`PUT /meetings/{id}/memo` |
| Meeting CSV import | `POST .../csv-import`、resolutions の PUT/DELETE/POST 系、create-member/category/role、member-apply/role-apply、apply |
| Participants import | `POST .../participants/import`、`/parse`、`PUT .../candidates`、`/apply` |
| Breakouts | `PUT .../breakouts`、`PUT .../breakout-rounds` |

> 注: `/admin/users/{user}`（既存）は引き続き `religo.chapter_admin`。

---

## Scope

### 変更可

| 領域 | ファイル |
|------|----------|
| Routes | `www/routes/api.php`（編集系を `religo.chapter_admin` ネスト group に集約） |
| Tests | `AdminRoleEnforcementTest.php`（新規）、編集系 Feature test の acting user を admin に調整 |
| Docs | `PHASE_264_*`、`PHASE_REGISTRY.md`、`INDEX.md`、`dragonfly_progress.md` |

### 変更しない

- React UI（Phase D / 265）
- owner スコープ系 member 書き込み
- DragonFly breakout レガシー（`/dragonfly/meetings/{number}/...` 番号系・sanctum 外）

---

## DoD

- [ ] 編集系 API が member で 403、admin で従来通り 200/201
- [ ] 閲覧系 GET は member で従来通り 200
- [ ] `AdminRoleEnforcementTest` で代表編集 API の 403/許可を検証
- [ ] `php artisan test` 全 pass
- [ ] React 変更なし → npm build スキップ

---

## Tasks

| # | Task | 完了条件 |
|---|------|----------|
| 1 | `routes/api.php` 再構成（admin ネスト group） | 編集系を `religo.chapter_admin` 配下へ |
| 2 | `AdminRoleEnforcementTest` 追加 | 代表 API の member 403 / admin 許可 |
| 3 | 編集系既存 Feature test を admin 化 | 全 pass |
| 4 | `php artisan test` | 全 pass |

---

## リスク

- 編集系 Feature test が member 既定で 403 になる → acting user を `chapter_admin` 化して対応
- 閲覧と編集が同一 prefix のため、GET を誤って admin 化しないよう注意
