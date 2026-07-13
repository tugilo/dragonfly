<?php

namespace Tests\Feature\Religo;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\File;
use Tests\Support\ReligoSanctumTestHelpers;
use Tests\TestCase;

class ShizuokaOutreachToolTest extends TestCase
{
    use RefreshDatabase;
    use ReligoSanctumTestHelpers;

    private string $toolPath;

    protected function setUp(): void
    {
        parent::setUp();
        $this->toolPath = resource_path('private/tools/bni-shizuoka-joint-social-outreach.html');
        File::ensureDirectoryExists(dirname($this->toolPath));
        File::put($this->toolPath, '<!DOCTYPE html><html><body>outreach</body></html>');
    }

    protected function tearDown(): void
    {
        if (File::isFile($this->toolPath)) {
            File::delete($this->toolPath);
        }

        parent::tearDown();
    }

    public function test_unauthenticated_user_cannot_access_outreach_tool(): void
    {
        $this->getJson('/api/tools/shizuoka-outreach')
            ->assertUnauthorized();
    }

    public function test_other_member_cannot_access_outreach_tool(): void
    {
        $this->actingAsReligoUser(ownerMemberId: 99);

        $this->getJson('/api/tools/shizuoka-outreach')
            ->assertForbidden();
    }

    public function test_owner_member_can_access_outreach_tool(): void
    {
        $this->actingAsReligoUser(ownerMemberId: 37);

        $this->get('/api/tools/shizuoka-outreach')
            ->assertOk()
            ->assertHeader('Content-Type', 'text/html; charset=UTF-8')
            ->assertSee('outreach', false);
    }
}
