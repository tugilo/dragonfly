<?php

namespace App\Services\Religo;

use App\Models\Country;
use App\Models\Member;
use App\Models\Region;
use App\Models\Workspace;
use Illuminate\Support\Facades\DB;

/**
 * BNI リージョン・チャプター（workspace）マスタの冪等シード。SPEC-021。
 *
 * 東京 N.E.リージョンの公式チャプターをシードし、既存の他リージョン所属チャプター
 * （大人なじみ＝東京南、クリエーションズ＝千葉セントラル等）には正しいリージョンを付与する。
 * NE 以外を一律 NE に紐付けることはしない。
 *
 * @see docs/SSOT/REGION_CHAPTER_MASTER_CROSS_CHAPTER_1TO1_REQUIREMENTS.md
 */
final class TokyoNeRegionChapterSeedService
{
    public const COUNTRY_NAME = 'Japan';

    public const REGION_NAME = 'BNI 東京 N.E.リージョン';

    /**
     * 東京 N.E.リージョン公式チャプター（slug は canonical）。aliases は既存 DB slug の突合用。
     *
     * @var list<array{name: string, slug: string, aliases: list<string>}>
     */
    public const CHAPTERS = [
        ['name' => 'TRES STELLAS', 'slug' => 'bni_tres_stellas', 'aliases' => ['bni_trestella']],
        ['name' => 'PASSIONE', 'slug' => 'bni_passione', 'aliases' => []],
        ['name' => 'DragonFly', 'slug' => 'bni_dragonfly', 'aliases' => ['default']],
        ['name' => 'BRIDGET', 'slug' => 'bni_bridget', 'aliases' => []],
        ['name' => 'KerNel', 'slug' => 'bni_kernel', 'aliases' => []],
        ['name' => 'Tifonet', 'slug' => 'bni_tifonet', 'aliases' => []],
        ['name' => 'Confioir', 'slug' => 'bni_confioir', 'aliases' => []],
        ['name' => 'EAGLE', 'slug' => 'bni_eagle', 'aliases' => []],
        ['name' => 'SILVIS', 'slug' => 'bni_silvis', 'aliases' => []],
        ['name' => 'DIANA', 'slug' => 'bni_diana', 'aliases' => []],
        ['name' => 'TRINITY', 'slug' => 'bni_trinity', 'aliases' => []],
        ['name' => 'LAPIS', 'slug' => 'bni_lapis', 'aliases' => []],
        ['name' => 'SPREAD', 'slug' => 'bni_spread', 'aliases' => []],
        ['name' => 'ETOILE', 'slug' => 'bni_etoile', 'aliases' => []],
        ['name' => 'OuVrir', 'slug' => 'bni_ouvrir', 'aliases' => []],
        ['name' => 'VORTEX', 'slug' => 'bni_vortex', 'aliases' => []],
        ['name' => 'ThunderVolt', 'slug' => 'bni_thundervolt', 'aliases' => []],
        ['name' => 'Reverie', 'slug' => 'bni_reverie', 'aliases' => []],
        ['name' => 'IMPROVE', 'slug' => 'bni_improve', 'aliases' => []],
        ['name' => 'bonheur', 'slug' => 'bni_bonheur', 'aliases' => []],
        ['name' => 'Abundance', 'slug' => 'bni_abundance', 'aliases' => []],
        ['name' => 'GRANDIR', 'slug' => 'bni_grandir', 'aliases' => []],
        ['name' => 'NATION DRIVE', 'slug' => 'bni_nation_drive', 'aliases' => []],
        ['name' => 'LUMINOUS', 'slug' => 'bni_luminous', 'aliases' => []],
        ['name' => 'EduTech', 'slug' => 'bni_edutech', 'aliases' => []],
    ];

    /**
     * NE 以外で既に DB に存在する（または 1to1 相手として使われている）チャプターの正しいリージョン。
     * 公式サイトで確認した所属に従う。
     *
     * @var list<array{region_name: string, chapters: list<array{name: string, slug: string, aliases: list<string>}>}>
     */
    public const OTHER_REGIONS = [
        [
            'region_name' => 'BNI 東京南リージョン',
            'chapters' => [
                ['name' => '大人なじみ', 'slug' => 'bni_otona_najimi', 'aliases' => []],
            ],
        ],
        [
            'region_name' => 'BNI 静岡セントラルリージョン',
            'chapters' => [
                ['name' => 'インフィニティ', 'slug' => 'bni_infinity', 'aliases' => []],
            ],
        ],
        [
            'region_name' => 'BNI 千葉セントラルリージョン',
            'chapters' => [
                ['name' => 'クリエーションズ', 'slug' => 'bni_creations', 'aliases' => []],
            ],
        ],
    ];

