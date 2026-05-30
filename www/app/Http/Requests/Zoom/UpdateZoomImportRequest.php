<?php

namespace App\Http\Requests\Zoom;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateZoomImportRequest extends FormRequest
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
            'selected' => ['nullable', 'boolean'],
            'matched_member_id' => ['nullable', 'integer', 'exists:members,id'],
            'match_status' => ['nullable', 'string', Rule::in(['matched', 'new', 'unmatched', 'hold'])],
            'status' => ['nullable', 'string', Rule::in(['pending', 'held', 'skipped'])],
        ];
    }
}
