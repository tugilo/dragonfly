<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;

class PatchReferralCorpusSettingsRequest extends FormRequest
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
            'allow_cross_corpus_contribution' => ['sometimes', 'boolean'],
        ];
    }
}
