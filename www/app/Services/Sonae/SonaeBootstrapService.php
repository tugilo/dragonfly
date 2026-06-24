<?php

namespace App\Services\Sonae;

use App\Models\Member;
use App\Models\Sonae\SonaeAlertType;
use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeChapterAlertSetting;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeJmaFetchSetting;
use App\Models\Sonae\SonaeLineAccount;
use App\Models\Sonae\SonaeMember;
use App\Models\Sonae\SonaeOrganization;
use App\Models\Workspace;
use Illuminate\Support\Str;

/**
 * SPEC-017: Religo workspace から SONAE チャプターをブートストラップする。
 */
class SonaeBootstrapService
{
    public function __construct(
        private readonly SonaeMemberSyncService $memberSync,
    ) {}

    /**
     * @return array{organization: SonaeOrganization, chapter: SonaeChapter, members_synced: int}
     */
    public function bootstrapFromWorkspace(Workspace $workspace, ?string $prefecture = null): array
    {
        $organization = SonaeOrganization::query()->firstOrCreate(
            [
                'source_system' => SonaeConstants::SOURCE_RELIGO,
                'external_id' => 'bni',
            ],
            [
                'name' => 'BNI Japan',
                'status' => SonaeConstants::STATUS_ACTIVE,
            ]
        );

        $chapterKey = Str::slug($workspace->slug ?: $workspace->name, '_');

        $chapter = SonaeChapter::query()->updateOrCreate(
            [
                'source_system' => SonaeConstants::SOURCE_RELIGO,
                'external_id' => (string) $workspace->id,
            ],
            [
                'organization_id' => $organization->id,
                'name' => $workspace->name,
                'code' => strtoupper($chapterKey),
                'chapter_key' => $chapterKey,
                'prefecture' => $prefecture,
                'status' => SonaeConstants::STATUS_ACTIVE,
            ]
        );

        $this->ensureDefaultSettings($chapter);

        $syncResult = $this->memberSync->syncChapterFromReligo($chapter, $workspace);

        return [
            'organization' => $organization,
            'chapter' => $chapter,
            'members_synced' => $syncResult['synced'],
        ];
    }

    public function findDragonFlyWorkspace(): ?Workspace
    {
        return Workspace::query()
            ->where('slug', 'bni_dragonfly')
            ->orWhere('name', 'DragonFly')
            ->orderBy('id')
            ->first();
    }

    private function ensureDefaultSettings(SonaeChapter $chapter): void
    {
        SonaeLineAccount::query()->firstOrCreate(
            ['chapter_id' => $chapter->id],
            [
                'channel_id' => '',
                'status' => SonaeConstants::STATUS_INACTIVE,
            ]
        );

        SonaeAlertType::query()
            ->where('is_active', true)
            ->orderBy('sort_order')
            ->each(function (SonaeAlertType $alertType) use ($chapter) {
                SonaeChapterAlertSetting::query()->firstOrCreate(
                    [
                        'chapter_id' => $chapter->id,
                        'alert_type_id' => $alertType->id,
                    ],
                    [
                        'is_enabled' => false,
                        'target_prefectures' => $chapter->prefecture ? [$chapter->prefecture] : [],
                    ]
                );
            });

        if (SonaeJmaFetchSetting::query()->doesntExist()) {
            SonaeJmaFetchSetting::query()->create([
                'is_enabled' => false,
                'interval_minutes' => 5,
            ]);
        }
    }
}
