<?php

namespace App\Http\Requests\Zoom;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class CreateZoomImportMemberRequest extends FormRequest
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
            'name' => ['required', 'string', 'max:255'],
            'name_kana' => ['nullable', 'string', 'max:255'],
            'type' => ['nullable', 'string', Rule::in(['member', 'active', 'inactive', 'visitor', 'guest'])],
            'workspace_id' => ['nullable', 'integer', 'exists:workspaces,id'],
            'force' => ['nullable', 'boolean'],
        ];
    }
}
