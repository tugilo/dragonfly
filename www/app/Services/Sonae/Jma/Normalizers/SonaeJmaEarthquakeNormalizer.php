<?php

namespace App\Services\Sonae\Jma\Normalizers;

class SonaeJmaEarthquakeNormalizer extends AbstractSonaeJmaTypeNormalizer
{
    protected function typeCode(): string
    {
        return 'earthquake';
    }
}
