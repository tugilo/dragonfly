# Phase M4J Members FilterBar 改善 — PLAN

**Phase:** M4J  
**作成日:** 2026-03-10  
**SSOT:** [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4.1, §4.2

---

## Phase

M4J — Members の FilterBar を、Card デフォルト表示に合わせて使いやすくする。条件クリア・条件の見える化・大カテゴリ→カテゴリ連動を追加する。

---

## Purpose

- **条件クリアボタン**を追加し、一括でフィルタを解除できるようにする。
- **現在の絞り込み条件を見える化**し、何で絞っているかを把握しやすくする。
- **大カテゴリ選択時**に、カテゴリ Select の候補をその大カテゴリ配下に絞り込む（連動）。
- List / Card 両表示で同じフィルタ結果が効くことを維持する。

---

## Background

- FIT_AND_GAP §4.1 の .fbar は「検索・大カテゴリ・カテゴリ・ロール・トグル・並び順・件数」。M4G で大カテゴリを追加済み。Card デフォルト（M4I）になったいま、フィルタを多用するが「何が効いているか」「一括解除」が欲しい。また大カテゴリを選んだあとカテゴリが全件のままだと選びづらいため、大カテゴリに連動してカテゴリ候補を絞る。

---

## Related SSOT

- docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md §4.1（.fbar 構成）、§4.2（実装比較）

---

## Scope

- **変更可能:** www/resources/js/admin/pages/MembersList.jsx の **MembersFilterBar** およびその直近のロジックのみ。
- **変更しない:** API、dataProvider、バックエンド、他ページ、List/Card の表示コンポーネント（FilterBar の子ではないため）。

---

## Target Files

- www/resources/js/admin/pages/MembersList.jsx

---

## Implementation Strategy

1. **条件クリア**
   - ボタン「条件クリア」を FilterBar に追加。クリックで `setFilters({})` を実行し、検索・大カテゴリ・カテゴリ・役職・interested・want_1on1 をすべて解除する。並び順は React Admin の sort に紐づくため、条件クリアでは触れない（フィルタのみクリア）。

2. **現在の絞り込み条件の見える化**
   - filterValues のうち値が入っているキーについて、ラベル付きで表示する。例: 検索 q → 「検索: xxx」、group_name → 「大カテゴリ: xxx」、category_id → 候補から名前を解決して「カテゴリ: 名前」、role_id → 「役職: 名前」、interested → 「Interested」、want_1on1 → 「Want 1on1」。表示は **Chip** で行い、各 Chip の onDelete でその条件だけ解除できるようにする。並び順は「条件」ではなくソートのため、見える化対象からは外す。

3. **大カテゴリ→カテゴリ連動**
   - 大カテゴリ（group_name）が選択されているとき、カテゴリ Select の候補を `categories.filter(c => c.group_name === fv.group_name)` で絞る。大カテゴリ未選択時は従来どおり全カテゴリを表示。**大カテゴリを変更したときに、現在の category_id が別の大カテゴリに属する場合は category_id をクリア**し、候補と選択値を一致させる（API は group_name と category_id の両方で絞るため、不整合を防ぐ）。

4. **List / Card**
   - フィルタは useListContext の filterValues / setFilters に紐づくため、List も Card も同じ data を参照する。FilterBar の変更のみで、両方に同じフィルタ結果が反映される。追加対応は不要。

---

## Tasks

- [ ] Task1: 現行 FilterBar と SSOT の差分確認（条件クリア・条件表示・大カテゴリ連動の有無）
- [ ] Task2: 条件クリアの実装（setFilters({}) とボタン配置）
- [ ] Task3: 絞り込み条件表示の実装（Chip で有効条件を表示、個別削除可能）
- [ ] Task4: 大カテゴリ→カテゴリ連動（候補絞り・大カテゴリ変更時の category_id クリア）
- [ ] Task5: List / Card 両方への反映確認（同一 List コンテキストのため変更不要）
- [ ] Task6: 既存フィルタ・件数・並び順への影響確認

---

## DoD

- FilterBar に「条件クリア」ボタンがあり、クリックでフィルタがすべて解除されること。
- 現在有効な絞り込み条件が Chip（または同等）で表示され、何で絞っているか分かること。可能であれば Chip の削除でその条件だけ解除できること。
- 大カテゴリを選択したとき、カテゴリ Select の候補がその大カテゴリ配下に絞られること。大カテゴリ変更時に不整合な category_id はクリアされること。
- List 表示・Card 表示の両方で同じフィルタ結果が効いていること。
- 既存の検索・大カテゴリ・カテゴリ・役職・interested・want_1on1・並び順・件数表示が壊れていないこと。
- MembersList.jsx 以外・API は変更していないこと。
- php artisan test および npm run build が通ること。

---

## 参照

- MembersList.jsx: MembersFilterBar（約 155 行目〜）、useListContext の filterValues / setFilters
