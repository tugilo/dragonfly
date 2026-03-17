<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;

/**
 * PUT /api/meetings/{meetingId}/participants/import/candidates
 * M7-P3-IMPLEMENT-1: 解析候補の保存。candidates のみ更新。空 name 行は保存時に除外。
 */
class UpdateParticipantImportCandidatesRequest extends FormRequest
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
            'candidates' => ['required', 'array'],
            'candidates.*.name' => ['nullable', 'string', 'max:255'],
            'candidates.*.raw_line' => ['nullable', 'string', 'max:1000'],
            'candidates.*.type_hint' => ['nullable', 'string', 'in:regular,guest,visitor,proxy'],
            'candidates.*.matched_member_id' => ['nullable', 'integer', 'exists:members,id'],
            'candidates.*.matched_member_name' => ['nullable', 'string', 'max:255'],
            'candidates.*.match_source' => ['nullable', 'string', 'in:auto,manual'],
        ];
    }
}
