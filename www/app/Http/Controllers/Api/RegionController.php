<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Region;
use Illuminate\Http\JsonResponse;

/**
 * GET /api/regions — リージョン一覧。SPEC-021。
 */
class RegionController extends Controller
{
    public function index(): JsonResponse
    {
        $regions = Region::query()
            ->with('country')
            ->orderBy('id')
            ->get(['id', 'country_id', 'name']);

        $data = $regions->map(static function (Region $r) {
            return [
                'id' => $r->id,
                'name' => $r->name,
                'country_id' => $r->country_id,
                'country_name' => $r->country?->name,
            ];
        })->values()->all();

        return response()->json($data);
    }
}
