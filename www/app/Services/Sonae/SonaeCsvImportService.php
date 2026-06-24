<?php

namespace App\Services\Sonae;

use App\Models\Sonae\SonaeChapter;
use App\Models\Sonae\SonaeConstants;
use App\Models\Sonae\SonaeMember;
use Illuminate\Support\Facades\DB;
use InvalidArgumentException;

/**
 * SPEC-017: SONAE 単体利用向け CSV 名簿取込。
 */
class SonaeCsvImportService
{
    /** @var list<string> */
    public const REQUIRED_HEADERS = ['name'];

    /** @var list<string> */
    public const OPTIONAL_HEADERS = ['name_kana', 'email', 'phone', 'category', 'role_label'];

    /**
     * @return list<array<string, string|null>>
     */
    public function parse(string $csvContent): array
    {
        $csvContent = trim($csvContent);
        if ($csvContent === '') {
            throw new InvalidArgumentException('CSV content is empty.');
        }

        $lines = preg_split('/\r\n|\r|\n/', $csvContent) ?: [];
        if ($lines === []) {
            throw new InvalidArgumentException('CSV content is empty.');
        }

        $headerLine = array_shift($lines);
        $headers = str_getcsv($headerLine ?? '');
        $headers = array_map(static fn ($h) => trim(strtolower((string) $h)), $headers);

        foreach (self::REQUIRED_HEADERS as $required) {
            if (! in_array($required, $headers, true)) {
                throw new InvalidArgumentException("Missing required CSV header: {$required}");
            }
        }

        $rows = [];
        foreach ($lines as $lineNumber => $line) {
            if (trim($line) === '') {
                continue;
            }

            $values = str_getcsv($line);
            $row = [];
            foreach ($headers as $index => $header) {
                $row[$header] = isset($values[$index]) ? trim($values[$index]) : null;
            }
            $row['_line'] = (string) ($lineNumber + 2);
            $rows[] = $row;
        }

        return $rows;
    }

    /**
     * @param  list<array<string, string|null>>  $rows
     * @return array{valid: list<array<string, mixed>>, errors: list<array<string, mixed>>}
     */
    public function validateRows(array $rows): array
    {
        $valid = [];
        $errors = [];

        foreach ($rows as $row) {
            $line = $row['_line'] ?? '?';
            $name = trim((string) ($row['name'] ?? ''));

            if ($name === '') {
                $errors[] = [
                    'line' => $line,
                    'message' => 'name is required',
                ];

                continue;
            }

            $valid[] = [
                'line' => $line,
                'name' => $name,
                'name_kana' => $this->nullableString($row['name_kana'] ?? null),
                'email' => $this->nullableString($row['email'] ?? null),
                'phone' => $this->nullableString($row['phone'] ?? null),
                'category' => $this->nullableString($row['category'] ?? null),
                'role_label' => $this->nullableString($row['role_label'] ?? null),
            ];
        }

        return ['valid' => $valid, 'errors' => $errors];
    }

    /**
     * @param  list<array<string, mixed>>  $validRows
     * @return array{imported: int, updated: int}
     */
    public function importValidRows(SonaeChapter $chapter, array $validRows): array
    {
        $imported = 0;
        $updated = 0;

        DB::transaction(function () use ($chapter, $validRows, &$imported, &$updated) {
            foreach ($validRows as $row) {
                $existing = SonaeMember::query()
                    ->where('chapter_id', $chapter->id)
                    ->where('source_system', SonaeConstants::SOURCE_SONAE)
                    ->where('name', $row['name'])
                    ->when(
                        ! empty($row['email']),
                        fn ($q) => $q->where('email', $row['email'])
                    )
                    ->first();

                $payload = [
                    'name' => $row['name'],
                    'name_kana' => $row['name_kana'],
                    'email' => $row['email'],
                    'phone' => $row['phone'],
                    'category' => $row['category'],
                    'role_label' => $row['role_label'],
                    'status' => SonaeConstants::STATUS_ACTIVE,
                ];

                if ($existing !== null) {
                    $existing->fill($payload);
                    $existing->save();
                    $updated++;

                    continue;
                }

                SonaeMember::query()->create(array_merge($payload, [
                    'chapter_id' => $chapter->id,
                    'source_system' => SonaeConstants::SOURCE_SONAE,
                    'external_id' => null,
                ]));
                $imported++;
            }
        });

        return ['imported' => $imported, 'updated' => $updated];
    }

    private function nullableString(mixed $value): ?string
    {
        if ($value === null) {
            return null;
        }

        $trimmed = trim((string) $value);

        return $trimmed === '' ? null : $trimmed;
    }
}
