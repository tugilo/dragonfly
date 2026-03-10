<?php

namespace App\Console\Commands;

use App\Models\Category;
use App\Models\Meeting;
use App\Models\Member;
use App\Models\MemberRole;
use App\Models\Participant;
use App\Models\Role;
use Illuminate\Console\Command;

/**
 * 定例会参加者CSVを members / participants に投入する汎用コマンド.
 *
 * 使用例:
 *   php artisan dragonfly:import-participants-csv 200 database/csv/dragonfly_59people.csv --held_on=2026-03-10
 */
class ImportParticipantsCsvCommand extends Command
{
    protected $signature = 'dragonfly:import-participants-csv
                            {meeting_number : 定例会回番号（例: 200）}
                            {csv_path : CSVファイルパス}
                            {--held_on= : 開催日 YYYY-MM-DD}';

    protected $description = '定例会参加者CSVを members / participants に投入する（第200回等で再利用可）';

    private const REQUIRED_HEADERS = ['種別', '名前'];

    /** CSV種別 -> [members.type, participants.type] */
    private const TYPE_MAP = [
        'メンバー' => ['member', 'regular'],
        'ビジター' => ['visitor', 'visitor'],
        'ゲスト' => ['guest', 'guest'],
        '代理出席' => ['guest', 'proxy'],
    ];

    private int $warningCount = 0;

    public function handle(): int
    {
        $meetingNumber = $this->argument('meeting_number');
        $csvPath = $this->argument('csv_path');
        $heldOn = $this->option('held_on');

        if (! $this->validateMeetingNumber($meetingNumber)) {
            return self::FAILURE;
        }

        $resolvedPath = $this->resolveCsvPath($csvPath);
        if ($resolvedPath === null) {
            $this->error("CSV file not found or not readable: {$csvPath}");

            return self::FAILURE;
        }

        $rows = $this->readCsvRows($resolvedPath);
        if ($rows === null) {
            return self::FAILURE;
        }

        if (count($rows) === 0) {
            $this->warn('No data rows in CSV.');

            return self::SUCCESS;
        }

        $meeting = $this->resolveMeeting((int) $meetingNumber, $heldOn);
        $nameToMemberId = [];
        $visitorIndex = 0;
        $guestIndex = 0;
        $proxyIndex = 0;

        foreach ($rows as $row) {
            $result = $this->processRow($row, $meeting, $nameToMemberId, $visitorIndex, $guestIndex, $proxyIndex);
            if ($result === null) {
                continue;
            }
            [$member, $participantType, $introducerId, $attendantId] = $result;
            $nameToMemberId[$member->name] = $member->id;
            $memberId = $member->id;

            Participant::updateOrCreate(
                [
                    'meeting_id' => $meeting->id,
                    'member_id' => $memberId,
                ],
                [
                    'type' => $participantType,
                    'introducer_member_id' => $introducerId,
                    'attendant_member_id' => $attendantId,
                ]
            );
        }

        $this->info("Imported {$meeting->number} meeting: " . count($rows) . ' participants.');
        if ($this->warningCount > 0) {
            $this->warn("Warnings: {$this->warningCount}");
        }

        return self::SUCCESS;
    }

    private function validateMeetingNumber(string $meetingNumber): bool
    {
        if (! ctype_digit($meetingNumber) || (int) $meetingNumber <= 0) {
            $this->error('meeting_number must be a positive integer.');

            return false;
        }

        return true;
    }

    private function resolveCsvPath(string $csvPath): ?string
    {
        if (is_file($csvPath) && is_readable($csvPath)) {
            return $csvPath;
        }
        $fromBase = base_path($csvPath);
        if (is_file($fromBase) && is_readable($fromBase)) {
            return $fromBase;
        }
        $fromDatabase = database_path($csvPath);
        if (is_file($fromDatabase) && is_readable($fromDatabase)) {
            return $fromDatabase;
        }

        return null;
    }

