/**
 * メンバー主行・副行の表示（管理画面共通）。
 * SSOT: docs/SSOT/CONNECTIONS_BO_MEMBER_CATEGORY_DISPLAY.md §4
 *       docs/SSOT/CONTACT_LOGIC_ALIGNMENT.md（適用範囲）
 */

/** 1 行目: display_no + name。空なら #id */
export function formatMemberPrimaryLine(member) {
    if (!member || member.id == null) return '';
    const line = `${member.display_no || ''} ${member.name || ''}`.trim();
    return line || `#${member.id}`;
}

/** 2 行目: 大/実カテゴリ → なければ current_role。無ければ null */
export function formatMemberSecondaryLine(member) {
    if (!member) return null;
    const cat = [member.category?.group_name, member.category?.name].filter(Boolean).join(' / ');
    if (cat) return cat;
    const role = (member.current_role || '').trim();
    return role || null;
}

/** Autocomplete の getOptionLabel 用: 主＋副（検索にカテゴリ文字列を含める） */
export function formatMemberAutocompleteLabel(member) {
    if (!member) return '';
    const p = formatMemberPrimaryLine(member);
    const s = formatMemberSecondaryLine(member);
    return s ? `${p} ${s}` : p;
}
