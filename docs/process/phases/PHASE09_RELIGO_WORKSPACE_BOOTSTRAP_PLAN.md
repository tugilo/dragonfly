# PHASE09 Religo Workspace 初期化（Seeder）と API テスト — PLAN

**Phase:** workspaces の運用前提を「最低 1 件あること」にし、詰まらない状態にする  
**作成日:** 2026-03-04  
**SSOT:** [docs/SSOT/DATA_MODEL.md](../../SSOT/DATA_MODEL.md) §4.1 workspaces. Phase08: GET /api/workspaces が DragonFlyBoard の default として利用される前提。

---

## 1. 狙い

- Phase08 で「workspace が 0 件だと 1to1 登録が保存不可」というガードを入れたため、**運用上「workspaces が最低 1 件あること」が前提**になる。
- 本 Phase で **Seeder による初期化** と **GET /api/workspaces の Feature テスト 1 本** を追加し、「運用で絶対に詰まらない」状態に仕上げる。

## 2. スコープロック

- **変更対象:** Workspace 初期化（Seeder）＋ GET /api/workspaces の API テスト（1 本）＋ docs 証跡のみ。
- **変更しない:** Phase04〜08 の既存仕様・挙動。API のレスポンス仕様は変えない。

## 3. Workspace Seeder（冪等）

- **ファイル:** `www/database/seeders/WorkspaceSeeder.php`
- **仕様:**
  - workspaces が **0 件** なら 1 件作成する。
  - すでに **1 件以上** ある場合は何もしない（冪等）。
  - 作成するレコード: `name = "Default Workspace"`, `slug = "default"`（id は固定しない）。
- **DatabaseSeeder:** 既存の呼び出し構造に合わせて WorkspaceSeeder を登録する（既存を壊さない）。

## 4. Feature テスト（/api/workspaces の存在保証）

- **ファイル:** `www/tests/Feature/Api/WorkspaceApiTest.php`（既存の Api テスト構成に合わせる）
- **前提:** RefreshDatabase ＋ seed（WorkspaceSeeder）で 1 件は必ず存在させる。
- **テスト観点（最小）:**
  1. GET /api/workspaces は **200** を返す。
  2. レスポンスは **配列** で、要素に **id** と **name** が含まれる。
  3. **id 昇順** で並んでいること（少なくとも sort されていることを軽く確認）。

## 5. DoD

- [ ] WorkspaceSeeder が冪等で 1 件だけ作成する（0 件のときのみ）
- [ ] DatabaseSeeder に WorkspaceSeeder を登録済み
- [ ] GET /api/workspaces の Feature テスト 1 本が green
- [ ] `php artisan db:seed --class=WorkspaceSeeder` が成功する
- [ ] 既存テスト（Phase04〜08）がすべて green のまま
- [ ] PLAN / WORKLOG / REPORT 作成済み、1 コミットで push、develop へ merge（--no-ff）
