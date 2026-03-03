<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'DragonFly MVP')</title>
    <style>
        body { font-family: sans-serif; margin: 1rem; max-width: 900px; }
        section { margin-bottom: 1.5rem; }
        h1 { font-size: 1.25rem; margin-bottom: 0.5rem; }
        h2 { font-size: 1rem; margin: 0.75rem 0 0.25rem; }
        table { border-collapse: collapse; width: 100%; margin-top: 0.5rem; }
        th, td { border: 1px solid #ccc; padding: 0.35rem 0.5rem; text-align: left; }
        th { background: #f0f0f0; }
        button { padding: 0.4rem 0.75rem; cursor: pointer; margin-right: 0.5rem; margin-top: 0.25rem; }
        select { padding: 0.35rem; min-width: 200px; }
        textarea { width: 100%; min-height: 60px; padding: 0.35rem; box-sizing: border-box; }
        .card { border: 1px solid #ccc; padding: 0.75rem; margin-bottom: 0.75rem; }
        .saved { color: green; font-size: 0.9rem; margin-left: 0.5rem; }
        .saved.error { color: red; }
        .save-result { font-size: 0.9rem; margin-left: 0.5rem; }
        .save-result.ok { color: green; }
        .save-result.error { color: red; }
        .hint { color: #666; font-size: 0.9rem; }
        .session-block { margin: 1rem 0; padding: 0.75rem; border: 1px solid #eee; }
        .roommate-checkboxes { max-height: 200px; overflow-y: auto; margin: 0.5rem 0; }
        .roommate-checkboxes label { display: block; padding: 0.2rem 0; }
        .review-list { list-style: disc; padding-left: 1.5rem; }
        .error { color: red; font-size: 0.9rem; }
        ul.memos { list-style: none; padding: 0; }
        ul.memos li { border-bottom: 1px solid #eee; padding: 0.5rem 0; }
    </style>
    @stack('styles')
</head>
<body>
    @yield('content')
    @stack('scripts')
</body>
</html>
