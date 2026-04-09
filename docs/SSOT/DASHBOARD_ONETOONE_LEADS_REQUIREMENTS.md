# Dashboard — 次の 1to1 候補（リード）表示要件（SSOT）

**Spec ID:** SPEC-005（[SSOT_REGISTRY.md](../02_specifications/SSOT_REGISTRY.md)）  
**ステータス:** active（実装: `category_label`・Dashboard 表示・API テスト）  
**関連:** [DATA_MODEL.md §4.12.1](DATA_MODEL.md) · `GET /api/dragonfly/members/one-to-one-status` · `DashboardLeadsPanel.jsx`

---

## 1. 目的

Dashboard 右列の **「次の 1to1 候補」** で、各メンバーが **何の業種・カテゴリか** を一覧だけで把握できるようにする。名前と **BNI カテゴリ（大カテゴリ／実カテゴリ）** をあわせて表示し、「誰と 1to1 するか」を選ぶ際の文脈を足す。

---

## 2. 表示の正

| 項目 | 内容 |
|------|------|
| **対象** | `members.type` が **`guest` / `visitor`** の行は **在籍メンバーではない** ため `one-to-one-status` の一覧・Dashboard「次の1to1候補」に **含めない**（[DATA_MODEL §4.12.1](DATA_MODEL.md)） |
| **データ源** | `members.category_id` → `categories`（`group_name`, `name`） |
| **表示文字列** | アプリ全体と同型: `group_name === name` のときは **`name` のみ**、異なるときは **`group_name / name`**（[DATA_MODEL §4.3](DATA_MODEL.md)・CSV/検索系 PHP と同じ結合規則） |
| **未設定** | `category_id` が null または参照不能のときは **`category_label` を null** とし、UI は **「—」** 等で明示 |

---

## 3. API

**`GET /api/dragonfly/members/one-to-one-status?owner_member_id=`** の各行に **`category_label`**（`string | null`）を含める。

既存キー（`member_id`, `name`, `last_one_to_one_at`, `one_to_one_status`, `want_1on1`）は変更しない。

実装: `MemberOneToOneLeadService::indexForOwner` が `members` を `category` 付きで読み、上記規則でラベル化。

---

## 4. UI（Dashboard）

- 各リード行で **氏名（既存）の直下**に **カテゴリ行**を表示（副行・`text.secondary`）。
- **検索フィールド**は **名前に加え `category_label` も部分一致**で絞り込み対象とする（placeholder に「名前・カテゴリで絞り込み」と明記）。
- **一覧の並び順**は **Members ページの番号昇順と同じ（数値ソート）** — `display_no` を CAST して `1,2,…,10,11` 順。ステータス優先のソートはしない。

---

## 5. スコープ外（当面）

- カテゴリでのソート専用 UI
- 役職（`current_role`）の同時表示（必要なら別 Spec）

---

## 6. 変更履歴

| 日時 (JST) | 内容 |
|------------|------|
| 2026-04-07 | 初版（SPEC-005・`category_label`・Dashboard 表示・絞り込み拡張） |
