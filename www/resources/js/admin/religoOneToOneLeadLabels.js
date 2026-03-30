/**
 * 1 to 1 リード（completed のみ集計）の表示ラベル。
 * SSOT: docs/SSOT/DATA_MODEL.md §4.12.1（ONETOONES-P6）
 */

/** API `one_to_one_status` → 一覧・Dashboard・詳細で共通の短いラベル */
export const RELIGO_ONE_TO_ONE_LEAD_STATUS_LABELS = {
    none: '未実施',
    needs_action: '要対応',
    ok: '実施済',
};

export function religoOneToOneLeadStatusLabel(status) {
    if (status == null || status === '') return '—';
    return RELIGO_ONE_TO_ONE_LEAD_STATUS_LABELS[status] ?? String(status);
}

/** Members DataGrid 列名 */
export const RELIGO_ONE_TO_ONE_LEAD_COLUMN_LABEL = '1to1（実施ベース）';

/** 日付行・Chip 用（completed の最終代表日） */
export const RELIGO_ONE_TO_ONE_LEAD_LAST_DATE_PREFIX = '最終（実施済）';

/** completed が無いときの補助文（completed のみが「実施」とカウントされることを示す） */
export const RELIGO_ONE_TO_ONE_LEAD_NO_COMPLETED = '1to1完了記録なし';

/** Dashboard パネル */
export const RELIGO_DASHBOARD_LEADS_TITLE = '次の 1to1 候補';

export const RELIGO_DASHBOARD_LEADS_HELPER =
    '状態は「実施済み（completed）」のみを集計しています。並び: 未実施 → 要対応 → 実施済（詳細は DATA_MODEL §4.12.1）。';

/** 候補 0 件時（P6 文脈・P7-3 で短文に整理） */
export const RELIGO_DASHBOARD_LEADS_EMPTY =
    '現在、優先して実施すべき 1 to 1 候補はありません。Members 一覧でも状況を確認できます。';

/**
 * Dashboard のリード一覧で表示する最大件数（UI 切替はしない）。
 * 全件は API が返すが、ダッシュボードはスクロール過多を避けるためスライスする。
 */
export const DASHBOARD_LEADS_DISPLAY_LIMIT = 25;
