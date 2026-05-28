<!DOCTYPE html>
<html lang="{{ str_replace('_', '-', app()->getLocale()) }}">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>DragonFly Admin — {{ config('app.name', 'Laravel') }}</title>
    <script>
        (function () {
            var tokenKey = 'religo.access_token';
            var hash = window.location.hash || '';
            if (hash.indexOf('/login') !== -1) {
                return;
            }
            try {
                if (!localStorage.getItem(tokenKey)) {
                    window.location.replace('/admin#/login');
                }
            } catch (e) {
                window.location.replace('/admin#/login');
            }
        })();
    </script>
    @vite(['resources/js/admin/app.jsx'])
</head>
<body>
    <div id="admin-root"></div>
</body>
</html>
