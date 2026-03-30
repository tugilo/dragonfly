/**
 * 接触・Dashboard 表示の読み替え（UI のみ）。
 * SSOT: docs/SSOT/CONTACT_LOGIC_ALIGNMENT.md §3.A
 *
 * last_contact_at が null のとき、API は stale_follow の meta に「999日間未接触」を渡す。
 * それは実日数ではなくプレースホルダのため、画面では数値を出さない。
 */

/** stale_follow の task.meta を表示用に整形する */
export function formatDashboardStaleTaskMeta(meta) {
    if (meta == null || typeof meta !== 'string') return meta || '';
    if (meta.startsWith('999日間未接触')) {
        return meta.replace(/^999日間未接触/, '接触記録なし');
    }
    return meta;
}
