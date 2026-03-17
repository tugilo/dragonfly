<?php

namespace App\Services\Religo;

use App\Models\Meeting;
use App\Models\MeetingParticipantImport;
use App\Models\Member;
use App\Models\Participant;

/**
 * M7-P3-IMPLEMENT-2: 解析候補（candidates）を participants に反映する。
 * 全置換方式。type_hint を participants.type に変換。member は名前で検索 or 新規作成。
 */
class ApplyParticipantCandidatesService
{
    /** type_hint → participants.type（null/不明は regular） */
    private const PARTICIPANT_TYPE_MAP = [
        'regular' => 'regular',
        'guest' => 'guest',
        'visitor' => 'visitor',
        'proxy' => 'proxy',
    ];

    /** type_hint → members.type（新規作成時） */
    private const MEMBER_TYPE_MAP = [
        'regular' => 'member',
        'guest' => 'guest',
        'visitor' => 'visitor',
        'proxy' => 'member',
    ];

    /**
     * 候補を participants に反映する。既存 participants は削除してから candidates で作り直す。
     *
     * @return int 反映した participant 件数（同一 member は 1 件にまとめる）
     */
    public function apply(Meeting $meeting, MeetingParticipantImport $import): int
    {
        $candidates = $import->extracted_result['candidates'] ?? [];
        $candidates = array_values(array_filter($candidates, function ($c) {
            $name = isset($c['name']) ? trim((string) $c['name']) : '';

            return $name !== '';
        }));

        Participant::where('meeting_id', $meeting->id)->delete();

        foreach ($candidates as $c) {
            $name = trim((string) ($c['name'] ?? ''));
            if ($name === '') {
                continue;
            }
            $typeHint = $c['type_hint'] ?? null;
            if (! array_key_exists($typeHint ?? '', self::PARTICIPANT_TYPE_MAP)) {
                $typeHint = 'regular';
            }
            $participantType = self::PARTICIPANT_TYPE_MAP[$typeHint];
            $memberType = self::MEMBER_TYPE_MAP[$typeHint];

            $member = $this->resolveMemberForCandidate($c, $name, $memberType);

            Participant::updateOrCreate(
                [
                    'meeting_id' => $meeting->id,
                    'member_id' => $member->id,
                ],
                [
                    'type' => $participantType,
                    'introducer_member_id' => null,
                    'attendant_member_id' => null,
                ]
            );
        }

        $count = Participant::where('meeting_id', $meeting->id)->count();
        $import->update([
            'imported_at' => now(),
            'applied_count' => $count,
        ]);

        return $count;
    }

    /**
     * M7-P5: candidate.matched_member_id を優先し、なければ名前で検索 or 新規作成。
     */
    private function resolveMemberForCandidate(array $candidate, string $name, string $memberType): Member
    {
        $matchedId = isset($candidate['matched_member_id']) ? (int) $candidate['matched_member_id'] : null;
        if ($matchedId > 0) {
            $member = Member::find($matchedId);
            if ($member !== null) {
                return $member;
            }
        }

        return $this->resolveOrCreateMember($name, $memberType);
    }

    private function resolveOrCreateMember(string $name, string $memberType): Member
    {
        $member = Member::where('name', $name)->first();
        if ($member !== null) {
            return $member;
        }

        return Member::create([
            'name' => $name,
            'name_kana' => null,
            'category_id' => null,
            'type' => $memberType,
            'display_no' => null,
            'introducer_member_id' => null,
            'attendant_member_id' => null,
        ]);
    }
}
