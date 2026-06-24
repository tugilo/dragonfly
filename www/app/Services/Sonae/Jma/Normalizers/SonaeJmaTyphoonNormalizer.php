<?php

namespace App\Services\Sonae\Jma\Normalizers;

class SonaeJmaTyphoonNormalizer extends AbstractSonaeJmaTypeNormalizer
{
    protected function typeCode(): string
    {
        return 'typhoon';
    }
}
