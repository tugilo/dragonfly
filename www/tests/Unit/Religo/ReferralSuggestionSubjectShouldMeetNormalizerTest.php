<?php

namespace Tests\Unit\Religo;

use App\Services\Religo\ReferralSuggestionPayloadNormalizer;
use Illuminate\Support\Collection;
use PHPUnit\Framework\TestCase;

class ReferralSuggestionSubjectShouldMeetNormalizerTest extends TestCase
{
    public function test_parses_subject_should_meet_with_match_member(): void
    {
        $normalizer = new ReferralSuggestionPayloadNormalizer();
        $raw = json_encode([
            'suggestions' => [[
                'direction' => 'subject_should_meet',
                'corpus_source' => 'member_network',
                'summary' => '主役とペット保険担当をつなぐ',
                'rationale' => '121 #88 に紹介希望',
                'match_member_id' => 30,
                'source_one_to_one_id' => 88,
                'confidence' => 'high',
            ]],
        ], JSON_THROW_ON_ERROR);

        $parsed = $normalizer->parseOneToOneSuggestions(
            $raw,
            Collection::make([5, 20, 30]),
            5,
            20,
            true,
        );

        $this->assertCount(1, $parsed);
        $this->assertSame('subject_should_meet', $parsed[0]['direction']);
        $this->assertSame('member_network', $parsed[0]['corpus_source']);
        $this->assertSame(5, $parsed[0]['suggested_from_member_id']);
        $this->assertSame(30, $parsed[0]['suggested_to_member_id']);
        $this->assertSame(88, $parsed[0]['source_one_to_one_id']);
    }

    public function test_skips_via_connector_without_contact_label(): void
    {
        $normalizer = new ReferralSuggestionPayloadNormalizer();
        $raw = json_encode([
            'suggestions' => [[
                'direction' => 'via_connector',
                'connector_member_id' => 10,
                'suggested_to_member_id' => 5,
                'summary' => 'invalid',
            ]],
        ], JSON_THROW_ON_ERROR);

        $parsed = $normalizer->parseOneToOneSuggestions(
            $raw,
            Collection::make([5, 10]),
            5,
            20,
            true,
        );

        $this->assertCount(0, $parsed);
    }
}
