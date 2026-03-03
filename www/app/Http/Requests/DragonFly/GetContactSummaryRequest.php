<?php

namespace App\Http\Requests\DragonFly;

use Illuminate\Foundation\Http\FormRequest;

class GetContactSummaryRequest extends FormRequest
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
            'limit_memos' => ['nullable', 'integer', 'min:1', 'max:10'],
            'meeting_number' => ['nullable', 'integer', 'exists:meetings,number'],
        ];
    }
}
