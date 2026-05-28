<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateMeetingRequest extends FormRequest
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
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        $meetingId = (int) $this->route('meetingId');

        return [
            'number' => ['required', 'integer', Rule::unique('meetings', 'number')->ignore($meetingId)],
            'held_on' => ['required', 'date'],
            'name' => ['nullable', 'string', 'max:255'],
        ];
    }
}
