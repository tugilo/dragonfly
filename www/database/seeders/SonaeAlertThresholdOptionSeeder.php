<?php

namespace Database\Seeders;

use App\Models\Sonae\SonaeAlertThresholdOption;
use App\Models\Sonae\SonaeAlertType;
use Illuminate\Database\Seeder;

/**
 * SPEC-017 §9.4 / §9.6: 発報条件 UI 閾値選択肢マスタ。
 */
class SonaeAlertThresholdOptionSeeder extends Seeder
{
    public function run(): void
    {
        $definitions = [
            'earthquake' => [
                ['code' => 'intensity_4_or_more', 'label' => '震度4以上', 'severity_rank' => 40, 'sort_order' => 10],
                ['code' => 'intensity_5_lower_or_more', 'label' => '震度5弱以上', 'severity_rank' => 50, 'sort_order' => 20],
                ['code' => 'intensity_5_upper_or_more', 'label' => '震度5強以上', 'severity_rank' => 55, 'sort_order' => 30],
                ['code' => 'intensity_6_lower_or_more', 'label' => '震度6弱以上', 'severity_rank' => 60, 'sort_order' => 40],
                ['code' => 'intensity_6_upper_or_more', 'label' => '震度6強以上', 'severity_rank' => 65, 'sort_order' => 50],
                ['code' => 'intensity_7', 'label' => '震度7', 'severity_rank' => 70, 'sort_order' => 60],
            ],
            'tsunami' => [
                ['code' => 'tsunami_advisory_or_more', 'label' => '津波注意報以上', 'severity_rank' => 10, 'sort_order' => 10],
                ['code' => 'tsunami_warning_or_more', 'label' => '津波警報以上', 'severity_rank' => 20, 'sort_order' => 20],
                ['code' => 'major_tsunami_warning', 'label' => '大津波警報のみ', 'severity_rank' => 30, 'sort_order' => 30],
            ],
            'heavy_rain' => [
                ['code' => 'heavy_rain_warning', 'label' => '大雨警報', 'severity_rank' => 10, 'sort_order' => 10],
                ['code' => 'heavy_rain_special_warning', 'label' => '大雨特別警報', 'severity_rank' => 20, 'sort_order' => 20],
            ],
            'flood' => [
                ['code' => 'flood_warning', 'label' => '洪水警報', 'severity_rank' => 10, 'sort_order' => 10],
            ],
            'landslide' => [
                ['code' => 'landslide_caution', 'label' => '土砂災害警戒情報', 'severity_rank' => 10, 'sort_order' => 10],
            ],
            'typhoon' => [
                ['code' => 'storm_warning', 'label' => '暴風警報', 'severity_rank' => 10, 'sort_order' => 10],
                ['code' => 'typhoon_approach', 'label' => '台風接近情報', 'severity_rank' => 5, 'sort_order' => 5],
            ],
            'heavy_snow' => [
                ['code' => 'heavy_snow_warning', 'label' => '大雪警報', 'severity_rank' => 10, 'sort_order' => 10],
                ['code' => 'heavy_snow_special_warning', 'label' => '大雪特別警報', 'severity_rank' => 20, 'sort_order' => 20],
            ],
            'volcano' => [
                ['code' => 'eruption_warning', 'label' => '噴火警報', 'severity_rank' => 10, 'sort_order' => 10],
                ['code' => 'eruption_flash', 'label' => '噴火速報', 'severity_rank' => 5, 'sort_order' => 5],
            ],
            'nankai_trough' => [
                ['code' => 'under_investigation', 'label' => '調査中', 'severity_rank' => 5, 'sort_order' => 10],
                ['code' => 'megaquake_attention', 'label' => '巨大地震注意', 'severity_rank' => 10, 'sort_order' => 20],
                ['code' => 'megaquake_warning', 'label' => '巨大地震警戒', 'severity_rank' => 20, 'sort_order' => 30],
            ],
        ];

        foreach ($definitions as $typeCode => $options) {
            $alertType = SonaeAlertType::query()->where('code', $typeCode)->first();
            if ($alertType === null) {
                continue;
            }

            foreach ($options as $option) {
                SonaeAlertThresholdOption::query()->updateOrCreate(
                    [
                        'alert_type_id' => $alertType->id,
                        'code' => $option['code'],
                    ],
                    [
                        'label' => $option['label'],
                        'severity_rank' => $option['severity_rank'],
                        'sort_order' => $option['sort_order'],
                        'is_active' => true,
                    ]
                );
            }
        }
    }
}
