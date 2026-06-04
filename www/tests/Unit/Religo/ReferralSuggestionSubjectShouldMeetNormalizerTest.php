<?php

namespace Tests\Unit\Religo;

use App\Services\Religo\ReferralSuggestionPayloadNormalizer;
use Illuminate\Support\Collection;
use PHPUnit\Framework\TestCase;

class ReferralSuggestionSubjectShouldMeetNormalizerTest extends TestCase
{
    public function test_rejects_subject_should_meet_and_chapter_member_to_member(): void
    {
        $normalizer = new ReferralSuggestionPayloadNormalizer();
        $raw = json_encode([
            'suggestions' => [
                [
                    'direction' => 'subject_should_meet',
                    'summary' => '章内つなぐ',
                    'match_member_id' => 30,
                    'confidence' => 'high',
                ],
                [
                    'direction' => 'owner_to_target',
                    'summary' => 'メンバー同士',
                    'suggested_from_member_id' => 5,
                    'suggested_to_member_id' => 30,
                    'confidence' => 'medium',
                ],
                [
                    'direction' => 'via_connector',
                    'summary' => 'つなぎ手経由',
                    'connector_member_id' => 10,
                    'suggested_to_member_id' => 5,
                    'suggested_contact_label' => 'B 社',
                    'confidence' => 'high',
                ],
                [
                    'direction' => 'owner_to_target',
                    'summary' => '社外紹介',
                    'suggested_to_label' => '建設会社',
                    'confidence' => 'high',
                ],
            ],
        ], JSON_THROW_ON_ERROR);

        $parsed = $normalizer->parseOneToOneSuggestions(
            $raw,
            Collection::make([5, 10, 20, 30]),
            5,
            20,
            true,
        );

        $this->assertCount(2, $parsed);
        $this->assertSame('via_connector', $parsed[0]['direction']);
        $this->assertSame('owner_to_target', $parsed[1]['direction']);
        $this->assertNull($parsed[1]['suggested_to_member_id']);
        $this->assertSame('建設会社', $parsed[1]['suggested_to_label']);
    }
}
