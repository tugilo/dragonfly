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

    public function test_rejects_via_connector_when_connector_is_requester(): void
    {
        $normalizer = new ReferralSuggestionPayloadNormalizer();
        $raw = json_encode([
            'suggestions' => [[
                'direction' => 'via_connector',
                'corpus_source' => 'member_network',
                'summary' => '自分自身をつなぎ手にしている誤提案',
                'rationale' => '121 #110',
                'connector_member_id' => 5,
                'suggested_to_member_id' => 5,
                'suggested_contact_label' => 'AI 業務改善に興味のある企業',
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

        $this->assertSame([], $parsed);
    }

    public function test_rejects_via_connector_when_from_equals_to(): void
    {
        $normalizer = new ReferralSuggestionPayloadNormalizer();
        $raw = json_encode([
            'suggestions' => [[
                'direction' => 'via_connector',
                'corpus_source' => 'member_network',
                'summary' => 'from と to が同一の誤提案',
                'rationale' => '121 #110',
                'connector_member_id' => 10,
                'suggested_to_member_id' => 10,
                'suggested_contact_label' => '社外 B',
                'confidence' => 'medium',
            ]],
        ], JSON_THROW_ON_ERROR);

        $parsed = $normalizer->parseOneToOneSuggestions(
            $raw,
            Collection::make([5, 10]),
            5,
            20,
            true,
        );

        $this->assertSame([], $parsed);
    }

    public function test_non_connector_external_label_falls_back_from_contact_label(): void
    {
        $normalizer = new ReferralSuggestionPayloadNormalizer();
        $raw = json_encode([
            'suggestions' => [[
                'direction' => 'owner_to_target',
                'corpus_source' => 'self',
                'summary' => '社外候補',
                'rationale' => '議事録より',
                'suggested_from_member_id' => 5,
                'suggested_to_member_id' => null,
                'suggested_contact_label' => '補助金申請に関心のある企業',
                'confidence' => 'medium',
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
        $this->assertSame('補助金申請に関心のある企業', $parsed[0]['suggested_to_label']);
        $this->assertNull($parsed[0]['suggested_contact_label']);
    }
}
