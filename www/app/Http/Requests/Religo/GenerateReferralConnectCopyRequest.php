<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Validator;

class GenerateReferralConnectCopyRequest extends FormRequest
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
            'party_a_member_id' => ['required', 'integer', 'exists:members,id'],
            'party_b_member_id' => ['sometimes', 'nullable', 'integer', 'exists:members,id'],
            'party_b_label' => ['sometimes', 'nullable', 'string', 'max:500'],
            'channel_hint' => ['sometimes', 'nullable', 'string', 'in:messenger,line,email'],
        ];
    }

    public function withValidator(Validator $validator): void
    {
        $validator->after(function (Validator $v): void {
            $bId = $this->input('party_b_member_id');
            $bLabel = trim((string) ($this->input('party_b_label') ?? ''));
            $aId = $this->input('party_a_member_id');

            if (($bId === null || $bId === '') && $bLabel === '') {
                $v->errors()->add('party_b_member_id', 'パーティ B はメンバー ID または自由テキストのいずれかを指定してください。');
            }

            if ($bId !== null && $bId !== '' && $bLabel !== '') {
                $v->errors()->add('party_b_member_id', 'party_b_member_id と party_b_label は同時に指定できません。');
            }

            if ($bId !== null && $bId !== '' && $aId !== null && (int) $bId === (int) $aId) {
                $v->errors()->add('party_b_member_id', 'パーティ A と B に同じメンバーを指定できません。');
            }
        });
    }
}
