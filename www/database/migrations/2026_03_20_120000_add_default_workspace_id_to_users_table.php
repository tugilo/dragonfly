<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * BO-AUDIT-P4: ユーザー既定チャプター（workspaces 1 行相当）を明示。nullable・既存行は null。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->foreignId('default_workspace_id')->nullable()->after('owner_member_id')->constrained('workspaces')->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropConstrainedForeignId('default_workspace_id');
        });
    }
};
