<?php

namespace App\Http\Controllers\Sonae;

use App\Http\Controllers\Controller;
use App\Services\Sonae\SonaeResponseTokenService;
use App\Services\Sonae\SonaeSafetyResponseService;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\View\View;
use InvalidArgumentException;

class SonaeResponseController extends Controller
{
    public function show(string $token, SonaeResponseTokenService $tokens): View
    {
        $target = $tokens->findTargetByPlainToken($token);
        if ($target === null) {
            abort(404);
        }

        return view('sonae.respond', [
            'token' => $token,
            'memberName' => $target->member?->name,
            'chapterName' => $target->notification?->chapter?->name,
            'existing' => $target->safetyResponse,
        ]);
    }

    public function store(
        Request $request,
        string $token,
        SonaeResponseTokenService $tokens,
        SonaeSafetyResponseService $responses
    ): RedirectResponse {
        $target = $tokens->findTargetByPlainToken($token);
        if ($target === null) {
            abort(404);
        }

        try {
            $responses->submit($target, $request->all());
        } catch (InvalidArgumentException $e) {
            return back()->withErrors(['form' => $e->getMessage()])->withInput();
        }

        return redirect()->route('sonae.respond.show', ['token' => $token])
            ->with('status', '回答を送信しました。');
    }
}
