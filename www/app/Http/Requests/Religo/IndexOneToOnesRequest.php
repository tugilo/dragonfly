<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class IndexOneToOnesRequest extends FormRequest
{
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
            'workspace_id' => ['nullable', 'integer', 'exists:workspaces,id'],
            'owner_member_id' => ['nullable', 'integer', 'exists:members,id'],
            'target_member_id' => ['nullable', 'integer', 'exists:members,id'],
            'status' => ['nullable', 'string', Rule::in(['planned', 'completed', 'canceled'])],
            'from' => ['nullable', 'date'],
            'to' => ['nullable', 'date', 'after_or_equal:from'],
            'limit' => ['nullable', 'integer', 'min:1', 'max:100'],
            'q' => ['nullable', 'string', 'max:200'],
            /** 一覧既定: `status` 未指定時に `canceled` を除く（ONETOONES-DELETE-POLICY-P1） */
            'exclude_canceled' => ['nullable', 'boolean'],
            /** 相手（target）側の絞り込み（Phase 303・SPEC-006 R2） */
            'target_workspace_id' => ['nullable', 'integer', 'exists:workspaces,id'],
            'target_group_name' => ['nullable', 'string', 'max:100'],
            'target_category_id' => ['nullable', 'integer', 'exists:categories,id'],
            /** 1: 他チャプター相手のみ（is_cross_chapter と同定義）／0: 自チャプター相手のみ */
            'cross_chapter' => ['nullable', 'boolean'],
        ];
    }
}
