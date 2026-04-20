<?php

return [

    /*
    |--------------------------------------------------------------------------
    | 1 to 1 リード「要対応」判定の日数
    |--------------------------------------------------------------------------
    |
    | GET /api/dragonfly/members/one-to-one-status において、最後の completed から
    | この日数を超えた相手を needs_action とする。デフォルト 30（P5 と同じ）。
    | ONETOONES-P6: MemberOneToOneLeadService が参照する。
    |
    */
    'one_to_one_lead_needs_action_days' => max(0, (int) env('RELIGO_ONE_TO_ONE_LEAD_NEEDS_ACTION_DAYS', 30)),

    /*
    |--------------------------------------------------------------------------
    | Member マージ API（管理者・手動）
    |--------------------------------------------------------------------------
    |
    | 空のとき POST /api/admin/member-merge/* は 404。値を設定し、リクエストヘッダ
    | X-Religo-Member-Merge-Token に同じ値を付与する。
    |
    */
    'member_merge_token' => env('RELIGO_MEMBER_MERGE_TOKEN'),

];
