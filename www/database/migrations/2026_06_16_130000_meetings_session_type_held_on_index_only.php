<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
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
        if ($this->indexExists('meetings_session_type_held_on_index')) {
            Schema::table('meetings', function (Blueprint $table) {
                $table->dropIndex('meetings_session_type_held_on_index');
            });
        }
    }

    private function indexExists(string $indexName): bool
    {
        $connection = Schema::getConnection();
        if ($connection->getDriverName() === 'sqlite') {
            foreach (\Illuminate\Support\Facades\DB::select("PRAGMA index_list('meetings')") as $row) {
                if (($row->name ?? null) === $indexName) {
                    return true;
                }
            }

            return false;
        }

        $database = $connection->getDatabaseName();
        $rows = \Illuminate\Support\Facades\DB::select(
            'SELECT 1 FROM information_schema.statistics WHERE table_schema = ? AND table_name = ? AND index_name = ? LIMIT 1',
            [$database, 'meetings', $indexName]
        );

        return $rows !== [];
    }
};
