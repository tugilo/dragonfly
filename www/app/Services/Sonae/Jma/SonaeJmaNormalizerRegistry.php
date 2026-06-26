<?php

namespace App\Services\Sonae\Jma;

class SonaeJmaNormalizerRegistry
{
    /**
     * @param  iterable<SonaeJmaNormalizerInterface>  $normalizers
     */
    public function __construct(
        private readonly iterable $normalizers,
    ) {}

    /**
     * @param  array<string, mixed>  $entry
     * @return array<string, mixed>|null
     */
    public function normalizeEntry(array $entry): ?array
    {
        foreach ($this->normalizers as $normalizer) {
            if (! $normalizer->supports($entry)) {
                continue;
            }

            return $normalizer->normalize($entry);
        }

        return null;
    }
}
