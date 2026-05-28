# Phase M-5 Members フラグ編集 — WORKLOG

**Phase:** M-5  
**作成日:** 2026-03-06

---

## Step0: Connections 側のフラグ更新の棚卸し

- **箇所:** `www/resources/js/admin/pages/DragonFlyBoard.jsx`
  - `putFlags(ownerMemberId, targetMemberId, data)` を定義。`data` は `{ interested, want_1on1 }`。
  - `PUT ${API}/api/dragonfly/flags/${targetMemberId}?owner_member_id=${ownerMemberId}`、body: `JSON.stringify(data)`。
  - 右ペインで Switch をトグルすると `handleToggle` → `putFlags` → 成功時 `loadSummary()` で再取得。
- **API:** `PUT /api/dragonfly/flags/{target_member_id}?owner_member_id={owner}`、body: `{ interested?: boolean, want_1on1?: boolean }`。Request: `UpsertContactFlagRequest`（owner_member_id 必須、interested / want_1on1 は nullable boolean）。
- **dataProvider:** `dragonflyDataProvider.update('dragonflyFlags', { id, data })` で同じ PUT を呼ぶ実装あり。id = target_member_id、data に owner_member_id, interested, want_1on1 を渡す。
- **結論:** 同じ PUT を Members からも呼べる。payload 名（interested, want_1on1）を揃える。

---

## Step1: 再利用する API / 関数 / 更新パターンの決定

- **API:** 既存 `PUT /api/dragonfly/flags/{target_member_id}?owner_member_id={owner}` をそのまま使用。新 API は作らない。
- **関数:** MembersList 内に `putFlags(ownerMemberId, targetMemberId, data)` を DragonFlyBoard と同様に fetch で実装する（既存パターンに合わせる。dataProvider を inject してもよいが、Connections が fetch なので fetch で揃える）。
- **更新パターン:** 保存成功時は `useRefresh()` で一覧を再取得し、フラグ列の Chip が更新されるようにする。

---

## Step2: Members 側 UI 方針決定

- **行アクションに「🚩 フラグ」を追加**し、クリックで Dialog を開く。
- **Dialog 項目:** interested（Checkbox または Switch）、want_1on1（同）、保存、キャンセル。タイトルは「🚩 フラグ編集 — {member.name}」。
- 既存の「✏️ メモ」「📅 1to1」「📝 1to1メモ」「詳細」と並べて配置。

---

## Step3: 更新後の一覧反映方法

- 保存成功時に `refresh()`（useRefresh）を呼ぶ。List が再 fetch するため、該当行の `summary_lite.interested` / `summary_lite.want_1on1` が更新され、FlagsField の Chip 表示が変わる。
- Dialog を閉じる。

---

## Step4: モックとの差分整理

- モック: 「🚩 フラグ編集」モーダルで interested / want_1on1 を編集。
- 実装: 行アクション「🚩 フラグ」＋ Dialog で同等の編集を提供。Connections は Switch インライン、Members は Dialog で明示的に保存する形で、誤操作を避ける。
