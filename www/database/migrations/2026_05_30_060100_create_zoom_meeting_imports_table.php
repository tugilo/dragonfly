<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Zoom 連携（SPEC-012 Phase B）: 取り込みステージング表。
 *
 * Zoom から取得したミーティングを「候補」として保持し、人が複数選択・相手正規化して
 * 確定したものだけ one_to_ones に反映する。相手未確定の「保留」はこの表に留める
 * （one_to_ones.target_member_id は NOT NULL を維持）。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('zoom_meeting_imports', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->foreignId('owner_member_id')->nullable()->constrained('members')->nullOnDelete();
            $table->foreignId('workspace_id')->nullable()->constrained('workspaces')->nullOnDelete();

            // Zoom 突合キー
            $table->string('zoom_meeting_id')->nullable();
            $table->string('zoom_meeting_uuid')->nullable();
            $table->string('kind', 20); // scheduled / past

            // Zoom メタ
            $table->string('topic')->nullable();
            $table->dateTime('start_time')->nullable();
            $table->dateTime('end_time')->nullable();
            $table->integer('duration_minutes')->nullable();
            $table->integer('participants_count')->nullable();

            // 1to1 判定
            $table->boolean('is_one_to_one_candidate')->default(false);
            $table->string('confidence', 10)->nullable(); // high / medium / low

            // 相手正規化
            $table->foreignId('matched_member_id')->nullable()->constrained('members')->nullOnDelete();
            $table->string('match_status', 20)->default('unmatched'); // matched / new / unmatched / hold
            $table->string('counterpart_name')->nullable();
            $table->string('counterpart_email')->nullable();

            // 取り込み制御
            $table->boolean('selected')->default(false);
            $table->string('status', 20)->default('pending'); // pending / imported / skipped / held
            $table->foreignId('one_to_one_id')->nullable()->constrained('one_to_ones')->nullOnDelete();

            $table->json('raw')->nullable();
            $table->timestamps();

            $table->unique(['user_id', 'zoom_meeting_uuid'], 'zoom_imports_user_uuid_unique');
            $table->index(['user_id', 'kind']);
            $table->index('zoom_meeting_id');
            $table->index('status');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('zoom_meeting_imports');
    }
};
