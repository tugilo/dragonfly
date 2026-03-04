<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     * contact_memos / introductions / dragonfly_contact_flags に workspace_id を追加（SSOT: DATA_MODEL.md）。
     * 既存データ互換のため nullable。既存ユニーク制約は変更しない。
     */
    public function up(): void
    {
        Schema::table('contact_memos', function (Blueprint $table) {
            $table->unsignedBigInteger('workspace_id')->nullable()->after('id');
            $table->foreign('workspace_id')->references('id')->on('workspaces')->nullOnDelete();
            $table->index('workspace_id');
        });

        Schema::table('introductions', function (Blueprint $table) {
            $table->unsignedBigInteger('workspace_id')->nullable()->after('id');
            $table->foreign('workspace_id')->references('id')->on('workspaces')->nullOnDelete();
            $table->index('workspace_id');
        });

        Schema::table('dragonfly_contact_flags', function (Blueprint $table) {
            $table->unsignedBigInteger('workspace_id')->nullable()->after('id');
            $table->foreign('workspace_id')->references('id')->on('workspaces')->nullOnDelete();
            $table->index('workspace_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('contact_memos', function (Blueprint $table) {
            $table->dropForeign(['workspace_id']);
            $table->dropIndex(['workspace_id']);
            $table->dropColumn('workspace_id');
        });

        Schema::table('introductions', function (Blueprint $table) {
            $table->dropForeign(['workspace_id']);
            $table->dropIndex(['workspace_id']);
            $table->dropColumn('workspace_id');
        });

        Schema::table('dragonfly_contact_flags', function (Blueprint $table) {
            $table->dropForeign(['workspace_id']);
            $table->dropIndex(['workspace_id']);
            $table->dropColumn('workspace_id');
        });
    }
};
