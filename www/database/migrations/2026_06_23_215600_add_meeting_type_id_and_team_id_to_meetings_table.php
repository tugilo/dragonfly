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
        if (! Schema::hasColumn('meetings', 'meeting_type_id')) {
            Schema::table('meetings', function (Blueprint $table) {
                $table->unsignedBigInteger('meeting_type_id')->nullable()->after('number');
            });
        } else {
            $this->dropMeetingTypeForeignKeyIfExists();
        }

        if (! Schema::hasColumn('meetings', 'team_id')) {
            Schema::table('meetings', function (Blueprint $table) {
                $table->string('team_id', 64)->default('')->after('session_type');
            });
        }

        $typeIdsByCode = DB::table('meeting_types')->pluck('id', 'code');

        DB::table('meetings')
            ->whereNull('meeting_type_id')
            ->orderBy('id')
            ->chunkById(100, function ($meetings) use ($typeIdsByCode): void {
                foreach ($meetings as $meeting) {
                    $sessionType = $meeting->session_type ?? 'chapter_weekly';
                    $typeId = $typeIdsByCode[$sessionType] ?? $typeIdsByCode['chapter_weekly'];

                    DB::table('meetings')->where('id', $meeting->id)->update([
                        'meeting_type_id' => $typeId,
                        'team_id' => $meeting->team_id ?? '',
                    ]);
                }
            });

        if (Schema::getConnection()->getDriverName() === 'mysql') {
            DB::statement('ALTER TABLE meetings MODIFY meeting_type_id BIGINT UNSIGNED NOT NULL');
        }

        $this->dropMeetingTypeForeignKeyIfExists();

        Schema::table('meetings', function (Blueprint $table) {
            $table->foreign('meeting_type_id')
                ->references('id')
                ->on('meeting_types')
                ->restrictOnDelete();
        });

        if (! $this->indexExists('meetings_type_team_held_unique')) {
            Schema::table('meetings', function (Blueprint $table) {
                $table->unique(
                    ['meeting_type_id', 'team_id', 'held_on'],
                    'meetings_type_team_held_unique'
                );
            });
        }

        if (! $this->indexExists('meetings_type_held_index')) {
            Schema::table('meetings', function (Blueprint $table) {
                $table->index(['meeting_type_id', 'held_on'], 'meetings_type_held_index');
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        if ($this->indexExists('meetings_type_team_held_unique')) {
            Schema::table('meetings', function (Blueprint $table) {
                $table->dropUnique('meetings_type_team_held_unique');
            });
        }

        if ($this->indexExists('meetings_type_held_index')) {
            Schema::table('meetings', function (Blueprint $table) {
                $table->dropIndex('meetings_type_held_index');
            });
        }

        $this->dropMeetingTypeForeignKeyIfExists();

        if (Schema::hasColumn('meetings', 'meeting_type_id')) {
            Schema::table('meetings', function (Blueprint $table) {
                $table->dropColumn('meeting_type_id');
            });
        }

        if (Schema::hasColumn('meetings', 'team_id')) {
            Schema::table('meetings', function (Blueprint $table) {
                $table->dropColumn('team_id');
            });
        }
    }

    private function dropMeetingTypeForeignKeyIfExists(): void
    {
        if (! Schema::hasColumn('meetings', 'meeting_type_id')) {
            return;
        }

        try {
            Schema::table('meetings', function (Blueprint $table) {
                $table->dropForeign(['meeting_type_id']);
            });
        } catch (\Throwable) {
            // No FK yet.
        }
    }

    private function indexExists(string $indexName): bool
    {
        $connection = Schema::getConnection();
        $driver = $connection->getDriverName();

        if ($driver === 'sqlite') {
            $rows = DB::select("PRAGMA index_list('meetings')");
            foreach ($rows as $row) {
                if (($row->name ?? null) === $indexName) {
                    return true;
                }
            }

            return false;
        }

        $database = $connection->getDatabaseName();
        $rows = DB::select(
            'SELECT 1 FROM information_schema.statistics WHERE table_schema = ? AND table_name = ? AND index_name = ? LIMIT 1',
            [$database, 'meetings', $indexName]
        );

        return $rows !== [];
    }
};
