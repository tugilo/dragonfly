<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreIntroductionRequest extends FormRequest
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
            'from_member_id' => ['required', 'integer', 'exists:members,id'],
            'to_member_id' => ['required', 'integer', 'exists:members,id', 'different:from_member_id'],
            'meeting_id' => ['sometimes', 'nullable', 'integer', 'exists:meetings,id'],
            'note' => ['sometimes', 'nullable', 'string'],
            'introduced_at' => ['sometimes', 'nullable', 'date'],
            'workspace_id' => ['sometimes', 'nullable', 'integer', 'exists:workspaces,id'],
            'referral_kind' => ['sometimes', 'string', Rule::in(['external'])],
        ];
    }
}
