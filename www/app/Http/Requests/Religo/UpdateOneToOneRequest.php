<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateOneToOneRequest extends FormRequest
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
            'owner_member_id' => ['sometimes', 'integer', 'exists:members,id'],
            'target_member_id' => ['sometimes', 'integer', 'exists:members,id'],
            'meeting_id' => ['nullable', 'integer', 'exists:meetings,id'],
            'status' => ['sometimes', 'string', Rule::in(['planned', 'completed', 'canceled'])],
            'scheduled_at' => ['nullable', 'date'],
            'started_at' => ['nullable', 'date'],
            'ended_at' => ['nullable', 'date'],
            'notes' => ['nullable', 'string'],
        ];
    }
}