    /**
     * CSV を読み、ヘッダーで列解決した連想配列の配列を返す。失敗時は null.
     */
    private function readCsvRows(string $path): ?array
    {
        $content = file_get_contents($path);
        if ($content === false) {
            $this->error("Failed to read file: {$path}");

            return null;
        }

        $content = $this->stripBom($content);
        $lines = preg_split('/\r\n|\r|\n/', $content);
        if ($lines === false || count($lines) < 2) {
            $this->error('CSV has no header or data rows.');

            return null;
        }

        $headerLine = array_shift($lines);
        $headers = str_getcsv($headerLine);
        $headers = array_map('trim', $headers);

        foreach (self::REQUIRED_HEADERS as $required) {
            if (! in_array($required, $headers, true)) {
                $this->error("Missing required column: {$required}");

                return null;
            }
        }

        $rows = [];
        foreach ($lines as $lineNum => $line) {
            $line = trim($line);
            if ($line === '') {
                continue;
            }
            $values = str_getcsv($line);
            if (count($values) < count($headers)) {
                $values = array_pad($values, count($headers), '');
            }
            $row = array_combine($headers, array_slice($values, 0, count($headers)));
            if ($row === false) {
                $this->warn("Row " . ($lineNum + 2) . ": column count mismatch, skipped.");
                $this->warningCount++;

                continue;
            }
            $row = array_map(fn ($v) => is_string($v) ? trim($v) : $v, $row);

            $kind = $row['種別'] ?? '';
            $name = $row['名前'] ?? '';
            if ($name === '') {
                $this->warn("Row " . ($lineNum + 2) . ": 名前 is empty, skipped.");
                $this->warningCount++;

                continue;
            }

            $rows[] = $row;
        }

        return $rows;
    }

    private function stripBom(string $content): string
    {
        $bom = "\xEF\xBB\xBF";
        if (str_starts_with($content, $bom)) {
            return substr($content, strlen($bom));
        }

        return $content;
    }

    private function resolveMeeting(int $meetingNumber, ?string $heldOn): Meeting
    {
        $attrs = [
            'held_on' => $heldOn ?? now()->toDateString(),
            'name' => "第{$meetingNumber}回定例会",
        ];
        $meeting = Meeting::firstOrCreate(
            ['number' => $meetingNumber],
            $attrs
        );
        if ($heldOn !== null && $heldOn !== '') {
            $current = $meeting->held_on?->format('Y-m-d');
            if ($current !== $heldOn) {
                $meeting->update(['held_on' => $heldOn, 'name' => $attrs['name']]);
            }
        }

        return $meeting;
    }

    /**
     * @return array{0: Member, 1: string, 2: ?int, 3: ?int}|null
     */
    private function processRow(
        array $row,
        Meeting $meeting,
        array &$nameToMemberId,
        int &$visitorIndex,
        int &$guestIndex,
        int &$proxyIndex
    ): ?array {
        $kind = trim($row['種別'] ?? '');
        $name = trim($row['名前'] ?? '');
        $nameKana = $this->nullIfEmpty($row['よみがな'] ?? '');
        $groupCategory = $this->nullIfEmpty($row['大カテゴリー'] ?? '');
        $categoryName = $this->nullIfEmpty($row['カテゴリー'] ?? '');
        $roleName = $this->nullIfEmpty($row['役職'] ?? '');
        $introducerName = $this->nullIfEmpty($row['紹介者'] ?? '');
        $attendantName = $this->nullIfEmpty($row['アテンド'] ?? '');
        // オリエンは読まない（または読んでも保存しない）

        if (! isset(self::TYPE_MAP[$kind])) {
            $this->warn("Unknown 種別: {$kind}, row skipped.");
            $this->warningCount++;

            return null;
        }

        [$memberType, $participantType] = self::TYPE_MAP[$kind];

        $displayNo = $this->resolveDisplayNo($kind, $row['No'] ?? '', $visitorIndex, $guestIndex, $proxyIndex);
        $categoryId = $this->resolveCategoryId($groupCategory, $categoryName);

        $member = $this->resolveOrCreateMember(
            $memberType,
            $displayNo,
            $name,
            $nameKana,
            $categoryId,
            $introducerName,
            $attendantName,
            $nameToMemberId
        );

        $this->syncCurrentRole($member, $roleName);

        $introducerId = $this->resolveMemberIdByName($introducerName, $nameToMemberId, '紹介者', $name);
        $attendantId = $this->resolveMemberIdByName($attendantName, $nameToMemberId, 'アテンド', $name);

        $member->update([
            'introducer_member_id' => $introducerId,
            'attendant_member_id' => $attendantId,
        ]);

        return [$member, $participantType, $introducerId, $attendantId];
    }

