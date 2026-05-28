<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 既存 members.role_notes の値を roles に投入し、現在役職を member_roles に移行する.
     * term_start = today, term_end = null で「現在の役職」とする.
     */
    public function up(): void
    {
        $today = now()->toDateString();
        $distinct = DB::table('members')
            ->whereNotNull('role_notes')
            ->where('role_notes', '!=', '')
            ->distinct()
            ->pluck('role_notes');

        $roleIdByNotes = [];
        foreach ($distinct as $notes) {
            $id = DB::table('roles')->insertGetId([
                'name' => $notes,
                'description' => null,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
            $roleIdByNotes[$notes] = $id;
        }

        foreach (DB::table('members')->whereNotNull('role_notes')->where('role_notes', '!=', '')->get() as $member) {
            $roleId = $roleIdByNotes[$member->role_notes] ?? null;
            if ($roleId !== null) {
                DB::table('member_roles')->insert([
                    'member_id' => $member->id,
                    'role_id' => $roleId,
                    'term_start' => $today,
                    'term_end' => null,
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);
            }
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // member_roles は 100006 の down で drop される
    }
};
