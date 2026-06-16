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
        if (! Schema::hasColumn('meetings', 'session_type')) {
            Schema::table('meetings', function (Blueprint $table) {
                $table->string('session_type', 64)->default('chapter_weekly')->after('number');
            });
        }

        if (Schema::getConnection()->getDriverName() === 'mysql') {
            DB::statement('ALTER TABLE meetings MODIFY number INT UNSIGNED NULL');
        }

        if ($this->indexExists('meetings_session_type_held_on_unique')) {
            Schema::table('meetings', function (Blueprint $table) {
                $table->dropUnique('meetings_session_type_held_on_unique');
            });
        }

        if (! $this->indexExists('meetings_session_type_held_on_index')) {
            Schema::table('meetings', function (Blueprint $table) {
                $table->index(['session_type', 'held_on'], 'meetings_session_type_held_on_index');
            });
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        if (DB::table('meetings')->whereNull('number')->exists()) {
            throw new RuntimeException('Cannot revert: meetings with null number exist.');
        }

        if ($this->indexExists('meetings_session_type_held_on_index')) {
            Schema::table('meetings', function (Blueprint $table) {
                $table->dropIndex('meetings_session_type_held_on_index');
            });
        }

        if (Schema::hasColumn('meetings', 'session_type')) {
            Schema::table('meetings', function (Blueprint $table) {
                $table->dropColumn('session_type');
            });
        }

        if (Schema::getConnection()->getDriverName() === 'mysql') {
            DB::statement('ALTER TABLE meetings MODIFY number INT UNSIGNED NOT NULL');
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
