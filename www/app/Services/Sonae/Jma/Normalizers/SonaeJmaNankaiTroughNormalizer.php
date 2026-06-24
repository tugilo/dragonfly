<?php

namespace App\Services\Sonae\Jma\Normalizers;

class SonaeJmaNankaiTroughNormalizer extends AbstractSonaeJmaTypeNormalizer
{
    protected function typeCode(): string
    {
        return 'nankai_trough';
    }
}
