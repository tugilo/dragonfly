/**
 * 例会・チャプターイベントの表示ラベル（API display_label のフォールバック付き）.
 */

export function meetingDisplayLabel(record) {
    if (!record) return '—';
    if (record.display_label) return record.display_label;
    if (record.number != null && record.number !== '') return `第${record.number}回`;
    if (record.name) return record.name;
    return '—';
}

/** Meetings 一覧・Connections セレクト用 */
export function meetingListLabel(record) {
    if (!record) return '';
    const label = meetingDisplayLabel(record);
    const held = record.held_on ?? '—';
    return `${label} — ${held}`;
}

/** 1to1 等 Autocomplete 用 */
export function meetingOptionLabel(record) {
    if (!record) return '';
    const label = meetingDisplayLabel(record);
    const held = record.held_on ?? '—';
    const name = record.name && record.number == null ? ` / ${record.name}` : '';
    return `${label} / ${held}${name}`;
}

/** 番号列: 定例会は数字、特別イベントは — */
export function meetingNumberCell(record) {
    if (!record) return '—';
    if (record.number != null && record.number !== '') return String(record.number);
    return '—';
}

/** ダイアログタイトル等 */
export function meetingShortTitle(record) {
    if (!record) return '';
    return meetingDisplayLabel(record);
}
