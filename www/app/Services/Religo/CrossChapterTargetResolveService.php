<?php

namespace App\Services\Religo;

use App\Models\Country;
use App\Models\Member;
use App\Models\Region;
use App\Models\Workspace;
use Illuminate\Support\Str;

/**
 * 他チャプター 1to1 相手のリージョン・チャプター・名前から members 行を解決（作成含む）。SPEC-021 T4。
 */
final class CrossChapterTargetResolveService
{
    /**
     * @param  array{
     *   region_id?: int|null,
     *   region_name?: string|null,
     *   workspace_id?: int|null,
     *   workspace_name?: string|null,
     *   target_name: string
     * }  $input
     * @return array{
     *   target_member_id: int,
     *   region_id: int|null,
     *   region_name: string|null,
     *   workspace_id: int,
     *   workspace_name: string,
     *   target_name: string,
     *   created_region: bool,
     *   created_workspace: bool,
     *   created_member: bool
     * }
     */
    public function resolve(array $input): array
    {
        $targetName = trim($input['target_name']);
        if ($targetName === '') {
            throw new \InvalidArgumentException('相手の名前は必須です。');
        }

        $createdRegion = false;
        $createdWorkspace = false;

        $region = $this->resolveRegion(
            isset($input['region_id']) ? (int) $input['region_id'] : null,
            isset($input['region_name']) ? trim((string) $input['region_name']) : null,
            $createdRegion
        );

        $workspace = $this->resolveWorkspace(
            $region,
            isset($input['workspace_id']) ? (int) $input['workspace_id'] : null,
            isset($input['workspace_name']) ? trim((string) $input['workspace_name']) : null,
            $createdWorkspace
        );

        $memberResult = $this->resolveMember($targetName, $workspace->id);

        return [
            'target_member_id' => $memberResult['member']->id,
            'region_id' => $region?->id,
            'region_name' => $region?->name,
            'workspace_id' => $workspace->id,
            'workspace_name' => $workspace->name,
            'target_name' => $memberResult['member']->name,
            'created_region' => $createdRegion,
            'created_workspace' => $createdWorkspace,
            'created_member' => $memberResult['created_member'],
        ];
    }

    private function resolveRegion(?int $regionId, ?string $regionName, bool &$created): ?Region
    {
        $created = false;
        if ($regionId !== null && $regionId > 0) {
            $region = Region::query()->find($regionId);
            if ($region === null) {
                throw new \InvalidArgumentException('指定のリージョンが見つかりません。');
            }

            return $region;
        }

        if ($regionName === null || $regionName === '') {
            return null;
        }

        $country = Country::query()->firstOrCreate(
            ['name' => TokyoNeRegionChapterSeedService::COUNTRY_NAME],
            ['name' => TokyoNeRegionChapterSeedService::COUNTRY_NAME]
        );

        $region = Region::query()->firstOrCreate(
            ['country_id' => $country->id, 'name' => $regionName],
            ['country_id' => $country->id, 'name' => $regionName]
        );
        $created = $region->wasRecentlyCreated;

        return $region;
    }

    private function resolveWorkspace(?Region $region, ?int $workspaceId, ?string $workspaceName, bool &$created): Workspace
    {
        $created = false;
        if ($workspaceId !== null && $workspaceId > 0) {
            $workspace = Workspace::query()->find($workspaceId);
            if ($workspace === null) {
                throw new \InvalidArgumentException('指定のチャプターが見つかりません。');
            }
            if ($region !== null && $workspace->region_id !== null && (int) $workspace->region_id !== (int) $region->id) {
                throw new \InvalidArgumentException('チャプターが選択したリージョンに属していません。');
            }

            return $workspace;
        }

        if ($workspaceName === null || $workspaceName === '') {
            throw new \InvalidArgumentException('チャプターを選択するか、名前を入力してください。');
        }

        $slug = $this->uniqueWorkspaceSlug($workspaceName);

        $workspace = Workspace::query()->firstOrCreate(
            ['slug' => $slug],
            [
                'name' => $workspaceName,
                'slug' => $slug,
                'region_id' => $region?->id,
            ]
        );
        $created = $workspace->wasRecentlyCreated;

        return $workspace;
    }

    /**
     * @return array{member: Member, created_member: bool}
     */
    private function resolveMember(string $targetName, int $workspaceId): array
    {
        $existing = Member::query()
            ->where('workspace_id', $workspaceId)
            ->where('name', $targetName)
            ->orderBy('id')
            ->first();

        if ($existing !== null) {
            return [
                'member' => $existing,
                'created_member' => false,
            ];
        }

        // 他チャプターの相手はリージョン・チャプターを選んで登録する別チャプター BNI 会員のため、
        // 在籍メンバー扱いの type にする（visitor/guest にすると「BNI会員以外」バッジが付く）。
        $member = Member::query()->create([
            'name' => $targetName,
            'type' => 'member',
            'workspace_id' => $workspaceId,
        ]);

        return [
            'member' => $member,
            'created_member' => true,
        ];
    }

    private function uniqueWorkspaceSlug(string $name): string
    {
        $base = Str::slug($name);
        if ($base === '') {
            $base = 'chapter_'.substr(md5($name), 0, 8);
        }
        $slug = 'bni_'.$base;
        $candidate = $slug;
        $i = 2;
        while (Workspace::query()->where('slug', $candidate)->exists()) {
            $candidate = $slug.'_'.$i;
            $i++;
        }

        return $candidate;
    }
}
