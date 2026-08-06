<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        $exists = DB::table('meeting_types')->where('code', 'chapter_1tomany')->exists();
        if ($exists) {
            return;
        }

        $now = now();
        DB::table('meeting_types')->insert([
            'code' => 'chapter_1tomany',
            'name_ja' => '1toMany',
            'is_numbered' => false,
            'requires_team_id' => false,
            'supports_participants' => false,
            'supports_breakouts' => false,
            'supports_referral_suggestions' => true,
            'sort_order' => 35,
            'is_active' => true,
            'created_at' => $now,
            'updated_at' => $now,
        ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        DB::table('meeting_types')->where('code', 'chapter_1tomany')->delete();
    }
};
