<?php

use App\Services\Religo\MemberWorkspaceBackfillService;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * members に所属チャプター（workspace）を保持する（BNI 1 member = 1 chapter 前提）.
     * SSOT: docs/SSOT/MEMBERS_WORKSPACE_ASSIGNMENT_POLICY.md · DATA_MODEL §5.1
     */
    public function up(): void
    {
        Schema::table('members', function (Blueprint $table) {
            $table->foreignId('workspace_id')->nullable()->after('category_id')->constrained('workspaces')->nullOnDelete();
        });
        Schema::table('members', function (Blueprint $table) {
            $table->index('workspace_id');
        });

        app(MemberWorkspaceBackfillService::class)->run();
    }

    public function down(): void
    {
        Schema::table('members', function (Blueprint $table) {
            $table->dropForeign(['workspace_id']);
        });
    }
};
