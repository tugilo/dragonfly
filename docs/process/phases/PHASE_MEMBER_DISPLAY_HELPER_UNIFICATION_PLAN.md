# PLAN: MEMBER_DISPLAY_HELPER_UNIFICATION

| 項目 | 内容 |
|------|------|
| Phase ID | MEMBER_DISPLAY_HELPER_UNIFICATION |
| 種別 | implement |
| Related SSOT | `CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md`、`CONTACT_LOGIC_ALIGNMENT.md` §4 |

## 方針

- `www/resources/js/admin/utils/memberDisplay.js` に `formatMemberPrimaryLine` / `SecondaryLine` / `AutocompleteLabel` を集約。
- `DragonFlyBoard` はローカル定義を削除し import。
- `MembersList` 名前列・カード、`Dashboard` オーナー選択、`OneToOnesList` / `OneToOnesFormParts` で利用。

## DoD

- 重複する `display_no + name` 組み立てを削減。
- `npm run build` 成功。
