<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateMeetingBreakoutRoundsRequest extends FormRequest
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
            'rounds' => ['required', 'array'],
            'rounds.*.round_no' => ['required', 'integer', 'min:1'],
            'rounds.*.label' => ['nullable', 'string', 'max:100'],
            'rounds.*.rooms' => ['required', 'array'],
            'rounds.*.rooms.*.room_label' => ['required', 'string', Rule::in(['BO1', 'BO2'])],
            'rounds.*.rooms.*.notes' => ['nullable', 'string'],
            'rounds.*.rooms.*.member_ids' => ['array'],
            'rounds.*.rooms.*.member_ids.*' => ['integer', 'exists:members,id'],
        ];
    }
}
