# Phase 265 PLAN — Member UI Separation（SPEC-020 Phase D）

**作成:** 2026-06-27 12:05 JST  
**Phase Type:** implement  
**Branch:** `feature/phase265-member-ui-separation`  
**Related SSOT:** SPEC-003（ADMIN_GLOBAL_OWNER_SELECTION）、SPEC-010、SPEC-020 §11.6 順位 6〜8 / 10 / §11.8 Phase D（[ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md](../../SSOT/ONETOONE_MULTIUSER_MINUTES_REQUIREMENTS.md)）  
**Status:** completed  

---

## Purpose

SPEC-020 P0-B/C の UI 分離（順位 6〜8 / 10）を React 管理画面に実装する。一般 member には管理メニュー・Owner 切替・編集画面を出さない。

- **順位 6:** `religo_role` でメニュー・ルートを分離（member / chapter_admin）。
- **順位 7:** 一般 member は Owner Select を表示専用にし、owner 変更不可。
- **順位 8:** Member / Categories / Roles 編集画面を `chapter_admin` のみ表示。
- **順位 10:** 一般 member から SONAE / Member merge / 管理系 Settings を非表示。

---

## 設計

- `authProvider.getPermissions()` が `/api/users/me` の `religo_role` を返す（キャッシュ・auth 変更でクリア）。
- `ReligoOwnerContext` に `religoRole` / `isChapterAdmin` を追加（AppBar 用に再 fetch を避ける）。
- `app.jsx` は `<Admin>` の function-as-child で `permissions` を受け、admin のみ Categories/Roles Resource・MemberEdit・member-merge/settings/SONAE ルートを描画。
- `ReligoMenu` は `usePermissions()` で admin 専用項目（Member merge / SONAE / Categories / Roles）を隠す。
- `CustomAppBar` は member の Owner Select を表示専用（disabled + 自分の owner 名表示）。

### member に出すもの

Dashboard / Connections / Members(一覧・詳細) / Meetings(一覧・詳細) / 1 to 1 / Role History / Zoom 取り込み / 所属チャプター(settings)。

### member に出さないもの

Member 編集 / Categories / Roles / Member merge / SONAE。

---

## Scope

### 変更可

| 領域 | ファイル |
|------|----------|
| Auth | `www/resources/js/admin/authProvider.js` |
| Context | `www/resources/js/admin/ReligoOwnerContext.jsx` |
| App | `www/resources/js/admin/app.jsx` |
| Menu | `www/resources/js/admin/ReligoMenu.jsx` |
| AppBar | `www/resources/js/admin/CustomAppBar.jsx` |
| Docs | `PHASE_265_*`、`PHASE_REGISTRY.md`、`INDEX.md`、`dragonfly_progress.md` |

### 変更しない

- バックエンド（Phase 263/264 で完了）
- 1to1 実施後記録 UI（Phase 267）

---

## DoD

- [ ] member ログイン時、Member merge / SONAE / Categories / Roles メニューが出ない
- [ ] member は Owner Select が表示専用（変更不可）
- [ ] member は Members 編集画面に遷移できない（Resource edit 無効）
- [ ] admin は従来どおり全機能利用可
- [ ] `npm run build` 成功
- [ ] 既存 `php artisan test` 全 pass（バックエンド非変更のため回帰確認のみ）

---

## Tasks

| # | Task | 完了条件 |
|---|------|----------|
| 1 | `getPermissions` で role 返却 | キャッシュ + auth クリア |
| 2 | `ReligoOwnerContext` に role 追加 | `isChapterAdmin` 公開 |
| 3 | `app.jsx` permissions 分岐 | admin のみ admin Resource/route |
| 4 | `ReligoMenu` admin 項目非表示 | member で非表示 |
| 5 | `CustomAppBar` Owner 表示専用 | member 変更不可 |
| 6 | `npm run build` | 成功 |

---

## リスク

- function-as-child により Resource 描画タイミングが permissions 解決後になる → ローディングは react-admin 既定で許容
- `/settings`（所属チャプター）は member にも残す（自分のチャプター確認のため）
