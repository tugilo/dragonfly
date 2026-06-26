<?php

namespace App\Services\Sonae\Jma;

/**
 * SPEC-017 §9.7: JMA フィード取得（PoC は fixture、本番は HTTP アダプタ差替）。
 *
 * @return array{entries: list<array<string, mixed>>}
 */
interface SonaeJmaFeedProviderInterface
{
    public function fetch(): array;
}
