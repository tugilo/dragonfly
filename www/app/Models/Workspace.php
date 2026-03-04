<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Religo ワークスペース（会／チャプター単位）. SSOT: docs/SSOT/DATA_MODEL.md §4.1.
 */
class Workspace extends Model
{
    protected $table = 'workspaces';

    protected $fillable = ['name', 'slug'];
}
