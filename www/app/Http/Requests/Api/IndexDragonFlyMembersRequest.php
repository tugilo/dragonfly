<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/**
 * GET /api/dragonfly/members のクエリ. M-3c. 検索・フィルタ・ソート用.
 */
class IndexDragonFlyMembersRequest extends FormRequest
{
    public const SORT_FIELDS = ['id', 'display_no', 'name'];

    public const ORDER_VALUES = ['asc', 'desc'];

    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'owner_member_id' => ['nullable', 'integer', 'exists:members,id'],
            'with_summary' => ['nullable', 'boolean'],
            'workspace_id' => ['nullable', 'integer', 'exists:workspaces,id'],
            'region_id' => ['nullable', 'integer', 'exists:regions,id'],
            'q' => ['nullable', 'string', 'max:255'],
            /** 1to1 相手検索: q をチャプター名（workspaces.name）・カテゴリ（group_name / name）にも拡張（SPEC-021 T6）。 */
            'q_extended' => ['nullable', 'boolean'],
            /** 1to1 相手検索: 当該 workspace 所属を除外（自チャプター除外）。workspace_id NULL は残す。 */
            'exclude_workspace_id' => ['nullable', 'integer', 'exists:workspaces,id'],
            /** Autocomplete 用の件数上限。 */
            'limit' => ['nullable', 'integer', 'min:1', 'max:200'],
            'category_id' => ['nullable', 'integer', 'exists:categories,id'],
            'group_name' => ['nullable', 'string', 'max:100'],
            'role_id' => ['nullable', 'integer', 'exists:roles,id'],
            'interested' => ['nullable', 'boolean'],
            'want_1on1' => ['nullable', 'boolean'],
            'sort' => ['nullable', 'string', Rule::in(self::SORT_FIELDS)],
            'order' => ['nullable', 'string', Rule::in(self::ORDER_VALUES)],
            /** Connections: 当該例会の参加者（欠席除く）に紐づく member のみ。レスに participant_type / bo_assignable を付与。 */
            'meeting_id' => ['nullable', 'integer', 'exists:meetings,id'],
            /** Members 名簿: guest / visitor を除外（Dashboard・1to1 リードと同系）。meeting_id スコープ時は無視。 */
            'bni_members_only' => ['nullable', 'boolean'],
            /** Members 名簿: DragonFly チャプター在籍メンバーのみ（他チャプター BNI 会員を除外）。 */
            'dragonfly_chapter_only' => ['nullable', 'boolean'],
        ];
    }
}
