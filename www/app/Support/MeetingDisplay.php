<?php

namespace App\Support;

use App\Models\Meeting;

/**
 * 例会・チャプターイベントの表示ラベルと既定名称（番号あり/なし共通）.
 */
final class MeetingDisplay
{
    public const SESSION_CHAPTER_WEEKLY = 'chapter_weekly';

    public const SESSION_MOMENTUM_TRAINING = 'momentum_training';

    public const SESSION_BUSINESS_OPEN_DAY = 'business_open_day';

    public const SESSION_TEAM_MEETING = 'team_meeting';

    public const SESSION_WEBMASTER_MEETING = 'webmaster_meeting';

    /** @var list<string> */
    public const SESSION_TYPES = [
        self::SESSION_CHAPTER_WEEKLY,
        self::SESSION_MOMENTUM_TRAINING,
        self::SESSION_BUSINESS_OPEN_DAY,
        self::SESSION_TEAM_MEETING,
    ];

    /** @var array<string, string> doc_type → session_type / meeting_types.code */
    public const DOC_TYPE_TO_SESSION_TYPE = [
        'chapter_weekly' => self::SESSION_CHAPTER_WEEKLY,
        'chapter_momentum' => self::SESSION_MOMENTUM_TRAINING,
        'chapter_bod' => self::SESSION_BUSINESS_OPEN_DAY,
        'team_meeting' => self::SESSION_TEAM_MEETING,
    ];

    public static function isNumberedSession(?string $sessionType): bool
    {
        return ($sessionType ?? self::SESSION_CHAPTER_WEEKLY) === self::SESSION_CHAPTER_WEEKLY;
    }

    public static function requiresTeamId(?string $sessionType): bool
    {
        return ($sessionType ?? '') === self::SESSION_TEAM_MEETING;
    }

    public static function defaultName(string $sessionType, ?int $number = null, ?string $teamNameJa = null): string
    {
        return match ($sessionType) {
            self::SESSION_MOMENTUM_TRAINING => 'モメンタムトレーニング',
            self::SESSION_BUSINESS_OPEN_DAY => 'ビジネスオープンデイ（BOD）',
            self::SESSION_TEAM_MEETING => ($teamNameJa !== null && trim($teamNameJa) !== '')
                ? trim($teamNameJa).' チームMTG'
                : 'チームMTG',
            default => sprintf('第%d回定例会', (int) $number),
        };
    }

    public static function sessionTypeFromDocType(?string $docType): ?string
    {
        if ($docType === null || $docType === '') {
            return null;
        }

        return self::DOC_TYPE_TO_SESSION_TYPE[$docType] ?? null;
    }

    public static function displayLabel(Meeting $meeting): string
    {
        if ($meeting->number !== null) {
            return sprintf('第%d回', $meeting->number);
        }

        $name = trim((string) ($meeting->name ?? ''));
        if ($name !== '') {
            return $name;
        }

        return self::defaultName((string) ($meeting->session_type ?? self::SESSION_CHAPTER_WEEKLY));
    }

    public static function listTitle(Meeting $meeting): string
    {
        $held = $meeting->held_on?->format('Y-m-d') ?? '—';

        return self::displayLabel($meeting).' — '.$held;
    }
}
