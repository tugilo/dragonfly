<?php

namespace App\Http\Controllers\Sonae;

use App\Http\Controllers\Controller;
use App\Models\Sonae\SonaeAlertThresholdOption;
use App\Models\Sonae\SonaeChapter;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SonaeAlertThresholdOptionController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = SonaeAlertThresholdOption::query()
            ->with('alertType:id,code,name')
            ->where('is_active', true)
            ->orderBy('alert_type_id')
            ->orderBy('sort_order');

        if ($request->filled('alert_type_code')) {
            $code = (string) $request->query('alert_type_code');
            $query->whereHas('alertType', fn ($q) => $q->where('code', $code));
        }

        $options = $query->get()->map(static fn (SonaeAlertThresholdOption $option) => [
            'id' => $option->id,
            'alert_type_id' => $option->alert_type_id,
            'alert_type_code' => $option->alertType?->code,
            'alert_type_name' => $option->alertType?->name,
            'code' => $option->code,
            'label' => $option->label,
            'severity_rank' => $option->severity_rank,
            'sort_order' => $option->sort_order,
        ]);

        return response()->json(['data' => $options]);
    }
}
