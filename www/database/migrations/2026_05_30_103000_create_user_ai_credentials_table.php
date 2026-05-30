<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * SPEC-013: ユーザーごとの AI 資格情報（BYO key）。
 * AI 利用はユーザー任意（ai_enabled）。provider をユーザーが選択し、API キーは暗号化保存。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('user_ai_credentials', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->boolean('ai_enabled')->default(false);
            $table->string('provider', 30)->nullable(); // openai / anthropic / google ...
            $table->text('api_key')->nullable(); // encrypted
            $table->string('model')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->unique('user_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_ai_credentials');
    }
};
