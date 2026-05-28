<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     * 既存 members.category の値を categories に投入し、members.category_id を設定する.
     */
    public function up(): void
    {
        $distinct = DB::table('members')
            ->whereNotNull('category')
            ->where('category', '!=', '')
            ->distinct()
            ->pluck('category');

        foreach ($distinct as $value) {
            $id = DB::table('categories')->insertGetId([
                'group_name' => $value,
                'name' => $value,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
            DB::table('members')->where('category', $value)->update(['category_id' => $id]);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        DB::table('members')->update(['category_id' => null]);
    }
};