    private function nullIfEmpty(string $v): ?string
    {
        $v = trim($v);
        if ($v === '' || $v === '-') {
            return null;
        }

        return $v;
    }

    private function resolveDisplayNo(string $kind, string $no, int &$visitorIndex, int &$guestIndex, int &$proxyIndex): string
    {
        if ($kind === 'メンバー' && $no !== '') {
            return $no;
        }
        if ($kind === 'ビジター') {
            $visitorIndex++;

            return 'V' . $visitorIndex;
        }
        if ($kind === 'ゲスト') {
            $guestIndex++;

            return 'G' . $guestIndex;
        }
        if ($kind === '代理出席') {
            $proxyIndex++;

            return 'P' . $proxyIndex;
        }

        return $no !== '' ? $no : '?';
    }

    private function resolveCategoryId(?string $groupName, ?string $categoryName): ?int
    {
        if ($groupName === null && $categoryName === null) {
            return null;
        }
        $group = $groupName ?? $categoryName;
        $name = $categoryName ?? $groupName;
        $cat = Category::firstOrCreate(
            ['group_name' => $group, 'name' => $name],
            ['group_name' => $group, 'name' => $name]
        );

        return $cat->id;
    }

    private function resolveOrCreateMember(
        string $type,
        string $displayNo,
        string $name,
        ?string $nameKana,
        ?int $categoryId,
        ?string $introducerName,
        ?string $attendantName,
        array $nameToMemberId
    ): Member {
        $key = $type === 'member'
            ? ['type' => $type, 'display_no' => $displayNo]
            : ['type' => $type, 'display_no' => $displayNo];

        return Member::updateOrCreate(
            $key,
            [
                'name' => $name,
                'name_kana' => $nameKana,
                'category_id' => $categoryId,
                'type' => $type,
                'display_no' => $displayNo,
                'introducer_member_id' => null,
                'attendant_member_id' => null,
            ]
        );
    }

    private function syncCurrentRole(Member $member, ?string $roleNotes): void
    {
        $v = $this->nullIfEmpty($roleNotes ?? '');
        $today = now()->toDateString();
        MemberRole::where('member_id', $member->id)->whereNull('term_end')->update(['term_end' => $today]);
        if ($v === null) {
            return;
        }
        $role = Role::firstOrCreate(
            ['name' => $v],
            ['name' => $v, 'description' => null]
        );
        MemberRole::updateOrCreate(
            [
                'member_id' => $member->id,
                'role_id' => $role->id,
                'term_end' => null,
            ],
            ['term_start' => $today]
        );
    }

    private function resolveMemberIdByName(?string $name, array $nameToMemberId, string $label, string $rowName): ?int
    {
        if ($name === null) {
            return null;
        }
        $id = $nameToMemberId[$name] ?? null;
        if ($id === null) {
            $existing = Member::where('name', $name)->first();
            if ($existing !== null) {
                return $existing->id;
            }
            $this->warn("{$label} not found: {$name} (row: {$rowName})");
            $this->warningCount++;
        }

        return $id;
    }
}
