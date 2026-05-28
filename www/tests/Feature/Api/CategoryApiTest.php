<?php

namespace Tests\Feature\Api;

use App\Models\Category;
use App\Models\Member;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

/**
 * Categories API CRUD. Phase16C.
 */
class CategoryApiTest extends TestCase
{
    use RefreshDatabase;

    public function test_index_returns_categories(): void
    {
        Category::create(['group_name' => 'IT', 'name' => 'Web']);
        Category::create(['group_name' => '士業', 'name' => '税理士']);

        $res = $this->getJson('/api/categories');
        $res->assertOk();
        $data = $res->json();
        $this->assertIsArray($data);
        $this->assertGreaterThanOrEqual(2, count($data));
        $groups = array_column($data, 'group_name');
        $this->assertContains('IT', $groups);
        $this->assertContains('士業', $groups);
    }

    public function test_show_returns_one_category(): void
    {
        $cat = Category::create(['group_name' => 'IT', 'name' => 'Web']);

        $res = $this->getJson('/api/categories/' . $cat->id);
        $res->assertOk();
        $res->assertJsonPath('id', $cat->id);
        $res->assertJsonPath('group_name', 'IT');
        $res->assertJsonPath('name', 'Web');
    }

    public function test_store_creates_category(): void
    {
        $res = $this->postJson('/api/categories', [
            'group_name' => '医療',
            'name' => '歯科',
        ]);
        $res->assertCreated();
        $res->assertJsonPath('group_name', '医療');
        $res->assertJsonPath('name', '歯科');
        $this->assertDatabaseHas('categories', ['group_name' => '医療', 'name' => '歯科']);
    }

    public function test_update_modifies_category(): void
    {
        $cat = Category::create(['group_name' => 'IT', 'name' => 'Web']);

        $res = $this->putJson('/api/categories/' . $cat->id, [
            'group_name' => 'IT',
            'name' => 'Web制作',
        ]);
        $res->assertOk();
        $res->assertJsonPath('name', 'Web制作');
        $cat->refresh();
        $this->assertSame('Web制作', $cat->name);
    }

    public function test_delete_removes_category_without_members(): void
    {
        $cat = Category::create(['group_name' => 'IT', 'name' => 'Temp']);

        $res = $this->deleteJson('/api/categories/' . $cat->id);
        $res->assertNoContent();
        $this->assertDatabaseMissing('categories', ['id' => $cat->id]);
    }

    public function test_delete_returns_422_when_category_has_members(): void
    {
        $cat = Category::create(['group_name' => 'IT', 'name' => 'Web']);
        Member::create(['name' => 'Test', 'type' => 'active', 'category_id' => $cat->id]);

        $res = $this->deleteJson('/api/categories/' . $cat->id);
        $res->assertStatus(422);
        $res->assertJsonPath('message', 'Cannot delete category with members. Move members to another category first.');
        $this->assertDatabaseHas('categories', ['id' => $cat->id]);
    }
}
