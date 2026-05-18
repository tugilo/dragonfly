<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('members', function (Blueprint $table) {
            $table->string('email', 255)->nullable()->after('name_kana');
        });
        Schema::table('members', function (Blueprint $table) {
            $table->unique(['workspace_id', 'email'], 'members_workspace_email_unique');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('members', function (Blueprint $table) {
            $table->dropUnique('members_workspace_email_unique');
        });
        Schema::table('members', function (Blueprint $table) {
            $table->dropColumn('email');
        });
    }
};
