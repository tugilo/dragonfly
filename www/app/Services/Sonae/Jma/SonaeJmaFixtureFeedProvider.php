<?php

namespace App\Services\Sonae\Jma;

use Illuminate\Support\Facades\File;

/**
 * PoC: storage/app/sonae/jma/fixtures/*.json を読み込む。
 */
class SonaeJmaFixtureFeedProvider implements SonaeJmaFeedProviderInterface
{
    public function __construct(
        private readonly ?string $directory = null,
    ) {}

    public function fetch(): array
    {
        $dir = $this->directory ?? storage_path('app/sonae/jma/fixtures');
        if (! is_dir($dir)) {
            return ['entries' => []];
        }

        $entries = [];
        foreach (File::files($dir) as $file) {
            if ($file->getExtension() !== 'json') {
                continue;
            }
            $decoded = json_decode((string) file_get_contents($file->getPathname()), true);
            if (! is_array($decoded)) {
                continue;
            }
            $fileEntries = $decoded['entries'] ?? $decoded;
            if (! is_array($fileEntries)) {
                continue;
            }
            foreach ($fileEntries as $entry) {
                if (is_array($entry)) {
                    $entries[] = $entry;
                }
            }
        }

        return ['entries' => $entries];
    }
}
