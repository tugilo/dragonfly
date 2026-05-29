<?php

namespace App\Http\Requests\Zoom;

use Illuminate\Foundation\Http\FormRequest;

class ZoomSyncRequest extends FormRequest
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
            'past_days' => ['nullable', 'integer', 'min:0', 'max:120'],
            'upcoming_days' => ['nullable', 'integer', 'min:0', 'max:90'],
        ];
    }
}
