<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;

class IndexInternalReferralsRequest extends FormRequest
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
            'limit' => ['sometimes', 'integer', 'min:1', 'max:100'],
        ];
    }
}
