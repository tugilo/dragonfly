<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Validator;

class StoreInternalReferralRequest extends FormRequest
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
            'buyer_member_id' => ['required', 'integer', 'exists:members,id'],
            'seller_member_id' => ['required', 'integer', 'exists:members,id'],
            'summary' => ['required', 'string', 'max:65535'],
            'closed_on' => ['sometimes', 'nullable', 'date'],
            'amount_yen' => ['sometimes', 'nullable', 'integer', 'min:0'],
            'notes' => ['sometimes', 'nullable', 'string'],
            'workspace_id' => ['sometimes', 'nullable', 'integer', 'exists:workspaces,id'],
        ];
    }

    public function withValidator(Validator $validator): void
    {
        $validator->after(function (Validator $v): void {
            if ((int) $this->input('buyer_member_id') === (int) $this->input('seller_member_id')) {
                $v->errors()->add('seller_member_id', 'buyer_member_id と seller_member_id は異なる必要があります。');
            }
        });
    }
}
