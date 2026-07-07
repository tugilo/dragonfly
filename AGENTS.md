# AGENTS.md — dragonfly / Religo

Product: **Religo** (relationship-map admin tool for the BNI **DragonFly** chapter). Stack: Laravel 12 (PHP 8.4) + React 19 / react-admin (Vite), MariaDB 11.2, Nginx — all run via Docker Compose.

Authoritative dev rules live in `.cursorrules`, `CLAUDE.md`, and `docs/AI_TOOLING.md`. Standard commands (compose up, artisan, npm build, tests, merge flow) are documented there — use them rather than reinventing.

## Cursor Cloud specific instructions

This environment runs the app with **Docker-in-Docker**. Notes below are the non-obvious gotchas for starting/running services here; everything else follows `.cursorrules` / `CLAUDE.md`.

- **Start the Docker daemon first each session** (it is not auto-started): `sudo service docker start`. Docker commands need `sudo` unless you start a fresh login shell (the `ubuntu` user is in the `docker` group).
- **`project.env` and `www/.env` are git-ignored and generated.** The startup/update script recreates them if missing. `www/.env` here is configured for MariaDB (`DB_CONNECTION=mysql`, `DB_HOST=db`, db/user/pass = `dragonfly`). Do not hand-edit `.env`; use a PHP script (per `.cursorrules`).
- **Do NOT start the `phpmyadmin` service.** It is pinned to `platform: linux/arm64` in `infra/compose/docker-compose.yml` and will not run on this x86_64 VM. It is optional. Start only the required services:
  `sudo docker compose -f infra/compose/docker-compose.yml --env-file project.env up -d db app nginx node`
- **`storage/` and `bootstrap/cache` must be writable by the `www-data` (uid 33) FPM worker.** On a fresh checkout they are owned by uid 1000 without group/other write, so Blade view compilation fails and pages (e.g. `/admin`) return HTTP 500 with a `tempnam(): file created in the system's temporary directory` error. Fix once (persists in the bind mount):
  `sudo docker compose -f infra/compose/docker-compose.yml --env-file project.env exec -T app chown -R www-data:www-data storage bootstrap/cache`
- **Dependencies live inside the containers** (`www/vendor`, `www/node_modules` are bind-mounted and git-ignored). Install/refresh after images are up:
  `... exec -T app composer install` and `... exec -T node npm install` (then `... exec -T node npm run build`).
- **Tests** use in-memory SQLite (`www/phpunit.xml`), so `... exec -T app php artisan test` does not require the `db` container. There are 577 tests.
- **Lint/format** is Laravel Pint: `... exec -T app ./vendor/bin/pint` (use `--test` to check only). The repo currently has pre-existing Pint style diffs, so `--test` reports failures unrelated to your change.
- **First-run onboarding / login:** seed the DB (`... exec -T app php artisan db:seed --force`) to create `Test User` (`test@example.com` / `password`) plus the default workspace. Optional richer data: seed `BniDragonFly199ParticipantsSeeder` and `DragonFlyMeeting199BreakoutSeeder`. After logging in at `http://localhost/admin`, the account shows **「メンバー紐付けが必要です」** until it is linked to a Member. Link it in the UI (owner-member picker) or via `PATCH /api/users/me {"owner_member_id": <id>}` with the Bearer token from `POST /api/auth/login`. Until linked, `/api/dragonfly/*` returns 401 and lists are empty.
