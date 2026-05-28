# Phase M4F Members 一覧かな表示 — PLAN

**Phase:** M4F  
**作成日:** 2026-03-10  
**SSOT:** [FIT_AND_GAP_MOCK_VS_UI.md](../../SSOT/FIT_AND_GAP_MOCK_VS_UI.md) §4.1, §4.2 M9

---

## Phase

M4F — Members の List / Card 両表示で name_kana（かな）を表示し、FIT_AND_GAP M9「一覧にかななし」を解消する。

---

## Purpose

- Members 一覧の **List 表示** と **Card 表示** の両方で name_kana を表示する。
- FIT_AND_GAP §4.2 M9 の GAP「一覧：かな — モック .mc-kana、実装 列なし」を解消する。
- 既存 API・バックエンドは変更せず、既存の「名前」体験をできるだけ崩さない。

---

## Background

- モック §4.1 では .mcard の .mc-hdr に .mc-name（名前）と .mc-kana（かな）を表示している。
- 実装では Card 表示（M4D）で mc-kana に `(record.name_kana || '').trim() || '—'` を既に表示している。List 表示の Datagrid には name 列のみがあり、かな列はない（M9 Gap）。
- members 一覧 API は既に name_kana を返している想定（既存 API は変更しないため、レスポンスに含まれていればそのまま利用する）。

---

## Related SSOT

- docs/SSOT/FIT_AND_GAP_MOCK_VS_UI.md §4.1（.mc-hdr 内 .mc-name、.mc-kana）、§4.2 M9（一覧：かな）

---

## Scope

- **変更可能:** www/resources/js/admin/pages/MembersList.jsx のみ。
- **変更しない:** API（バックエンド）、他ページ、Datagrid の列構成を「壊さない」範囲での変更のみ（名前列の出し方変更またはかな列追加のいずれか）。

---

## Target Files

- www/resources/js/admin/pages/MembersList.jsx

---

## Implementation Strategy

1. **List 表示でのかなの出し方**
   - **案A 名前列の補助表示:** 「名前」列を FunctionField にし、1 セル内に「名前」をメイン、「かな」をその下の補助表示（caption / secondary）で表示する。列数を増やさず、横幅・既存レイアウトを維持できる。
   - **案B かな列追加:** 「かな」列を新規追加（TextField source="name_kana" など）。一覧でかなを独立して見やすいが、列が 1 つ増え横幅が伸びる。
   - **採用方針:** **案A 名前列内サブ表示** を採用する。理由: 「UI の横幅・可読性を優先し、既存 Datagrid を大きく崩さない」という前提に合い、モックの .mc-name / .mc-kana の上下関係とも一致する。列数を増やさないため既存の「名前」体験を壊しにくい。

2. **Card 表示**
   - mc-hdr 内の .mc-kana は既に実装済み。表示内容・spacing・typography を SSOT と照らして確認し、不足や不自然さがあれば微調整する。空のときは「—」のままとする。

3. **空値の扱い**
   - name_kana が null / 空文字のときは List では補助表示を出さないか「—」、Card では既存どおり「—」とし、不自然な空白やラベルだけにならないようにする。

4. **新規 API・バックエンド・新規ページ**
   - 禁止。members 一覧 API の既存レスポンスの name_kana を利用するのみ。

---

## Tasks

- [ ] Task1: SSOT と現行 MembersList.jsx の name_kana 表示差分確認（List になし / Card に mc-kana あり）
- [ ] Task2: List 表示でのかな表示の実装（名前列内サブ表示で FunctionField 化）
- [ ] Task3: Card 表示のかな表示の確認・必要なら spacing / typography の微調整
- [ ] Task4: name_kana が null / 空文字のときのフォールバック確認

---

## DoD

- List 表示で「名前」列に名前とかな（name_kana）が表示されること（名前列内サブ表示）。
- Card 表示で mc-hdr 内のかな表示が SSOT に沿っており、不自然でないこと。
- name_kana が null / 空のとき、不自然な表示にならないこと。
- 既存 Datagrid の列構成・ソート・他列の動作が壊れていないこと。
- 既存 API 変更なし。Scope は MembersList.jsx のみ。
- php artisan test および npm run build が通ること。

---

## 参照

- モック .mc-name / .mc-kana: www/public/mock/religo-admin-mock-v2.html#/members
- 現行 List 列: MembersList.jsx MembersListInner 内 Datagrid（name は TextField source="name"）
- 現行 Card: MemberCard 内 mc-kana で (record.name_kana || '').trim() || '—'
