# Connections：BO 周りでメンバー名に加えカテゴリー名を表示する要件・フィット＆ギャップ

**画面:** 管理画面 Connections（`DragonFlyBoard`、ルート `#/connections` 相当）  
**関連:** [CONNECTIONS_REQUIREMENTS.md](CONNECTIONS_REQUIREMENTS.md)、[FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) §3 Connections  
**データ:** `GET /api/dragonfly/members?owner_member_id=…&with_summary=1`（各メンバーに `category.group_name` / `category.name` が含まれる想定）

---

## 1. 背景・目的

例会の **BO（同室枠・BO1/BO2…）** にメンバーを割り当てる操作では、**同姓同名や名前のみでは業種・カテゴリが分かりにくい**ことがある。  
左のメンバー一覧ではカテゴリが見える一方、**BO 割当エリアや関係ログの見出しでは名前中心**のため、割当確認や画面間の一貫性の観点で **カテゴリー名（大カテゴリ／実カテゴリ）も併記**したい。

---

## 2. 用語

| 用語 | 意味 |
|------|------|
| BO | Breakout 同室枠（UI 上の BO1, BO2 …）。`room_label` と対応。 |
| カテゴリー | `category.group_name`（大カテゴリ）と `category.name`（実カテゴリ）を **「大 / 実」** 形式で表示するのが画面全体の既存パターン。 |

---

## 3. 要件（ユーザーストーリー）

1. **BO に既に割り当てられたメンバー**を一覧で見たとき、**番号・氏名に加え、カテゴリーが一目で分かる**こと。
2. **BO にメンバーを追加する Autocomplete** で候補を探すとき、**検索候補の行にもカテゴリーが表示**され、誤選択しにくいこと。
3. **右ペイン「Relationship Log」の見出し**で、**現在選択中のメンバー**について、**左ペインと同様にカテゴリーが分かる**こと（名前のみでは不足、という課題の解消）。
4. **カテゴリー未設定時**は、左ペインと同様に **`current_role` を補助行に出す**、または **「—」** 等で揃える（既存の `sub` ロジックと整合）。

**非目標（本要件の外にしやすいもの）**

- Dashboard の Activity 文言や API ペイロードの変更（監査ログの表示形式は別 SSOT）。
- メンバー CSV・Meetings 参加者 PDF など、Connections 以外の画面の一括改修（必要なら別 Phase）。

---

## 4. 表示フォーマット（既存 UI との整合）

左ペイン（メンバー一覧）で既に採用している次の形式を **BO 周り・右ペイン見出しでも再利用**する。

- **1 行目（主）:** `{display_no} {name}`（従来どおり）
- **2 行目（副）:** `[group_name, name].filter(Boolean).join(' / ')` が空なら `current_role`、それも空なら副行は省略または「—」

実装コード上の参照: `DragonFlyBoard.jsx` 左ペインの `sub` 算出（`m.category?.group_name`, `m.category?.name`, `m.current_role`）。

---

## 5. フィット＆ギャップ（現状実装 vs 要件）

| # | 箇所 | 現状 | 要件との関係 |
|---|------|------|----------------|
| F1 | 左ペイン・メンバー一覧 | 名前＋**カテゴリ（または役職）副行**あり | **Fit** |
| F2 | 中央ペイン・BO 割当 **Autocomplete** の `getOptionLabel` | `display_no` + `name` のみ | **Gap**（候補にカテゴリなし） |
| F3 | 中央ペイン・各 BO の **割当済みメンバー行**（チップ状リスト） | `display_no` + `name` のみ | **Gap**（割当確認時にカテゴリなし） |
| F4 | 右ペイン・**Relationship Log 見出し**（選択メンバー表示） | `display_no` + `name` のみ | **Gap**（見出しにカテゴリなし） |
| F5 | **メンバー詳細モーダル**（BO 行タップで開く） | 名前の下に **カテゴリ／役職**あり | **Fit** |
| F6 | API `members` | `category` が付与され左ペインで利用済み | **Fit**（本改修は主に **UI のラベル組み立て**で完結可能） |

---

## 6. 実装時のメモ（実装 Phase 向け）

- **ヘルパー化:** `formatMemberPrimaryLine(m)` / `formatMemberSecondaryLine(m)` は **`www/resources/js/admin/utils/memberDisplay.js`** に集約（Connections 以外の画面からも import）。
- **Autocomplete:** `getOptionLabel` を 1 行に詰めると長くなる場合は、`renderOption` で 2 行表示（主＋副）を検討。
- **アクセシビリティ:** `aria-label` に全文を入れすぎないよう、必要なら「名前」のみ短く残し、視覚表示でカテゴリを補うか、規約を決めて統一。
- **検索:** 左ペインのフィルタは既にカテゴリ文字列を含む。Autocomplete の `filterOptions` は MUI デフォルトで `getOptionLabel` 全体にマッチするため、**ラベルにカテゴリを含めると検索挙動が変わる** — 意図した挙動か確認する。

---

## 7. モック（FIT_AND_GAP_MOCK_VS_UI）との位置づけ

[FIT_AND_GAP_MOCK_VS_UI.md](FIT_AND_GAP_MOCK_VS_UI.md) §3 は「左 … **名前＋カテゴリ**」を **Fit** としている。  
本ドキュメントの **Gap（F2〜F4）** は、**同じ情報設計を BO 割当ブロックと Relationship Log 見出しにまで広げる**拡張要件として整理したものである。

---

## 8. 改訂履歴

| 日付 | 内容 |
|------|------|
| 2026-03-24 | 初版（要件・Fit/Gap・実装メモ） |
| 2026-03-24 | **実装:** Phase `CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT`（`DragonFlyBoard.jsx`・PLAN/WORKLOG/REPORT）。Gap F2〜F4 を UI で解消。 |
