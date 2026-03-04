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
        ];
    }
}
