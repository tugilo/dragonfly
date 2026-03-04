<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'DragonFly MVP')</title>
    @vite(['resources/css/app.css'])
    @stack('styles')
</head>
<body class="min-h-screen bg-slate-50 text-slate-800 antialiased">
    <div class="mx-auto max-w-4xl px-4 py-6 sm:px-6 lg:px-8">
        @yield('content')
    </div>
    @stack('scripts')
</body>
</html>
