<?php

namespace App\Services\Religo;

use App\Models\ContactMemo;

class ContactMemoService
{
    public function store(array $data): ContactMemo
    {
        $memo = new ContactMemo([
            'owner_member_id' => $data['owner_member_id'],
            'target_member_id' => $data['target_member_id'],
            'workspace_id' => $data['workspace_id'] ?? null,
            'memo_type' => $data['memo_type'] ?? 'other',
            'body' => $data['body'],
            'meeting_id' => $data['meeting_id'] ?? null,
            'one_to_one_id' => $data['one_to_one_id'] ?? null,
        ]);
        $memo->save();
        return $memo;
    }
}
