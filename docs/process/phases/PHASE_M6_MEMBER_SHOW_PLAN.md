# Phase M-6 Member Show / Drawer 履歴強化 — PLAN

**Phase:** M-6  
**作成日:** 2026-03-06  
**参照:** [MEMBERS_REQUIREMENTS.md](../../SSOT/MEMBERS_REQUIREMENTS.md)、[FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4、[PHASE_M5_MEMBERS_FLAG_EDIT_REPORT.md](PHASE_M5_MEMBERS_FLAG_EDIT_REPORT.md)

---

## 1. 目的

- Member Show / Drawer の履歴を**実用レベル**にし、「1人の関係履歴」を見やすくする。
- 対象: **Members 一覧の詳細 Drawer** と **/members/:id の Member Show**。
- 既存 API を再利用し、メモ履歴 / 1to1履歴 / 基本サマリを整理表示する。**新 API は作らない**。
- Connections と Members で同じ情報源を見せるように揃える。

---

## 2. スコープ

| # | 項目 | 内容 |
|---|------|------|
| 1 | **Overview 強化** | display_no, name, category/role, same_room_count, one_to_one_count, last_contact_at, interested/want_1on1、直近メモを整理表示。 |
| 2 | **Memos タブ強化** | 最新順にメモ履歴。日付・種別・本文・関連 meeting/1to1 の補足。「Coming soon」を除去。 |
| 3 | **1to1 タブ強化** | 最新順に 1to1 履歴。status, scheduled_at/実施日時, メモ。planned/done/canceled を整理。「Coming soon」を除去。 |
| 4 | **Show ページ** | 上記と同等の内容（Overview / Memos / 1to1）を表示。Drawer と情報構造を揃える。 |

---

## 3. 非対象

- 新規 API。
- Connections 側の大改修。
- カードグリッド化。

---

## 4. DoD

- Drawer と Show でメモ履歴 / 1to1履歴が見える。
- 基本サマリ（同室・最終接触・フラグ等）が整理表示される。
- 既存 API 再利用（新 API なし）。
- 「Coming soon」を除去。
- php artisan test / npm run build 成功。

---

## 5. 成果物

| Phase | 成果物 |
|-------|--------|
| M-6a | PHASE_M6_MEMBER_SHOW_PLAN.md / WORKLOG.md / REPORT.md、INDEX 追記。 |
| M-6b | MembersList.jsx（Drawer の Overview に直近メモ等を追加）、MemberShow.jsx（Overview / Memos / 1to1 を既存 API で表示、「Coming soon」除去）。 |
| M-6c | FIT_AND_GAP（Members 節）・dragonfly_progress・REPORT 取り込み証跡を更新。 |

---

## 6. Git

| Phase | ブランチ | 備考 |
|-------|----------|------|
| M-6a | feature/m6a-member-show-docs | docs のみ。1 commit → develop --no-ff merge → test/build |
| M-6b | feature/m6b-member-show-impl | Drawer / Show 実装。1 commit → develop merge → test/build |
| M-6c | feature/m6c-member-show-close | docs のみ。1 commit → develop merge → test/build |
