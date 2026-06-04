<?php

namespace App\Http\Requests\Religo;

use App\Models\MeetingReferralSuggestion;
use App\Models\OneToOneReferralSuggestion;
use Illuminate\Foundation\Http\FormRequest;

class PatchReferralSuggestionRequest extends FormRequest
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
        $statuses = [
            OneToOneReferralSuggestion::STATUS_PENDING,
            OneToOneReferralSuggestion::STATUS_ACCEPTED,
            OneToOneReferralSuggestion::STATUS_DISMISSED,
            OneToOneReferralSuggestion::STATUS_DEFERRED,
            MeetingReferralSuggestion::STATUS_PENDING,
            MeetingReferralSuggestion::STATUS_ACCEPTED,
            MeetingReferralSuggestion::STATUS_DISMISSED,
            MeetingReferralSuggestion::STATUS_DEFERRED,
        ];

        return [
            'status' => ['sometimes', 'string', 'in:'.implode(',', array_unique($statuses))],
            'edited_snapshot' => ['sometimes', 'nullable', 'array'],
        ];
    }
}
