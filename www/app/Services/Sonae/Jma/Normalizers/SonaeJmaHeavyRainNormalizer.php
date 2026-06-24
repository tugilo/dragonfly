<?php

namespace App\Services\Sonae\Jma\Normalizers;

class SonaeJmaHeavyRainNormalizer extends AbstractSonaeJmaTypeNormalizer
{
    protected function typeCode(): string
    {
        return 'heavy_rain';
    }
}
