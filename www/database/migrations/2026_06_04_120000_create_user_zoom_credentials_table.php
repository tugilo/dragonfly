<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * SPEC-012 拡張: ユーザーごとの Zoom OAuth アプリ資格情報（BYO app credentials）。
 * client_secret / webhook_secret_token は Eloquent encrypted キャストで暗号化保存。
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('user_zoom_credentials', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('client_id')->nullable();
            $table->text('client_secret')->nullable(); // encrypted
            $table->text('webhook_secret_token')->nullable(); // encrypted, optional
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->unique('user_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('user_zoom_credentials');
    }
};
