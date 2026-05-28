/**
 * 接触・1to1 の利用者向け補助文（Dashboard / Members 共通）。
 * SSOT: docs/SSOT/CONTACT_LOGIC_ALIGNMENT.md
 */

/** 優先アクション・KPI 周りで使う短文（1 行） */
export const CONTACT_HELP_STALE_LINE =
    '未接触は「自分の所属チャプター」の在籍メンバー同士で算出します（ゲスト・ビジター除外）。最終接触には、**例会で同一 BO（ブレイクアウト）ルームに一度でも同席した日**（開催日ベース）、メモ、1 to 1（予定・実施・登録日を含む）が含まれます。同じ例会にいても **別ルーム** で、`participant_breakout` に同席が載っていない場合は接触にならないことがあります。';

/** 1to1 リード（completed のみ）の補助 */
export const CONTACT_HELP_ONE_TO_ONE_COMPLETED_LINE =
    '1 to 1 の「実施」はステータス「完了（completed）」のみです。予定（planned）だけでは実施扱いになりません。';
