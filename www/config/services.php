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
    | アプリ資格情報は .env で管理しハードコードしない（SPEC-012 §6）。
    | ユーザー OAuth: client_id / client_secret / redirect。
    | Webhook 署名検証: webhook_secret_token。
    | アクセス/リフレッシュトークンは .env ではなく zoom_accounts に暗号化保存する。
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

];
