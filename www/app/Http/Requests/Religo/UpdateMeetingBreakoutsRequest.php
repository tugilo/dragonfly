<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Validator;

class UpdateMeetingBreakoutsRequest extends FormRequest
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
            'rooms' => ['required', 'array', 'size:2'],
            'rooms.*.room_label' => ['required', 'string', Rule::in(['BO1', 'BO2'])],
            'rooms.*.notes' => ['nullable', 'string'],
            'rooms.*.member_ids' => ['array'],
            'rooms.*.member_ids.*' => ['integer', 'exists:members,id'],
        ];
    }

    public function withValidator(Validator $validator): void
    {
        $validator->after(function (Validator $v) {
            $labels = array_column($this->input('rooms', []), 'room_label');
            sort($labels);
            if ($labels !== ['BO1', 'BO2']) {
                $v->errors()->add('rooms', 'rooms には BO1 と BO2 をそれぞれ1つずつ含めてください。');
            }
        });
    }
}
