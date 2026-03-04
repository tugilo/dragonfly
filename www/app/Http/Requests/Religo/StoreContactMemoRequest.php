<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreContactMemoRequest extends FormRequest
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
        $memoType = $this->input('memo_type', 'other');

        return [
            'owner_member_id' => ['required', 'integer', 'exists:members,id'],
            'target_member_id' => ['required', 'integer', 'exists:members,id'],
            'workspace_id' => ['nullable', 'integer', 'exists:workspaces,id'],
            'memo_type' => ['nullable', 'string', Rule::in(['meeting', 'one_to_one', 'introduction', 'other'])],
            'body' => ['required', 'string', 'min:1', 'max:2000'],
            'meeting_id' => [
                'nullable',
                'integer',
                'exists:meetings,id',
                Rule::requiredIf($memoType === 'meeting'),
            ],
            'one_to_one_id' => [
                'nullable',
                'integer',
                'exists:one_to_ones,id',
                Rule::requiredIf($memoType === 'one_to_one'),
            ],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'meeting_id.required_if' => 'memo_type が meeting のとき meeting_id は必須です。',
            'one_to_one_id.required_if' => 'memo_type が one_to_one のとき one_to_one_id は必須です。',
        ];
    }
}
