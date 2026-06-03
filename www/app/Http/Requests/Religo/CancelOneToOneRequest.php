<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class CancelOneToOneRequest extends FormRequest
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
            'cancel_reason' => [
                'required',
                'string',
                Rule::in(['owner_convenience', 'target_convenience', 'other']),
            ],
            'cancel_remark' => [
                'nullable',
                'string',
                'min:1',
                Rule::requiredIf(fn () => $this->input('cancel_reason') === 'other'),
            ],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'cancel_remark.required' => 'その他を選んだ場合は備考が必須です。',
        ];
    }
}
