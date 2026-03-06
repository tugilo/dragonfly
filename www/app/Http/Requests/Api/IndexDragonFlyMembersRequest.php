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
            'q' => ['nullable', 'string', 'max:255'],
            'category_id' => ['nullable', 'integer', 'exists:categories,id'],
            'group_name' => ['nullable', 'string', 'max:100'],
            'role_id' => ['nullable', 'integer', 'exists:roles,id'],
            'interested' => ['nullable', 'boolean'],
            'want_1on1' => ['nullable', 'boolean'],
            'sort' => ['nullable', 'string', Rule::in(self::SORT_FIELDS)],
            'order' => ['nullable', 'string', Rule::in(self::ORDER_VALUES)],
        ];
    }
}
