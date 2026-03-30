# PLAN: CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT

| 項目 | 内容 |
|------|------|
| Phase ID | CONTACT_DISPLAY_IMPROVEMENT_IMPLEMENT |
| 種別 | implement |
| Related SSOT | `CONTACT_LOGIC_ALIGNMENT.md` §3.A |

## 方針

- API・DB 変更なし。
- `999日間未接触` → UI で「接触記録なし」に読み替え（`contactDisplayFormat.js`）。
- Dashboard / Members に補助文（`contactUiCopy.js`）。
- 1to1 補助: `RELIGO_ONE_TO_ONE_LEAD_NO_COMPLETED` 文言変更。
- 最終接触 null: 「接触記録なし」表示。

## DoD

- 画面に「999」が出ない（Tasks meta）。
- 補助説明が Dashboard / Members にある。
