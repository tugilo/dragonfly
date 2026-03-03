<?php

namespace App\Http\Requests\DragonFly;

use Illuminate\Foundation\Http\FormRequest;

class UpsertBreakoutMemoRequest extends FormRequest
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
            'participant_id' => ['required', 'integer', 'exists:participants,id'],
            'target_participant_id' => ['required', 'integer', 'exists:participants,id'],
            'body' => ['nullable', 'string'],
            'breakout_room_id' => ['nullable', 'integer', 'exists:breakout_rooms,id'],
        ];
    }
}
