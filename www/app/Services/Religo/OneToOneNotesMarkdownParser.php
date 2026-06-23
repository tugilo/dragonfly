<?php

namespace App\Services\Religo;

/**
 * 1to1 議事録 Markdown のセクション分割（SPEC-019 §5.2）。
 */
class OneToOneNotesMarkdownParser
{
    /**
     * @return list<array{session_number: int, heading_line: string, content: string, one_to_one_id: int|null}>
     */
    public function parseSessions(string $body): array
    {
        if (! preg_match_all('/^###\s*【第(\d+)回】[^\n]*$/mu', $body, $matches, PREG_OFFSET_CAPTURE)) {
            return [];
        }

        $sessions = [];
        $count = count($matches[0]);

        for ($i = 0; $i < $count; $i++) {
            $start = $matches[0][$i][1];
            $sessionNumber = (int) $matches[1][$i][0];
            $headingLine = $matches[0][$i][0];
            $end = ($i + 1 < $count) ? $matches[0][$i + 1][1] : strlen($body);
            $chunk = substr($body, $start, $end - $start);

            if (preg_match('/^##\s*■/mu', $chunk, $sectionMatch, PREG_OFFSET_CAPTURE) && $sectionMatch[0][1] > 0) {
                $chunk = substr($chunk, 0, $sectionMatch[0][1]);
            }

            $content = trim($chunk);
            if ($content === '') {
                continue;
            }

            $sessions[] = [
                'session_number' => $sessionNumber,
                'heading_line' => $headingLine,
                'content' => $content,
                'one_to_one_id' => $this->extractOneToOneIdFromText($content),
            ];
        }

        return $sessions;
    }

    public function extractOneToOneIdFromText(string $text): ?int
    {
        if (preg_match('/one_to_ones\.id`\s*=\s*\*\*(\d+)\*\*/', $text, $matches)) {
            return (int) $matches[1];
        }

        if (preg_match('/one_to_ones\.id\s*=\s*(\d+)/', $text, $matches)) {
            return (int) $matches[1];
        }

        return null;
    }

    public function extractSourcePath(string $text): ?string
    {
        if (preg_match('/【ソース:\s*(docs\/meetings\/1to1\/[a-zA-Z0-9_.-]+\.md)(?:#第\d+回)?】/', $text, $matches)) {
            return trim($matches[1]);
        }

        if (preg_match('/ソース:\s*(docs\/meetings\/1to1\/[a-zA-Z0-9_.-]+\.md)(?:#第\d+回)?/', $text, $matches)) {
            return trim($matches[1]);
        }

        return null;
    }
}
