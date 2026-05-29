<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Zoom 連携（SPEC-012 Phase B）: 取り込み実行の監査ログ。
 * 誰がいつ何件を登録/保留/スキップしたかを残す（M7 の *_apply_logs と同趣旨）。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('zoom_import_apply_logs', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->dateTime('executed_at');
            $table->string('action', 30); // sync / apply
            $table->integer('imported_count')->default(0);
            $table->integer('held_count')->default(0);
            $table->integer('skipped_count')->default(0);
            $table->json('meta')->nullable();
            $table->timestamps();

            $table->index(['user_id', 'executed_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('zoom_import_apply_logs');
    }
};
