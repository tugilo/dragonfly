<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class OneToOneStatsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * 1 to 1 統計。GET /api/one-to-ones と同一の任意 filter を受け取り、同じ WHERE で集計（ONETOONES-P4）。
     *
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            /** GET /api/one-to-ones と同様（未指定なら全 Owner の行を集計） */
            'owner_member_id' => ['nullable', 'integer', 'exists:members,id'],
            'workspace_id' => ['nullable', 'integer', 'exists:workspaces,id'],
            'target_member_id' => ['nullable', 'integer', 'exists:members,id'],
            'status' => ['nullable', 'string', Rule::in(['planned', 'completed', 'canceled'])],
            'from' => ['nullable', 'date'],
            'to' => ['nullable', 'date', 'after_or_equal:from'],
            'q' => ['nullable', 'string', 'max:200'],
            /** 一覧と同一（ONETOONES-DELETE-POLICY-P1） */
            'exclude_canceled' => ['nullable', 'boolean'],
            /** 一覧と同一（Phase 303・相手側絞り込み） */
            'target_workspace_id' => ['nullable', 'integer', 'exists:workspaces,id'],
            'target_group_name' => ['nullable', 'string', 'max:100'],
            'target_category_id' => ['nullable', 'integer', 'exists:categories,id'],
            'cross_chapter' => ['nullable', 'boolean'],
        ];
    }
}
