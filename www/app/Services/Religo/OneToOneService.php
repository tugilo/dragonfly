<?php

namespace App\Services\Religo;

use App\Models\OneToOne;

class OneToOneService
{
    public function store(array $data): OneToOne
    {
        $o2o = new OneToOne([
            'workspace_id' => $data['workspace_id'],
            'owner_member_id' => $data['owner_member_id'],
            'target_member_id' => $data['target_member_id'],
            'meeting_id' => $data['meeting_id'] ?? null,
            'status' => $data['status'] ?? 'planned',
            'scheduled_at' => $data['scheduled_at'] ?? null,
            'started_at' => $data['started_at'] ?? null,
            'ended_at' => $data['ended_at'] ?? null,
            'notes' => $data['notes'] ?? null,
        ]);
        $o2o->save();
        return $o2o;
    }

    /**
     * @param  array<string, mixed>  $data
     */
    public function update(OneToOne $o2o, array $data): OneToOne
    {
        $keys = [
            'owner_member_id',
            'target_member_id',
            'meeting_id',
            'status',
            'scheduled_at',
            'started_at',
            'ended_at',
            'notes',
        ];
        foreach ($keys as $key) {
            if (array_key_exists($key, $data)) {
                $o2o->{$key} = $data[$key];
            }
        }
        $o2o->save();

        return $o2o->fresh();
    }
}
