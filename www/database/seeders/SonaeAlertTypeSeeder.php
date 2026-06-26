<?php

namespace Database\Seeders;

use App\Models\Sonae\SonaeAlertType;
use Illuminate\Database\Seeder;

/**
 * SPEC-017 §9.3: 気象庁連携対象アラート種別マスタ。
 */
class SonaeAlertTypeSeeder extends Seeder
{
    public function run(): void
    {
        $types = [
            ['code' => 'earthquake', 'name' => '地震', 'sort_order' => 10],
            ['code' => 'tsunami', 'name' => '津波', 'sort_order' => 20],
            ['code' => 'heavy_rain', 'name' => '大雨', 'sort_order' => 30],
            ['code' => 'flood', 'name' => '洪水', 'sort_order' => 40],
            ['code' => 'landslide', 'name' => '土砂災害', 'sort_order' => 50],
            ['code' => 'typhoon', 'name' => '台風', 'sort_order' => 60],
            ['code' => 'heavy_snow', 'name' => '大雪', 'sort_order' => 70],
            ['code' => 'volcano', 'name' => '火山', 'sort_order' => 80],
            ['code' => 'nankai_trough', 'name' => '南海トラフ', 'sort_order' => 90],
        ];

        foreach ($types as $type) {
            SonaeAlertType::query()->updateOrCreate(
                ['code' => $type['code']],
                [
                    'name' => $type['name'],
                    'sort_order' => $type['sort_order'],
                    'is_active' => true,
                ]
            );
        }
    }
}
