/** Dashboard フォールバック・表示用定数。API 失敗時・P7-2 で subtext 動的化時の差し替えポイント。 */

/** 空状態・エラー（P7-3）。長文にしない。 */
export const DASHBOARD_MSG = {
    KPI_NEED_OWNER: 'オーナーを設定すると、未接触件数や今月の活動量（KPI）が表示されます。',
    KPI_LOAD_ERROR: 'KPI を読み込めませんでした。画面を再読み込みしてください。',
    TASKS_NEED_OWNER: 'オーナーを設定すると、フォロー対象のタスクがここに表示されます。',
    TASKS_EMPTY: 'いま表示する優先アクションはありません。条件を満たす未接触・予定 1 to 1・例会フォローがあればここに出ます。',
    ACTIVITY_NEED_OWNER: 'オーナーを設定すると、直近のメモ・1 to 1・つながりの更新が表示されます。',
    ACTIVITY_EMPTY: '最近の活動はまだありません。メモや 1 to 1 を記録するとここに表示されます。',
};

export const STATS_DEFAULT = {
    stale_contacts_count: 3,
    monthly_one_to_one_count: 5,
    monthly_intro_memo_count: 8,
    monthly_meeting_memo_count: 4,
    subtexts: { stale: '要フォロー', one_to_one: '先月比 +2', intro: 'BO含む', meeting: '例会#247 含む' },
};

export const TASKS_FALLBACK = [
    { id: 's1', kind: 'stale_follow', title: '伊藤 勇樹', meta: '55日間未接触 — 1to1を検討', action: { label: '1to1予定', href: '/one-to-ones/create', disabled: false } },
    { id: 's2', kind: 'stale_follow', title: '水野 花菜', meta: '66日間未接触 — フォローアップ要', action: { label: 'メモ追加', href: '/members/2/show', disabled: false } },
    { id: 'o1', kind: 'one_to_one_planned', title: '田中 誠一 との1to1', meta: '本日 12:00 — CRM導入フォロー', badge: '予定', action: { label: '予定', href: null, disabled: true } },
    { id: 'm1', kind: 'meeting_follow_up', title: '例会 #248（次回・直近のフォロー）', meta: '次回例会まであと5日', action: { label: 'Meetingsへ', href: '/meetings', disabled: false } },
];

export const ACTIVITY_ICONS = {
    memo_added: '✏️',
    memo_introduction: '🎯',
    one_to_one_created: '📅',
    one_to_one_completed: '🤝',
    flag_changed: '⭐',
    bo_assigned: '📋',
};

export const ACTIVITY_FALLBACK = [
    { id: 'a1', kind: 'memo_added', title: '佐藤 美咲 にメモ追加', meta: 'セミナー案件・1to1メモ — 2分前' },
    { id: 'a2', kind: 'one_to_one_created', title: '田中 誠一 1to1を登録', meta: 'planned — 本日 12:00 — 3時間前' },
    { id: 'a3', kind: 'bo_assigned', title: '例会 #247 BO割当を保存', meta: 'BO4件 — 2025-07-08 — 昨日' },
    { id: 'a4', kind: 'one_to_one_completed', title: '渡辺 彩香 1to1完了', meta: 'DX案件ヒアリング — 2025-07-09' },
    { id: 'a5', kind: 'flag_changed', title: '森 友美 に interested フラグ', meta: 'スポーツ施術コラボ検討 — 2025-07-06' },
    { id: 'a6', kind: 'memo_added', title: '小林 陽子 にメモ追加', meta: '投資物件の情報提供依頼 — 2025-07-05' },
];

/** モック v2 のカードに近い角丸・薄シャドウ */
export const DASHBOARD_CARD_SX = {
    borderRadius: '10px',
    boxShadow: '0 1px 3px rgba(0,0,0,.12)',
};
