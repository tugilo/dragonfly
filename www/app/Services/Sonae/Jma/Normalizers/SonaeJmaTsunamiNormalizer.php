<?php

namespace App\Services\Sonae\Jma\Normalizers;

class SonaeJmaTsunamiNormalizer extends AbstractSonaeJmaTypeNormalizer
{
    protected function typeCode(): string
    {
        return 'tsunami';
    }
}
