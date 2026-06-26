<?php

namespace App\Models\Sonae;

/**
 * SPEC-017: SONAE 共通定数。
 */
final class SonaeConstants
{
    public const SOURCE_RELIGO = 'religo';

    public const SOURCE_SONAE = 'sonae';

    public const STATUS_ACTIVE = 'active';

    public const STATUS_INACTIVE = 'inactive';

    public const NOTIFICATION_ALERT = 'alert';

    public const NOTIFICATION_TRAINING = 'training';

    public const SAFETY_SAFE = 'safe';

    public const SAFETY_MINOR_INJURY = 'minor_injury';

    public const SAFETY_SERIOUS_INJURY = 'serious_injury';

    public const SAFETY_EVACUATING = 'evacuating';

    public const SAFETY_HARD_TO_ANSWER = 'hard_to_answer';

    public const ACTIVITY_NORMAL = 'normal';

    public const ACTIVITY_PARTIALLY_AFFECTED = 'partially_affected';

    public const ACTIVITY_DIFFICULT = 'difficult';

    public const ATTENDANCE_CAN = 'can_attend';

    public const ATTENDANCE_CANNOT = 'cannot_attend';

    public const ATTENDANCE_UNDECIDED = 'undecided';

    public const LINE_LINK_ACTIVE = 'active';

    public const LINE_LINK_BLOCKED = 'blocked';

    public const LINE_LINK_UNLINKED = 'unlinked';
}
