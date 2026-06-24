<?php

namespace App\Services\Sonae\Jma\Normalizers;

class SonaeJmaFloodNormalizer extends AbstractSonaeJmaTypeNormalizer
{
    protected function typeCode(): string
    {
        return 'flood';
    }
}
