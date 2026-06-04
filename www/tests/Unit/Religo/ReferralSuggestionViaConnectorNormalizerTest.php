<?php

namespace Tests\Unit\Religo;

use App\Services\Religo\ReferralSuggestionPayloadNormalizer;
use Illuminate\Support\Collection;
use PHPUnit\Framework\TestCase;

class ReferralSuggestionViaConnectorNormalizerTest extends TestCase
{
    public function test_parses_via_connector_with_requester_as_to(): void
    {
        $normalizer = new ReferralSuggestionPayloadNormalizer();
        $raw = json_encode([
            'suggestions' => [[
                'direction' => 'via_connector',
                'corpus_source' => 'member_network',
                'summary' => 'A に B 紹介を依頼',
                'rationale' => '121 #99',
                'connector_member_id' => 10,
                'suggested_to_member_id' => 5,
                'suggested_contact_label' => 'B 社 田中',
                'confidence' => 'high',
            ]],
        ], JSON_THROW_ON_ERROR);

        $parsed = $normalizer->parseOneToOneSuggestions(
            $raw,
            Collection::make([5, 10]),
            5,
            20,
            true,
        );

        $this->assertCount(1, $parsed);
        $this->assertSame('via_connector', $parsed[0]['direction']);
        $this->assertSame('member_network', $parsed[0]['corpus_source']);
        $this->assertSame(10, $parsed[0]['suggested_from_member_id']);
        $this->assertSame(5, $parsed[0]['suggested_to_member_id']);
        $this->assertSame('B 社 田中', $parsed[0]['suggested_contact_label']);
    }
}
