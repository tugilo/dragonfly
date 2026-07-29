# AGENTS.md — dragonfly / Religo

Product: **Religo** (BNI relationship-map tool) — Laravel 12 API + Blade, React 19 / react-admin SPA.
Chapter name: **DragonFly**. Internal repo/container name: **dragonfly**.

Primary rules live in `.cursorrules`, `CLAUDE.md`, and `docs/AI_TOOLING.md`. Follow those for the DevOS phase workflow, naming, and git (PR-less) rules. The section below is only cloud-environment operating context.

## Cursor Cloud specific instructions

This repo runs entirely through Docker Compose (`infra/compose/docker-compose.yml`, launched with `--env-file project.env`). All PHP/Composer/Node/artisan commands run **inside containers**, never on the host (host has no PHP/Node/Composer). The compose command prefix is:

```
docker compose -f infra/compose/docker-compose.yml --env-file project.env
```

### Services
- `app` (dragonfly-app): PHP-FPM 8.4 + Laravel. Runs as `www-data` (uid 33).
- `db` (dragonfly-db): MariaDB 11.2. App is configured for `DB_CONNECTION=mysql`, host `db`, db/user/pass all `dragonfly`.
- `nginx` (dragonfly-nginx): serves the app on http://localhost (port 80).
- `node` (dragonfly-node): Node 20 build container (idles on `tail -f /dev/null`); used for `npm install` / `npm run build`.
- `phpmyadmin` (optional): **pinned to `platform: linux/arm64` in the compose file**, so it fails to start on x86_64 hosts. On amd64 cloud VMs, start only the required services and skip it: `... up -d app db nginx node`.

### Startup (services are NOT auto-started by the update script)
1. Ensure the Docker daemon is running (the update script handles this; if needed: `sudo systemctl start docker` or `sudo dockerd &`, then `sudo chmod 666 /var/run/docker.sock`).
2. Bring up the stack (skip phpmyadmin on amd64): `docker compose -f infra/compose/docker-compose.yml --env-file project.env up -d app db nginx node`.
3. `project.env` and `www/.env` are gitignored and persist in the VM snapshot. If `project.env` is missing, run `make setup` (or recreate it: `COMPOSE_PROJECT_NAME/PROJECT=dragonfly`, `PROJECT_DIR=/workspace`, versions from `versions.env`, `APP_PORT=80 DB_PORT=3307 PMA_PORT=8081`). If `www/.env` is missing, copy `www/.env.example` and set `DB_CONNECTION=mysql`, `DB_HOST=db`, `DB_PORT=3306`, `DB_DATABASE/DB_USERNAME/DB_PASSWORD=dragonfly`, then `php artisan key:generate` and `php artisan migrate --force`. Do not hand-edit `.env`; write it via a PHP script (project rule).

### Non-obvious gotchas
- **Storage permissions (causes HTTP 500 `tempnam()` on every page):** `www/storage` and `www/bootstrap/cache` are bind-mounted and owned by the host user (uid 1000), but php-fpm runs as `www-data` (uid 33). If they are not writable by www-data, Laravel view compilation fails with a 500. Fix (idempotent), from inside the container as root: `docker compose ... exec -u root app chmod -R 777 /var/www/storage /var/www/bootstrap/cache`. Re-apply if you ever see `tempnam()` 500s after a fresh checkout.
- **Dependencies live in the bind mount:** `www/vendor` and `www/node_modules` are gitignored and persist in the snapshot. Refresh them only when manifests change: `docker compose ... exec app composer install` and `docker compose ... exec node npm install`. (Both require the stack to be up.)
- **Frontend build required after JS changes:** after editing `www/resources/js/**`, rebuild: `docker compose ... exec node npm run build` (assets output to `www/public/build`, served by nginx).

### Auth / test account for exercising the admin UI
- The admin SPA is at http://localhost/admin (react-admin; token stored in `localStorage`). API login: `POST /api/auth/login` with email+password (Sanctum PAT).
- A dev user exists: **test@example.com / password** (created via `php artisan db:seed` + a tinker tweak; the factory password is `password`).
- Admin-only menus (Categories, Roles, SONAE, Member merge) and their routes/resources only render when the user's `religo_role === 'chapter_admin'` and the user has a linked `owner_member_id` (member record). Valid roles are `member` and `chapter_admin` only (`app/Models/User.php`).
- **react-admin caches permissions:** after changing a user's `religo_role`, an already-open browser session keeps the old permissions (admin routes show "Not Found"). Clear it with `localStorage.clear()` in DevTools + reload, then log in fresh.

### Lint / test / build / run (all inside containers)
- Tests: `docker compose ... exec app php artisan test` (577 tests pass).
- Lint: `docker compose ... exec app ./vendor/bin/pint` (or `--test` to check only; the committed code currently has pre-existing style deviations).
- Build frontend: `docker compose ... exec node npm run build`.
- Run/serve: nginx serves http://localhost once the stack is up (no `artisan serve` needed).
