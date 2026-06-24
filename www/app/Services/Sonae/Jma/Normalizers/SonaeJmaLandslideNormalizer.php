<?php

namespace App\Services\Sonae\Jma\Normalizers;

class SonaeJmaLandslideNormalizer extends AbstractSonaeJmaTypeNormalizer
{
    protected function typeCode(): string
    {
        return 'landslide';
    }
}
