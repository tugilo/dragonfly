<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('meeting_types', function (Blueprint $table) {
            $table->id();
            $table->string('code', 64)->unique();
            $table->string('name_ja', 255);
            $table->boolean('is_numbered')->default(false);
            $table->boolean('requires_team_id')->default(false);
            $table->boolean('supports_participants')->default(false);
            $table->boolean('supports_breakouts')->default(false);
            $table->boolean('supports_referral_suggestions')->default(false);
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });

        $now = now();
        $rows = [
            [
                'code' => 'chapter_weekly',
                'name_ja' => '定例会',
                'is_numbered' => true,
                'requires_team_id' => false,
                'supports_participants' => true,
                'supports_breakouts' => true,
                'supports_referral_suggestions' => true,
                'sort_order' => 10,
            ],
            [
                'code' => 'momentum_training',
                'name_ja' => 'モメンタム',
                'is_numbered' => false,
                'requires_team_id' => false,
                'supports_participants' => true,
                'supports_breakouts' => true,
                'supports_referral_suggestions' => true,
                'sort_order' => 20,
            ],
            [
                'code' => 'business_open_day',
                'name_ja' => 'BOD',
                'is_numbered' => false,
                'requires_team_id' => false,
                'supports_participants' => true,
                'supports_breakouts' => true,
                'supports_referral_suggestions' => true,
                'sort_order' => 30,
            ],
            [
                'code' => 'team_meeting',
                'name_ja' => 'チームMTG',
                'is_numbered' => false,
                'requires_team_id' => true,
                'supports_participants' => false,
                'supports_breakouts' => false,
                'supports_referral_suggestions' => false,
                'sort_order' => 40,
            ],
            [
                'code' => 'webmaster_meeting',
                'name_ja' => 'WebマスターMTG',
                'is_numbered' => false,
                'requires_team_id' => false,
                'supports_participants' => false,
                'supports_breakouts' => false,
                'supports_referral_suggestions' => false,
                'sort_order' => 50,
            ],
        ];

        foreach ($rows as $row) {
            DB::table('meeting_types')->insert(array_merge($row, [
                'is_active' => true,
                'created_at' => $now,
                'updated_at' => $now,
            ]));
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('meeting_types');
    }
};
