<?php

namespace Tests\Unit\Ai;

use App\Services\Ai\OpenAiTextGenerator;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

class OpenAiTextGeneratorTest extends TestCase
{
    public function test_omits_temperature_for_gpt5_models(): void
    {
        Http::fake(['api.openai.com/*' => Http::response([
            'choices' => [['message' => ['content' => 'OK']]],
        ], 200)]);

        $gen = new OpenAiTextGenerator('sk-test', 'gpt-5');
        $gen->generate('sys', 'user');

        Http::assertSent(function ($request) {
            $body = $request->data();

            return ($body['model'] ?? '') === 'gpt-5'
                && ! array_key_exists('temperature', $body);
        });
    }

    public function test_omits_temperature_for_gpt5_5(): void
    {
        Http::fake(['api.openai.com/*' => Http::response([
            'choices' => [['message' => ['content' => 'OK']]],
        ], 200)]);

        $gen = new OpenAiTextGenerator('sk-test', 'gpt-5.5');
        $gen->generate('sys', 'user');

        Http::assertSent(function ($request) {
            $body = $request->data();

            return ($body['model'] ?? '') === 'gpt-5.5'
                && ! array_key_exists('temperature', $body);
        });
    }

    public function test_includes_temperature_for_gpt4o_models(): void
    {
        Http::fake(['api.openai.com/*' => Http::response([
            'choices' => [['message' => ['content' => 'OK']]],
        ], 200)]);

        $gen = new OpenAiTextGenerator('sk-test', 'gpt-4o-mini');
        $gen->generate('sys', 'user');

        Http::assertSent(function ($request) {
            $body = $request->data();

            return ($body['model'] ?? '') === 'gpt-4o-mini'
                && ($body['temperature'] ?? null) === 0.4;
        });
    }
}
