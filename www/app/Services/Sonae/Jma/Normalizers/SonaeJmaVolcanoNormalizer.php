<?php

namespace App\Services\Sonae\Jma\Normalizers;

class SonaeJmaVolcanoNormalizer extends AbstractSonaeJmaTypeNormalizer
{
    protected function typeCode(): string
    {
        return 'volcano';
    }
}
