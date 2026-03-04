<?php

namespace Tests\Feature\Api;

use Database\Seeders\WorkspaceSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

/**
 * GET /api/workspaces — 200・配列・id/name・id 昇順を検証. Phase09. SSOT: DATA_MODEL §4.1.
 */
class WorkspaceApiTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(WorkspaceSeeder::class);
    }

    public function test_get_workspaces_returns_200_array_with_id_name_sorted_by_id(): void
    {
        $response = $this->getJson('/api/workspaces');
        $response->assertOk();
        $data = $response->json();
        $this->assertIsArray($data);
        $this->assertGreaterThanOrEqual(1, count($data), 'at least one workspace after seed');
        foreach ($data as $row) {
            $this->assertArrayHasKey('id', $row);
            $this->assertArrayHasKey('name', $row);
        }
        $ids = array_column($data, 'id');
        $sorted = $ids;
        sort($sorted, SORT_NUMERIC);
        $this->assertSame($sorted, $ids, 'workspaces must be sorted by id ascending');
    }
}
