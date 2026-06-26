<?php

namespace App\Services\Sonae\Jma\Normalizers;

class SonaeJmaHeavySnowNormalizer extends AbstractSonaeJmaTypeNormalizer
{
    protected function typeCode(): string
    {
        return 'heavy_snow';
    }
}
