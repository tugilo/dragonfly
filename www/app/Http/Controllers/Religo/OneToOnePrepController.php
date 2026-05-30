<?php

namespace App\Http\Controllers\Religo;

use App\Http\Controllers\Controller;
use App\Models\ContactMemo;
use App\Models\OneToOne;
use App\Models\OneToOneAttachment;
use App\Models\UserAiCredential;
use App\Models\User;
use App\Services\Ai\AiGenerationException;
use App\Services\Ai\HtmlTextExtractor;
use App\Services\Ai\OneToOnePrepService;
use App\Services\Religo\PdfParticipantParseService;
use App\Services\Religo\ReligoActorContext;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Storage;

/**
 * SPEC-013: 1to1 事前準備（相手プロフィール添付・テキスト化・AI 原稿生成）。
 * 認証済みユーザー本人（owner）のみ。添付は private disk に保存。
 */
class OneToOnePrepController extends Controller
{
    private const DISK = 'local';

    public function __construct(
        private PdfParticipantParseService $pdfParser,
        private HtmlTextExtractor $htmlExtractor,
        private OneToOnePrepService $prepService,
    ) {}

    public function indexAttachments(OneToOne $oneToOne): JsonResponse
    {
        if ($resp = $this->guard($oneToOne)) {
            return $resp;
        }
        $rows = OneToOneAttachment::where('one_to_one_id', $oneToOne->id)->orderBy('id')->get();

        return response()->json($rows->map(fn (OneToOneAttachment $a) => $this->attachmentPayload($a))->all());
    }

    public function storePdf(Request $request, OneToOne $oneToOne): JsonResponse
    {
        if ($resp = $this->guard($oneToOne)) {
            return $resp;
        }
        $request->validate([
            'file' => ['required', 'file', 'mimes:pdf', 'max:20480'],
        ]);

        $file = $request->file('file');
        $path = $file->store("one_to_one_attachments/{$oneToOne->id}", self::DISK);

        $text = '';
        try {
            $text = $this->pdfParser->extractText(Storage::disk(self::DISK)->path($path));
        } catch (\Throwable) {
            // 抽出失敗でも添付は保持（後で手動補完）。
        }

        $attachment = OneToOneAttachment::create([
            'one_to_one_id' => $oneToOne->id,
            'target_member_id' => $oneToOne->target_member_id,
            'uploaded_by_user_id' => ReligoActorContext::actingUser()?->id,
            'source_type' => OneToOneAttachment::SOURCE_PDF,
            'file_path' => $path,
            'original_name' => $file->getClientOriginalName(),
            'extracted_text' => $text !== '' ? $text : null,
        ]);

        return response()->json($this->attachmentPayload($attachment), 201);
    }

    public function storeUrl(Request $request, OneToOne $oneToOne): JsonResponse
    {
        if ($resp = $this->guard($oneToOne)) {
            return $resp;
        }
        $validated = $request->validate([
            'url' => ['required', 'url', 'max:1024'],
        ]);

        $text = null;
        try {
            $res = Http::timeout(20)->get($validated['url']);
            if ($res->successful()) {
                $text = $this->htmlExtractor->extract($res->body());
            }
        } catch (\Throwable) {
            // 取得失敗は best-effort（テキスト無しで保持）。
        }

        $attachment = OneToOneAttachment::create([
            'one_to_one_id' => $oneToOne->id,
            'target_member_id' => $oneToOne->target_member_id,
            'uploaded_by_user_id' => ReligoActorContext::actingUser()?->id,
            'source_type' => OneToOneAttachment::SOURCE_URL,
            'source_url' => $validated['url'],
            'extracted_text' => $text !== '' ? $text : null,
        ]);

        $payload = $this->attachmentPayload($attachment);
        $payload['fetch_ok'] = $text !== null && $text !== '';

        return response()->json($payload, 201);
    }

    public function destroyAttachment(OneToOne $oneToOne, OneToOneAttachment $attachment): JsonResponse
    {
        if ($resp = $this->guard($oneToOne)) {
            return $resp;
        }
        if ($attachment->one_to_one_id !== $oneToOne->id) {
            return response()->json(['message' => 'Not found.'], 404);
        }
        if ($attachment->file_path && Storage::disk(self::DISK)->exists($attachment->file_path)) {
            Storage::disk(self::DISK)->delete($attachment->file_path);
        }
        $attachment->delete();

        return response()->json(['message' => 'deleted']);
    }

    public function generate(Request $request, OneToOne $oneToOne): JsonResponse
    {
        if ($resp = $this->guard($oneToOne)) {
            return $resp;
        }
        $user = ReligoActorContext::actingUser();
        $cred = UserAiCredential::where('user_id', $user->id)->first();
        if ($cred === null || ! $cred->hasUsableKey()) {
            return response()->json(['message' => 'AI が未設定です。設定画面で AI を有効化し API キーを登録してください。'], 422);
        }

        $validated = $request->validate([
            'save_to' => ['nullable', 'string', 'in:notes,memo'],
        ]);

        try {
            $draft = $this->prepService->generate($oneToOne, $cred);
        } catch (AiGenerationException $e) {
            return response()->json(['message' => $e->getMessage()], 422);
        }

        $savedTo = null;
        if (($validated['save_to'] ?? null) === 'notes') {
            $existing = trim((string) $oneToOne->notes);
            $oneToOne->notes = $existing === '' ? $draft : $existing."\n\n---\n".$draft;
            $oneToOne->save();
            $savedTo = 'notes';
        } elseif (($validated['save_to'] ?? null) === 'memo') {
            ContactMemo::create([
                'owner_member_id' => $oneToOne->owner_member_id,
                'target_member_id' => $oneToOne->target_member_id,
                'workspace_id' => $oneToOne->workspace_id,
                'memo_type' => 'one_to_one',
                'body' => $draft,
                'one_to_one_id' => $oneToOne->id,
                'meeting_id' => null,
            ]);
            $savedTo = 'memo';
        }

        return response()->json([
            'draft' => $draft,
            'saved_to' => $savedTo,
            'provider' => $cred->provider,
            'model' => $cred->model,
        ]);
    }

    /**
     * 認証済み・かつ acting user が当該 1to1 の owner であることを確認する。
     */
    private function guard(OneToOne $oneToOne): ?JsonResponse
    {
        $user = ReligoActorContext::actingUser();
        if ($user === null) {
            return response()->json(['message' => 'No acting user.'], 403);
        }
        if ($user->owner_member_id === null || (int) $user->owner_member_id !== (int) $oneToOne->owner_member_id) {
            return response()->json(['message' => 'この 1 to 1 を操作する権限がありません。'], 403);
        }

        return null;
    }

    /**
     * @return array<string, mixed>
     */
    private function attachmentPayload(OneToOneAttachment $a): array
    {
        return [
            'id' => $a->id,
            'source_type' => $a->source_type,
            'original_name' => $a->original_name,
            'source_url' => $a->source_url,
            'has_text' => ! empty($a->extracted_text),
            'text_length' => mb_strlen((string) $a->extracted_text),
            'created_at' => $a->created_at?->toIso8601String(),
        ];
    }
}
