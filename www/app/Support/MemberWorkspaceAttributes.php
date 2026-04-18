<?php

namespace App\Support;

use App\Models\Member;

/**
 * メンバーに紐づく workspace → region → country を API フラット項目に展開。
 */
final class MemberWorkspaceAttributes
{
    /**
     * @return array{
     *   workspace_id: int|null,
     *   workspace_name: string|null,
     *   region_id: int|null,
     *   region_name: string|null,
     *   country_id: int|null,
     *   country_name: string|null
     * }
     */
    public static function flatForMember(?Member $member): array
    {
        if ($member === null) {
            return [
                'workspace_id' => null,
                'workspace_name' => null,
                'region_id' => null,
                'region_name' => null,
                'country_id' => null,
                'country_name' => null,
            ];
        }

        $member->loadMissing('workspace.region.country');
        $ws = $member->workspace;
        $region = $ws?->region;
        $country = $region?->country;

        return [
            'workspace_id' => $member->workspace_id,
            'workspace_name' => $ws?->name,
            'region_id' => $ws?->region_id,
            'region_name' => $region?->name,
            'country_id' => $region?->country_id,
            'country_name' => $country?->name,
        ];
    }
}
