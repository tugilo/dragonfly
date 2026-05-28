# Phase M-5 Members フラグ編集（Interested / Want 1on1）— PLAN

**Phase:** M-5  
**作成日:** 2026-03-06  
**参照:** [MEMBERS_REQUIREMENTS.md](../../SSOT/MEMBERS_REQUIREMENTS.md)、[FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4、[PHASE_M4_MEMBERS_LAYOUT_REPORT.md](PHASE_M4_MEMBERS_LAYOUT_REPORT.md)

---

## 1. 目的

- **Members 一覧から** interested / want_1on1 を編集できるようにする。
- Connections で既にあるフラグ更新の仕組みを可能な限り再利用する。
- Members 画面にも「関係性の更新導線」を追加する。
- **新 API は作らず**、既存の更新 API / 既存の実装パターンに寄せる。

---

## 2. 方針

1. **既存の Connections のフラグ更新実装を棚卸し**（API・payload・再描画方法）。
2. **API が既存で使えるなら流用**（PUT /api/dragonfly/flags/{target_member_id}）。
3. **UI は Members 一覧の行アクションまたはフラグ列から開く。**

---

## 3. UI 方針候補

| 候補 | 内容 | メリット / デメリット |
|------|------|------------------------|
| **A** | 「フラグ」列クリックで small dialog | 列と近いが、Chip クリック範囲が小さい |
| **B** | 行アクションに「🚩 フラグ」追加 | モックに近い・誤操作しにくい・実装が整理しやすい |
| C | インライン Switch | accidental update が起きやすいため避ける |

**決定:** **B. 行アクションに「🚩 フラグ」追加し、Dialog を開く。**

---

## 4. DoD

- Members 一覧から interested / want_1on1 を更新できる。
- 既存 API を流用（新 API なし）。
- 更新後に一覧表示へ反映（refresh または行データ更新）。
- php artisan test / npm run build 成功。

---

## 5. 成果物

| Phase | 成果物 |
|-------|--------|
| M-5a | PHASE_M5_MEMBERS_FLAG_EDIT_PLAN.md / WORKLOG.md / REPORT.md、INDEX 追記。 |
| M-5b | MembersList.jsx に「🚩 フラグ」行アクション＋フラグ編集 Dialog（interested / want_1on1）。保存は既存 PUT /api/dragonfly/flags/{id} を流用。 |
| M-5c | FIT_AND_GAP（Members 節）・dragonfly_progress・REPORT 取り込み証跡を更新。 |

---

## 6. Git

| Phase | ブランチ | 備考 |
|-------|----------|------|
| M-5a | feature/m5a-members-flag-edit-docs | docs のみ。1 commit → develop --no-ff merge → test/build → push |
| M-5b | feature/m5b-members-flag-edit-impl | MembersList のみ。1 commit → develop merge → test/build → push |
| M-5c | feature/m5c-members-flag-edit-close | docs のみ。1 commit → develop merge → test/build → push |
