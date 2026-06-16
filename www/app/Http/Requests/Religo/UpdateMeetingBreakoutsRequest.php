<?php

namespace App\Http\Requests\Religo;

use App\Services\Religo\MeetingBreakoutService;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Validator;

class UpdateMeetingBreakoutsRequest extends FormRequest
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
        $max = MeetingBreakoutService::MAX_BO_ROOMS;

        return [
            'rooms' => ['required', 'array', 'min:1', "max:{$max}"],
            'rooms.*.room_label' => ['required', 'string', 'regex:/^BO\d+$/'],
            'rooms.*.notes' => ['nullable', 'string'],
            'rooms.*.member_ids' => ['array'],
            'rooms.*.member_ids.*' => ['integer', 'exists:members,id'],
            // Connections: どの BO にも含まれないとき BO1 に自動追加（省略可・後方互換）
            'owner_member_id' => ['sometimes', 'nullable', 'integer', 'exists:members,id'],
        ];
    }

    public function withValidator(Validator $validator): void
    {
        $validator->after(function (Validator $v) {
            $rooms = $this->input('rooms', []);
            $labels = array_column($rooms, 'room_label');
            if (count($labels) !== count(array_unique($labels))) {
                $v->errors()->add('rooms', 'room_label が重複しています。');

                return;
            }

            $numbers = [];
            foreach ($labels as $label) {
                if (! MeetingBreakoutService::isManagedBoLabel((string) $label)) {
                    $v->errors()->add('rooms', 'room_label は BO1, BO2, … の形式にしてください。');

                    return;
                }
                $numbers[] = MeetingBreakoutService::boNumberFromLabel((string) $label);
            }

            sort($numbers);
            if ($numbers === [] || $numbers[0] !== 1) {
                $v->errors()->add('rooms', 'rooms は BO1 から始めてください。');

                return;
            }

            for ($i = 0; $i < count($numbers); $i++) {
                if ($numbers[$i] !== $i + 1) {
                    $v->errors()->add('rooms', 'rooms は BO1, BO2, … と連番で指定してください（欠番不可）。');

                    return;
                }
            }
        });
    }
}
