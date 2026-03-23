<?php

namespace App\Http\Requests\Religo;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreOneToOneRequest extends FormRequest
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
            'workspace_id' => ['required', 'integer', 'exists:workspaces,id'],
            'owner_member_id' => ['required', 'integer', 'exists:members,id'],
            'target_member_id' => ['required', 'integer', 'exists:members,id'],
            'meeting_id' => ['nullable', 'integer', 'exists:meetings,id'],
            'status' => ['nullable', 'string', Rule::in(['planned', 'completed', 'canceled'])],
            'scheduled_at' => ['nullable', 'date'],
            'started_at' => ['nullable', 'date'],
            /**
             * `after:scheduled_at` は scheduled が空・形式差で誤 422 になり得るため、両方あるときだけ比較する。
             */
            'ended_at' => [
                'nullable',
                'date',
                function (string $attribute, mixed $value, \Closure $fail): void {
                    if ($value === null || $value === '') {
                        return;
                    }
                    $scheduled = $this->input('scheduled_at');
                    if ($scheduled === null || $scheduled === '') {
                        return;
                    }
                    $end = strtotime((string) $value);
                    $start = strtotime((string) $scheduled);
                    if ($end === false || $start === false) {
                        return;
                    }
                    if ($end <= $start) {
                        $fail('終了予定は開始予定より後の日時である必要があります。');
                    }
                },
            ],
            'notes' => ['nullable', 'string'],
        ];
    }
}
