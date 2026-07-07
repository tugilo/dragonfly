<?php

namespace Tests\Unit\Religo;

use App\Services\Religo\ReferralConnectCopyPartyDefaults;
use PHPUnit\Framework\TestCase;

/**
 * SPEC-022: パーティ初期値マッピング — Phase 274.
 */
class ReferralConnectCopyPartyDefaultsTest extends TestCase
{
    public function test_via_connector_defaults_to_owner_and_connector(): void
    {
        $result = ReferralConnectCopyPartyDefaults::fromSuggestion([
            'direction' => 'via_connector',
            'suggested_from_member_id' => 12,
            'suggested_contact_label' => '社外B',
        ], 5, null);

        $this->assertSame(5, $result['party_a_member_id']);
        $this->assertSame(12, $result['party_b_member_id']);
        $this->assertNull($result['party_b_label']);
    }

    public function test_via_connector_with_contact_label_only(): void
    {
        $result = ReferralConnectCopyPartyDefaults::fromSuggestion([
            'direction' => 'via_connector',
            'suggested_contact_label' => '社外B',
        ], 5, null);

        $this->assertSame(5, $result['party_a_member_id']);
        $this->assertNull($result['party_b_member_id']);
        $this->assertSame('社外B', $result['party_b_label']);
    }

    public function test_subject_should_meet_defaults(): void
    {
        $result = ReferralConnectCopyPartyDefaults::fromSuggestion([
            'direction' => 'subject_should_meet',
            'suggested_to_member_id' => 20,
        ], 5, 8);

        $this->assertSame(8, $result['party_a_member_id']);
        $this->assertSame(20, $result['party_b_member_id']);
    }

    public function test_owner_to_target_with_label(): void
    {
        $result = ReferralConnectCopyPartyDefaults::fromSuggestion([
            'direction' => 'owner_to_target',
            'suggested_from_member_id' => 5,
            'suggested_to_label' => '建設会社',
        ], 5, null);

        $this->assertSame(5, $result['party_a_member_id']);
        $this->assertNull($result['party_b_member_id']);
        $this->assertSame('建設会社', $result['party_b_label']);
    }
}
