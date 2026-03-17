<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Http\Requests\Religo\UpdateParticipantImportCandidatesRequest;
use App\Models\Member;
use App\Models\Meeting;
use App\Models\MeetingParticipantImport;
use App\Services\Religo\ApplyParticipantCandidatesService;
use App\Services\Religo\PdfParticipantParseService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

/**
 * M7-P1: 参加者PDFのアップロード・取得・ダウンロード。
 * M7-P2-IMPLEMENT-1: PDF解析実行（テキスト抽出・候補保存）。participants には一切触れない。
 */
class MeetingParticipantImportController extends Controller
{
    private const DISK = 'local';

    private const DIRECTORY = 'meeting_participant_imports';

    public function __construct(
        private PdfParticipantParseService $parseService,
        private ApplyParticipantCandidatesService $applyCandidatesService
    ) {}

    /**
     * GET /api/meetings/{meetingId}/participants/import
     * 該当 Meeting の PDF メタ情報を返す。
     */
    public function show(int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = $meeting->participantImport;
        if (! $import) {
            return response()->json([
                'has_pdf' => false,
                'original_filename' => null,
            ]);
        }

        return response()->json([
            'has_pdf' => true,
            'original_filename' => $import->original_filename,
        ]);
    }

    /**
     * POST /api/meetings/{meetingId}/participants/import
     * PDF をアップロードし、meeting_participant_imports に保存。1 Meeting = 1 PDF のため既存は上書き。
     */
    public function store(Request $request, int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $request->validate([
            'pdf' => ['required', 'file', 'mimes:pdf', 'max:20480'],
        ], [
            'pdf.required' => 'PDFファイルを選択してください。',
            'pdf.mimes' => 'PDFファイルのみアップロードできます。',
            'pdf.max' => 'ファイルサイズは20MB以内にしてください。',
        ]);

        $file = $request->file('pdf');
        $originalName = $file->getClientOriginalName();

        $existing = $meeting->participantImport;
        if ($existing && Storage::disk(self::DISK)->exists($existing->file_path)) {
            Storage::disk(self::DISK)->delete($existing->file_path);
        }

        $path = $file->storeAs(
            self::DIRECTORY . '/' . $meetingId,
            Str::uuid() . '.pdf',
            self::DISK
        );

        MeetingParticipantImport::updateOrCreate(
            ['meeting_id' => $meetingId],
            [
                'file_path' => $path,
                'original_filename' => $originalName,
                'status' => 'uploaded',
                'parse_status' => MeetingParticipantImport::PARSE_STATUS_PENDING,
                'parsed_at' => null,
                'extracted_text' => null,
                'extracted_result' => null,
            ]
        );

        return response()->json([
            'has_pdf' => true,
            'original_filename' => $originalName,
        ], 201);
    }

    /**
     * GET /api/meetings/{meetingId}/participants/import/download
     * 該当 Meeting の PDF をダウンロードする。
     */
    public function download(int $meetingId): Response|JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = $meeting->participantImport;
        if (! $import || ! Storage::disk(self::DISK)->exists($import->file_path)) {
            return response()->json(['message' => 'PDF not found.'], 404);
        }

        $contents = Storage::disk(self::DISK)->get($import->file_path);
        $filename = $import->original_filename ?: 'participants.pdf';

