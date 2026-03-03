<?php

namespace App\Http\Requests\DragonFly;

use Illuminate\Foundation\Http\FormRequest;

class UpsertContactFlagRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation(): void
    {
        $ownerId = $this->input('owner_member_id') ?? $this->query('owner_member_id');
        if ($ownerId !== null && $ownerId !== '') {
            $this->merge(['owner_member_id' => $ownerId]);
        }
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'owner_member_id' => ['required', 'integer', 'exists:members,id'],
            'interested' => ['nullable', 'boolean'],
            'want_1on1' => ['nullable', 'boolean'],
            'extra_status' => ['nullable', 'array'],
            'reason' => ['nullable', 'string', 'max:280'],
            'meeting_id' => ['nullable', 'integer', 'exists:meetings,id'],
            'meeting_number' => ['nullable', 'integer'],
        ];
    }
}
