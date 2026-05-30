<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * SPEC-013: 1to1 事前準備の相手プロフィール添付（PDF / NCAS URL / テキスト）。
 * 抽出テキストを保存し、AI 原稿生成の素材にする。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('one_to_one_attachments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('one_to_one_id')->constrained('one_to_ones')->cascadeOnDelete();
            $table->foreignId('target_member_id')->nullable()->constrained('members')->nullOnDelete();
            $table->foreignId('uploaded_by_user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->string('source_type', 20); // pdf / url / text
            $table->string('file_path')->nullable();
            $table->string('source_url', 1024)->nullable();
            $table->string('original_name')->nullable();
            $table->longText('extracted_text')->nullable();
            $table->json('parsed_profile')->nullable();
            $table->timestamps();

            $table->index('one_to_one_id');
            $table->index('target_member_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('one_to_one_attachments');
    }
};
