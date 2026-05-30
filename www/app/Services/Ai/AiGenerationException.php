<?php

namespace App\Services\Ai;

use RuntimeException;

/**
 * SPEC-013: AI 生成時のエラー（キー未設定/無効・レート超過・通信失敗など）。
 */
class AiGenerationException extends RuntimeException {}
