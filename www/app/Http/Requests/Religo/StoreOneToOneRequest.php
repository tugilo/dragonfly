<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreOneToOneRequest extends FormRequest
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
            'workspace_id' => ['required', 'integer', 'exists:workspaces,id'],
            'owner_member_id' => ['required', 'integer', 'exists:members,id'],
            'target_member_id' => ['required', 'integer', 'exists:members,id'],
            'meeting_id' => ['nullable', 'integer', 'exists:meetings,id'],
            'status' => ['nullable', 'string', Rule::in(['planned', 'completed', 'canceled'])],
            'scheduled_at' => ['nullable', 'date'],
            'started_at' => ['nullable', 'date'],
            'ended_at' => ['nullable', 'date'],
            'notes' => ['nullable', 'string'],
        ];
    }
}
