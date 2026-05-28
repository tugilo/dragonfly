<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * M7-M6: 参加者CSV の participants / members / roles 反映の監査ログ（追記のみ想定）。
     */
    public function up(): void
    {
        Schema::create('meeting_csv_apply_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('meeting_id')->constrained()->cascadeOnDelete();
            $table->foreignId('meeting_csv_import_id')->constrained('meeting_csv_imports')->cascadeOnDelete();
            $table->string('apply_type', 32);
            $table->date('applied_on');
            $table->dateTime('executed_at');
            $table->unsignedInteger('applied_count')->default(0);
            $table->unsignedInteger('added_count')->nullable();
            $table->unsignedInteger('updated_count')->nullable();
            $table->unsignedInteger('deleted_count')->nullable();
            $table->unsignedInteger('protected_count')->nullable();
            $table->unsignedInteger('skipped_count')->nullable();
            $table->json('meta')->nullable();
            $table->unsignedBigInteger('executed_by_member_id')->nullable();
            $table->timestamps();

            $table->index(['meeting_id', 'executed_at']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('meeting_csv_apply_logs');
    }
};
