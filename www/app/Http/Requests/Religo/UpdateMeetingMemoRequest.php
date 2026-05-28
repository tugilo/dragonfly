<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;

/**
 * PUT /api/meetings/{meetingId}/memo — 例会メモの保存. Phase M4.
 * body が空文字の場合はメモなし扱い（既存行削除）。
 */
class UpdateMeetingMemoRequest extends FormRequest
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
            'body' => ['nullable', 'string', 'max:10000'],
        ];
    }
}
