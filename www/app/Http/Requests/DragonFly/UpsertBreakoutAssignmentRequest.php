<?php

namespace App\Http\Requests\DragonFly;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpsertBreakoutAssignmentRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation(): void
    {
        if ($this->input('session') === null && $this->getContent()) {
            $decoded = json_decode($this->getContent(), true);
            if (is_array($decoded)) {
                $this->merge($decoded);
            }
        }
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'session' => ['required', 'integer', Rule::in([1, 2])],
            'participant_id' => ['required', 'integer', 'exists:participants,id'],
            'room_label' => ['required', 'string', 'max:50'],
            'roommate_participant_ids' => ['nullable', 'array'],
            'roommate_participant_ids.*' => ['integer', 'exists:participants,id'],
        ];
    }
}
