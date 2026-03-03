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
        return view('dragonfly.mvp', [
            'number' => $number,
            'participant_id_from_query' => request()->query('participant_id'),
        ]);
    }
}
