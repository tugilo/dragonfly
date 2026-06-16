<?php

namespace App\Http\Requests\Religo;

use App\Models\Meeting;
use App\Support\MeetingDisplay;
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
        $meeting = Meeting::query()->find($meetingId);
        $sessionType = $meeting?->session_type ?? MeetingDisplay::SESSION_CHAPTER_WEEKLY;
        $isNumbered = MeetingDisplay::isNumberedSession($sessionType);

        return [
            'number' => [
                Rule::requiredIf(fn () => $isNumbered),
                'nullable',
                'integer',
                'min:1',
                Rule::unique('meetings', 'number')->ignore($meetingId),
                Rule::prohibitedIf(fn () => ! $isNumbered),
            ],
            'held_on' => ['required', 'date'],
            'name' => ['nullable', 'string', 'max:255'],
        ];
    }
}
