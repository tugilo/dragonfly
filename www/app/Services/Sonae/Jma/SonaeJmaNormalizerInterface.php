<?php

namespace App\Services\Sonae\Jma;

/**
 * JMA 取得エントリを AlertEvent 用に正規化する。
 */
interface SonaeJmaNormalizerInterface
{
    /**
     * @param  array<string, mixed>  $entry
     */
    public function supports(array $entry): bool;

    /**
     * @param  array<string, mixed>  $entry
     * @return array<string, mixed>|null
     */
    public function normalize(array $entry): ?array;
}
