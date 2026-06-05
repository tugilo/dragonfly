<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Third Party Services
    |--------------------------------------------------------------------------
    |
    | This file is for storing the credentials for third party services such
    | as Mailgun, Postmark, AWS and more. This file provides the de facto
    | location for this type of information, allowing packages to have
    | a conventional file to locate the various service credentials.
    |
    */

    'postmark' => [
        'key' => env('POSTMARK_API_KEY'),
    ],

    'resend' => [
        'key' => env('RESEND_API_KEY'),
    ],

    'ses' => [
        'key' => env('AWS_ACCESS_KEY_ID'),
        'secret' => env('AWS_SECRET_ACCESS_KEY'),
        'region' => env('AWS_DEFAULT_REGION', 'us-east-1'),
    ],

    'slack' => [
        'notifications' => [
            'bot_user_oauth_token' => env('SLACK_BOT_USER_OAUTH_TOKEN'),
            'channel' => env('SLACK_BOT_USER_DEFAULT_CHANNEL'),
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Zoom 連携（SPEC-012 / 1 to 1 取り込み）
    |--------------------------------------------------------------------------
    |
    | アプリ資格情報（Client ID / Secret / Webhook Secret）はユーザーごとに
    | user_zoom_credentials に暗号化保存（SPEC-012 拡張・Phase 189）。
    | .env の ZOOM_CLIENT_ID 等は移行期間のフォールバック。
    | ZOOM_REDIRECT_URI はシステム共通（全ユーザー同一 callback）。
    | アクセス/リフレッシュトークンは zoom_accounts に暗号化保存する。
    |
    */
    'zoom' => [
        'client_id' => env('ZOOM_CLIENT_ID'),
        'client_secret' => env('ZOOM_CLIENT_SECRET'),
        'redirect' => env('ZOOM_REDIRECT_URI'),
        'webhook_secret_token' => env('ZOOM_WEBHOOK_SECRET_TOKEN'),
        'base_url' => env('ZOOM_API_BASE_URL', 'https://api.zoom.us/v2'),
        'oauth_base_url' => env('ZOOM_OAUTH_BASE_URL', 'https://zoom.us'),
    ],

    /*
    |--------------------------------------------------------------------------
    | AI（SPEC-013 / 1to1 事前準備の原稿生成）
    |--------------------------------------------------------------------------
    |
    | API キーは .env ではなく user_ai_credentials（ユーザーごと・暗号化）で管理する。
    | ここはエンドポイント/既定モデル/タイムアウト等の非秘匿設定のみ。
    |
    */
    'ai' => [
        'request_timeout' => (int) env('AI_REQUEST_TIMEOUT', 60),
        'openai' => [
            'base_url' => env('OPENAI_BASE_URL', 'https://api.openai.com/v1'),
            'default_model' => env('OPENAI_DEFAULT_MODEL', 'gpt-4o-mini'),
            // UI 選択肢（id は Chat Completions の model パラメータにそのまま渡す）
            'models' => [
                ['id' => 'gpt-4o-mini', 'label' => 'GPT-4o mini（推奨・低コスト）'],
                ['id' => 'gpt-4o', 'label' => 'GPT-4o'],
                ['id' => 'gpt-4.1-mini', 'label' => 'GPT-4.1 mini'],
                ['id' => 'gpt-4.1', 'label' => 'GPT-4.1'],
                ['id' => 'o4-mini', 'label' => 'o4-mini（推論）'],
                ['id' => 'o3-mini', 'label' => 'o3-mini（推論）'],
                ['id' => 'gpt-5-mini', 'label' => 'GPT-5 mini'],
                ['id' => 'gpt-5', 'label' => 'GPT-5'],
                ['id' => 'gpt-5.5', 'label' => 'GPT-5.5'],
                ['id' => 'gpt-5.5-pro', 'label' => 'GPT-5.5 Pro'],
            ],
            // temperature / top_p 等のサンプリングパラメータ非対応（API 既定のみ）
            'models_without_sampling_params' => [
                'gpt-5',
                'gpt-5-mini',
                'gpt-5.5',
                'gpt-5.5-pro',
            ],
        ],
    ],

];
