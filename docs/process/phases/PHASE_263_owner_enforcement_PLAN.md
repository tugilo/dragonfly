# Phase 263 PLAN — Owner Enforcement（SPEC-020 Phase B）

**作成:** 2026-06-27 11:46 JST  
**Phase Type:** implement  
**Branch:** `feature/phase263-owner-enforcement`  
**Related SSOT:** SPEC-010（[AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md](../../SSOT/AUTH_LOGIN_AND_OWNER_BINDING_REQUIREMENTS.md)）、SPEC-020 §4.2 / §4.5 / §11.6 順位 3〜4 / §11.8 Phase B（[ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md](../../SSOT/ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md)）  
**Status:** completed  

---

## Purpose

SPEC-020 の **P0-A 順位 3〜4** を実装する。Phase 262（認証境界）に続き、認可境界（owner スコープ）をサーバ側で強制する。

1. **owner サーバ固定（順位 3 / B2・B3・B12）** — query/body の `owner_member_id` を信用せず、`acting user の owner_member_id` を正とする。`chapter_admin` のみ任意 owner 指定可（グローバル Owner 選択を維持）。一般 member が別 owner を指定したら **403**。
2. **route model owner 検証（順位 4 / B1・B2）** — `one_to_ones`・`contact_memos`・`introductions`・`internal_referrals` 等の詳細/更新/削除で owner 不一致は **403**（admin は許可）。
3. **`PATCH /api/users/me` の owner/workspace 変更制限（順位 3 / B3）** — 一般 member は `owner_member_id` を一度設定したら変更不可（初回 null→設定のみ許可）。`chapter_admin` は変更可。

**本 Phase 外（Phase 264 以降）:** admin API の `religo_role` 強制（順位 5）、React UI 分離（順位 6〜8）。

---

## Scope

### 変更可

| 領域 | ファイル（例） |
|------|----------------|
| Owner 解決 trait | `www/app/Http/Controllers/Religo/Concerns/ResolvesReligoOwner.php` |
| Controllers | `OneToOneController`、`ContactMemoController`、`IntroductionController`、`InternalReferralController`、`DashboardController`、`UserController`、`Api/DragonFlyContactFlagController`、`Api/DragonFlyContactSummaryController` |
| Tests | `OwnerEnforcementTest.php`（新規）、既存 Feature test の調整 |
| Docs | `docs/process/phases/PHASE_263_*`、`PHASE_REGISTRY.md`、`INDEX.md`、`dragonfly_progress.md` |

### 変更しない

- admin 系 API のロール強制（Phase C / 264）
- React `www/resources/js/**`（Phase D / 265）
- `default_workspace_id` の admin 管理化（onboarding 関連は Phase 266 で詳細化）

---

## 認可ポリシー（確定）

| 役割 | owner クエリ/body | route model owner 不一致 | users/me owner 変更 |
|------|-------------------|--------------------------|---------------------|
| `member` | 自分の owner と一致のみ可。未指定は自分 owner を採用。不一致は **403** | **403** | 初回（null→設定）のみ可。変更は **403** |
| `chapter_admin` | 任意 owner 指定可 | 許可 | 任意に変更可 |

---

## DoD

- [ ] `ResolvesReligoOwner::resolveOwnerMemberId` が acting user owner を正とし、member の不一致指定で 403
- [ ] `chapter_admin` は従来どおり任意 owner を指定可（Dashboard / 一覧の global owner 選択を維持）
- [ ] `one-to-ones` / `contact-memos` / `introductions` / `internal-referrals` の詳細・更新・キャンセルで owner 不一致 403
- [ ] `GET /api/one-to-ones` が member では自分 owner に固定（他 owner の件数 0 / 不一致 owner 指定で 403）
- [ ] `PATCH /api/users/me` で member の owner 変更（設定済み→別値）が 403
- [ ] `OwnerEnforcementTest` で上記を検証
- [ ] `php artisan test` 全 pass
- [ ] React 変更なしのため npm build はスキップ可

---

## Tasks

| # | Task | 完了条件 |
|---|------|----------|
| 1 | `ResolvesReligoOwner` 強化（admin 例外・403・`assertOwnerMatchesActor`） | trait 単体で enforce |
| 2 | `DashboardController` を trait 利用に統一 | ローカル resolve 削除 |
| 3 | `OneToOneController` の index owner 固定・store enforce・route model 403 | 全メソッド |
| 4 | `ContactMemoController` の index/store owner enforce | trait 適用 |
| 5 | `DragonFlyContactFlag/Summary` の owner enforce | Api 名前空間でも trait 利用 |
| 6 | `UserController::updateMe` owner 変更制限 | member 初回のみ |
| 7 | `OwnerEnforcementTest` 追加 | 403 / 固定検証 |
| 8 | 既存 Feature test 調整 | 全 pass |

---

## リスク

- 既存テストが query `owner_member_id` を acting user と別値で渡している場合 403 になる → acting user owner を一致させるよう調整
- admin global owner 選択（SPEC-003）を壊さないよう admin 例外を必須とする
