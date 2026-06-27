<?php

namespace App\Http\Requests\Api;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Validator;

class ResolveCrossChapterTargetRequest extends FormRequest
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
            'region_id' => ['nullable', 'integer', 'exists:regions,id'],
            'region_name' => ['nullable', 'string', 'max:255'],
            'workspace_id' => ['nullable', 'integer', 'exists:workspaces,id'],
            'workspace_name' => ['nullable', 'string', 'max:255'],
            'target_name' => ['required', 'string', 'max:255'],
        ];
    }

    public function withValidator(Validator $validator): void
    {
        $validator->after(function (Validator $v) {
            $hasRegion = $this->filled('region_id') || $this->filled('region_name');
            $hasWorkspace = $this->filled('workspace_id') || $this->filled('workspace_name');
            if (! $hasWorkspace) {
                $v->errors()->add('workspace_id', 'チャプターを選択するか、名前を入力してください。');
            }
            if (! $hasRegion && ! $this->filled('workspace_id')) {
                // workspace_name の手動登録時は region_name も推奨だが必須ではない
            }
        });
    }
}
