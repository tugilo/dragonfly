<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;

/**
 * GET /api/contact-memos のクエリ. Phase17A. owner/target 必須、limit 任意.
 */
class IndexContactMemosRequest extends FormRequest
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
            'owner_member_id' => ['required', 'integer', 'exists:members,id'],
            'target_member_id' => ['required', 'integer', 'exists:members,id'],
            'limit' => ['nullable', 'integer', 'min:1', 'max:100'],
        ];
    }
}
