<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Nキャス（外部システム）の自己紹介ページ URL をメンバーごとに保持する.
     */
    public function up(): void
    {
        Schema::table('members', function (Blueprint $table) {
            $table->string('ncast_profile_url', 2048)->nullable()->after('display_no');
        });
    }

    public function down(): void
    {
        Schema::table('members', function (Blueprint $table) {
            $table->dropColumn('ncast_profile_url');
        });
    }
};
