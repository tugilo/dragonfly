# PLAN: CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT

| 項目 | 内容 |
|------|------|
| Phase ID | CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY_IMPLEMENT |
| 種別 | implement |
| Related SSOT | `docs/SSOT/CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md` |
| ブランチ | `feature/phase-connections-bo-member-category-display-implement` |

---

## 1. 背景

Connections（`DragonFlyBoard`）の左ペインでは番号・氏名＋副行（大/実カテゴリまたは `current_role`）を表示しているが、BO 割当リスト・BO 追加 Autocomplete・Relationship Log 見出しは名前中心で業種が分かりにくい。SSOT の Gap F2〜F4 を UI のみで解消する。

---

## 2. Scope

- **implement:** `www/resources/js/admin/pages/DragonFlyBoard.jsx` を主対象。表示ヘルパーは同ファイル内に追加（過剰分割しない）。
- **変更しない:** API・DB・ルート・他画面。

---

## 3. 実装方針

1. **`formatMemberPrimaryLine` / `formatMemberSecondaryLine`** を追加（SSOT §4 と同一ルール）。
2. **左ペイン**の `name` / `sub` 算出をヘルパーに寄せ、表記を一本化。
3. **BO 割当済み行:** 主行＋副行の 2 行表示。`mem` 欠損時は `#id` のみ。`aria-label` は主行ベースで短く維持。
4. **Autocomplete:** `getOptionLabel` に主＋副を連結（カテゴリ文字列でもフィルタ可能に）。`renderOption` で 2 行表示。
5. **Relationship Log 見出し:** 主行＋副行（副が無いときは非表示）。
6. **メンバー詳細モーダル**は SSOT上 Fit だが、副行を `formatMemberSecondaryLine` に統一し `null` 時は `—`（既存挙動維持）。

---

## 4. 非目標

SSOT「非目標」に従い、Dashboard / Members 一覧 / CSV・PDF 等は触らない。

---

## 5. 確認項目（手動・ビルド）

- `npm run build` 成功。
- 左ペイン表示の崩れなし。
- BO 行・Autocomplete・Relationship Log でカテゴリ／役職が左と同ルール。
- カテゴリなし・役職なしで副行が出ない（モーダルは `—` のまま）。
- クリック・削除・メモ・詳細モーダルが従来どおり。

---

## 6. DoD

1. BO 割当済み行にカテゴリまたは役職（副行）が表示される。
2. Autocomplete 候補に副行が表示され、`getOptionLabel` でカテゴリ検索に利用可能。
3. Relationship Log 見出しに副行が追加される。
4. 表示ルールが左ペインと一致（ヘルパー共通化）。
5. API・DB・ルート変更なし。
6. PLAN / WORKLOG / REPORT・PHASE_REGISTRY・INDEX・進捗更新。
