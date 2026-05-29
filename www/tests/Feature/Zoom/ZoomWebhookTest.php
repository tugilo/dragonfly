<?php

namespace Tests\Feature\Zoom;

use App\Jobs\Zoom\ProcessZoomMeetingEndedJob;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Queue;
use Tests\TestCase;

/**
 * SPEC-012 Phase D: Webhook 署名検証・URL 検証・イベント dispatch。
 */
class ZoomWebhookTest extends TestCase
{
    use RefreshDatabase;

    private string $secret = 'test-webhook-secret';

    protected function setUp(): void
    {
        parent::setUp();
        config(['services.zoom.webhook_secret_token' => $this->secret]);
    }

    private function signedHeaders(string $body): array
    {
        $ts = (string) time();

        return [
            'x-zm-request-timestamp' => $ts,
            'x-zm-signature' => 'v0='.hash_hmac('sha256', 'v0:'.$ts.':'.$body, $this->secret),
            'Content-Type' => 'application/json',
        ];
    }

    public function test_url_validation_returns_encrypted_token(): void
    {
        $body = json_encode([
            'event' => 'endpoint.url_validation',
            'payload' => ['plainToken' => 'abc123'],
        ]);

        $res = $this->call('POST', '/api/zoom/webhook', [], [], [], $this->toServer($this->signedHeaders($body)), $body);

        $res->assertOk();
        $res->assertJsonPath('plainToken', 'abc123');
        $res->assertJsonPath('encryptedToken', hash_hmac('sha256', 'abc123', $this->secret));
    }

    public function test_invalid_signature_is_rejected(): void
    {
        $body = json_encode(['event' => 'meeting.ended', 'payload' => ['object' => []]]);
        $headers = [
            'x-zm-request-timestamp' => (string) time(),
            'x-zm-signature' => 'v0=deadbeef',
            'Content-Type' => 'application/json',
        ];

        $res = $this->call('POST', '/api/zoom/webhook', [], [], [], $this->toServer($headers), $body);
        $res->assertStatus(401);
    }

    public function test_meeting_ended_dispatches_job(): void
    {
        Queue::fake();
        $body = json_encode([
            'event' => 'meeting.ended',
            'payload' => ['object' => ['id' => '123', 'uuid' => 'uuid==', 'host_id' => 'host1', 'topic' => 'X さん 1to1']],
        ]);

        $res = $this->call('POST', '/api/zoom/webhook', [], [], [], $this->toServer($this->signedHeaders($body)), $body);

        $res->assertOk();
        Queue::assertPushed(ProcessZoomMeetingEndedJob::class);
    }

    /**
     * @param  array<string, string>  $headers
     * @return array<string, string>
     */
    private function toServer(array $headers): array
    {
        $server = [];
        foreach ($headers as $key => $value) {
            $normalized = strtoupper(str_replace('-', '_', $key));
            // Content-Type / Content-Length は CGI 仕様で HTTP_ 接頭辞を付けない。
            if (in_array($normalized, ['CONTENT_TYPE', 'CONTENT_LENGTH'], true)) {
                $server[$normalized] = $value;
            } else {
                $server['HTTP_'.$normalized] = $value;
            }
        }

        return $server;
    }
}
