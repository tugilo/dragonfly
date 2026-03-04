<?php

namespace App\Http\Controllers;

use Illuminate\View\View;

class DragonFlyMvpController extends Controller
{
    /**
     * DragonFly MVP 画面（meeting number 固定で API はブラウザから fetch）.
     */
    public function show(int $number): View
    {
        $raw = request()->query('participant_id');
        $participant_id_from_query = null;
        if ($raw !== null && $raw !== '' && preg_match('/^\d+$/', (string) $raw)) {
            $participant_id_from_query = (string) $raw;
        }

        return view('dragonfly.mvp', [
            'number' => $number,
            'participant_id_from_query' => $participant_id_from_query,
        ]);
    }
}
