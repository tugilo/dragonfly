<?php

namespace App\Http\Requests\Religo;

use App\Support\MeetingDisplay;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Validator;

class StoreMeetingRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation(): void
    {
        if ($this->has('name') && is_string($this->input('name')) && trim($this->input('name')) === '') {
            $this->merge(['name' => null]);
        }

        if (! $this->has('session_type') || $this->input('session_type') === null || $this->input('session_type') === '') {
            $this->merge(['session_type' => MeetingDisplay::SESSION_CHAPTER_WEEKLY]);
        }
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'session_type' => ['required', 'string', Rule::in(MeetingDisplay::SESSION_TYPES)],
            'number' => [
                Rule::requiredIf(fn () => $this->isNumberedSession()),
                'nullable',
                'integer',
                'min:1',
                Rule::unique('meetings', 'number'),
                Rule::prohibitedIf(fn () => ! $this->isNumberedSession()),
            ],
            'held_on' => ['required', 'date'],
            'name' => ['nullable', 'string', 'max:255'],
        ];
    }

    public function withValidator(Validator $validator): void
    {
        $validator->after(function (Validator $validator): void {
            if ($validator->errors()->isNotEmpty()) {
                return;
            }

            if (! $this->isNumberedSession() && ($this->input('name') === null || trim((string) $this->input('name')) === '')) {
                // 番号なしイベントは name 未指定時に controller で既定名を付与
                return;
            }
        });
    }

    public function isNumberedSession(): bool
    {
        return MeetingDisplay::isNumberedSession((string) $this->input('session_type'));
    }
}