        return response($contents, 200, [
            'Content-Type' => 'application/pdf',
            'Content-Disposition' => 'attachment; filename="' . $this->sanitizeFilename($filename) . '"',
        ]);
    }

    /**
     * POST /api/meetings/{meetingId}/participants/import/parse
     * PDF を解析し、extracted_text / extracted_result / parse_status / parsed_at を保存する。
     */
    public function parse(int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = $meeting->participantImport;
        if (! $import) {
            return response()->json(['message' => 'No participant PDF for this meeting.'], 422);
        }

        if (! Storage::disk(self::DISK)->exists($import->file_path)) {
            return response()->json(['message' => 'PDF file not found.'], 422);
        }

        $fullPath = Storage::disk(self::DISK)->path($import->file_path);
        $now = now();

        try {
            $text = $this->parseService->extractText($fullPath);
        } catch (\Throwable $e) {
            Log::warning('Participant PDF parse: text extraction failed.', [
                'meeting_id' => $meetingId,
                'path' => $import->file_path,
                'message' => $e->getMessage(),
            ]);
            $import->update([
                'parse_status' => MeetingParticipantImport::PARSE_STATUS_FAILED,
                'parsed_at' => $now,
                'extracted_text' => null,
                'extracted_result' => null,
            ]);
            return response()->json([
                'message' => 'PDF text extraction failed.',
                'parse_status' => MeetingParticipantImport::PARSE_STATUS_FAILED,
                'parsed_at' => $now->toIso8601String(),
            ], 422);
        }

        $result = $this->parseService->buildCandidates($text);
        $candidateCount = count($result['candidates']);

        $import->update([
            'extracted_text' => $text,
            'extracted_result' => $result,
            'parse_status' => MeetingParticipantImport::PARSE_STATUS_SUCCESS,
            'parsed_at' => $now,
        ]);

        return response()->json([
            'parse_status' => MeetingParticipantImport::PARSE_STATUS_SUCCESS,
            'parsed_at' => $now->toIso8601String(),
            'candidate_count' => $candidateCount,
        ]);
    }

    /**
     * PUT /api/meetings/{meetingId}/participants/import/candidates
     * 解析候補（candidates）を更新する。meta は維持。空 name 行は除外。participants には触れない。
     */
    public function updateCandidates(UpdateParticipantImportCandidatesRequest $request, int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = $meeting->participantImport;
        if (! $import) {
            return response()->json(['message' => 'No participant PDF for this meeting.'], 422);
        }

        if ($import->parse_status !== MeetingParticipantImport::PARSE_STATUS_SUCCESS) {
            return response()->json(['message' => 'Candidates can only be updated when parse status is success.'], 422);
        }

        $raw = $request->input('candidates', []);
        $allowedTypes = ['regular', 'guest', 'visitor', 'proxy'];
        $candidates = [];
        foreach ($raw as $row) {
            $name = isset($row['name']) ? trim((string) $row['name']) : '';
            if ($name === '') {
                continue;
            }
            $typeHint = $row['type_hint'] ?? null;
            if ($typeHint !== null && ! in_array($typeHint, $allowedTypes, true)) {
                $typeHint = null;
            }
            $candidate = [
                'name' => $name,
                'raw_line' => isset($row['raw_line']) ? trim((string) $row['raw_line']) : '',
                'type_hint' => $typeHint,
            ];
            $matchedMemberId = isset($row['matched_member_id']) ? (int) $row['matched_member_id'] : null;
            if ($matchedMemberId > 0) {
                $member = Member::find($matchedMemberId);
                if ($member) {
                    $candidate['matched_member_id'] = $member->id;
                    $candidate['matched_member_name'] = $member->name;
                    $candidate['match_status'] = 'matched';
                    $candidate['match_source'] = ($row['match_source'] ?? '') === 'manual' ? 'manual' : 'auto';
                }
            } else {
                $candidate['matched_member_id'] = null;
                $candidate['matched_member_name'] = null;
                $candidate['match_source'] = null;
            }
            $candidates[] = $candidate;
        }

        $existing = $import->extracted_result ?? [];
        $meta = $existing['meta'] ?? ['line_count' => 0, 'parser_version' => 1];
        $import->update([
            'extracted_result' => [
                'candidates' => $candidates,
                'meta' => $meta,
            ],
        ]);

        return response()->json([
            'candidate_count' => count($candidates),
            'candidates' => $candidates,
        ]);
    }

    /**
     * POST /api/meetings/{meetingId}/participants/import/apply
     * 解析候補を participants に反映する（全置換）。
     */
    public function apply(int $meetingId): JsonResponse
    {
        $meeting = Meeting::find($meetingId);
        if (! $meeting) {
            return response()->json(['message' => 'Meeting not found.'], 404);
        }

        $import = $meeting->participantImport;
        if (! $import) {
            return response()->json(['message' => 'No participant PDF for this meeting.'], 422);
        }

        if ($import->parse_status !== MeetingParticipantImport::PARSE_STATUS_SUCCESS) {
            return response()->json(['message' => 'Candidates can only be applied when parse status is success.'], 422);
        }

        $candidates = $import->extracted_result['candidates'] ?? [];
        $candidates = array_values(array_filter($candidates, function ($c) {
            $name = isset($c['name']) ? trim((string) $c['name']) : '';

            return $name !== '';
        }));

        if (count($candidates) === 0) {
            return response()->json(['message' => 'No candidates to apply.'], 422);
        }

        $appliedCount = $this->applyCandidatesService->apply($meeting, $import);

        return response()->json([
            'applied_count' => $appliedCount,
            'message' => 'participants を更新しました',
        ]);
    }

    private function sanitizeFilename(string $name): string
    {
        return preg_replace('/[^\p{L}\p{N}\s._-]/u', '_', $name) ?: 'participants.pdf';
    }
}
