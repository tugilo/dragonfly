# Phase 270 PLAN — メンバー詳細ドロワーからの email インライン編集

**作成:** 2026-06-27 13:03 JST  
**Phase Type:** implement  
**Branch:** `feature/phase270-member-email-drawer-edit`  
**Related SSOT:** SPEC-010、SPEC-011、[FIT_AND_GAP_MEMBER_EMAIL_REGISTRATION.md](../../SSOT/FIT_AND_GAP_MEMBER_EMAIL_REGISTRATION.md)（G1）、[TEST_USER_ONBOARDING_FLOW.md](../../SSOT/TEST_USER_ONBOARDING_FLOW.md)  
**Status:** completed  

---

## Purpose

テストユーザー追加時、複数メンバーの `members.email` を登録する作業を効率化する。Fit&Gap の G1（Members 一覧/詳細ドロワーから email を直接編集できない）を解消し、ドロワーの Overview タブで email をインライン編集・保存できるようにする。

- 既存の Nキャス URL 編集と同じパターン（`putDragonflyMember`）を再利用。
- email 更新 API は admin 限定のため、UI も `isChapterAdmin` でゲート。

---

## 設計

- `MemberDetailDrawer`（`MembersList.jsx`）に email 用 state（draft / saving / error / saved）を追加。
- ドロワー表示時に `member.email` で draft を初期化（一覧 API の select に email 含む）。
- Overview タブに **「ログイン用メールアドレス」** カードを追加（`isChapterAdmin` のときのみ）。
- 保存は `putDragonflyMember(id, { email })` → 成功時 `onMemberUpdated`・「保存しました」表示。
- バリデーション・重複チェックはサーバ（`DragonFlyMemberController`・同一 workspace unique）に委譲。エラーは API メッセージを表示。

---

## Scope

### 変更可

| 領域 | ファイル |
|------|----------|
| Members UI | `www/resources/js/admin/pages/MembersList.jsx` |
| Docs | `PHASE_270_*`、`PHASE_REGISTRY.md`、`INDEX.md`、`dragonfly_progress.md`、`FIT_AND_GAP_MEMBER_EMAIL_REGISTRATION.md`（G1 解消反映） |

### 変更しない

- バックエンド API（email 更新は既存実装で充足）
- Member 編集画面（`MemberEdit`）— 既存の email 欄は維持

---

## DoD

- [ ] admin はドロワー Overview から email を入力・保存できる
- [ ] 一般 member にはドロワーに email 編集カードが出ない
- [ ] 重複 email はサーバ 422 のメッセージが表示される
- [ ] `npm run build` 成功
- [ ] 既存 `php artisan test` 全 pass（バックエンド非変更の回帰確認）

---

## Tasks

| # | Task | 完了条件 |
|---|------|----------|
| 1 | email state 追加 | draft/saving/error/saved |
| 2 | draft 初期化 | member.email から |
| 3 | email 編集カード（admin 限定） | isChapterAdmin ゲート |
| 4 | 保存ハンドラ | putDragonflyMember(email) |
| 5 | build / test | 成功・567 pass |

---

## リスク

- email 更新の実体防御はサーバ（admin 限定 + unique）で担保済み。UI ゲートは利便性目的。
- ドロワーの member 行は一覧キャッシュ由来。保存後の表示整合は `onMemberUpdated` と draft 状態で吸収。
