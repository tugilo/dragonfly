<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Validator;

class UpdateInternalReferralRequest extends FormRequest
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
            'buyer_member_id' => ['sometimes', 'integer', 'exists:members,id'],
            'seller_member_id' => ['sometimes', 'integer', 'exists:members,id'],
            'summary' => ['sometimes', 'string', 'max:65535'],
            'closed_on' => ['sometimes', 'nullable', 'date'],
            'amount_yen' => ['sometimes', 'nullable', 'integer', 'min:0'],
            'notes' => ['sometimes', 'nullable', 'string'],
            'workspace_id' => ['sometimes', 'nullable', 'integer', 'exists:workspaces,id'],
        ];
    }

    public function withValidator(Validator $validator): void
    {
        $validator->after(function (Validator $v): void {
            $buyer = $this->input('buyer_member_id');
            $seller = $this->input('seller_member_id');
            if ($buyer !== null && $seller !== null && (int) $buyer === (int) $seller) {
                $v->errors()->add('seller_member_id', 'buyer_member_id と seller_member_id は異なる必要があります。');
            }
        });
    }
}
