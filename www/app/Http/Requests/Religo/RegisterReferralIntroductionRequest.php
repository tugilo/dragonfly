<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;

class RegisterReferralIntroductionRequest extends FormRequest
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
            'from_member_id' => ['sometimes', 'integer', 'exists:members,id'],
            'to_member_id' => ['required', 'integer', 'exists:members,id', 'different:from_member_id'],
            'note' => ['sometimes', 'nullable', 'string'],
            'introduced_at' => ['sometimes', 'nullable', 'date'],
            'edited_snapshot' => ['sometimes', 'nullable', 'array'],
        ];
    }
}