    /**
     * 既存121相手のうち、ユーザー確認済みの所属チャプター。
     *
     * @var list<array{tokens: list<string>, workspace_slug: string}>
     */
    public const MEMBER_WORKSPACE_ASSIGNMENTS = [
        ['tokens' => ['古屋', '周治'], 'workspace_slug' => 'bni_infinity'],
        ['tokens' => ['門松', '直幸'], 'workspace_slug' => 'bni_edutech'],
    ];

    /**
     * @return array{country_id: int, region_id: int, created: int, updated: int, other_regions: int, other_chapters: int, member_assignments: int}
     */
    public function run(): array
    {
        return DB::transaction(function () {
            $country = Country::query()->firstOrCreate(
                ['name' => self::COUNTRY_NAME],
                ['name' => self::COUNTRY_NAME]
            );
            $neRegion = $this->ensureRegion($country->id, self::REGION_NAME);

            $created = 0;
            $updated = 0;
            foreach (self::CHAPTERS as $chapter) {
                $this->upsertChapter($chapter, $neRegion->id, $created, $updated);
            }

            $otherRegionsCount = 0;
            $otherChaptersCount = 0;
            foreach (self::OTHER_REGIONS as $group) {
                $region = $this->ensureRegion($country->id, $group['region_name']);
                $otherRegionsCount++;
                foreach ($group['chapters'] as $chapter) {
                    $c = 0;
                    $u = 0;
                    $this->upsertChapter($chapter, $region->id, $c, $u);
                    $otherChaptersCount += $c + $u;
                }
            }
            $memberAssignments = $this->assignKnownMembersToWorkspaces();

            return [
                'country_id' => $country->id,
                'region_id' => $neRegion->id,
                'created' => $created,
                'updated' => $updated,
                'other_regions' => $otherRegionsCount,
                'other_chapters' => $otherChaptersCount,
                'member_assignments' => $memberAssignments,
            ];
        });
    }

    private function ensureRegion(int $countryId, string $name): Region
    {
        return Region::query()->firstOrCreate(
            ['country_id' => $countryId, 'name' => $name],
            ['country_id' => $countryId, 'name' => $name]
        );
    }

    /**
     * @param  array{name: string, slug: string, aliases: list<string>}  $chapter
     */
    private function upsertChapter(array $chapter, int $regionId, int &$created, int &$updated): void
    {
        $workspace = $this->findExistingWorkspace($chapter);
        if ($workspace === null) {
            Workspace::query()->create([
                'name' => $chapter['name'],
                'slug' => $chapter['slug'],
                'region_id' => $regionId,
            ]);
            $created++;

            return;
        }

        $dirty = false;
        if ($workspace->name !== $chapter['name']) {
            $workspace->name = $chapter['name'];
            $dirty = true;
        }
        if ($workspace->region_id !== $regionId) {
            $workspace->region_id = $regionId;
            $dirty = true;
        }
        if ($dirty) {
            $workspace->save();
            $updated++;
        }
    }

    /**
     * @param  array{name: string, slug: string, aliases: list<string>}  $chapter
     */
    private function findExistingWorkspace(array $chapter): ?Workspace
    {
        $slugs = array_unique(array_merge([$chapter['slug']], $chapter['aliases']));

        return Workspace::query()->whereIn('slug', $slugs)->orderBy('id')->first();
    }

    private function assignKnownMembersToWorkspaces(): int
    {
        $updated = 0;

        foreach (self::MEMBER_WORKSPACE_ASSIGNMENTS as $assignment) {
            $workspace = Workspace::query()->where('slug', $assignment['workspace_slug'])->first();
            if ($workspace === null) {
                continue;
            }

            $query = Member::query();
            foreach ($assignment['tokens'] as $token) {
                $query->where('name', 'like', '%'.$token.'%');
            }

            foreach ($query->get() as $member) {
                if ((int) $member->workspace_id === (int) $workspace->id) {
                    continue;
                }
                $member->workspace_id = $workspace->id;
                $member->save();
                $updated++;
            }
        }

        return $updated;
    }
}
