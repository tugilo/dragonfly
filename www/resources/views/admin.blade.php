<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>DragonFly Admin — {{ config('app.name', 'Laravel') }}</title>
    @vite(['resources/js/admin/app.jsx'])
</head>
<body>
    <div id="admin-root"></div>
</body>
</html>
